cube(`Products`, {
  sql_table: `product`,
  public: false,
  measures: {
    count: {
      type: `count`,
      drillMembers: [productkey, productname],
    },
  },

  dimensions: {
    productkey: {
      sql: `productkey`,
      type: `number`,
      primaryKey: true,
    },
    productcode: {
      sql: `productcode`,
      type: `string`,
    },
    productname: {
      sql: `productname`,
      type: `string`,
    },
    manufacturer: {
      sql: `manufacturer`,
      type: `string`,
    },
    brand: {
      sql: `brand`,
      type: `string`,
    },
    color: {
      sql: `color`,
      type: `string`,
    },
    weightunit: {
      sql: `weightunit`,
      type: `string`,
    },
    weight: {
      sql: `weight`,
      type: `number`,
    },
    cost: {
      sql: `cost`,
      type: `number`,
    },
    price: {
      sql: `price`,
      type: `number`,
    },
    categorykey: {
      sql: `categorykey`,
      type: `number`,
    },
    categoryname: {
      sql: `categoryname`,
      type: `string`,
    },
    subcategorykey: {
      sql: `subcategorykey`,
      type: `number`,
    },
    subcategoryname: {
      sql: `subcategoryname`,
      type: `string`,
    },
  },
});
