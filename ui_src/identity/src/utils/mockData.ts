import type { Character, OpenMenuData } from '../types/nui';

export const mockCharacters: Character[] = [
  {
    id: 1,
    firstname: 'John',
    lastname: 'Doe',
    dateofbirth: '1990-05-15',
    gender: 'male',
    height: 180,
    nationality: 'Américaine',
    addictions: {
      cigarette: 50,
      alcohol: 25,
      drugs: 0,
    },
  },
  {
    id: 2,
    firstname: 'Jane',
    lastname: 'Smith',
    dateofbirth: '1995-08-22',
    gender: 'female',
    height: 165,
    nationality: 'Britannique',
    addictions: {
      cigarette: 0,
      alcohol: 10,
      drugs: 0,
    },
  },
  {
    id: 3,
    firstname: 'Mike',
    lastname: 'Johnson',
    dateofbirth: '1988-03-10',
    gender: 'male',
    height: 175,
    nationality: 'Canadienne',
    addictions: {
      cigarette: 75,
      alcohol: 60,
      drugs: 30,
    },
  },
];

export const mockOpenMenuData: OpenMenuData = {
  characters: mockCharacters,
  maxCharacters: 5,
  availableNationalities: [
    'Française',
    'Américaine',
    'Britannique',
    'Allemande',
    'Italienne',
    'Espagnole',
    'Portugaise',
    'Belge',
    'Suisse',
    'Canadienne',
    'Australienne',
    'Japonaise',
    'Chinoise',
    'Russe',
    'Brésilienne',
    'Mexicaine',
    'Argentine',
    'Marocaine',
    'Algérienne',
    'Tunisienne',
  ],
};

export const sendMockNUIMessage = (action: string, data: any) => {
  if (import.meta.env.DEV) {
    window.postMessage({ action, data }, '*');
  }
};