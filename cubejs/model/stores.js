cube(`Stores`, {
  sql_table: `store`,
  dataSource: "default",
  public: false,
  joins: {
    Sales: {
      sql: `${CUBE}.storekey = ${Sales}.storekey`,
      relationship: `hasMany`,
    },
  },

  measures: {
    count: {
      type: `count`,
      drillMembers: [storekey, countryname, state, opendate],
    },

    revenuePerStore: {
      sql: `${Sales.netprice}`,
      type: `sum`,
      title: `Revenue per Store`,
    },

    profitPerStore: {
      sql: `${Sales.netprice} - ${Sales.unitcost} * ${Sales.quantity}`,
      type: `sum`,
      title: `Profit per Store`,
    },

    salesPerSquareMeter: {
      sql: `CASE WHEN ${CUBE}.squaremeters > 0 THEN SUM(${Sales.netprice}) / ${CUBE}.squaremeters ELSE 0 END`,
      type: `number`,
      title: `Sales per Square Meter`,
    },

    openStoresCount: {
      sql: `CASE WHEN ${CUBE}.closedate IS NULL AND ${CUBE}.status = 'Open' THEN 1 ELSE 0 END`,
      type: `sum`,
      title: `Open Stores`,
    },

    closedStoresCount: {
      sql: `CASE WHEN ${CUBE}.closedate IS NOT NULL OR ${CUBE}.status = 'Closed' THEN 1 ELSE 0 END`,
      type: `sum`,
      title: `Closed Stores`,
    },

    averageStoreSize: {
      sql: `squaremeters`,
      type: `avg`,
      title: `Average Store Size (sqm)`,
    },
  },

  dimensions: {
    storekey: {
      sql: `storekey`,
      type: `number`,
      primaryKey: true,
    },
    storecode: {
      sql: `storecode`,
      type: `string`,
    },
    geoareakey: {
      sql: `geoareakey`,
      type: `number`,
    },
    countrycode: {
      sql: `countrycode`,
      type: `string`,
    },
    countryname: {
      sql: `countryname`,
      type: `string`,
    },
    state: {
      sql: `state`,
      type: `string`,
    },
    opendate: {
      sql: `opendate`,
      type: `time`,
    },
    closedate: {
      sql: `closedate`,
      type: `time`,
    },
    description: {
      sql: `description`,
      type: `string`,
    },
    squaremeters: {
      sql: `squaremeters`,
      type: `number`,
    },
    status: {
      sql: `status`,
      type: `string`,
    },
  },
});
