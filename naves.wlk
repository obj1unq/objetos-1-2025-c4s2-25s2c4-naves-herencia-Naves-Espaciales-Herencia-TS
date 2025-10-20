class Nave {
	var property velocidad = 0
	const INCREMENTO_VELOCIDAD_POR_PROPULSION = 20000
	const LIMITE_VELOCIDAD = 300000

	method propulsar() {
		velocidad = (velocidad + INCREMENTO_VELOCIDAD_POR_PROPULSION).min(LIMITE_VELOCIDAD)
	}
}

class NaveDeCarga inherits Nave {
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	method recibirAmenaza() {
		carga = 0
	}

}

class NaveDeCargaDeResiduosRadiactivos inherits NaveDeCarga {
	var property selladaAlVacio = false 

	override method recibirAmenaza() {
		if (selladaAlVacio) self.velocidad(0) else super()
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

	method recibirAmenaza() {
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

	method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

}

object reposo {
	method invisible(nave) = nave.velocidad() < 10000

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

}

object ataque {
	method invisible(nave) = not nave.tieneArmasDesplegadas()

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
		nave.tieneArmasDesplegadas(true)
	}

}
