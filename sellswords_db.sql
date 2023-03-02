--Table for storing the player information
CREATE TABLE IF NOT EXISTS 'player' (
    username VARCHAR(30) NOT NULL,
    password VARCHAR(40) NOT NULL,
    PRIMARY KEY (username),
    UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the game information
CREATE TABLE IF NOT EXISTS 'game' (
    gameid INT NOT NULL,
    round_start TIMESTAMP NOT NULL, -- Store time at the beginning of the round
    round_end TIMESTAMP NOT NULL, -- Store end time at end of the round
    max_players INT CHECK(max_players <= 2 AND max_players > 0), 
    start_playerid INT NOT NULL, 
    result INT NOT NULL,
    move_timelimit INT NOT NULL,
    PRIMARY KEY (gameid),
    FOREIGN KEY (startplayerid) REFERENCES player(username),
    FOREIGN KEY (result) REFERENCES result(resultid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the players in a game
CREATE TABLE IF NOT EXISTS 'member' (
    memberid INT NOT NULL,
    playerid VARCHAR(30) NOT NULL,
    matchid INT NOT NULL,
    --score DECIMAL(5,2) NOT NULL, !!!NOT SURE IF NECESSARY!!!
    PRIMARY KEY (memberid),
    FOREIGN KEY (playerid) REFERENCES player(username),
    FOREIGN KEY (matchid) REFERENCES game(gameid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the results of a game
CREATE TABLE IF NOT EXISTS 'result' (
    resultid INT NOT NULL,
    result_type BINARY, -- A 1 or 0 for a win or loss, respectively
    PRIMARY KEY (resultid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the cards in the game
CREATE TABLE IF NOT EXISTS 'card' (
    cardid INT NOT NULL,
    card_name VARCHAR(32), -- Actual names of each card
    card_type VARCHAR(32), -- Denotes types of card: minion, invocation, terrain
    PRIMARY KEY (cardid),
    FOREIGN KEY (card_type) REFERENCES energy(energy_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the energy types in the game
CREATE TABLE IF NOT EXISTS 'energy' (
    energyid INT NOT NULL,
    energy_type VARCHAR(32), -- All energy types: void, fire, wind, water
    PRIMARY KEY (energyid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the minion cards in the game
CREATE TABLE IF NOT EXISTS 'minion' (
    minionid INT NOT NULL,
    card_type VARCHAR(32),
    energy_type VARCHAR(32),
    summon_cost SMALLINT, -- Cost of summoning a minion card in hand
    start_power SMALLINT, -- Power that a minion can start with
    atk_cost SMALLINT, -- The cost of attacking with a particular minion
    PRIMARY KEY (minionid),
    FOREIGN KEY (card_type) REFERENCES card(card_type),
    FOREIGN KEY (energy_type) REFERENCES energy(energy_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the invocation cards in the game
CREATE TABLE IF NOT EXISTS 'spell' (
    spellid INT NOT NULL,
    card_type VARCHAR(32),
    energy_type VARCHAR(32),
    fast_cost SMALLINT, -- Cost to speed up the time to activate invocation
    slow_time SMALLINT, -- Time to play the specific invocation card
    PRIMARY KEY (spellid),
    FOREIGN KEY (card_type) REFERENCES card(card_type),
    FOREIGN KEY (energy_type) REFERENCES energy(energy_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the terrain cards in the game
CREATE TABLE IF NOT EXISTS 'terrain' (
    terrainid INT NOT NULL,
    card_type VARCHAR(32),
    energy_type VARCHAR(32),
    PRIMARY KEY (terrainid),
    FOREIGN KEY (card_type) REFERENCES card(card_type)
    FOREIGN KEY (energy_type) REFERENCES energy(energy_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the cards in a player's hand
CREATE TABLE IF NOT EXISTS 'card_in_hand' (
    card_in_handid INT NOT NULL,
    memberid INT NOT NULL,
    PRIMARY KEY (card_in_handid),
    FOREIGN KEY (card_in_handid) REFERENCES card(cardid),
    FOREIGN KEY (memberid) REFERENCES member(memberid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

-- Table for storing the information about the cards in the discard stack
CREATE TABLE IF NOT EXISTS 'card_in_discard' (
    card_in_discardid INT NOT NULL,
    memberid INT NOT NULL,
    PRIMARY KEY (card_in_discardid),
    FOREIGN KEY (card_in_discardid) REFERENCES card(cardid),
    FOREIGN KEY (memberid) REFERENCES member(memberid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the zone traits
CREATE TABLE IF NOT EXISTS 'zone_traits' (
    zone_traitid INT NOT NULL,
    zone_type VARCHAR(32),
    PRIMARY KEY (zoneid)
)

-- Table for storing the information about the zones in the game
CREATE TABLE IF NOT EXISTS 'contested_zone' (
    contested_zoneid INT NOT NULL,
    zoneid INT NOT NULL,
    memberid INT NOT NULL,
    zone1_effect VARCHAR(32),
    zone2_effect VARCHAR(32),
    zone3_effect VARCHAR(32),
    zone1_revealed BOOLEAN, 
    zone2_revealed BOOLEAN,
    zone3_revealed BOOLEAN,
    zone1_slot INT CHECK(zone1_slot != zone2_slot AND zone1_slot != zone3_slot),
    zone2_slot INT CHECK(zone2_slot != zone1_slot AND zone2_slot != zone3_slot),
    zone3_slot INT CHECK(zone3_slot != zone1_slot AND zone3_slot != zone2_slot),
    PRIMARY KEY (contested_zoneid),
    FOREIGN KEY (zoneid) REFERENCES zone_traits(zoneid),
    FOREIGN KEY (memberid) REFERENCES member(memberid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for storing the information about the actual game info
-- available on the board that players see
CREATE TABLE IF NOT EXISTS 'player_board' (
    player_boardid INT NOT NULL,
    gameid INT NOT NULL,
    memberid INT NOT NULL,
    card_in_handid INT NOT NULL,
    card_in_discardid INT NOT NULL,
    contested_zoneid INT NOT NULL,
    cardid INT NOT NULL,
    minion1_slot INT CHECK(minion1_slot != minion2_slot AND minion1_slot != minion3_slot),
    minion2_slot INT CHECK(minion2_slot != minion1_slot AND minion2_slot != minion3_slot),
    minion3_slot INT CHECK(minion3_slot != minion1_slot AND minion3_slot != minion2_slot),
    invocation1_slot INT CHECK(invocation1_slot != invocation2_slot AND invocation1_slot != invocation3_slot),
    invocation2_slot INT CHECK(invocation2_slot != invocation1_slot AND invocation2_slot != invocation3_slot),
    invocation3_slot INT CHECK(invocation3_slot != invocation1_slot AND invocation3_slot != invocation2_slot),
    active_terrain_count INT, -- Stores the active terrain currently in play
    spent_terrain_count INT, -- Stores the terrain that has been used
    terrainid INT NOT NULL,
    player_health INT, -- Stores the health of each player
    AFKwarnings = 0 SMALLINT,
    PRIMARY KEY (boardid),
    FOREIGN KEY (gameid) REFERENCES game(gameid),
    FOREIGN KEY (memberid) REFERENCES member(memberid),
    FOREIGN KEY (card_in_handid) REFERENCES card_in_hand(card_in_handid),
    FOREIGN KEY (card_in_discardid) REFERENCES card_in_discard(card_in_discardid),
    FOREIGN KEY (contested_zoneid) REFERENCES contested_zone(contested_zoneid),
    FOREIGN KEY (cardid) REFERENCES card(cardid),
    FOREIGN KEY (terrainid) REFERENCES terrain(terrainid)
    FOREIGN KEY (minion1_slot) REFERENCES minion(minionid),
    FOREIGN KEY (minion2_slot) REFERENCES minion(minionid),
    FOREIGN KEY (minion3_slot) REFERENCES minion(minionid),
    FOREIGN KEY (invocation1_slot) REFERENCES spell(spellid),
    FOREIGN KEY (invocation2_slot) REFERENCES spell(spellid),
    FOREIGN KEY (invocation3_slot) REFERENCES spell(spellid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;