import { Tabs } from "antd";
import {
  ShoppingCartOutlined,
  MinusOutlined,
  PlusOutlined,
} from "@ant-design/icons";

import styles from "./outstandingProducts.module.css";
import { Link } from "react-router-dom";

interface Product {
  id: string;
  name: string;
  slug: string;
  image: string;
  price: number;
}

interface Props {
  vegetables: Product[];
  fruits: Product[];
  juices: Product[];
  processed: Product[];
}

export default function OutstandingProducts({
  vegetables = [],
  fruits = [],
  juices = [],
  processed = [],
}: Props) {
  const renderProducts = (products: Product[]) => {
    return (
      <div className={styles.grid}>
        {products.map((product) => (
          <div key={product.id} className={styles.card}>
            {/* IMAGE */}
            <Link
              to={`/product/${product.slug}`}
              className={styles.imageWrapper}
            >
              <img src={product.image} alt={product.name} />
            </Link>

            {/* INFO */}
            <div className={styles.content}>
              <h3>{product.name}</h3>

              <div className={styles.price}>
                {product.price.toLocaleString("vi-VN")} VND
              </div>

              {/* ACTION */}
              <div className={styles.bottom}>
                <div className={styles.qty}>
                  <button>
                    <MinusOutlined />
                  </button>

                  <input value={1} readOnly />

                  <button>
                    <PlusOutlined />
                  </button>
                </div>

                <button className={styles.cartBtn}>
                  <ShoppingCartOutlined />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    );
  };

  return (
    <section className={styles.section}>
      <div className={styles.header}>
        <h2>Sản phẩm nổi bật</h2>
      </div>

      <Tabs
        defaultActiveKey="1"
        className={styles.tabs}
        items={[
          {
            key: "1",
            label: "Rau củ",
            children: renderProducts(vegetables),
          },
          {
            key: "2",
            label: "Trái cây",
            children: renderProducts(fruits),
          },
          {
            key: "3",
            label: "Đồ uống",
            children: renderProducts(juices),
          },
          {
            key: "4",
            label: "Sản phẩm chế biến",
            children: renderProducts(processed),
          },
        ]}
      />
    </section>
  );
}
