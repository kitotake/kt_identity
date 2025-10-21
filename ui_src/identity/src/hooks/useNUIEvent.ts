import { useEffect } from 'react';
import type { NUIMessage } from '../types/nui';

export const useNUIEvent = <T = any>(
  action: string,
  handler: (data: T) => void
) => {
  useEffect(() => {
    const eventListener = (event: MessageEvent<NUIMessage<T>>) => {
      const { action: eventAction, data } = event.data;
      
      if (eventAction === action) {
        handler(data);
      }
    };

    window.addEventListener('message', eventListener);
    
    return () => window.removeEventListener('message', eventListener);
  }, [action, handler]);
};
