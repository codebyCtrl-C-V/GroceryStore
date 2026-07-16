import { Tabs } from "antd";
import styles from "./outstandingProducts.module.css";
import ProductCard from "./ProductCard";

interface Product {
  id: string | number;
  name: string;
  slug: string;
  image: string;
  price: number;
  sale: number;
  discountPrice?: number;
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
          <ProductCard key={product.id} product={product} />
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
