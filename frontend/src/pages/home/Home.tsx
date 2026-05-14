import Banner from "../../components/banner/Banner";
import OutstandingProducts from "../../components/product/OutstandingProducts";
import NewProducts from "../../components/product/NewProducts";
import { getProductForHome, getProductNew } from "../../services/apiProduct";
import { useEffect, useState } from "react";

export default function Home() {
  const [dataProduct, setDataProduct] = useState<any>([]);
  const [dataNewProduct, setDataNewProduct] = useState<any>([]);

  const handleGetProductForHome = async () => {
    try {
      const response = await getProductForHome();
      setDataProduct(response);
    } catch (error) {
      console.log(error);
    }
  };

  const handleGetProductNew = async () => {
    try {
      const response = await getProductNew();
      setDataNewProduct(response);
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    handleGetProductForHome();
    handleGetProductNew();
  }, []);

  return (
    <>
      <Banner />
      <OutstandingProducts
        vegetables={dataProduct?.data?.vegetables}
        fruits={dataProduct?.data?.fruits}
        juices={dataProduct?.data?.juices}
        processed={dataProduct?.data?.processed}
      />
      <NewProducts newProducts={dataNewProduct?.data} />
    </>
  );
}
