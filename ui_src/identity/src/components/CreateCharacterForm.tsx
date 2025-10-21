import React, { useState } from 'react';
import type { CreateCharacterData } from '../types/nui';

interface CreateCharacterFormProps {
  onSubmit: (data: CreateCharacterData) => void;
  onCancel: () => void;
}

export const CreateCharacterForm: React.FC<CreateCharacterFormProps> = ({
  onSubmit,
  onCancel,
}) => {
  const [formData, setFormData] = useState<CreateCharacterData>({
    firstname: '',
    lastname: '',
    dateofbirth: '',
    gender: 'male',
    height: 175,
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation simple
    if (!formData.firstname.trim() || !formData.lastname.trim()) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }

    onSubmit(formData);
  };

  const maxDate = new Date();
  maxDate.setFullYear(maxDate.getFullYear() - 18); // Au moins 18 ans

  return (
    <form onSubmit={handleSubmit} className="create-form">
      <div className="create-form__group">
        <label className="create-form__label" htmlFor="firstname">
          Prénom *
        </label>
        <input
          id="firstname"
          type="text"
          value={formData.firstname}
          onChange={(e) => setFormData({ ...formData, firstname: e.target.value })}
          className="create-form__input"
          placeholder="Ex: John"
          required
          minLength={2}
          maxLength={50}
        />
      </div>

      <div className="create-form__group">
        <label className="create-form__label" htmlFor="lastname">
          Nom *
        </label>
        <input
          id="lastname"
          type="text"
          value={formData.lastname}
          onChange={(e) => setFormData({ ...formData, lastname: e.target.value })}
          className="create-form__input"
          placeholder="Ex: Doe"
          required
          minLength={2}
          maxLength={50}
        />
      </div>

      <div className="create-form__group">
        <label className="create-form__label" htmlFor="dateofbirth">
          Date de naissance *
        </label>
        <input
          id="dateofbirth"
          type="date"
          value={formData.dateofbirth}
          onChange={(e) => setFormData({ ...formData, dateofbirth: e.target.value })}
          className="create-form__input"
          max={maxDate.toISOString().split('T')[0]}
          required
        />
      </div>

      <div className="create-form__group">
        <label className="create-form__label" htmlFor="gender">
          Sexe *
        </label>
        <select
          id="gender"
          value={formData.gender}
          onChange={(e) => setFormData({ ...formData, gender: e.target.value as 'male' | 'female' })}
          className="create-form__select"
        >
          <option value="male">Homme</option>
          <option value="female">Femme</option>
        </select>
      </div>

      <div className="create-form__group">
        <label className="create-form__label" htmlFor="height">
          Taille: <strong>{formData.height} cm</strong>
        </label>
        <input
          id="height"
          type="range"
          min="150"
          max="210"
          step="1"
          value={formData.height}
          onChange={(e) => setFormData({ ...formData, height: parseInt(e.target.value) })}
          className="create-form__range"
        />
        <div className="create-form__range-labels">
          <span>150 cm</span>
          <span>{formData.height} cm</span>
          <span>210 cm</span>
        </div>
        <p className="create-form__hint">
          Ajustez le curseur pour définir la taille de votre personnage
        </p>
      </div>

      <div className="create-form__actions">
        <button
          type="submit"
          className="create-form__button create-form__button--submit"
        >
          ✓ Créer le personnage
        </button>
        <button
          type="button"
          onClick={onCancel}
          className="create-form__button create-form__button--cancel"
        >
          ✕ Annuler
        </button>
      </div>
    </form>
  );
};
