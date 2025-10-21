class Nave {
	var property velocidad = 0
	const INCREMENTO_VELOCIDAD_POR_PROPULSION = 20000
	const INCREMENTO_VELOCIDAD_PARA_VIAJAR = 15000
	const LIMITE_VELOCIDAD = 300000

	method propulsar() {
		self.incrementarVelocidad(INCREMENTO_VELOCIDAD_POR_PROPULSION)
	}

	method prepararseParaViajar() {
		self.incrementarVelocidad(INCREMENTO_VELOCIDAD_PARA_VIAJAR)
	}

	method incrementarVelocidad(incrementoVelocidad) {
		velocidad = (velocidad + incrementoVelocidad).min(LIMITE_VELOCIDAD)
	}

	method recibirAmenaza() 

	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
}

class NaveDeCarga inherits Nave {
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeCargaDeResiduosRadiactivos inherits NaveDeCarga {
	var property selladaAlVacio = false 

	override method recibirAmenaza() {
		if (selladaAlVacio) self.velocidad(0) else super()
	}

	override method prepararseParaViajar() {
		super()
		selladaAlVacio = true
	}
}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method cantidadDePersonasABordo() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 
		300000 / self.cantidadDePersonasABordo() - self.reduccionVelocidadPorMedidasDeSeguridad()

	method reduccionVelocidadPorMedidasDeSeguridad() = if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = self.velocidad() > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}
}

class NaveDeCombate inherits Nave {
	var property modo = reposo
	const property mensajesEmitidos = []
	var property tieneArmasDesplegadas = false

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.invisible(self)

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararseParaViajar() {
		super()
		modo.prepararseParaViajar(self)
	}

}

object reposo {
	method invisible(nave) = nave.velocidad() < 10000

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararseParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}
}

object ataque {
	method invisible(nave) = not nave.tieneArmasDesplegadas()

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		nave.tieneArmasDesplegadas(true)
	}

	method prepararseParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}
}
