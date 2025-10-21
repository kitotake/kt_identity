import { useCallback } from 'react';

export const useNUI = () => {
  const post = useCallback(async <T = any>(
    event: string, 
    data: any = {}
  ): Promise<T | null> => {
    try {
      const response = await fetch(`https://${GetParentResourceName()}/${event}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error(`NUI callback failed: ${response.statusText}`);
      }

      const result = await response.json();
      return result as T;
    } catch (error) {
      console.error(`[NUI] Error calling ${event}:`, error);
      return null;
    }
  }, []);

  return { post };
};

function GetParentResourceName(): string {
  return (window as any).GetParentResourceName?.() || 'kt_identity';
}