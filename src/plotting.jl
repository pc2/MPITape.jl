using Plots

function plot_edges(edges::Array{Tuple{MPIEvent, MPIEvent}})
    for (src, dst) in edges
        plot!([src.t_end,dst.t_end], [src.rank, dst.rank], arrow=true, color=:black, label="")
    end
end

function event_to_rect(ev::MPIEvent; color=:blue)
    plot!(Shape([ev.t_start, ev.t_end, ev.t_end, ev.t_start], 
            [ev.rank - 0.25, ev.rank - 0.25, ev.rank + 0.25, ev.rank + 0.25]), color=color,
            label="")
end

function plot_merged(tape::Array{MPIEvent}; palette=palette(:Accent_8))
    plot()
    unique_calls = unique([ev.f for ev in tape])
    for mpievent in tape
        event_to_rect(mpievent, color=palette[findall(x->x==mpievent.f, unique_calls)[1]])
    end
    for (col, call) in zip(palette[1:length(unique_calls)], unique_calls)
        plot!(Shape([0],[0]), color=col, label=string(call))
    end
    edges = get_edges(tape)
    plot_edges(edges)
    Plots.xlabel!("Execution time [s]")
    Plots.ylabel!("MPI Rank")
    return plot!()
end