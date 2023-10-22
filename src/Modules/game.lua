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
    Counter.pieceReward()
    if not Field.findRows() then
        Game.launchFigure()
    end
end

function Game.launchFigure()
    DestroyTimer(Figure.current.t)
    DestroyTimer(Figure.current.softDropTimer)
    DestroyTimer(Figure.current.hardDropTimer)
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
            math.randomseed(os.time())
            Music.ambientOff()
            UI.load()
            Music.setMusic()
            Game.start()
            Triggers.initKeyTrigger()
        end
    end
end

function Game.gameOver()
    Figure.next = nil
    Figure.current = nil
    Game.status = "lost"
    CustomFrames.setLose(true)
end

function Game.restartGame()
    Counter.resetScore()
    CustomFrames.setLose(false)
    Field.clear()
    Preview.clear()

    Game.status = "play"
    Counter.resetScore()

    Game.start()
end

