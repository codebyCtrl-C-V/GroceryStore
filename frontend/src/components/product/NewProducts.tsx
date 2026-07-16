import {
  ShoppingCartOutlined,
  MinusOutlined,
  PlusOutlined,
  LeftOutlined,
  RightOutlined,
} from "@ant-design/icons";

import { Carousel } from "antd";

import styles from "./newProducts.module.css";
import { Link } from "react-router-dom";


interface Product {
  id: string;
  name: string;
  slug: string;
  image: string;
  price: number;
  discountPrice: number;
  sale: number;
}

interface Props {
  newProducts: Product[];
}

function PrevArrow(props: any) {
  const { className, style, onClick } = props;

  return (
    <div className={className} style={style} onClick={onClick}>
      <LeftOutlined />
    </div>
  );
}

function NextArrow(props: any) {
  const { className, style, onClick } = props;

  return (
    <div className={className} style={style} onClick={onClick}>
      <RightOutlined />
    </div>
  );
}

export default function NewProducts({ newProducts = [] }: Props) {
  return (
    <section className={styles.section}>
      {/* HEADER */}
      <div className={styles.header}>
        <div>
          <h2>Sản phẩm mới về</h2>
        </div>

        <Link to="/products" className={styles.viewAll}>
          Xem tất cả →
        </Link>
      </div>

      {/* CAROUSEL */}
      <Carousel
        dots={false}
        arrows
        prevArrow={<PrevArrow />}
        nextArrow={<NextArrow />}
        slidesToShow={5}
        responsive={[
          {
            breakpoint: 1200,
            settings: {
              slidesToShow: 4,
            },
          },
          {
            breakpoint: 992,
            settings: {
              slidesToShow: 3,
            },
          },
          {
            breakpoint: 768,
            settings: {
              slidesToShow: 2,
            },
          },
          {
            breakpoint: 576,
            settings: {
              slidesToShow: 1,
            },
          },
        ]}
      >
        {newProducts.map((product) => (
          <div key={product.id} className={styles.slide}>
            <div className={styles.card}>
              {/* SALE */}
              <div className={styles.sale}>-{product.sale}%</div>

              {/* IMAGE */}
              <Link
                to={`/product/${product.slug}`}
                className={styles.imageWrapper}
              >
                <img src={product.image} alt={product.name} />
              </Link>

              {/* CONTENT */}
              <div className={styles.content}>
                <h3>{product.name}</h3>

                {/* PRICE */}
                <div className={styles.priceBox}>
                  <del>{product.price.toLocaleString("vi-VN")} VND</del>

                  <span>
                    {product.discountPrice.toLocaleString("vi-VN")} VND
                  </span>
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
          </div>
        ))}
      </Carousel>
    </section>
  );
}
