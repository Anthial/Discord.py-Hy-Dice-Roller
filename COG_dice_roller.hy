(import discord)
(import discord.ext [commands])
(require hyrule *)
(import hy.pyops *)
(import re)
(import random)

(defclass dice-roller-hy [commands.Cog]
    (defn __init__ [self bot]
        (setv self.bot bot))

    (defn dice-roll [self dice]
        (let [dice-list (.split dice "d")
            a (int (get dice-list 0))
            b (get dice-list 1)] 
        
        (setv results 
        (if (= b "f")
            (ap-reduce (+ (random.choice [-1, -1, 0, 0, 1, 1]) acc) 
            (range 
                (+ (min (abs a) 10000) ;Set max amount of dice rolled to be 10000
                1)))
            (if (not (<= (int b) 0))
            (ap-reduce (+ (random.randint 1 (int b)) acc) 
            (range 
                (+ (min (abs a) 10000) ;Set max amount of dice rolled to be 10000
                1)))
            0)))
        (if (< a 0)
            (- 0 results)
            results)))
    
    

    (defn/a [(commands.command :aliases ["rd"])] roll-dice [self ctx * message]
        (as->   (.replace message " " "") $
                (.lower $)
                (re.findall "[+-]*[0-9]+[0-9]*d*[0-9]+[0-9]*|[+-]*[0-9]+[0-9]*df|[+-]*[0-9]+(?!d)[0-9]*" $) ;Get dice rolls and modifiers
                (do 
                (setv n 0)
                (for [x $] 
                    (+= n 
                    (if (in "d" x)
                        (self.dice-roll x)
                        (int x))))
                [$ n])
                (await (ctx.send (+ "Rolling: " (str (.join " + " (get $ 0)))
                "\nYou rolled: " (str (get $ 1))))))))

            
(defn setup [bot]
    (bot.add_cog (dice-roller-hy bot)))




