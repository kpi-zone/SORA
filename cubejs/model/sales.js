cube(`Sales`, {
  sql_table: `sales`,
  dataSource: "default",
  public: false,
  joins: {
    Customers: {
      sql: `${CUBE}.customerkey = ${Customers}.customerkey`,
      relationship: `belongsTo`,
    },
    Stores: {
      sql: `${CUBE}.storekey = ${Stores}.storekey`,
      relationship: `belongsTo`,
    },
    Products: {
      sql: `${CUBE}.productkey = ${Products}.productkey`,
      relationship: `belongsTo`,
    },
    Dates: {
      sql: `${CUBE}.orderdate = ${Dates}.date`,
      relationship: `belongsTo`,
    },
  },

  measures: {
    count: {
      type: `count`,
      drillMembers: [orderkey, orderdate],
    },
    totalRevenue: {
      sql: `unitprice * quantity`,
      type: `sum`,
    },
    netRevenue: {
      sql: `netprice`,
      type: `sum`,
    },
    totalUnitsSold: {
      sql: `quantity`,
      type: `sum`,
    },
    totalCost: {
      sql: `unitcost * quantity`,
      type: `sum`,
    },
    orderCount: {
      sql: `orderkey`,
      type: `countDistinct`,
    },
    averageOrderValue: {
      sql: `netprice`,
      type: `avg`,
    },
    profit: {
      sql: `netprice - unitcost * quantity`,
      type: `sum`,
    },
  },

  dimensions: {
    orderkey: {
      sql: `orderkey`,
      type: `number`,
      primaryKey: true,
    },
    linenumber: {
      sql: `linenumber`,
      type: `number`,
    },
    orderdate: {
      sql: `orderdate`,
      type: `time`,
    },
    deliverydate: {
      sql: `deliverydate`,
      type: `time`,
    },
    customerkey: {
      sql: `customerkey`,
      type: `number`,
    },
    storekey: {
      sql: `storekey`,
      type: `number`,
    },
    productkey: {
      sql: `productkey`,
      type: `number`,
    },
    quantity: {
      sql: `quantity`,
      type: `number`,
    },
    unitprice: {
      sql: `unitprice`,
      type: `number`,
    },
    netprice: {
      sql: `netprice`,
      type: `number`,
    },
    unitcost: {
      sql: `unitcost`,
      type: `number`,
    },
    currencycode: {
      sql: `currencycode`,
      type: `string`,
    },
    exchangerate: {
      sql: `exchangerate`,
      type: `number`,
    },
  },
});
