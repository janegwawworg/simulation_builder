extends Reference
class_name Recipes

const Crafting := {
	StirlingEngine = {inputs = {"Ingot": 8, "Wire": 3}, amount = 1},
	Wire = {inputs = {"Ingot": 2}, amount = 5},
	Battery = {inputs = {"Ingot": 12, "Wire": 5}, amount = 1},
	Pickaxe = {inputs = {"Branches": 2, "Ingot": 3}, amount = 1},
	CrudePickaxe = {inputs = {"Branches": 2, "Stone": 5}, amount = 1},
	Axe = {inputs = {"Branches": 2, "Ingot": 3}, amount = 1},
	CrudeAxe = {inputs = {"Branches": 2, "Stone": 5}, amount = 1},
	Branches = {inputs = {"Lumber": 1, "Axe": 0}, amount = 5},
	Chest = {inputs = {"Lumber": 2, "Branches": 3, "Ingot": 1}, amount = 1},
}

const Fuels := {Lumber = 50.0, Branches = 10.0}

const Smelting := {
	Ingot = {inputs = {"Ore": 1}, amount = 1, time = 5.0},
	Coal = {inputs = {"Lumber": 1}, amount = 2, time = 3.0},
}
