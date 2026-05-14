import { type ReactNode, createContext, useState } from 'react';
import Loading from '../components/loading/Loading';

interface LoadingContextType {
  loading: boolean;
  setLoading: (value: boolean) => void;
}

const LoadingContext = createContext<LoadingContextType>({
  loading: false,
  setLoading: () => {},
});

interface LoadingProviderProps {
  children: ReactNode;
}

export const LoadingProvider = ({ children }: LoadingProviderProps) => {
  const [loading, setLoading] = useState(false);
  return (
    <LoadingContext.Provider value={{ loading, setLoading }}>
      {loading && <Loading />} {children}
    </LoadingContext.Provider>
  );
};

export type { LoadingContextType };
export default LoadingContext;
