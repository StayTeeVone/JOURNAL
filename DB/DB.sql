SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- USER
-- =========================
CREATE TABLE user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL,
    email VARCHAR(85) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    UNIQUE KEY uq_user_email (email)
) ENGINE=InnoDB;

-- =========================
-- TIMEFRAME
-- =========================
CREATE TABLE timeframe (
    id_timeframe INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    seconds INT NOT NULL,
    UNIQUE KEY uq_timeframe_name (name)
) ENGINE=InnoDB;

-- =========================
-- ASSET
-- =========================
CREATE TABLE asset (
    id_asset INT AUTO_INCREMENT PRIMARY KEY,
    ticker VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    type ENUM('Forex','Crypto','Index','Stock','Commodity') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_asset_ticker (ticker),
    KEY idx_asset_type (type)
) ENGINE=InnoDB;

-- =========================
-- PROP_ACCOUNT
-- =========================
CREATE TABLE prop_account (
    id_prop_account INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    broker VARCHAR(100),
    initial_balance DECIMAL(15,2) NOT NULL,
    account_type ENUM('real','phase-1','phase-2','phase-3','funded','archived') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_account_user (id_user),
    CONSTRAINT fk_prop_user FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- EQUITY_HISTORY
-- =========================
CREATE TABLE equity_history (
    id_equity INT AUTO_INCREMENT PRIMARY KEY,
    id_prop_account INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    equity DECIMAL(15,2) NOT NULL,
    drawdown_percent DECIMAL(5,2),
    recorded_at DATETIME NOT NULL,
    KEY idx_equity_account (id_prop_account),
    KEY idx_equity_date (recorded_at),
    KEY idx_equity_account_date (id_prop_account, recorded_at),
    CONSTRAINT fk_equity_account FOREIGN KEY (id_prop_account)
        REFERENCES prop_account(id_prop_account)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- STRATEGY
-- =========================
CREATE TABLE strategy (
    id_strategy INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    content TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_strategy_user (id_user),
    CONSTRAINT fk_strategy_user FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- IDEA
-- =========================
CREATE TABLE idea (
    id_idea INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_asset INT NOT NULL,
    id_timeframe INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    content TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_idea_user (id_user),
    KEY idx_idea_asset (id_asset),
    KEY idx_idea_timeframe (id_timeframe),
    CONSTRAINT fk_idea_user FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON DELETE CASCADE,
    CONSTRAINT fk_idea_asset FOREIGN KEY (id_asset)
        REFERENCES asset(id_asset),
    CONSTRAINT fk_idea_timeframe FOREIGN KEY (id_timeframe)
        REFERENCES timeframe(id_timeframe)
) ENGINE=InnoDB;

-- =========================
-- DOCUMENT
-- =========================
CREATE TABLE document (
    id_document INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    content TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_document_user (id_user),
    CONSTRAINT fk_document_user FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- TAG
-- =========================
CREATE TABLE tag (
    id_tag INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    KEY idx_tag_user (id_user),
    CONSTRAINT fk_tag_user FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- TRADE
-- =========================
CREATE TABLE trade (
    id_trade INT AUTO_INCREMENT PRIMARY KEY,
    id_prop_account INT NOT NULL,
    id_asset INT NOT NULL,
    id_strategy INT,
    id_idea INT,
    direction ENUM('Long','Short') NOT NULL,
    status ENUM('Open','Closed') NOT NULL,
    result ENUM('Win','Loss','BE'),
    session ENUM('Asia','Frankfurt','London','New York'),
    risk_type ENUM('Percent','Fixed'),
    risk_percent DECIMAL(5,2),
    risk_amount DECIMAL(15,2),
    rr_ratio DECIMAL(5,2),
    pnl_amount DECIMAL(15,2),
    commission DECIMAL(15,2),
    balance_before DECIMAL(15,2),
    balance_after DECIMAL(15,2),
    open_date DATETIME,
    closed_date DATETIME,
    duration_seconds INT,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_trade_account (id_prop_account),
    KEY idx_trade_asset (id_asset),
    KEY idx_trade_status (status),
    KEY idx_trade_open_date (open_date),
    KEY idx_trade_account_date (id_prop_account, open_date),
    CONSTRAINT fk_trade_account FOREIGN KEY (id_prop_account)
        REFERENCES prop_account(id_prop_account)
        ON DELETE CASCADE,
    CONSTRAINT fk_trade_asset FOREIGN KEY (id_asset)
        REFERENCES asset(id_asset),
    CONSTRAINT fk_trade_strategy FOREIGN KEY (id_strategy)
        REFERENCES strategy(id_strategy)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_idea FOREIGN KEY (id_idea)
        REFERENCES idea(id_idea)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- REASON
-- =========================
CREATE TABLE reason (
    id_reason INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =========================
-- TRADE_REASON
-- =========================
CREATE TABLE trade_reason (
    id_trade INT NOT NULL,
    id_reason INT NOT NULL,
    PRIMARY KEY (id_trade, id_reason),
    CONSTRAINT fk_tr_reason_trade FOREIGN KEY (id_trade)
        REFERENCES trade(id_trade)
        ON DELETE CASCADE,
    CONSTRAINT fk_tr_reason_reason FOREIGN KEY (id_reason)
        REFERENCES reason(id_reason)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- TRADE_METRICS
-- =========================
CREATE TABLE trade_metrics (
    id_trade_metrics INT AUTO_INCREMENT PRIMARY KEY,
    id_prop_account INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_trades INT,
    winning_trades INT,
    losing_trades INT,
    winrate DECIMAL(5,2),
    avg_rr DECIMAL(5,2),
    total_pnl DECIMAL(15,2),
    gross_profit DECIMAL(15,2),
    gross_loss DECIMAL(15,2),
    max_drawdown_percent DECIMAL(8,2),
    period_type ENUM('day','week','month','year') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_metrics_account (id_prop_account),
    KEY idx_metrics_period (period_type),
    KEY idx_metrics_account_period (id_prop_account, period_type),
    CONSTRAINT fk_metrics_account FOREIGN KEY (id_prop_account)
        REFERENCES prop_account(id_prop_account)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- BACKTEST
-- =========================
CREATE TABLE backtest (
    id_backtest INT AUTO_INCREMENT PRIMARY KEY,
    id_prop_account INT NOT NULL,
    id_asset INT NOT NULL,
    id_strategy INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    initial_balance DECIMAL(15,2),
    final_balance DECIMAL(15,2),
    total_return_percent DECIMAL(8,2),
    max_drawdown_percent DECIMAL(8,2),
    max_drawdown_amount DECIMAL(15,2),
    total_trades INT,
    winrate DECIMAL(5,2),
    profit_factor DECIMAL(6,2),
    avg_rr DECIMAL(15,2),
    avg_loss DECIMAL(15,2),
    largest_win DECIMAL(15,2),
    largest_loss DECIMAL(15,2),
    winning_streak INT,
    losing_streak INT,
    avg_trade_duration INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    KEY idx_backtest_account (id_prop_account),
    CONSTRAINT fk_backtest_account FOREIGN KEY (id_prop_account)
        REFERENCES prop_account(id_prop_account)
        ON DELETE CASCADE,
    CONSTRAINT fk_backtest_asset FOREIGN KEY (id_asset)
        REFERENCES asset(id_asset),
    CONSTRAINT fk_backtest_strategy FOREIGN KEY (id_strategy)
        REFERENCES strategy(id_strategy)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- BACKTEST_METRIC
-- =========================
CREATE TABLE backtest_metric (
    id_backtest_metric INT AUTO_INCREMENT PRIMARY KEY,
    id_backtest INT NOT NULL,
    period_start DATE,
    period_end DATE,
    period_type ENUM('week','month','year') NOT NULL,
    total_trades INT,
    winning_trades INT,
    losing_trades INT,
    breakeven_trades INT,
    gross_profit DECIMAL(15,2),
    gross_loss DECIMAL(15,2),
    net_profit DECIMAL(15,2),
    winrate DECIMAL(5,2),
    avg_rr DECIMAL(5,2),
    starting_balance DECIMAL(15,2),
    ending_balance DECIMAL(15,2),
    max_drawdown_percent DECIMAL(8,2),
    KEY idx_backtest_metric_backtest (id_backtest),
    CONSTRAINT fk_backtest_metric FOREIGN KEY (id_backtest)
        REFERENCES backtest(id_backtest)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================
-- ATTACHMENT
-- =========================
CREATE TABLE attachment (
    id_attachment INT AUTO_INCREMENT PRIMARY KEY,
    id_timeframe INT,
    entity_type ENUM('trade','document','idea','strategy') NOT NULL,
    entity_id INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    sort_order INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    KEY idx_attachment_entity (entity_type, entity_id),
    KEY idx_attachment_timeframe (id_timeframe),
    CONSTRAINT fk_attachment_timeframe FOREIGN KEY (id_timeframe)
        REFERENCES timeframe(id_timeframe)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================
-- ENTITY_TAG
-- =========================
CREATE TABLE entity_tag (
    id_tag INT NOT NULL,
    entity_type ENUM('trade','idea','strategy','document') NOT NULL,
    entity_id INT NOT NULL,
    PRIMARY KEY (id_tag, entity_type, entity_id),
    KEY idx_entity_tag_entity (entity_type, entity_id),
    CONSTRAINT fk_entity_tag_tag FOREIGN KEY (id_tag)
        REFERENCES tag(id_tag)
        ON DELETE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
