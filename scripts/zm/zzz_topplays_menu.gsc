main()
{
}

init()
{
    if ( getdvar( "mapname" ) != "zm_theater" )
        return;

    println( "TOPPLAYS MENU >> V2 loaded" );

    level thread tp_wait_for_players();
}

tp_wait_for_players()
{
    for ( ;; )
    {
        players = getplayers();

        for ( i = 0; i < players.size; i++ )
        {
            p = players[i];

            if ( !isdefined( p.tp_menu_initialized ) )
            {
                p.tp_menu_initialized = 1;
                p thread tp_player_init();
            }
        }

        wait 0.25;
    }
}

tp_player_init()
{
    self endon( "disconnect" );

    self.tp_menu_open = 0;
    self.tp_menu_index = 0;
    self.tp_menu_page = 0;
    self.tp_give_page = 0;

    self thread tp_menu_controls();

    self iprintlnbold( "^2TopPlays V2 Loaded" );
    self iprintln( "^7Hold ADS + Melee to open" );
}

tp_menu_controls()
{
    self endon( "disconnect" );

    openHeld = 0;
    fireHeld = 0;
    adsHeld = 0;
    useHeld = 0;
    meleeHeld = 0;

    for ( ;; )
    {
        if ( !self.tp_menu_open )
        {
            if ( self adsbuttonpressed() && self meleebuttonpressed() )
            {
                if ( !openHeld )
                {
                    openHeld = 1;

                    // Prevent the opening buttons from immediately
                    // acting as navigation/back buttons.
                    adsHeld = 1;
                    meleeHeld = 1;

                    self tp_open_menu();
                }
            }
            else
            {
                openHeld = 0;
            }
        }
        else
        {
            // FIRE = DOWN
            if ( self attackbuttonpressed() )
            {
                if ( !fireHeld )
                {
                    fireHeld = 1;
                    self.tp_menu_index++;

                    if ( self.tp_menu_page == 0 )
                    {
                        if ( self.tp_menu_index > 5 )
                            self.tp_menu_index = 0;
                    }
                    else
                    {
                        if ( self.tp_menu_page == 2 )
                        {
                            if ( self.tp_menu_index > 5 )
                                self.tp_menu_index = 0;
                        }
                        else
                        {
                            if ( self.tp_menu_page == 3 )
                            {
                                if ( self.tp_menu_index > 5 )
                                    self.tp_menu_index = 0;
                            }
                            else
                            {
                                if ( self.tp_menu_index > 4 )
                                    self.tp_menu_index = 0;
                            }
                        }
                    }

                    self tp_update_selector();
                }
            }
            else
            {
                fireHeld = 0;
            }

            // ADS = UP
            if ( self adsbuttonpressed() )
            {
                if ( !adsHeld )
                {
                    adsHeld = 1;
                    self.tp_menu_index--;

                    if ( self.tp_menu_page == 0 )
                    {
                        if ( self.tp_menu_index < 0 )
                            self.tp_menu_index = 5;
                    }
                    else
                    {
                        if ( self.tp_menu_page == 2 )
                        {
                            if ( self.tp_menu_index < 0 )
                                self.tp_menu_index = 5;
                        }
                        else
                        {
                            if ( self.tp_menu_page == 3 )
                            {
                                if ( self.tp_menu_index < 0 )
                                    self.tp_menu_index = 5;
                            }
                            else
                            {
                                if ( self.tp_menu_index < 0 )
                                    self.tp_menu_index = 4;
                            }
                        }
                    }

                    self tp_update_selector();
                }
            }
            else
            {
                adsHeld = 0;
            }

            // F / USE = SELECT
            if ( self usebuttonpressed() )
            {
                if ( !useHeld )
                {
                    useHeld = 1;
                    self tp_select_option();
                }
            }
            else
            {
                useHeld = 0;
            }

            // MELEE = BACK / CLOSE
            if ( self meleebuttonpressed() )
            {
                if ( !meleeHeld )
                {
                    meleeHeld = 1;

                    if ( self.tp_menu_page != 0 )
                    {
                        oldPage = self.tp_menu_page;

                        if ( oldPage == 3 )
                        {
                            self.tp_menu_page = 2;
                            self.tp_menu_index = 0;

                            self tp_set_weapons_text();
                            self tp_update_selector();
                        }
                        else
                        {
                            self.tp_menu_page = 0;

                            if ( oldPage == 1 )
                                self.tp_menu_index = 2;

                            if ( oldPage == 2 )
                                self.tp_menu_index = 1;

                            self tp_set_main_text();
                            self tp_update_selector();
                        }
                    }
                    else
                    {
                        self tp_close_menu();
                    }
                }
            }
            else
            {
                meleeHeld = 0;
            }
        }

        wait 0.05;
    }
}

tp_open_menu()
{
    self.tp_menu_open = 1;
    self.tp_menu_page = 0;
    self.tp_menu_index = 0;

    self tp_build_menu_hud();
    self tp_set_main_text();
    self tp_update_selector();
}

tp_close_menu()
{
    self.tp_menu_open = 0;
    self.tp_menu_page = 0;
    self.tp_menu_index = 0;

    self tp_destroy_menu_hud();

    self freezecontrols( 0 );
}

tp_select_option()
{
    // MAIN MENU
    if ( self.tp_menu_page == 0 )
    {
        if ( self.tp_menu_index == 0 )
        {
            self iprintlnbold( "^5Player Mods coming next" );
            return;
        }

        if ( self.tp_menu_index == 1 )
        {
            self.tp_menu_page = 2;
            self.tp_menu_index = 0;

            self tp_set_weapons_text();
            self tp_update_selector();
            return;
        }

        if ( self.tp_menu_index == 2 )
        {
            self.tp_menu_page = 1;
            self.tp_menu_index = 0;

            self tp_set_points_text();
            self tp_update_selector();
            return;
        }

        if ( self.tp_menu_index == 3 )
        {
            self iprintlnbold( "^5Zombie Mods coming next" );
            return;
        }

        if ( self.tp_menu_index == 4 )
        {
            self iprintlnbold( "^5Fun Mods coming next" );
            return;
        }

        if ( self.tp_menu_index == 5 )
        {
            self iprintlnbold( "^5Settings coming next" );
            return;
        }

        return;
    }

    // POINTS SUBMENU
    if ( self.tp_menu_page == 1 )
    {
        if ( self.tp_menu_index == 0 )
        {
            self tp_add_points( 10000 );
            return;
        }

        if ( self.tp_menu_index == 1 )
        {
            self tp_add_points( 50000 );
            return;
        }

        if ( self.tp_menu_index == 2 )
        {
            self tp_add_points( 100000 );
            return;
        }

        if ( self.tp_menu_index == 3 )
        {
            self tp_add_points( 1000000 );
            return;
        }

        if ( self.tp_menu_index == 4 )
        {
            self.tp_menu_page = 0;
            self.tp_menu_index = 2;

            self tp_set_main_text();
            self tp_update_selector();
            return;
        }
    }

    // WEAPONS SUBMENU
    if ( self.tp_menu_page == 2 )
    {
        if ( self.tp_menu_index == 0 )
        {
            self.tp_menu_page = 3;
            self.tp_menu_index = 0;
            self.tp_give_page = 0;

            self tp_set_give_weapon_text();
            self tp_update_selector();
            return;
        }

        if ( self.tp_menu_index == 1 )
        {
            self tp_max_ammo();
            return;
        }

        if ( self.tp_menu_index == 2 )
        {
            self iprintlnbold( "^5Pack-a-Punch selected" );
            return;
        }

        if ( self.tp_menu_index == 3 )
        {
            self iprintlnbold( "^5Upgrade Current selected" );
            return;
        }

        if ( self.tp_menu_index == 4 )
        {
            self iprintlnbold( "^5Remove Weapon selected" );
            return;
        }

        if ( self.tp_menu_index == 5 )
        {
            self.tp_menu_page = 0;
            self.tp_menu_index = 1;

            self tp_set_main_text();
            self tp_update_selector();
            return;
        }
    }

    // GIVE WEAPON SUBMENU (paginated)
    // Rows 0-3 = weapons, row 4 = NEXT PAGE, row 5 = PREVIOUS PAGE.
    // MELEE still returns to the Weapons submenu.
    if ( self.tp_menu_page == 3 )
    {
        if ( self.tp_menu_index == 4 )
        {
            self tp_give_page_step( 1 );
            return;
        }

        if ( self.tp_menu_index == 5 )
        {
            self tp_give_page_step( -1 );
            return;
        }

        page = tp_get_weapon_page( self.tp_give_page );

        if ( self.tp_menu_index < page.ids.size )
            self tp_give_weapon( page.ids[ self.tp_menu_index ], page.names[ self.tp_menu_index ] );

        return;
    }
}


tp_give_weapon( weapon, displayName )
{
    weapons = self getWeaponsListPrimaries();

    // Normal BO2 two-weapon behavior.
    // If both primary slots are occupied, replace the weapon
    // the player is currently holding.
    if ( weapons.size >= 2 )
    {
        currentWeapon = self getCurrentWeapon();

        if ( currentWeapon != "none" && currentWeapon != "" )
        {
            self takeWeapon( currentWeapon );
        }
    }

    self giveWeapon( weapon );
    self setWeaponAmmoClip( weapon, 999 );
    self setWeaponAmmoStock( weapon, 999 );
    self switchToWeapon( weapon );

    self iprintlnbold( "^2GAVE " + displayName );
    println( "TOPPLAYS MENU >> gave weapon " + weapon );
}


tp_max_ammo()
{
    weapon = self getCurrentWeapon();

    if ( weapon == "none" || weapon == "" )
    {
        self iprintlnbold( "^1No weapon equipped" );
        return;
    }

    self setWeaponAmmoClip( weapon, 999 );
    self setWeaponAmmoStock( weapon, 999 );

    self iprintlnbold( "^2MAX AMMO" );
    println( "TOPPLAYS MENU >> Max Ammo applied to " + weapon );
}
tp_add_points( amount )
{
    self.score += amount;

    self iprintlnbold( "^2+" + amount + " Points" );

    println( "TOPPLAYS MENU >> added " + amount + " points; score=" + self.score );
}

tp_update_selector()
{
    selectorY = 64 + ( self.tp_menu_index * 34 );

    if ( isdefined( self.tp_select_bar ) )
        self.tp_select_bar.y = selectorY;

    if ( isdefined( self.tp_select_edge ) )
        self.tp_select_edge.y = selectorY;
}

tp_set_main_text()
{
    self.tp_title settext( "TOPPLAYS ZOMBIES" );
    self.tp_subtitle settext( "" );

    self.tp_text1 settext( "PLAYER MODS" );
    self.tp_text2 settext( "WEAPONS" );
    self.tp_text3 settext( "POINTS" );
    self.tp_text4 settext( "ZOMBIE MODS" );
    self.tp_text5 settext( "FUN MODS" );
    self.tp_text6 settext( "SETTINGS" );
}

tp_set_points_text()
{
    self.tp_title settext( "TOPPLAYS ZOMBIES" );
    self.tp_subtitle settext( "" );

    self.tp_text1 settext( "+10,000 POINTS" );
    self.tp_text2 settext( "+50,000 POINTS" );
    self.tp_text3 settext( "+100,000 POINTS" );
    self.tp_text4 settext( "+1,000,000 POINTS" );
    self.tp_text5 settext( "BACK" );
    self.tp_text6 settext( "" );
}

tp_set_give_weapon_text()
{
    page = tp_get_weapon_page( self.tp_give_page );

    self.tp_title settext( "TOPPLAYS ZOMBIES" );
    self.tp_subtitle settext( page.title + "  " + ( self.tp_give_page + 1 ) + "/" + tp_weapon_page_count() );

    self.tp_text1 settext( tp_page_label( page, 0 ) );
    self.tp_text2 settext( tp_page_label( page, 1 ) );
    self.tp_text3 settext( tp_page_label( page, 2 ) );
    self.tp_text4 settext( tp_page_label( page, 3 ) );
    self.tp_text5 settext( "NEXT PAGE >" );
    self.tp_text6 settext( "< PREVIOUS PAGE" );
}

tp_give_page_step( delta )
{
    count = tp_weapon_page_count();

    self.tp_give_page += delta;

    if ( self.tp_give_page >= count )
        self.tp_give_page = 0;

    if ( self.tp_give_page < 0 )
        self.tp_give_page = count - 1;

    self tp_set_give_weapon_text();
    self tp_update_selector();
}

tp_page_label( page, i )
{
    if ( i < page.names.size )
        return page.names[i];

    return "";
}

tp_page_add( page, id, name )
{
    page.ids[ page.ids.size ] = id;
    page.names[ page.names.size ] = name;
}

tp_weapon_page_count()
{
    return 10;
}

// Weapon IDs verified at runtime from level.zombie_weapons (W1 probe).
// Upgraded variants are NOT listed here; UPGRADE CURRENT will read
// level.zombie_weapons[ weapon ].upgrade_name at runtime instead.
tp_get_weapon_page( index )
{
    page = spawnstruct();
    page.title = "";
    page.ids = [];
    page.names = [];

    switch ( index )
    {
        case 0:
            page.title = "WONDER WEAPONS";
            tp_page_add( page, "ray_gun_zm", "RAY GUN" );
            tp_page_add( page, "raygun_mark2_zm", "RAY GUN MARK II" );
            tp_page_add( page, "thundergun_zm", "THUNDERGUN" );
            tp_page_add( page, "freezegun_zm", "WINTER'S HOWL" );
            break;

        case 1:
            page.title = "PISTOLS 1/2";
            tp_page_add( page, "m1911_zm", "M1911" );
            tp_page_add( page, "python_zm", "PYTHON" );
            tp_page_add( page, "fiveseven_zm", "FIVE-SEVEN" );
            tp_page_add( page, "beretta93r_zm", "B23R" );
            break;

        case 2:
            page.title = "PISTOLS 2/2";
            tp_page_add( page, "kard_zm", "KAP-40" );
            break;

        case 3:
            page.title = "SMGS 1/2";
            tp_page_add( page, "mp5k_zm", "MP5" );
            tp_page_add( page, "mp40_zm", "MP40" );
            tp_page_add( page, "ak74u_zm", "AK-74U" );
            tp_page_add( page, "pdw57_zm", "PDW-57" );
            break;

        case 4:
            page.title = "SMGS 2/2";
            tp_page_add( page, "uzi_zm", "UZI" );
            break;

        case 5:
            page.title = "RIFLES 1/2";
            tp_page_add( page, "m14_zm", "M14" );
            tp_page_add( page, "m16_zm", "M16" );
            tp_page_add( page, "galil_zm", "GALIL" );
            tp_page_add( page, "tar21_zm", "MTAR" );
            break;

        case 6:
            page.title = "RIFLES 2/2";
            tp_page_add( page, "type95_zm", "TYPE 25" );
            tp_page_add( page, "sa58_zm", "FAL OSW" );
            tp_page_add( page, "hk416_zm", "M27" );
            tp_page_add( page, "xm8_zm", "M8A1" );
            break;

        case 7:
            page.title = "SHOTGUNS";
            tp_page_add( page, "870mcs_zm", "REMINGTON 870" );
            tp_page_add( page, "rottweil72_zm", "OLYMPIA" );
            tp_page_add( page, "srm1216_zm", "M1216" );
            break;

        case 8:
            page.title = "LMG / SNIPER";
            tp_page_add( page, "hamr_zm", "HAMR" );
            tp_page_add( page, "rpd_zm", "RPD" );
            tp_page_add( page, "dsr50_zm", "DSR 50" );
            tp_page_add( page, "barretm82_zm", "BARRETT M82A1" );
            break;

        case 9:
            page.title = "SPECIALS";
            tp_page_add( page, "usrpg_zm", "RPG" );
            tp_page_add( page, "m32_zm", "WAR MACHINE" );
            tp_page_add( page, "knife_ballistic_zm", "BALLISTIC KNIFE" );
            tp_page_add( page, "knife_ballistic_bowie_zm", "BALLISTIC KNIFE (BOWIE)" );
            break;

        default:
            break;
    }

    return page;
}


tp_set_weapons_text()
{
    self.tp_title settext( "TOPPLAYS ZOMBIES" );
    self.tp_subtitle settext( "" );

    self.tp_text1 settext( "GIVE WEAPON" );
    self.tp_text2 settext( "MAX AMMO" );
    self.tp_text3 settext( "PACK-A-PUNCH" );
    self.tp_text4 settext( "UPGRADE CURRENT" );
    self.tp_text5 settext( "REMOVE WEAPON" );
    self.tp_text6 settext( "BACK" );
}
tp_make_text( x, y, scale, color )
{
    hud = newclienthudelem( self );

    hud.elemtype = "font";
    hud.font = "default";
    hud.fontscale = scale;
    hud.color = color;
    hud.alpha = 1;
    hud.sort = 20;
    hud.hidewheninmenu = 1;
    hud.x = x;
    hud.y = y;

    return hud;
}

tp_make_box( x, y, width, height, color, alpha, sort )
{
    hud = newclienthudelem( self );

    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.hidewheninmenu = 1;
    hud setshader( "white", width, height );
    hud.x = x;
    hud.y = y;

    return hud;
}

tp_build_menu_hud()
{
    // Compact TopPlays panel.
    // Moved inward from the extreme left side.
    panelX = -55;
    panelY = 15;

    // Main panel
    self.tp_bg = self tp_make_box(
        panelX,
        panelY,
        230,
        285,
        ( 0.01, 0.02, 0.05 ),
        0.94,
        5
    );

    // Header
    self.tp_header_bg = self tp_make_box(
        panelX,
        panelY,
        230,
        52,
        ( 0.025, 0.04, 0.09 ),
        1,
        6
    );

    // Top cyan half
    self.tp_cyan_top = self tp_make_box(
        panelX,
        panelY,
        115,
        3,
        ( 0.00, 0.75, 1.00 ),
        1,
        8
    );

    // Top magenta half
    self.tp_purple_top = self tp_make_box(
        panelX + 115,
        panelY,
        115,
        3,
        ( 0.85, 0.05, 1.00 ),
        1,
        8
    );

    // Left cyan border
    self.tp_cyan_left = self tp_make_box(
        panelX,
        panelY,
        3,
        285,
        ( 0.00, 0.75, 1.00 ),
        1,
        8
    );

    // Right magenta border
    self.tp_purple_right = self tp_make_box(
        panelX + 227,
        panelY,
        3,
        285,
        ( 0.85, 0.05, 1.00 ),
        1,
        8
    );

    // Six compact rows
    self.tp_row1 = self tp_make_box( panelX + 10, 64, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );
    self.tp_row2 = self tp_make_box( panelX + 10, 98, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );
    self.tp_row3 = self tp_make_box( panelX + 10, 132, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );
    self.tp_row4 = self tp_make_box( panelX + 10, 166, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );
    self.tp_row5 = self tp_make_box( panelX + 10, 200, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );
    self.tp_row6 = self tp_make_box( panelX + 10, 234, 210, 29, ( 0.035, 0.05, 0.09 ), 0.90, 6 );

    // Selected row
    self.tp_select_bar = self tp_make_box(
        panelX + 10,
        64,
        210,
        29,
        ( 0.70, 0.05, 1.00 ),
        0.50,
        7
    );

    self.tp_select_edge = self tp_make_box(
        panelX + 10,
        64,
        3,
        29,
        ( 0.00, 0.80, 1.00 ),
        1,
        8
    );

    // Header text
    self.tp_title = self tp_make_text( panelX + 18, panelY + 12, 1.35, ( 0.00, 0.80, 1.00 ) );
    self.tp_title settext( "TOPPLAYS ZOMBIES" );

    // Permanent TopPlays build branding.
    self.tp_build_name = self tp_make_text( panelX + 18, panelY + 30, 1.0, ( 0.90, 0.90, 1.00 ) );
    self.tp_build_name settext( "MOD MENU v1.0" );

    self.tp_build_version = self tp_make_text( panelX + 190, panelY + 28, 1.0, ( 1.00, 0.00, 1.00 ) );
    self.tp_build_version settext( "" );

    // Fontscale below 1.0 renders oversized in T6; keep it >= 1.0.
    // Sits under the TOPPLAYS title, inside the header band.
    self.tp_subtitle = self tp_make_text( panelX + 145, panelY + 30, 1.0, ( 0.90, 0.90, 1.00 ) );
    self.tp_subtitle settext( "" );

    // Row labels
    textX = panelX + 26;

    self.tp_text1 = self tp_make_text( textX, 69, 1.05, ( 0.92, 0.94, 1.00 ) );
    self.tp_text2 = self tp_make_text( textX, 103, 1.05, ( 0.92, 0.94, 1.00 ) );
    self.tp_text3 = self tp_make_text( textX, 137, 1.05, ( 0.92, 0.94, 1.00 ) );
    self.tp_text4 = self tp_make_text( textX, 171, 1.05, ( 0.92, 0.94, 1.00 ) );
    self.tp_text5 = self tp_make_text( textX, 205, 1.05, ( 0.92, 0.94, 1.00 ) );
    self.tp_text6 = self tp_make_text( textX, 239, 1.05, ( 0.92, 0.94, 1.00 ) );
}

tp_destroy_menu_hud()
{
    if ( isdefined( self.tp_bg ) )
        self.tp_bg destroy();

    if ( isdefined( self.tp_header_bg ) )
        self.tp_header_bg destroy();

    if ( isdefined( self.tp_cyan_top ) )
        self.tp_cyan_top destroy();

    if ( isdefined( self.tp_purple_top ) )
        self.tp_purple_top destroy();

    if ( isdefined( self.tp_cyan_left ) )
        self.tp_cyan_left destroy();

    if ( isdefined( self.tp_purple_right ) )
        self.tp_purple_right destroy();

    if ( isdefined( self.tp_row1 ) )
        self.tp_row1 destroy();

    if ( isdefined( self.tp_row2 ) )
        self.tp_row2 destroy();

    if ( isdefined( self.tp_row3 ) )
        self.tp_row3 destroy();

    if ( isdefined( self.tp_row4 ) )
        self.tp_row4 destroy();

    if ( isdefined( self.tp_row5 ) )
        self.tp_row5 destroy();

    if ( isdefined( self.tp_row6 ) )
        self.tp_row6 destroy();

    if ( isdefined( self.tp_select_bar ) )
        self.tp_select_bar destroy();

    if ( isdefined( self.tp_select_edge ) )
        self.tp_select_edge destroy();

    if ( isdefined( self.tp_title ) )
        self.tp_title destroy();

    if ( isdefined( self.tp_subtitle ) )
        self.tp_subtitle destroy();

    if ( isdefined( self.tp_build_name ) )
        self.tp_build_name destroy();

    if ( isdefined( self.tp_build_version ) )
        self.tp_build_version destroy();

    if ( isdefined( self.tp_text1 ) )
        self.tp_text1 destroy();

    if ( isdefined( self.tp_text2 ) )
        self.tp_text2 destroy();

    if ( isdefined( self.tp_text3 ) )
        self.tp_text3 destroy();

    if ( isdefined( self.tp_text4 ) )
        self.tp_text4 destroy();

    if ( isdefined( self.tp_text5 ) )
        self.tp_text5 destroy();

    if ( isdefined( self.tp_text6 ) )
        self.tp_text6 destroy();
}







