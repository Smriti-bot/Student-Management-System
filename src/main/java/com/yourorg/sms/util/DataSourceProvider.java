package com.yourorg.sms.util;

import javax.sql.DataSource;

/**
 * Static holder for a DataSource created at app startup.
 * DAOs should call DataSourceProvider.getDataSource() to obtain it.
 */
public final class DataSourceProvider {

    private static volatile DataSource dataSource;

    private DataSourceProvider() { /* no-op */ }

    public static void setDataSource(DataSource ds) {
        dataSource = ds;
    }

    public static DataSource getDataSource() {
        return dataSource;
    }
}
