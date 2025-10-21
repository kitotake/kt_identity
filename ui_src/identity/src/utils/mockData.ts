import type { Character, OpenMenuData } from '../types/nui';

export const mockCharacters: Character[] = [
  {
    id: 1,
    firstname: 'John',
    lastname: 'Doe',
    dateofbirth: '1990-05-15',
    gender: 'male',
    height: 180,
  },
  {
    id: 2,
    firstname: 'Jane',
    lastname: 'Smith',
    dateofbirth: '1995-08-22',
    gender: 'female',
    height: 165,
  },
  {
    id: 3,
    firstname: 'Mike',
    lastname: 'Johnson',
    dateofbirth: '1988-03-10',
    gender: 'male',
    height: 175,
  },
];

export const mockOpenMenuData: OpenMenuData = {
  characters: mockCharacters,
  maxCharacters: 5,
};

export const sendMockNUIMessage = (action: string, data: any) => {
  if (import.meta.env.DEV) {
    window.postMessage({ action, data }, '*');
  }
};