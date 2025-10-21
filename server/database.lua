function GetPlayerCharacters(identifier)
    return MySQL.query.await('SELECT * FROM users WHERE identifier = ?', {identifier})
end

function CreateCharacter(identifier, data)
    return MySQL.insert.await(
        'INSERT INTO users (identifier, firstname, lastname, dateofbirth, sex, height) VALUES (?, ?, ?, ?, ?, ?)',
        {identifier, data.firstname, data.lastname, data.dateofbirth, data.sex, data.height}
    )
end

function DeleteCharacter(charId)
    return MySQL.update.await('DELETE FROM users WHERE id = ?', {charId})
end
