CREATE TABLE Vinculo (
    id int NOT NULL IDENTITY,
    sigla varchar(255) NOT NULL,
    descricao varchar(255),
    PRIMARY KEY (id)
);
CREATE TABLE UnidadeOrganica(
    id int NOT NULL IDENTITY,
    sigla varchar(255) NOT NULL,
    descricao varchar(255),
    PRIMARY KEY (id)
);
CREATE TABLE ClassroomGroup(
	id VARCHAR(255) NOT NULL PRIMARY KEY,
	name VARCHAR(255)
);
CREATE TABLE Profile(
	id VARCHAR(255) NOT NULL PRIMARY KEY,
	name VARCHAR(255)
);
CREATE TABLE MUP(
    id INT NOT NULL IDENTITY,
    uo INT NOT NULL,
	vinculo INT NOT NULL,
    profile varchar(255) NOT NULL,
	classGroup VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),

	FOREIGN KEY (uo) REFERENCES Vinculo(id),
	FOREIGN KEY (vinculo) REFERENCES UnidadeOrganica(id),
	FOREIGN KEY (profile) REFERENCES ClassroomGroup(id),
	FOREIGN KEY (classGroup) REFERENCES Profile(id),
);

