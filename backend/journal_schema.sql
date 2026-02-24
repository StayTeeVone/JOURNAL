-- Trading Journal MySQL Schema
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(18,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    name VARCHAR(100),
    ticker VARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE strategies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

CREATE TABLE trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    asset_id INT,
    direction VARCHAR(10),
    result VARCHAR(20),
    session VARCHAR(20),
    risk_percent DECIMAL(5,2),
    rr_ratio DECIMAL(5,2),
    open_date DATETIME,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (asset_id) REFERENCES assets(id)
);

CREATE TABLE screenshots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trade_id INT,
    timeframe VARCHAR(10),
    file_path VARCHAR(255),
    FOREIGN KEY (trade_id) REFERENCES trades(id)
);

CREATE TABLE reasons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trade_id INT,
    text TEXT,
    FOREIGN KEY (trade_id) REFERENCES trades(id)
);

CREATE TABLE timeframes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    title VARCHAR(100),
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

CREATE TABLE document_screenshots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    file_path VARCHAR(255),
    FOREIGN KEY (document_id) REFERENCES documents(id)
);
