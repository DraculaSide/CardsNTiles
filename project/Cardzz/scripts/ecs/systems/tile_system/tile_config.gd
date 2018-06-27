extends Node

const Resources = preload("../resource_system/resources.gd").Resources

export(Texture) var texture
export(Resources) var resource
export(bool) var walkable