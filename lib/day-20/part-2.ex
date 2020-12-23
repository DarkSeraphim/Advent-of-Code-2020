defmodule Day20_2 do
  import Common

  @tile_id_pattern ~r/Tile (\d+):/

  def parse_tile_id(tile_id) do
    case Regex.run(@tile_id_pattern, tile_id) do
      [_, id] -> int(id)
    end
  end

  def parse_tile(tile) do
    [tile_id_str | tile ] = String.split(tile, "\n")

    {parse_tile_id(tile_id_str), Enum.map(tile, &String.graphemes/1)}
  end

  def add_to_list(list, item), do: [item | list]

  def add_and_flipped(map, tile_id, side) do
    Map.update(map, side, [tile_id], &add_to_list(&1, tile_id))
    |> Map.update(String.reverse(side), [tile_id], &add_to_list(&1, tile_id))
  end

  def add_match({tile_id, tile}, matches) do
    upper = hd(tile) |> Enum.join("")
    lower = List.last(tile) |> Enum.join("")
    rotated = transpose(tile)
    left = hd(rotated) |> Enum.join("")
    right = List.last(rotated) |> Enum.join("")
    add_and_flipped(matches, tile_id, upper)
    |> add_and_flipped(tile_id, lower)
    |> add_and_flipped(tile_id, left)
    |> add_and_flipped(tile_id, right)
  end

  def has_two_matches({_side, [_a, _b]}), do: true
  def has_two_matches({_side, [_a]}), do: false
 
  def is_corner({_tile, [_a, _b, _c, _d]}), do: true
  def is_corner(_), do: false

  def red({edge, [a, b]}, map) do
    Map.update(map, a, [edge], &([edge | &1]))
    |> Map.update(b, [edge], &([edge | &1]))
  end

  def opposites({tileid, tile}) do
    upper = hd(tile) |> Enum.join("")
    lower = List.last(tile) |> Enum.join("")
    rotated = transpose(tile)
    left = hd(rotated) |> Enum.join("")
    right = List.last(rotated) |> Enum.join("")

    {tileid, Map.put(%{}, upper, lower)
      |> Map.put(lower, upper)
      |> Map.put(left, right)
      |> Map.put(right, left)
      |> Map.put(String.reverse(upper), String.reverse(lower))
      |> Map.put(String.reverse(lower), String.reverse(upper))
      |> Map.put(String.reverse(left), String.reverse(right))
      |> Map.put(String.reverse(right), String.reverse(left))
    }
  end

  def flood_one(last_tile_id, incoming, edge_map, opposites, dim2) do
    tile_ids = Map.get(edge_map, incoming, [])
    |> Enum.filter(&(&1 != last_tile_id))
    case tile_ids do
      [] -> []
      [tile_id] -> 
        outgoing = Map.get(opposites, tile_id)
        |> Map.get(incoming)
        elem = if not dim2 do
          start_other(tile_id, incoming, edge_map, opposites)
        else
          tile_id
        end
        [elem | flood_one(tile_id, outgoing, edge_map, opposites, dim2)]
    end
  end

  def start_other(start_tile_id, outgoing, edge_map, opposites) do
    outgoing = [outgoing, String.reverse(outgoing)]
    ops = Map.get(opposites, start_tile_id)
    opp_outgoing = outgoing |> Enum.map(&Map.get(ops, &1))
    opts = Map.get(opposites, start_tile_id)
    |> Map.keys()
    |> Enum.filter(&(&1 not in outgoing and &1 not in opp_outgoing))
    |> Enum.filter(&Map.has_key?(edge_map, &1))
    [down] = opts
    |> Enum.take(1)
    [start_tile_id | flood_one(start_tile_id, down, edge_map, opposites, true)]
  end

  def start_edge(start_tile_id, outgoing, edge_map, opposites) do
    [start_other(start_tile_id, outgoing, edge_map, opposites) | 
    flood_one(start_tile_id, outgoing, edge_map, opposites, false)]
  end

  def take_middle([_ | tail]), do: Enum.take(tail, Enum.count(tail) - 1)

  def strip_borders({tile_id, tile}) do
    height = Enum.count(tile) - 2
    a = tile |> Enum.drop(1) |> Enum.take(height)
    {tile_id, Enum.map(a, &take_middle/1)}
  end

  def swap_row(list), do: Enum.map(list, &Enum.reverse/1)

  def solve_for_corner(corner, by_tile_id, edge_map, opposites) do
    Map.get(by_tile_id, corner)
    |> Enum.map(&start_edge(corner, &1, edge_map, opposites))
    |> Enum.map(&swap_row/1)
  end

  def is_square(list) do
    dimA = Enum.count(list)
    Enum.all?(list, &(Enum.count(&1) == dimA))
  end

  def get_tile(id_and_grid) do
    strip_borders(id_and_grid) |> elem(1)
  end

  def mutate(grid, :noop), do: grid

  def mutate(grid, :flip_x), do: Enum.map(grid, &Enum.reverse/1)

  def mutate(grid, :flip_y), do: Enum.reverse(grid)

  def mutate(grid, :flip_xy), do: mutate(mutate(grid, :flip_x), :flip_y)

  def mutate(grid, :rotate_270) do
    mutate(grid, :rotate_90)
    |> mutate(:rotate_180)
  end

  def mutate(grid, :rotate_180) do
    mutate(grid, :rotate_90)
    |> mutate(:rotate_90)
  end

  def mutate([[] | _], :rotate_90), do: []
  def mutate(grid, :rotate_90) do
    [Enum.reverse(Enum.map(grid, &hd/1)) | mutate(Enum.map(grid, &tl/1), :rotate_90)]
  end

  def mutate(grid, [flip, rotate]) do
    grid |> mutate(flip) |> mutate(rotate)
  end 

  @flip [:noop, :flip_x, :flip_y, :flip_xy]
  @rot [:noop, :rotate_90, :rotate_180, :rotate_270]

  @muts for f <- @flip, r <- @rot, do: [f, r]
  def create_puzzle_row(puzzle_row) do
    Enum.map(puzzle_row, &get_tile(&1))
    |> Enum.zip()
    |> Enum.map(&(Tuple.to_list(&1) |> List.flatten() |> Enum.join("")))
    |> Enum.join("\n")
  end

  def create_puzzle(puzzle) do
    Enum.map(puzzle, &create_puzzle_row(&1))
    |> Enum.join("\n")
  end

  def inflate(id, tiles) when is_integer(id), do: {id, Map.get(tiles, id)}
  def inflate([], _tiles), do: []
  def inflate([row | rest], tiles) do
    [inflate(row, tiles) | inflate(rest, tiles)]
  end

  def find_edge(edge_map, link) do
    edge_map
    |> Enum.filter(&(elem(&1, 1) == link or elem(&1, 1) == Enum.reverse(link)))
    |> Enum.map(&elem(&1, 0))
  end

  def rotate_top_left([[{tile_id, grid}, {right_id, right_grid} | first_row], [{bottom_id, bottom_grid} | second_row] | other_rows], edge_map) do
    [_, right_edge] = find_edge(edge_map, [tile_id, right_id])
    [bottom_edge, _] = find_edge(edge_map, [tile_id, bottom_id])
    matches = @muts
    |> Enum.map(&mutate(grid, &1))
    |> Enum.filter(fn(grid) -> 
      bottom = List.last(grid) |> Enum.join("")
      right = List.last(transpose(grid)) |> Enum.join("")
      bottom == bottom_edge and right == right_edge
    end) |> Enum.uniq()

    case matches do
      [] -> :error
      [top_left] -> [[{tile_id, top_left}, {right_id, right_grid} | first_row], [{bottom_id, bottom_grid} | second_row] | other_rows]
    end
  end

  def prepare_puzzle(grid, edge_map) do
    grid = rotate_top_left(grid, edge_map)
    if grid == :error do
      :error
    else
      first_row = hd(grid)
      second_row = tl(grid) |> hd()
      first_row = [hd(first_row) | rotate_top_row(first_row, second_row, edge_map)] 

      first_column = transpose(grid) |> hd()
      second_column = transpose(grid) |> tl() |> hd()
      first_column = [hd(first_column) | rotate_left_column(first_column, second_column, edge_map)]

      first_row_swapped = [first_row | tl(grid)]
      result = [first_column | tl(transpose(first_row_swapped))]
      |> transpose()
      result
    end
  end

  def rotate_top_row([_], _, _), do: []
  def rotate_top_row([{_, left}, {tile_id, tile} | rest], [{_, _}, {bottom_id, bottom} | bottom_rest], edge_map) do
    right = List.last(transpose(left))
    top = find_edge(edge_map, [bottom_id, tile_id])

    [tile] = @muts
    |> Enum.map(&mutate(tile, &1))
    |> Enum.filter(fn(tile) -> 
      left = hd(transpose(tile))
      bottom = List.last(tile) |> Enum.join("") 
      (right == left) and (bottom in top)
    end)
    |> Enum.uniq()

    [{tile_id, tile} | rotate_top_row([{tile_id, tile} | rest], [{bottom_id, bottom} | bottom_rest], edge_map)]
  end

  def rotate_left_column([_], _, _), do: []
  def rotate_left_column([{_, top}, {tile_id, tile} | rest], [{_, _}, {right_id, right} | right_rest], edge_map) do
    bottom = List.last(top)
    left = find_edge(edge_map, [right_id, tile_id])

    [tile] = @muts
    |> Enum.map(&mutate(tile, &1))
    |> Enum.filter(fn(tile) -> 
      top = Enum.at(tile, 0)
      right = List.last(transpose(tile)) |> Enum.join("")
      bottom == top and right in left
    end) |> Enum.uniq()

    [{tile_id, tile} | rotate_left_column([{tile_id, tile} | rest], [{right_id, right} | right_rest], edge_map)]
  end

  def rotate_top_and_left({_left_id, left_grid}, {_top_id, top_grid}, {second_id, second_grid}) do
    bottom = List.last(top_grid)
    right = List.last(transpose(left_grid))
    [correct] = @muts
    |> Enum.map(&mutate(second_grid, &1))
    |> Enum.filter(fn(grid) ->
      top = Enum.at(grid, 0)
      left = Enum.at(transpose(grid), 0)
      (bottom == top) and (right == left)
    end) |> Enum.uniq()
    {second_id, correct}
  end

  def rotate_rest([[x] | y]), do: [[x] | y]
  def rotate_rest([_x]), do: [[]]
  def rotate_rest([[_, top | _other_cols], [left, current | _other_cols_2] | _other_rows] = grid) do
    current = rotate_top_and_left(left, top, current)

    left = Enum.map(grid, &tl/1)
    [first, [_ | second] | remainder] = left

    [_, other_cols | _] = rotate_rest(IO.inspect([first, [current | second] | remainder]))
   
    bottom = Enum.drop(grid, 1)
    [[first, _ | col] | row] = bottom
    other_rows = rotate_rest([[first, current | col] | row])
    [[current | other_cols] | other_rows]
  end

  def rotate_right(first_row, second_row, first \\ true)
  def rotate_right([_], [_], _), do: []
  def rotate_right([_, top | rest_1], [left, self | rest_2], first) do
    self = rotate_top_and_left(left, top, self)
    rest_2 = rotate_right([top | rest_1], [self | rest_2], false)
    if first do
      [left, self | rest_2]
    else
      [self | rest_2]
    end
  end

  def rotate_down(rows, first \\ true)
  def rotate_down([_first], _), do: []
  def rotate_down([first, second | rest], first_call) do
    second = rotate_right(first, second)
    rest = rotate_down([second | rest], false)
    if first_call do
      [first, second | rest]
    else
      [second | rest]
    end
  end

  @seamonster "                  # 
#    ##    ##    ###
 #  #  #  #  #  #   "

  def find_seamonsters(picture) do
    seamonster = String.split(@seamonster, "\n")
    |> Enum.map(&String.graphemes/1)
    
    hash = List.flatten(seamonster)
    |> Enum.filter(&Kernel.==(&1, "#"))
    |> Enum.count()

    picture = String.split(picture, "\n")
    |> Enum.map(&String.graphemes/1)

    dots = List.flatten(picture)
    |> Enum.filter(&Kernel.==(&1, "#"))
    |> Enum.count()

    dots - (@muts
    |> Enum.map(&mutate(picture, &1))
    |> Enum.map(&count_in_picture(&1, seamonster))
    |> Enum.max()
    |> Kernel.*(hash))
  end

  def count_in_picture(picture, seamonster) do
    seamonster_height = Enum.count(seamonster) 
    Enum.chunk_every(picture, seamonster_height, 1, :discard)
    |> Enum.flat_map(&check_slice(&1, seamonster))
    |> Enum.filter(&detect_seamonster(seamonster, &1))
    |> Enum.count()
  end

  def check_slice(picture_slice, seamonster) do
    picture_width = Enum.count(hd(picture_slice))
    seamonster_width = Enum.count(hd(seamonster))
    0..(picture_width - seamonster_width)
    |> Enum.map(fn(idx) -> 
      Enum.map(picture_slice, &Enum.slice(&1, idx, seamonster_width))
    end)
  end

  def detect_seamonster([a, b, c], [d, e, f]) do
    aa = Enum.zip(a, d) |> Enum.all?(&check_tile/1)
    bb = Enum.zip(b, e) |> Enum.all?(&check_tile/1)
    cc = Enum.zip(c, f) |> Enum.all?(&check_tile/1)
    aa and bb and cc
  end

  def check_tile({a, b}) do
    a == b or a == " "
  end

  def solve() do
    tiles = read_lines("\n\n")
    |> Enum.map(&parse_tile/1)
   
    opposites = tiles
    |> Enum.map(&opposites/1)
    |> Map.new()

    edges = tiles
    |> Enum.reduce(%{}, &add_match/2)
    |> Map.to_list()
    |> Enum.filter(&has_two_matches/1)

    by_tile_id = Enum.reduce(edges, %{}, &red/2)

    by_tile_id
    |> Enum.filter(&(Enum.count(elem(&1, 1)) == 4))

    starting_corners = by_tile_id
    |> Enum.filter(&is_corner/1)
    |> Enum.map(&elem(&1, 0))

    edge_map = Map.new(edges)

    starting_corners
    |> Enum.flat_map(&solve_for_corner(&1, by_tile_id, edge_map, opposites))
    |> Enum.filter(&is_square/1)
    |> Enum.map(&transpose/1)
    |> Enum.map(&inflate(&1, Map.new(tiles)))
    |> Enum.map(&prepare_puzzle(&1, edge_map))
    |> Enum.filter(fn(grid) -> grid != :error end)
    |> Enum.map(fn(grid) -> rotate_down(grid) end)
    |> Enum.map(&create_puzzle(&1))
    |> Enum.take(1)
    |> Enum.map(&find_seamonsters/1)
    |> Enum.map(&to_string/1)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
