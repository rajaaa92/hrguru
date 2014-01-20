collection memberships
extends 'memberships/base'

node(:icon_edit) { |membership| membership.icon_edit(id: membership.id) }
