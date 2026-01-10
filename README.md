## DeltaCam
![image](https://github.com/user-attachments/assets/e2ad45cf-8963-493c-8832-efd12b33fd97)
Ashcorp studios 2026
# English

## What is Deltacam

Deltacam is a first of it's kind (that's open source at least) suspension system for vehicles that doesn't require complicated setups. It's free of use and open source, meaning that anyone can modify it as long as they give credit to the author -Ashdev-. It can be used in all sorts of vehicles, from cars to planes, altough i've designed it for trains, in the beginning. It has an easy set up and the important parts of the code are commented, similarly to how adonis config does it. 

## Who can use it?

Anyone, really! 

## How do i use it? 

In short, its a local script that changes the player camera's offset giving the effect of suspension. The player must press the C key to toggle it. It will make the player go on first peron. **Put this in StarterPlayerScripts as a LocalScript.**

## Author and Thanks
**Ashley "Ashdev"** : Script

**Adonis Admin**: Inspiration!

**British Railways** : Idea

**You** : For using it!


# Spanish
## Que es deltacam?
Deltacam es un novel sistema simple de suspension hecho en roblox para vehiculos. Es de libre edicion y codigo abierto, lo cual significa que cualquiera puede modificar y ver el codigo, ademas de usarlo. Se pueden hacer re-masters, remakes, y modificaciones de todo tipo siempre y cuando se proporcione créditos a la autorìa original, Ashdev. Se puede utilizar para todo tipo de vehiculos, desde coches, trenes, aviones... Es facilmente configurable y el primero de su especie en ser publicamente disponible.


## Quien lo puede utilizar? 
Cualquiera, desde los juegos mas grande a los mas pequeños! No es necesario pedir permiso, simplemente copias el codigo y lo metes en tu juego siguiendo las instrucciones que indica el mismo. 

## No se ingles, como lo puedo configurar?
Adjunto la configuracion pasada al español! 

```luau
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInput     = game:GetService("UserInputService")
local ContextAction = game:GetService("ContextActionService")

local player    = Players.LocalPlayer -- jugador
local cam       = workspace.CurrentCamera --camara
local SPRING_K  = 20      -- lo fuerte que esta la suspension
local DAMP_K    = 5       -- lo mucho que se mueve ns
local suspensionMultiplier = 2 -- el multiplicador

-- state
local active               = false -- se activa automaticamente cuando el jugador se sienta? 
local baseFOV              = 70
local zoomStep             = 2 		-- cuanto la FOV cambia en un delta de la rueda del raton
local minFOV, maxFOV       = 30, 90	-- 
local springPos, springVel = 0, 0 	-- las posiciones y velocidades de la suspension
local swayPos, swayVel     = 0, 0   -- movimiento lateral 
local cameraRootPart 	   = "hum" 	-- alterna entre `"hum"` (humanoid) y `"root"` (root part). la ultima hace que todo el jugador sea invisible. Tambien se puede establecer como un `cframe` o un `Vector`. Por defecto es, o si pasa cualquier error, es `"hum"`.
```

## Como lo uso?

Este es básicamente un script que cuando el jugador presiona la tecla C activa o desactiva la camara en primera persona. Tambien hace una ilusion de suspension del vehiculo con movimientos similares a la suspension de la camara, actua y da el pego pero no hay suspension basada en fisicas. Se puede usar para todo tipo de vehiculos, desde trenes, barcos, coches..., esperate
bugs y cosas raras si lo usas con otros vehiculos.

**Pon esto en StarterPlayerScripts como un LocalScript.**

## Como puedo agradecrte?
Simplemente madame un DM a la cuenta de discord de **catzhtu.ash**

## Autoria y agradecimientos
**Ashley "Ashdev"** : Script

**Adonis Admin**: Inspiracion!

**British Railways** : Idea

**Tu** : Por usarlo!

![Diseo-sin-ttulo-3](https://github.com/user-attachments/assets/50a1d4f7-487c-47f7-8f0c-ef49c75005d1)
