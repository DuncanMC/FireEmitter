##FireEmitter

This project demonstrates how to use a CAEmiterLayer to create an animation of "setting a view on fire" to make it disappear.

Here is the effect:

![](https://media.giphy.com/media/16eeoIdGKDQjGLMNci/giphy.gif)

The project includes a custom subclass of UIView called `BurnItDownView`

The `BurnItDownView` is meant to contain other views.

It has one public method, `burnItDown()`. That triggers the animation.

There are multiple parts to the animation:

1. A CAEmitterLayer set up to simulate flames burning off a flat surface:
2. An animation that lowers the emitter layer from the top of the view to the bottom,
3. A CAGradientView applied as a mask to the view that starts ot fully opaque (with colors of `[.clear, .white, .white]` and locations of `[-0.5, 0, 1]` (where the clear color is above the top of the view) and animates the `locations` property of the gradient view to mask away the view contents from top to bottom. (Animating the `locations` property to `[0, 0, 0]`, so the entire gradient layer is filled with clear color, fully masking the view's layer.)
4. Once the view is fully masked, it starts lowering the "birthRate" of the emitter layer in steps until the birth rate is 0. It then holds this step for 2 seconds until all the flame particles have animated away.
5. Once the flame is fully "extinguised", it resets the locations array to the original value of `[-0.5, 0, 1]`. This causes an "implicit animation" so the view animates back from the bottom, but quickly
6. Finally, it resets the emitter layer and emitter cells back to newly a newly created emitter layer and emitter cell to get it ready for the next pass of the animation. (I couldn't figure out how to restore the emitter back to its original state. It was simpler to just create new ones.)