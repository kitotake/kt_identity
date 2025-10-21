export interface Character {
  id: number;
  firstname: string;
  lastname: string;
  dateofbirth: string;
  gender: 'male' | 'female';
  height: number;
  nationality: string;
  avatar?: string;
  addictions?: Addictions;
}

export interface Addictions {
  cigarette: number; 
  alcohol: number;   
  drugs: number;     
}

export interface NUIMessage<T = any> {
  action: string;
  data: T;
}

export interface OpenMenuData {
  characters: Character[];
  maxCharacters: number;
  availableNationalities: string[];
  canCreateMore?: boolean;
}

export interface SelectCharacterData {
  characterId: number;
}

export interface CreateCharacterData {
  firstname: string;
  lastname: string;
  dateofbirth: string;
  gender: 'male' | 'female';
  height: number;
  nationality: string;
  addictions: Addictions;
}

export interface DeleteCharacterData {
  characterId: number;
}

export type NUICallback = 
  | 'selectCharacter'
  | 'createCharacter'
  | 'deleteCharacter'
  | 'closeMenu';