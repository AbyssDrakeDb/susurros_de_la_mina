class_name CavePathData
extends Resource

## Datos extraídos de cave_example.tscn
## Contiene la secuencia de piezas y sus transformaciones relativas
## para que mine_generator.gd pueda generar cuevas con vértices alineados.

@export var pieces: Array[Dictionary] = []

static func from_cave_example() -> CavePathData:
	var data: CavePathData = CavePathData.new()
	
	var raw_positions: Array[Dictionary] = [
		{"name": "Object014", "pos": Vector3(3782.32, 160.90, -2490.72), "rot": false},
		{"name": "Object015", "pos": Vector3(3674.97, -153.41, -3687.23), "rot": false},
		{"name": "Object039", "pos": Vector3(-178.39, -1183.15, -4093.46), "rot": false},
		{"name": "Object010", "pos": Vector3(3758.89, -322.63, -4867.61), "rot": false},
		{"name": "Object012", "pos": Vector3(4933.72, -311.60, -4903.90), "rot": false},
		{"name": "Object017", "pos": Vector3(2882.42, -287.91, -4903.90), "rot": false},
		{"name": "Object023", "pos": Vector3(6073.27, -287.79, -4920.02), "rot": false},
		{"name": "Shape013", "pos": Vector3(-207.88, -1040.64, -5524.83), "rot": false},
		{"name": "Object018", "pos": Vector3(2889.48, -494.43, -5775.82), "rot": false},
		{"name": "Object016", "pos": Vector3(3652.54, -311.60, -6042.94), "rot": false},
		{"name": "Shape012", "pos": Vector3(6105.78, -192.78, -6458.24), "rot": false},
		{"name": "Object019", "pos": Vector3(2782.38, -808.74, -6971.32), "rot": false},
		{"name": "Object009", "pos": Vector3(3649.01, -316.14, -7095.30), "rot": true},
		{"name": "Object020", "pos": Vector3(2548.27, -153.47, -7157.80), "rot": false},
		{"name": "Shape022", "pos": Vector3(6766.53, -2202.75, -7192.07), "rot": true},
		{"name": "Object011", "pos": Vector3(1368.90, -11.47, -7241.47), "rot": false},
		{"name": "Object021", "pos": Vector3(221.54, -599.51, -7250.54), "rot": false},
		{"name": "Object027", "pos": Vector3(6183.40, -316.14, -7890.62), "rot": false},
		{"name": "Object028", "pos": Vector3(6960.07, -287.79, -8053.92), "rot": false},
		{"name": "Shape018", "pos": Vector3(1493.39, -848.05, -8099.28), "rot": false},
		{"name": "Object024", "pos": Vector3(2866.30, -978.02, -8152.70), "rot": false},
		{"name": "Shape014", "pos": Vector3(4632.33, -845.91, -8169.84), "rot": false},
		{"name": "Shape023", "pos": Vector3(7811.58, -2999.08, -8218.23), "rot": false},
		{"name": "Shape024", "pos": Vector3(2334.32, -2343.75, -8218.23), "rot": true},
		{"name": "Object056", "pos": Vector3(5228.06, -2628.38, -8223.27), "rot": false},
		{"name": "Object057", "pos": Vector3(6423.81, -2969.34, -8330.11), "rot": false},
		{"name": "Object026", "pos": Vector3(-281.96, -1159.59, -8595.22), "rot": false},
		{"name": "Object052", "pos": Vector3(3876.82, -1902.62, -8704.09), "rot": false},
		{"name": "Object029", "pos": Vector3(6936.88, -494.43, -8945.00), "rot": false},
		{"name": "Object055", "pos": Vector3(6725.20, -2506.66, -8973.22), "rot": false},
		{"name": "Object025", "pos": Vector3(2759.70, -967.00, -9327.03), "rot": false},
		{"name": "Object043", "pos": Vector3(1005.51, -1001.33, -9721.17), "rot": false},
		{"name": "Object042", "pos": Vector3(-175.37, -1170.61, -9769.55), "rot": false},
		{"name": "Shape015", "pos": Vector3(5396.40, 325.84, -9769.55), "rot": true},
		{"name": "Object044", "pos": Vector3(2150.86, -811.95, -9821.97), "rot": false},
		{"name": "Object030", "pos": Vector3(7044.24, -808.74, -10141.50), "rot": false},
		{"name": "Object034", "pos": Vector3(3784.34, -1132.62, -10141.50), "rot": false},
		{"name": "Object054", "pos": Vector3(6832.56, -2820.91, -10169.73), "rot": false},
		{"name": "Object045", "pos": Vector3(2782.38, -1132.62, -10790.66), "rot": false},
		{"name": "Object046", "pos": Vector3(-166.80, -1771.39, -10918.68), "rot": false},
		{"name": "Object058", "pos": Vector3(2235.03, -634.67, -11055.77), "rot": false},
		{"name": "Object053", "pos": Vector3(6732.26, -2955.35, -11314.82), "rot": false},
		{"name": "Shape021", "pos": Vector3(-3571.85, -2534.26, -11333.98), "rot": true},
		{"name": "Object048", "pos": Vector3(1183.93, -2497.09, -11398.49), "rot": true},
		{"name": "Object050", "pos": Vector3(4110.68, -2820.91, -11398.49), "rot": true},
		{"name": "Object047", "pos": Vector3(-1518.03, -2497.09, -11399.50), "rot": false},
		{"name": "Object049", "pos": Vector3(2647.31, -2655.35, -11421.67), "rot": false},
		{"name": "Object051", "pos": Vector3(5573.81, -2979.17, -11421.67), "rot": false},
		{"name": "Object031", "pos": Vector3(6563.42, -406.98, -11492.23), "rot": false},
		{"name": "Object033", "pos": Vector3(4265.16, -406.98, -11492.23), "rot": false},
		{"name": "Object032", "pos": Vector3(5414.29, 193.79, -11535.58), "rot": false},
		{"name": "Object061", "pos": Vector3(2887.46, -1264.30, -12183.73), "rot": false},
		{"name": "Object040", "pos": Vector3(7070.19, -971.47, -12431.70), "rot": false},
		{"name": "Object041", "pos": Vector3(8164.89, -967.00, -12472.02), "rot": false},
		{"name": "Shape016", "pos": Vector3(10213.16, -845.91, -12560.72), "rot": true},
		{"name": "Object036", "pos": Vector3(5307.69, 204.81, -12710.92), "rot": false},
		{"name": "Object035", "pos": Vector3(3784.34, -808.74, -12842.97), "rot": false},
		{"name": "Shape025", "pos": Vector3(2126.17, -372.59, -13340.92), "rot": true},
		{"name": "Shape027", "pos": Vector3(2733.49, -1758.03, -13653.40), "rot": false},
		{"name": "Shape026", "pos": Vector3(7728.93, 1047.82, -14147.33), "rot": true},
		{"name": "Object037", "pos": Vector3(5330.37, 39.25, -14173.54), "rot": true},
		{"name": "Object060", "pos": Vector3(5598.50, 847.99, -14365.06), "rot": false},
		{"name": "Object059", "pos": Vector3(4258.36, -406.98, -14476.95), "rot": false},
		{"name": "Object065", "pos": Vector3(2298.03, -17.52, -15135.18), "rot": false},
		{"name": "Object063", "pos": Vector3(5437.72, -301.84, -15370.04), "rot": false},
		{"name": "Object066", "pos": Vector3(5104.58, -497.08, -15388.19), "rot": false},
		{"name": "Shape029", "pos": Vector3(711.18, -567.32, -15496.04), "rot": false},
		{"name": "Object062", "pos": Vector3(3905.55, -744.10, -15534.35), "rot": false},
		{"name": "Object068", "pos": Vector3(3784.34, -484.85, -16437.52), "rot": false},
		{"name": "Object064", "pos": Vector3(5330.37, -616.15, -16566.55), "rot": false},
		{"name": "Object067", "pos": Vector3(3891.69, -170.61, -17633.02), "rot": false},
		{"name": "Shape028", "pos": Vector3(5482.58, -616.27, -18733.76), "rot": false},
		{"name": "Shape030", "pos": Vector3(3067.14, 325.84, -19226.68), "rot": true},
		{"name": "Object069", "pos": Vector3(5437.72, -957.17, -19979.66), "rot": false},
		{"name": "Object070", "pos": Vector3(5330.37, -1271.48, -21176.17), "rot": false},
		{"name": "Object071", "pos": Vector3(5437.72, -1612.56, -22371.66), "rot": false},
		{"name": "Object072", "pos": Vector3(5330.37, -1926.93, -23568.17), "rot": false},
		{"name": "Object073", "pos": Vector3(5269.89, -2289.57, -25129.57), "rot": false},
	]
	
	data.pieces.clear()
	var prev_pos: Vector3 = raw_positions[0]["pos"]
	
	for i in range(raw_positions.size()):
		var entry: Dictionary = raw_positions[i]
		var rel_pos: Vector3 = entry["pos"] - prev_pos if i > 0 else Vector3.ZERO
		
		data.pieces.append({
			"name": entry["name"],
			"absolute_pos": entry["pos"],
			"relative_pos": rel_pos,
			"has_rotation": entry["rot"],
			"depth_level": _get_depth_level(entry["pos"].z),
		})
		prev_pos = entry["pos"]
	
	return data

static func _get_depth_level(z: float) -> int:
	if z > -4500: return 0
	if z > -6500: return 1
	if z > -8500: return 2
	if z > -10000: return 3
	if z > -11500: return 4
	if z > -13000: return 5
	if z > -15500: return 6
	if z > -18000: return 7
	if z > -20500: return 8
	if z > -23000: return 9
	return 10
