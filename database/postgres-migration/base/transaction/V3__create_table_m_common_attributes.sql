CREATE TABLE m_common_attributes (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
     created_by VARCHAR(100),
     updated_by VARCHAR(100),

     category                TEXT        NOT NULL,
     name                    TEXT        NOT NULL,
     value_type              TEXT        NOT NULL,
     value_options           TEXT,
     default_value           TEXT
);

CREATE UNIQUE INDEX CONCURRENTLY "idx_m_common_attributes_name" ON m_common_attributes USING btree (name);
CREATE UNIQUE INDEX CONCURRENTLY "idx_m_common_attributes_category_name" ON m_common_attributes USING btree (category,name);