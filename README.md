# dbt (Data Build Tool) insights. Data Engineering and Modeling. Aron Galdon

I will discuss what I have learned after working as a data engineer for over a year, utilizing dbt and Snowflake in a project for a pharmaceutical company.

## Benefits of dbt

dbt transforms raw data into clean, reliable datasets directly in a data warehouse using SQL.

Good things I have noticed are:​

- Modular SQL Code: working with dbt has taught me the importance of writing modular SQL code. By breaking down complex queries into smaller, reusable components, I can improve readability and maintainability. This modular approach allows for easier debugging and enhances collaboration among team members, as each module can be developed and tested independently before being integrated into the larger workflow.​

- Built-in Testing: One of the standout features of dbt is its built-in testing capabilities. I've learned to implement testing procedures that ensure complex implementations accuracy and data quality.​

- Auto Documentation: this feature generates clear and organized documentation, making it easier for new team members to understand the project's structure and for stakeholders to access critical information.​

- Snowflake Integration: snowflake's scalable architecture and dbt's transformation capabilities complement each other, allowing for efficient data manipulation and storage.​ Anyway, dbt is platform-agnostic.

- In-Warehouse Transformation: by executing transformations directly within the data warehouse, we minimize data movement and optimize processing speed. This approach enhances data security and reduces latency, ensuring that our data workflows are both efficient and secure.​

- Software engineering-style version control for data workflows: this practice ensures traceability, facilitates collaboration, and allows for easy rollback of changes, enhancing the overall robustness and reliability of the project.

## Limitations of dbt

dbt does not handle data extraction/loading or complex non-SQL logic and requires technical expertise and manual performance tuning.

Some limitations are:​

- No data extraction or loading: dbt focuses solely on transforming data within the warehouse, requiring separate tools for data extraction and loading processes.​

- SQL-only: dbt operates exclusively with SQL, limiting its flexibility to leverage other programming languages for complex data transformations.​

- Designed for batch processing, not streaming data: anyway almost real-time processing can work.​

- Needs knowledge of SQL, Git, and command-line tools: can be a barrier for those unfamiliar with developer way of work.​

- Performance tuning must be managed in Snowflake: manage and optimize performance settings directly within Snowflake for optimal results.​

## Challenge solved using dbt

Consolidate and transform heterogeneous raw data sources into standardized, analytics-ready tables that align with business logic and drive actionable insights.

## Strategy

Approach followed in the models:

- Modular and readable.​

- Avoid over-engineering with Jinja.​

- Style: split using CTEs (Common Table Expressions, named queries) for clarity and organization, placing ref() statements at the beginning and a final CTE with the resulting column names.

Transformation phases to organize the models:

```text
              configurations
                    ↓
sources → staging → intermediate → marts
```

- sources: Raw data already loaded in Snowflake.​

- staging: Clean and standardize raw Snowflake tables.​

- configurations: Custom settings for the transformation set by business.​

- intermediate: Apply business logic, joins, enrichments.​

- marts: Final outputs for analytics and BI tools.

## Project setup

- Installation: involves installing `dbt-core` and a specific adapter (e.g., `dbt-snowflake`) using `pip`.

- Initialization: the `dbt init` command scaffolds a new project, setting up the `dbt_project.yml` configuration and the critical **`models/` directory**.

- Profile: a configuration created during initialization that contains the necessary connection details (user, password, warehouse, database) for dbt to interact with the target database.

## Compile and run

- compile: only generates the target SQL model. Any Jinja blocks and macros are translated into pure SQL, that can already be executed in Snowflake.

- run: creates the table or view in the warehouse as well. The object in Snowflake is updated and can be used as any other table.

The `--select` argument enables developers to execute a subset of models, tests, or seeds rather than running the entire project. This drastically reduces development time and costs by allowing fine-grained control over which resources are targeted.

The materialization defines how the model's output is stored in the database: view (virtual table) or table.

Dependencies managed as a DAG. Models are build upon each other using the `ref()` function.

## Incremental models

To optimize performance for large tables or slow-changing data.​

Use is_incremental() in a Jinja block.​

The condition is usually based in the ingestion timestamp.​

When dbt is called in full-refresh mode, the incremental block is excluded.

## Jinja in dbt models

Macros, variables, conditions and loops can be set for less redundant and dynamic generation of the resulting SQL.

Take into account that Jinja runs at compile time: it is not able to check live data already.

Some suggestions are:​

- Use Jinja sparingly, only for essential logic reuse​.

- Prefer explicit SQL for clarity and maintainability​.

- Avoid deeply nested macros unless necessary.

## Testing

There are two main kinds of tests in dbt:​

- Unit tests: to validate complex transformation logic by checking that specific input scenarios produce the expected outputs. Useful when the logic involves multiple conditions, joins, or edge cases.​

- Data tests: to validate the integrity and quality of the data by checking for issues like duplicates, nulls, or unexpected values.​

Unit tests for a specific model are defined in a single file.​

Data tests are defined in the properties.yml of each stage.

## Auto-generated documentation

Web catalog with all objects in a dbt project.

Descriptions about models and columns can be kept in the properties.yml file of each stage.
