CREATE TABLE player IF NOT EXISTS (
    username VARCHAR(30) NOT NULL,
    password VARCHAR(40) NOT NULL,
    PRIMARY KEY (username),
    UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE game IF NOT EXISTS (
    gameid INT NOT NULL,
    round_start TIMESTAMP NOT NULL,
    round_end TIMESTAMP NOT NULL,
    max_players INT CHECK(maxplayers <= 2 AND maxplayers > 0),
    start_playerid INT NOT NULL,
    result INT NOT NULL,
    move_timelimit INT NOT NULL,
    PRIMARY KEY (gameid),
    FOREIGN KEY (startplayerid) REFERENCES player(username),
    FOREIGN KEY (result) REFERENCES result(resultid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE member IF NOT EXISTS (
    memberid INT NOT NULL,
    playerid VARCHAR(30) NOT NULL,
    matchid INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (memberid),
    FOREIGN KEY (playerid) REFERENCES player(username),
    FOREIGN KEY (matchid) REFERENCES game(gameid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE result IF NOT EXISTS (
    resultid INT NOT NULL,
    result_type VARCHAR(128),
    PRIMARY KEY (resultid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE card IF NOT EXISTS (
    cardid INT NOT NULL,
    card_name VARCHAR(32),
    card_type VARCHAR(32),
    PRIMARY KEY (cardid),
    FOREIGN KEY (card_type) REFERENCES energy(energy_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE energy IF NOT EXISTS (
    energyid INT NOT NULL,
    energy_type VARCHAR(32),
    PRIMARY KEY (energyid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE action IF NOT EXISTS (
    actionid INT NOT NULL,
    matchid INT NOT NULL,
    cardid INT NOT NULL,
    memberid INT NOT NULL,
    action_type INT,
    move_from VARCHAR(32) NULL,
    move_to VARCHAR(32),
    PRIMARY KEY (actionid),
    FOREIGN KEY (matchid) REFERENCES game(gameid),
    FOREIGN KEY (cardid) REFERENCES card(cardid),
    FOREIGN KEY (memberid) REFERENCES member(memberid),
    FOREIGN KEY (action_type) REFERENCES action_type(action_typeid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE action_type IF NOT EXISTS (
    action_typeid INT NOT NULL,
    action_name VARCHAR(32),
    PRIMARY KEY (action_typeid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;