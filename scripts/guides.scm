

(define (guides-delimit-image image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
        )
    (gimp-image-undo-group-start image)

    (gimp-image-add-vguide image 0)
    (gimp-image-add-hguide image 0)
    (gimp-image-add-vguide image width)
    (gimp-image-add-hguide image height)

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "guides-delimit-image"
  _"Delimitar imagem"
  _"Cria 4 guias delimitando a imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "guides-delimit-image"
                         "<Image>/Image/Guides")

(define (guides-mark-centre image drawable)
  (let* (
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
        )
    (gimp-image-undo-group-start image)

    (gimp-image-add-vguide image (/ width 2))
    (gimp-image-add-hguide image (/ height 2))

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)

(script-fu-register "guides-mark-centre"
  _"Marcar o centro"
  _"Cria 2 guias marcando o centro exato da imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "guides-mark-centre"
                         "<Image>/Image/Guides")
                         

(define (cm2pixels cm dpi)
  (/ (* cm dpi) 2.54)
)

(define (point2pixels pt dpi)
  (/ (* pt dpi) 72)
)

(define (guides-set-margin image drawable superior esquerda direita inferior unidade delimitar marcar-centro)
  (let* (
          (width  (car  (gimp-image-width image)))
          (height (car (gimp-image-height image)))
          
          (dpi-x (car  (gimp-image-get-resolution image)))
          (dpi-y (cadr (gimp-image-get-resolution image)))
        )
        
    
    (gimp-image-undo-group-start image)
    
    ;---------------------------------------------------------------------

      (if (= delimitar TRUE) (begin
        (guides-delimit-image image drawable 0 0)
      ))
    
      (if (= marcar-centro TRUE) (begin
        (guides-mark-centre image drawable 0 0)
      ))
    
    ;---------------------------------------------------------------------

      (if (= unidade 1) (begin
        (set! superior (cm2pixels superior dpi-y))
        (set! inferior (cm2pixels inferior dpi-y))
        
        (set! esquerda (cm2pixels esquerda dpi-x))
        (set! direita  (cm2pixels direita  dpi-x))
      ))
      
      (if (= unidade 2) (begin
        (set! superior (cm2pixels (/ superior 10) dpi-y))
        (set! inferior (cm2pixels (/ inferior 10) dpi-y))
        
        (set! esquerda (cm2pixels (/ esquerda 10) dpi-x))
        (set! direita  (cm2pixels (/ direita  10) dpi-x))
      ))
      
      (if (= unidade 3) (begin
        (set! superior (cm2pixels (* superior 2.54) dpi-y))
        (set! inferior (cm2pixels (* inferior 2.54) dpi-y))
        
        (set! esquerda (cm2pixels (* esquerda 2.54) dpi-x))
        (set! direita  (cm2pixels (* direita  2.54) dpi-x))
      ))
      
      (if (= unidade 4) (begin
        (set! superior (point2pixels superior dpi-y))
        (set! inferior (point2pixels inferior dpi-y))
        
        (set! esquerda (point2pixels esquerda dpi-x))
        (set! direita  (point2pixels direita  dpi-x))
      ))
    
    ;---------------------------------------------------------------------
    
      (if (> superior 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-hguide image superior)
        ))
      ))
    
      (if (> inferior 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-hguide image (- height inferior))
        ))
      ))
    
      (if (> esquerda 0) (begin
        (if (> width esquerda) (begin
          (gimp-image-add-vguide image esquerda)
        ))
      ))
    
      (if (> direita 0) (begin
        (if (> height superior) (begin
          (gimp-image-add-vguide image (- width direita))
        ))
      ))

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
    
    (list superior esquerda direita inferior)
  )
)

(script-fu-register "guides-set-margin"
  _"Definir margens"
  _"Cria 4 guias criando uma margem na imagem"
  "sudo-give-me-coffee"
  "Natanael Barbosa Santos, 2020.  MIT."
  "2020-08-05"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "Drawable" 0
  
  SF-ADJUSTMENT "Superior" (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Esquerda" (list 3 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Direita"  (list 2 0 5000 1 10 2 SF-SPINNER)
  SF-ADJUSTMENT "Inferior" (list 2 0 5000 1 10 2 SF-SPINNER)

  SF-OPTION    "Unidade de medida"        '("Pixels (px)" 
                                            "Centimetros (cm)" 
                                            "Milimetros (mm)"
                                            "Polegadas (in)"
                                            "Pontos (pt)")
                                            
  SF-TOGGLE    "Delimitar imagem"             TRUE
  SF-TOGGLE    "Marcar o centro"              FALSE
)

(script-fu-menu-register "guides-set-margin"
                         "<Image>/Image/Guides")
                         


                         




