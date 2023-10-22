Counter = {}
Counter.score = 0
Counter.highScore = 0
Counter.rowsRewards = {}
Counter.rowsRewards[1] = 50
Counter.rowsRewards[2] = 150
Counter.rowsRewards[3] = 350
Counter.rowsRewards[4] = 700
Counter.pieceRewardConst = 5

function Counter.pieceReward()
    local reward = Counter.pieceRewardConst
    Counter.update(reward)
end

function Counter.rowsReward(numb)
    local reward = Counter.rowsRewards[numb]
    Counter.update(reward)
end

function Counter.update(additive)
    if Game.status == "play" then
        Counter.score = Counter.score + additive
        if Counter.highScore < Counter.score then
            Counter.highScore = Counter.score
        end

        local score = string.format("%06d", Counter.score)
        local highScore = string.format("%06d", Counter.highScore)
        local str = "|cffffff00HIGH SCORE|r:  "..highScore.."     |cffffff00SCORE|r:  "..score
        BlzFrameSetText(CustomFrames.score, str)
    end
end

function Counter.resetScore()
    Counter.score = 0
    BlzFrameSetText(CustomFrames.score, CustomFrames.defScoreString)
    Counter.update(0)
end