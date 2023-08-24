Game = {}
Game.status = "play"

function Game.start()
    local figure = Figure.createRandom()
    Figure.next = Figure.createRandom()
    Figure.next:preview()
    figure:draw()
    figure:startTimer()
end

function Game.checkField()
    if not Field.findRows() then
        Game.launchFigure()
    end
end

function Game.launchFigure()
    DestroyTimer(Figure.current.t)
    DestroyTimer(Figure.current.softDropTimer)
    Figure.current = nil
    Figure.next:draw()
    Figure.next = Figure.createRandom()
    Figure.next:preview()
    Figure.current:startTimer()
    return
end

function Game.load()
    do
        function MarkGameStarted()
            UI.load()
            Game.start()
            Triggers.initKeyTrigger()
            math.randomseed(os.time())
        end
    end
end

function Game.gameOver()
    Figure.next = nil
    Figure.current = nil
    Game.status = "lost"
    CustomFrames.setLose(true)
end

