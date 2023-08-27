Counter = {}
Counter.score = 0
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
        local score = string.format("%06d", Counter.score)
        local str = "|cffffff00SCORE|r:  "..score
        BlzFrameSetText(CustomFrames.score, str)
    end
end