
function srcdest_to_rankarray(srcdest)
    if srcdest in ["all", "each", "some"]
        return collect(0:getcommsize()-1)
    end
    if typeof(srcdest) <: Integer
        return [srcdest]
    end
    if isnothing(srcdest)
        return Int[]
    end
    return srcdest
end

struct MPIEventNeighbors
    open_srcs::Vector{Int}
    open_dst::Vector{Int}
end

function MPIEventNeighbors(ev::MPIEvent)
    srcdest = getsrcdest(ev)
    if isnothing(srcdest)
        srcdest = (src = nothing, dest = nothing)
    end
    opensrcs = srcdest_to_rankarray(srcdest[:src])
    opendests = srcdest_to_rankarray(srcdest[:dest])
    # Delete rank from recvs or sends it if is root!
    if length(opensrcs) == 1 && (opensrcs[1] in opendests)
        deleteat!(opendests, findfirst(isequal(opensrcs[1]), opendests))
    end
    if length(opendests) == 1 && (opendests[1] in opensrcs)
        deleteat!(opensrcs, findfirst(isequal(opendests[1]), opensrcs))
    end 
    # remove other ranks on own communication side
    if ev.rank in opendests
        opendests = [ev.rank]
    end
    if ev.rank in opensrcs
        opensrcs = [ev.rank]
    end
    MPIEventNeighbors(opensrcs, opendests)
end

function get_edges(tape::Array{MPIEvent}; check=true)
    # Data structure containing communication edges
    edges = Tuple{MPIEvent, MPIEvent}[]
    # temporary data to keep track of left communication pairs
    open_links = MPIEventNeighbors[]
    # Construct data structure for linked list of MPI calls
    for e in tape
        push!(open_links, MPIEventNeighbors(e))
    end
    # Start finding communication pairs for global list of MPI calls
    for (e, l) in zip(tape, open_links)
        verbose() && println("Event: $(e) $(l.open_srcs) $(l.open_dst)")
        # If the current call is a sending call, search for matching receive calls
        if any(s == e.rank for s in l.open_srcs)
            verbose() && println("Send call found! $(e) $(l.open_srcs) $(l.open_dst)")
            # for every destination (if multiple)
            found_dsts = Int[]
            for d in l.open_dst
                if d == e.rank
                    push!(found_dsts, d)
                    # Skip connections to self in graph
                    continue
                end
                for (recvevent, l_recv) in zip(tape, open_links)
                    verbose() && println("Check: $recvevent")
                    # identify receive call and matching signature
                    if d == recvevent.rank &&
                            any(e.rank == s for s in l_recv.open_srcs) &&
                            gettag(e) == gettag(recvevent)
                        verbose() && println("Matched $(e) and $(recvevent)")
                        deleteat!(l_recv.open_srcs,findfirst(x->x==e.rank, l_recv.open_srcs))
                        push!(found_dsts, d)
                        push!(edges, (e, recvevent))
                        break
                    end
                end
            end
            deleteat!(l.open_dst,findall(x->any(x==d for d in found_dsts), l.open_dst))
            # check for errors in graph
            if !isempty(l.open_dst)
                check && error("Not all destinations found for $(e): $(l.open_dst)")
            end
            deleteat!(l.open_srcs,findfirst(x->x==e.rank, l.open_srcs))
        end
    end
    for (ol, e) in zip(open_links, tape)
        if !isempty(ol.open_srcs)
            check && error("Not all transmissions are linked correctly: Sources left: $(ol.open_srcs) $(e)")
        end
    end
    return edges
end
