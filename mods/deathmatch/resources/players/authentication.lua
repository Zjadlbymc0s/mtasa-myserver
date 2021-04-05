local MINIMUM_PASSWORD_LENGTH = 6

local function isPasswordValid(password)
    return string.len(password) >= MINIMUM_PASSWORD_LENGTH
end

-- create an account
addCommandHandler('register', function (player, command, username, password)
    if not username or not password then
        return outputChatBox('Correct command: /' .. command .. ' [username] [password]', player, 255, 255, 255)
    end

    -- check if an account with that username already exists
    if getAccount(username) then
        return outputChatBox('An account already exists with that name.', player, 255, 100, 100)
    end

    -- is the password valid
    if not isPasswordValid(password) then
        return outputChatBox('The password supplied was not valid.', player, 255, 100, 100)
    end

    -- create a hash of the password
    passwordHash(password, 'bcrypt', {}, function (hashedPassword)
        -- create the account
        local account = addAccount(username, hashedPassword)
        setAccountData(account, 'hashed_password', hashedPassword)

        -- let the user know of our success
        outputChatBox('Your account has been successfully created! You may now login with /accLogin', player, 100, 255, 100)
    end)
end, false, false)

-- login to their account
addCommandHandler('accLogin', function (player, command, username, password)
    if not username or not password then
        return outputChatBox('Correct command: /' .. command .. ' [username] [password]', player, 255, 255, 255)
    end

    local account = getAccount(username)
    if not account then
        return outputChatBox('No such account could be found with that username or password.', player, 255, 100, 100)
    end

    local hashedPassword = getAccountData(account, 'hashed_password')
    passwordVerify(password, hashedPassword, function (isValid)
        if not isValid then
            return outputChatBox('No such account could be found with that username or password.', player, 255, 100, 100)
        else
            return logIn(player, account, hashedPassword)
        end

        return outputChatBox('An unknown error occured while attempting to authenticate.', player, 255, 100, 100)
    end)

end, false, false)

-- logout of their account
addCommandHandler('accLogout', function (player)
    logOut(player)
end)