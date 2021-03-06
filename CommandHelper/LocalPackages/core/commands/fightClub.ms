register_command(fightclub, 

    array(
    
        description: 'Starts a fight club request',
        
        usage: '/fightclub',
        
        permission: 'ch.alias.fightclub',
        
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
    
        executor: closure() {
                
                @fightClubStatus = import('fightClubStatus')
                @plr = player()

                @ploc = ploc(@plr)
                
                @vicLoc = associative_array('x':-14,'y':31,'z':-11)

                @x1 = @ploc['x']
                @y1 = @ploc['y']
                @z1 = @ploc['z']

                @x2 = @vicLoc['x']
                @y2 = @vicLoc['y']
                @z2 = @vicLoc['z']

                @x3 = pow(@x1 - @x2, 2)
                @y3 = pow(@y1 - @y2, 2)
                @z3 = pow(@z1 - @z2, 2)

                @final = @x3 + @y3 + @z3

                @final = sqrt(@final)

                if(@final > 5){
                    tmsg(@plr,color(red).'You must be in the basement of the bar in the bright area to enter Fight Club')
                    die()
                }

                if(@fightClubStatus != 'closed'){
                    @plrs = all_players('fightclub')
                    @otherRegisteredPlayers = false
                    foreach(@player in @plrs){
                        @alreadyRegistered = import(@player.'fightClub')

                        if(@alreadyRegistered == 'true' && @plr != @player){
                            @playaz = all_players()
                            foreach(@pl in @playaz){
                                export(@plr.'fightClubBetPerson','')
                                export(@plr.'fightClubBetAmt','')
                            }
                            export('fightClubStatus','closed')
                            export('fightClubFighter1',@player)
                            export('fightClubFighter2',@plr)
                            export(@player.'fcvs',@plr)
                            export(@plr.'fcvs',@player)
                            @plrWins = get_value(@plr.'fightClubWins')
                            @plrLosses = get_value(@plr.'fightClubLosses')
                            @playerWins = get_value(@player.'fightClubWins')
                            @playerLosses = get_value(@player.'fightClubLosses')
                            @otherRegisteredPlayers = true
                            @playerBetPercent = 100
                            
                            if(@plrWins == null){
                                @plrWins = 0
                            }
                            if(@plrLosses == null){
                                @plrLosses = 0
                            }
                            if(@playerWins == null){
                                @playerWins = 0
                            }
                            if(@playerLosses == null){
                                @playerLosses = 0
                            }

                            broadcast(
                                color(white).@player.
                                color(red).' ('.color(green).@playerWins.' wins '.
                                color(dark_red).@playerLosses.' losses'.color(red).') '.
                                'and '.
                                color(white).@plr.
                                color(red).' ('.color(green).@plrWins.' wins '.
                                color(dark_red).@plrLosses.' losses'.color(red).') '.
                                'will starting Fight Club! Use '.
                                color(gold).'/fightclubbet <amount> <player>'.
                                color(dark_red).'   You only win money in official matches.'
                            )

                            set_timeout(10000,closure(
                                broadcast(color(red).'Fight Club begins in 20 secs...')
                            ))
                            set_timeout(20000,closure(
                                broadcast(color(red).'Fight Club begins in 10 secs...')
                            ))
                            set_timeout(27000,closure(
                                broadcast(color(red).'Fight Club begins in 3...')
                            ))
                            set_timeout(28000,closure(
                                broadcast(color(red).'Fight Club begins in 2...')
                            ))
                            set_timeout(29000,closure(
                                broadcast(color(red).'Fight Club begins in 1...')
                            ))
                            set_timeout(30000,closure(
                                runas(~console,'/heal '.@player)
                                runas(~console,'/heal '.@plr)
                                runas(~console,'/effect '.@player.' saturation 0')
                                runas(~console,'/effect '.@plr.' saturation 0')
                                broadcast(color(red).'Fight!')
                                export('fightClubActive','true')
                                runas(~console,'/pex user '.@player.' add essentials.protect.pvp fightclub')
                                runas(~console,'/pex user '.@plr.' add essentials.protect.pvp fightclub')

                                @p1 = bind(player_death,null,associative_array('player':@player),@e,@winner = @plr, @loser = @player){
                                    include('/home/minecraft/server/plugins/CommandHelper/includes/fightClubReset.ms')
                                    _fightClubReset(@winner,@loser)
                                }
                                @p2 = bind(player_death,null,associative_array('player':@plr),@e,@loser = @plr, @winner = @player){
                                    include('/home/minecraft/server/plugins/CommandHelper/includes/fightClubReset.ms')
                                    _fightClubReset(@winner,@loser)
                                }

                                export(@plr.'fightClubDeath',@p2)
                                export(@player.'fightClubDeath',@p1)
                            ))
                        }
                    }

                    if(@otherRegisteredPlayers == false){
                        export(@plr.'fightClub','true')
                        tmsg(@plr,color(red).'You have registered for Fight Club!')
                        broadcast(@plr.color(red).' wants to fight in Fight Club! '.color(gold).'/warp fightclub')
                    }
                }else{
                    tmsg(@plr,color(red),'Sorry, Fight Club is full right now!')
                }
        
                
        
        }
    )
)

register_command(fightclubreset, 

    array(
    
        description: 'Resets Fight Club',
        
        usage: '/fightclubreset',
        
        permission: 'ch.alias.fightclubreset',
        
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
    
        executor: closure() {		
                
                @plrs = all_players('fightclub')

                foreach(@player in @plrs){
                    export(@player.'fightClubDeath','')
                    export(@player.'fcvs','')
                    export(@player.'fightClub','')
                    tmsg('God_Doesnt_Exist',@player.' was reset')
                    runas(~console,'/pex user '.@player.' remove essentials.protect.pvp fightclub')
                }			
        
        }
    )
)
