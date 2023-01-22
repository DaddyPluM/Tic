require "button"

alpha = 0

local squares = {   --Contains information about the quares in the game(what is in each square)
                            "", "", "",
                            "", "", "",
                            "", "", ""
}

local buttons = {   --The game uses invisible buttons to check for player input
    game_state = {},
    win_state = {}
}

local game_state = {    --Game's states
    game = true,
    win = false
}

local function restart()    --Restarts the game(Resets some variables)
    game_state["game"] = true
    game_state["win"] = false
    x = true
    winner = ""
    lose = 0
    squares = {"", "", "", "","", "", "", "", ""}
end

local function exit()   --Closes the game
    love.event.quit()
end

local function win()
    game_state["game"] = false
    game_state["win"] = true
end

function love.load()
    lose = 0
    winner = ""     --Contains the player that won E.g. If the player 2(O) won, this changes to "O"
    timer = 0
    love.graphics.setNewFont(240)   --Font size in pixels
    cell_size = 200     --The size of the squares on-screen
    win_width, win_height = love.window.getMode()   --Gets the width and height of the window
    buttons.win_state.Restart = button("Restart", restart, nil, 100, 30)
    for i in pairs(squares) do
        buttons.game_state[i] = button(nil, click, i, cell_size, cell_size)
    end
    x = true    --This variable determines whose turn it is. If this is false then it is player 2(O)'s turn
end

function love.update(dt)
    if game_state["game"] then
        for i, v in pairs(squares) do  --Checks if a player has won
            if squares[1] == "x" and squares[2] == "x" and squares[3] == "x"
            or
            squares[4] == "x" and squares[5] == "x" and squares[6] == "x"
            or
            squares[7] == "x" and squares[8] == "x" and squares[9] == "x"
            or
            squares[1] == "x" and squares[4] == "x" and squares[7] == "x"
            or
            squares[3] == "x" and squares[6] == "x" and squares[9] == "x"
            or
            squares[1] == "x" and squares[5] == "x" and squares[9] == "x"
            or
            squares[3] == "x" and squares[5] == "x" and squares[7] == "x"
            then    --If the winner is player 1(X)
                timer = timer + dt
                winner = "X"
            end
            if squares[1] == "o" and squares[2] == "o" and squares[3] == "o"
            or
            squares[4] == "o" and squares[5] == "o" and squares[6] == "o"
            or
            squares[7] == "o" and squares[8] == "o" and squares[9] == "o"
            or
            squares[1] == "o" and squares[4] == "o" and squares[7] == "o"
            or
            squares[3] == "o" and squares[6] == "o" and squares[9] == "o"
            or
            squares[1] == "o" and squares[5] == "o" and squares[9] == "o"
            or
            squares[3] == "o" and squares[5] == "o" and squares[7] == "o"
            then    --If the winner is player 2(O)
                timer = timer + dt
                winner = "O"
            end
        end
        if lose >= 9 then   --Checks if the game has ended in a draw
            timer = timer + dt
        end
        if timer >= 1 then  --A short delay before the win/draw screen
            win()
        end
    elseif game_state["win"] then
        if timer <= 2 then  --If this wasn't here, the player could restart the game without seeing to the win screen
            timer = timer + dt
        end
    end
end

function love.mousereleased(x, y, button, isTouch, presses)     --Checks which square the mouse button was released in
    if button == 1 then
        for i in pairs(buttons.game_state) do
            buttons.game_state[i]:checkPressed(x, y)
        end
        --Remove the timer if statement and win the game with your last turn being placed in the center. It may take a few tries but something will happen
        if timer >= 2 then
            for i in pairs(buttons.win_state) do
                buttons.win_state[i]:checkPressed(x, y)
                timer = 0
            end
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        exit()
    end
end

function click(i)   --This is triggered whenever the left mouse button is released and the cursor is on a square
        for k, v in pairs(squares) do
            if k == i then
                if v == "" then
                        lose = lose + 1     --This variable will increase by one every time someone plays. If each player has played three times,  six squares in the game will be occipied by either "x" or "o" and this variabe will be equals to 6
                        table.remove(squares, i)
                        if x then   --Checks if x is true
                            table.insert(squares, i, "x")
                            x = not x   --Toggle the value of x
                        elseif not x then   --Checks if x is false
                            table.insert(squares, i, "o")
                            x = not x   --Toggle the value of x
                    end
                end
            end
        end
end

function love.draw()
    --love.graphics.print(lose) --Uncomment this line to see what lose does
    --love.graphics.print(timer)
    if game_state["game"] then
        for i, v in pairs(squares) do
            if v ~= "" then     --Display whatever is in the table called "square" if it isn't empty
                if i <= 3 then
                    love.graphics.print(v, (i - .85) * cell_size, -60)
                elseif i >= 4 and i <= 6 then
                    love.graphics.print(v, (i - 3.85) * cell_size, 140)
                elseif i >= 7 and i <= 9 then
                    love.graphics.print(v, (i - 6.85) * cell_size, 340)
                end
            end
        end
        --Draw lines on the screen
        love.graphics.line(200,20,200,win_height - 20)
        love.graphics.line(400,20,400,win_height - 20)
        love.graphics.line(20,200,win_width - 20,200)
        love.graphics.line(20,400,win_width - 20,400)
        --Create invisible buttons that check which square the cursor was in when the left mouse button was released
        for i in pairs(buttons.game_state) do
            if i <= 3 then
                buttons.game_state[i]:draw((i - 1) * cell_size, 0, 0, 0, alpha)
            elseif i > 3 and i <=6 then
                buttons.game_state[i]:draw((i - 4) * cell_size, 200, 0, 0, alpha)
            elseif i > 6 and i <=9 then
                buttons.game_state[i]:draw((i - 7) * cell_size, 400, 0, 0, alpha)
            end
        end

    elseif game_state["win"] then
        if lose >= 9 then   --I reused the Win state for the Draw state
            love.graphics.print("DRAW", win_width / 2 - 35, win_height / 2 - 100, 0, .1, .1)
        else
            love.graphics.print(winner .. " WINS :)", win_width / 2 - 50, win_height / 2 - 100, 0, .1, .1)     --Display who won the game
        end
        buttons.win_state.Restart:draw(win_width / 2 - 50,win_height / 2, 15, 4, 1, .08, .08)
    end
end