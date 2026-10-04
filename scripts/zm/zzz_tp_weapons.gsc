#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

// TopPlays weapon pack loader (pilot: MP7 only).
// Assets: dlc5\mod.ff + topplays_weapons.iwd + topplays_weapons.all.sabl
// Registers base/upgraded pairs so level.zombie_weapons[ base ].upgrade_name
// is available to UPGRADE CURRENT later. Not added to the mystery box.

init()
{
    if ( getdvar( "mapname" ) != "zm_theater" )
        return;

    if ( isdefined( level.tp_weapons_registered ) )
        return;

    level.tp_weapons_registered = 1;

    tp_register_weapon( "mp7_zm", "mp7_upgraded_zm", &"ZOMBIE_WEAPON_MP7", 1200, "smg" );
}

tp_register_weapon( base, upgraded, hint, cost, vox )
{
    precacheitem( base );
    precacheitem( upgraded );

    include_weapon( base, 0 );
    include_weapon( upgraded, 0 );

    add_zombie_weapon( base, upgraded, hint, cost, vox, "", undefined );

    println( "TOPPLAYS WEAPONS >> registered " + base + " -> " + upgraded );
}
