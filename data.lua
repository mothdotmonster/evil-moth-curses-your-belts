-- create items
for _, oldEntity in pairs(table.deepcopy(data.raw["underground-belt"])) do
	local oldItem = table.deepcopy(data.raw["item"][oldEntity.name])
	local oldRecipe = table.deepcopy(data.raw["recipe"][oldEntity.name])

	local entity = oldEntity
	local item = oldItem
	local recipe = oldRecipe

	entity.name = "deep-" .. entity.name
	entity.underground_sprite.shift = {0, 0.25}
	entity.minable.result = entity.name
	if (entity.next_upgrade ~= nil) then -- [object Object]
		entity.next_upgrade = "deep-" .. entity.next_upgrade
	end

	item.name = entity.name
	item.place_result = entity.name
	iconSize = 64
	if string.find(item.name, "bob") then -- TODO: better solution than hardcoding since Bob could just make his icons bigger
		iconSize = 32
	end

	item.icons = { -- overlay an arrow over the icon so you can tell them apart in your inventory 
		{
			icon = item.icon,
			icon_size = iconSize
		},{
			icon = "__base__/graphics/icons/arrows/down-arrow.png", 
			scale = 0.5,
			tint = {0, 0, 0, 0.5},
			floating = true
		},{
			icon = "__base__/graphics/icons/arrows/down-arrow.png", 
			scale = 0.4,
			floating = true
		}
	}

	recipe.name = entity.name
	-- concrete to make a good foundation and iron sticks like rebar. :)
	-- also an excuse to push slightly back in progression so you don't have them immediately
	table.insert(recipe.ingredients, {type = "item", name = "iron-stick", amount = 4})
	table.insert(recipe.ingredients, {type = "item", name = "concrete", amount = 2}) 
	recipe.results = {{type = "item", name = entity.name, amount = 2}}
	data:extend{item, recipe, entity}
end

data:extend{{ -- base technology
  type = "technology",
  name = "deep-underground-belts",
  icon_size = 32,
  icon = "__evil-moth-curses-your-belts__/graphics/placeholder/orange32.png", -- placeholder until i make a good icon
  effects = {{type = "unlock-recipe", recipe = "deep-underground-belt"}, {type = "unlock-recipe", recipe = "deep-fast-underground-belt"}},
  unit =
  {
    count = 250,
    ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
    time = 30
  },
	prerequisites = {"concrete", "logistics-2"} -- unlocked after red belts and concrete
}}

-- just monkeypatch the rest into existing techs
table.insert(data.raw["technology"]["logistics-3"].effects, {type = "unlock-recipe", recipe = "deep-express-underground-belt"})
table.insert(data.raw["technology"]["logistics-3"].prerequisites, "deep-underground-belts")

if mods["space-age"] then
	table.insert(data.raw["technology"]["turbo-transport-belt"].effects, {type = "unlock-recipe", recipe = "deep-turbo-underground-belt"})
end

if mods["boblogistics"] then
	table.insert(data.raw["technology"]["logistics-4"].effects, {type = "unlock-recipe", recipe = "deep-bob-turbo-underground-belt"})
	table.insert(data.raw["technology"]["logistics-5"].effects, {type = "unlock-recipe", recipe = "deep-bob-ultimate-underground-belt"})
end

if mods["Krastorio2"] then
	table.insert(data.raw["technology"]["kr-logistic-4"].effects, {type = "unlock-recipe", recipe = "deep-kr-advanced-underground-belt"})
	table.insert(data.raw["technology"]["kr-logistic-5"].effects, {type = "unlock-recipe", recipe = "deep-kr-superior-underground-belt"})
end

if mods["Krastorio2-spaced-out"] then
	table.insert(data.raw["technology"]["kr-logistic-5"].effects, {type = "unlock-recipe", recipe = "deep-kr-superior-underground-belt"})
end