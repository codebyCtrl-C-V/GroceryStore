import { Header } from 'antd/es/layout/layout';
import styles from './headers.module.css';

export default function Headers() {
  return (
    <Header className={`${styles.headers}`}>
      <div className={styles.logo}>Grocery Store</div>
    </Header>
  );
}
