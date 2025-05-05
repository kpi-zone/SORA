// views/sales_products_customers.js

view("sales_products_customers", {
  title: "Sales, Products, and Customers View",
  description:
    "Unified view exposing key sales metrics, product attributes, and customer details.",
  cubes: [
    {
      joinPath: "Sales",
      includes: [
        // Most relevant sales measures
        "totalRevenue",
        "netRevenue",
        "profit",
        "orderCount",
        "averageOrderValue",
        "totalUnitsSold",
        "totalCost",
        "unitcost",
        // Most relevant sales dimensions
        "orderdate",
        "deliverydate",
        "currencycode",
      ],
    },
    {
      joinPath: "Sales.Products",
      prefix: true,
      includes: [
        // Most relevant product fields
        "productname",
        "brand",
        "categoryname",
        "subcategoryname",
        "manufacturer",
        "price",
        // Other product attributes
        "productcode",
        "color",
        "weight",
        "weightunit",
        "cost",
        "categorykey",
        "subcategorykey",
      ],
    },
    {
      joinPath: "Sales.Customers",
      prefix: true,
      includes: [
        // Most relevant customer fields
        "country",
        "city",
        "state",
        "age",
        "gender",
        "occupation",
        // Other customer attributes
        "continent",
        "company",
        "vehicle",
        "birthday",
        "latitude",
        "longitude",
      ],
    },
  ],
});
