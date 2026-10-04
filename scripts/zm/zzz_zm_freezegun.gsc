#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init()
{
    if ( isDefined( level.freezegun_registered ) )
    {
        return;
    }

    level.freezegun_registered = 1;

    precachestring( &"ZOMBIE_WEAPON_FREEZEGUN" );

    precacheitem( "freezegun_zm" );
    precacheitem( "freezegun_upgraded_zm" );

    include_weapon( "freezegun_zm" );

    add_limited_weapon( "freezegun_zm", 1 );

    add_zombie_weapon(
        "freezegun_zm",
        "freezegun_upgraded_zm",
        &"ZOMBIE_WEAPON_FREEZEGUN",
        10,
        "freeze",
        "",
        undefined
    );

    maps\mp\zombies\_zm_weap_freezegun::init();

    println( "TOPPLAYS >> Winter's Howl registered" );
}
