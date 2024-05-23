-- Таблица LogicBlocks
CREATE TABLE LogicBlocks (
    Id SERIAL PRIMARY KEY,
    Code VARCHAR(255) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    TableName VARCHAR(255) NOT NULL
);

-- Таблица Characteristics
CREATE TABLE Characteristics (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    DataTypeId INT NOT NULL,
    LogicBlockId INT NOT NULL,
    Description TEXT NOT NULL,
    CONSTRAINT FK_Characteristics_LogicBlocks FOREIGN KEY (LogicBlockId) REFERENCES LogicBlocks(Id) ON DELETE CASCADE
);

-- Таблица LogicBlockAttributes
CREATE TABLE LogicBlockAttributes (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    AttributeType INT NOT NULL,
    Description TEXT NOT NULL,
    LogicBlockId INT NOT NULL,
    CONSTRAINT FK_LogicBlockAttributes_LogicBlocks FOREIGN KEY (LogicBlockId) REFERENCES LogicBlocks(Id) ON DELETE CASCADE
);

-- Базовая таблица LogicBlockAttributeValues
CREATE TABLE LogicBlockAttributeValues (
    Id SERIAL PRIMARY KEY,
    LogicBlockAttributeId INT NOT NULL,
    ValueType VARCHAR(255) NOT NULL,
    CONSTRAINT FK_LogicBlockAttributeValues_LogicBlockAttributes FOREIGN KEY (LogicBlockAttributeId) REFERENCES LogicBlockAttributes(Id) ON DELETE CASCADE
);

-- Таблица для LogicBlockAttributeCharacteristicCollection
CREATE TABLE LogicBlockAttributeCharacteristicCollections (
    Id SERIAL PRIMARY KEY,
    LogicBlockAttributeId INT NOT NULL,
    CONSTRAINT FK_LogicBlockAttributeCharacteristicCollections_LogicBlockAttributeValues FOREIGN KEY (Id) REFERENCES LogicBlockAttributeValues(Id) ON DELETE CASCADE
);

-- Промежуточная таблица для связи LogicBlockAttributeCharacteristicCollection и Characteristics
CREATE TABLE LogicBlockAttributeCharacteristicCollectionCharacteristics (
    LogicBlockAttributeCharacteristicCollectionId INT NOT NULL,
    CharacteristicId INT NOT NULL,
    PRIMARY KEY (LogicBlockAttributeCharacteristicCollectionId, CharacteristicId),
    CONSTRAINT FK_LogicBlockAttributeCharacteristicCollectionCharacteristics_LogicBlockAttributeCharacteristicCollections FOREIGN KEY (LogicBlockAttributeCharacteristicCollectionId) REFERENCES LogicBlockAttributeCharacteristicCollections(Id) ON DELETE CASCADE,
    CONSTRAINT FK_LogicBlockAttributeCharacteristicCollectionCharacteristics_Characteristics FOREIGN KEY (CharacteristicId) REFERENCES Characteristics(Id) ON DELETE CASCADE
);

-- Таблица для LogicBlockAttributeDateRange
CREATE TABLE LogicBlockAttributeDateRanges (
    Id SERIAL PRIMARY KEY,
    LogicBlockAttributeId INT NOT NULL,
    StartDateId INT NOT NULL,
    EndDateId INT NOT NULL,
    CONSTRAINT FK_LogicBlockAttributeDateRanges_LogicBlockAttributeValues FOREIGN KEY (Id) REFERENCES LogicBlockAttributeValues(Id) ON DELETE CASCADE,
    CONSTRAINT FK_LogicBlockAttributeDateRanges_StartDate FOREIGN KEY (StartDateId) REFERENCES Characteristics(Id) ON DELETE RESTRICT,
    CONSTRAINT FK_LogicBlockAttributeDateRanges_EndDate FOREIGN KEY (EndDateId) REFERENCES Characteristics(Id) ON DELETE RESTRICT
);

-- Таблица для LogicBlockAttributeTimeRange
CREATE TABLE LogicBlockAttributeTimeRanges (
    Id SERIAL PRIMARY KEY,
    LogicBlockAttributeId INT NOT NULL,
    StartTimeId INT NOT NULL,
    EndTimeId INT NOT NULL,
    CONSTRAINT FK_LogicBlockAttributeTimeRanges_LogicBlockAttributeValues FOREIGN KEY (Id) REFERENCES LogicBlockAttributeValues(Id) ON DELETE CASCADE,
    CONSTRAINT FK_LogicBlockAttributeTimeRanges_StartTime FOREIGN KEY (StartTimeId) REFERENCES Characteristics(Id) ON DELETE RESTRICT,
    CONSTRAINT FK_LogicBlockAttributeTimeRanges_EndTime FOREIGN KEY (EndTimeId) REFERENCES Characteristics(Id) ON DELETE RESTRICT
);
