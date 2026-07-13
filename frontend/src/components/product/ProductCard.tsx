import { useState } from "react";
import { Link } from "react-router-dom";
import { ShoppingCartOutlined, MinusOutlined, PlusOutlined } from "@ant-design/icons";
import { toast } from "react-toastify";
import styles from "./productCard.module.css";
import { addToCart } from "../../services/apiCart";

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
  product: Product;
}

export default function ProductCard({ product }: Props) {
  const [qty, setQty] = useState(1);
  const [adding, setAdding] = useState(false);

  const handleAdd = async () => {
    const token = localStorage.getItem('access_token');
    if (!token) {
      toast.warn("Vui lòng đăng nhập để mua sắm!");
      return;
    }

    setAdding(true);
    try {
      await addToCart(product.id, qty);
      toast.success(`Đã thêm ${qty} x ${product.name} vào giỏ hàng!`);
    } catch (error) {
      console.error(error);
      toast.error("Không thể thêm vào giỏ hàng.");
    } finally {
      setAdding(false);
    }
  };

  const finalPrice = product.discountPrice || (product.sale > 0 ? product.price * (1 - product.sale / 100) : product.price);

  return (
    <div className={styles.card}>
      {product.sale > 0 && <div className={styles.sale}>-{product.sale}%</div>}

      <Link to={`/product/${product.slug}`} className={styles.imageWrapper}>
        <img src={product.image || "/images/default-product.png"} alt={product.name} />
      </Link>

      <div className={styles.content}>
        <h3>
          <Link to={`/product/${product.slug}`} className={styles.titleLink}>
            {product.name}
          </Link>
        </h3>

        <div className={styles.priceBox}>
          {product.sale > 0 ? (
            <>
              <del>{product.price.toLocaleString("vi-VN")} VND</del>
              <span>{finalPrice.toLocaleString("vi-VN")} VND</span>
            </>
          ) : (
            <span>{product.price.toLocaleString("vi-VN")} VND</span>
          )}
        </div>

        <div className={styles.bottom}>
          <div className={styles.qty}>
            <button onClick={() => setQty((q) => Math.max(1, q - 1))}>
              <MinusOutlined />
            </button>
            <input
              type="text"
              value={qty}
              readOnly
              style={{ width: "30px", textAlign: "center", border: "none" }}
            />
            <button onClick={() => setQty((q) => q + 1)}>
              <PlusOutlined />
            </button>
          </div>

          <button className={styles.cartBtn} onClick={handleAdd} disabled={adding}>
            <ShoppingCartOutlined />
          </button>
        </div>
      </div>
    </div>
  );
}
