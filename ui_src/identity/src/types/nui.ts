export interface Character {
  id: number;
  firstname: string;
  lastname: string;
  dateofbirth: string;
  gender: 'male' | 'female';
  height: number;
  avatar?: string;
}

export interface NUIMessage<T = any> {
  action: string;
  data: T;
}

export interface OpenMenuData {
  characters: Character[];
  maxCharacters: number;
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
}

export interface DeleteCharacterData {
  characterId: number;
}

export type NUICallback = 
  | 'selectCharacter'
  | 'createCharacter'
  | 'deleteCharacter'
  | 'closeMenu';

  