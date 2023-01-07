package com.piniponselvagem.cybertruckrc

import kotlin.experimental.and
import kotlin.experimental.or
import kotlin.experimental.xor

import com.piniponselvagem.cybertruckrc.LightConfig.*

class CyberControl {
    var updated: Boolean = false
        private set

    private val angleCenterInternal = 90
    val angleCenter = 0
    val angleMax    = 20    // max range to one of the sides, to the other side is the same

    var angle: UInt  = angleCenterInternal.toUInt()
        private set
    var speed: Speed = Speed.STOP
        private set

    fun setAngle(angle: Int) {
        this.angle = (angleCenterInternal + angle).toUInt()
        updated = true
    }

    fun setSpeed(speed: Speed) {
        this.speed = speed
        updated = true
    }

    fun convertToSend(): ByteArray {
        updated = false
        return byteArrayOf(angle.toByte(), speed.value)
    }
}

class CyberLights {
    var updated: Boolean = false
        private set

    private var lightHead: Byte = 0
    private var lightTail: Byte = 0


    private fun enable(lights: Byte, mask: Byte, lightsToActivate: Byte): Byte {
        // updated was changed here, but in some situations it would trigger more than one update, eg. setNormal(...)
        return lights or (mask and lightsToActivate)
    }
    private fun disable(lights: Byte, mask: Byte, lightsToActivate: Byte): Byte {
        // updated was changed here, but in some situations it would trigger more than one update, eg. setNormal(...)
        return lights and (mask xor lightsToActivate)
    }

    fun toggleHead(light: Byte) {
        lightHead = lightHead xor (light)
        updated = true
    }
    fun toggleTail(light: Byte) {
        lightTail = lightTail xor (light)
        updated = true
    }

    fun setDance(head: String, tail: String) {
        val lh1 = if (head[0] == '1') LIGHT_HEAD_1.value else 0
        val lh2 = if (head[1] == '1') LIGHT_HEAD_2.value else 0
        val lh3 = if (head[2] == '1') LIGHT_HEAD_3.value else 0
        val lh4 = if (head[3] == '1') LIGHT_HEAD_4.value else 0
        val lh5 = if (head[4] == '1') LIGHT_HEAD_5.value else 0

        val lt1 = if (tail[0] == '1') LIGHT_TAIL_1.value else 0
        val lt2 = if (tail[1] == '1') LIGHT_TAIL_2.value else 0
        val lt3 = if (tail[2] == '1') LIGHT_TAIL_3.value else 0
        val lt4 = if (tail[3] == '1') LIGHT_TAIL_4.value else 0
        val lt5 = if (tail[4] == '1') LIGHT_TAIL_5.value else 0

        lightHead = lh1 or lh2 or lh3 or lh4 or lh5
        lightTail = lt1 or lt2 or lt3 or lt4 or lt5
        updated = true
    }

    fun setLowBeams(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_2.value or LIGHT_HEAD_4.value))
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_2.value or LIGHT_HEAD_4.value))

        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_2.value or LIGHT_TAIL_4.value))
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_2.value or LIGHT_TAIL_4.value))

        updated = true
    }

    fun setBrake(status: Boolean) {
        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, LIGHT_TAIL_ALL.value)
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, LIGHT_TAIL_ALL.value)

        updated = true
    }

    fun setHighBeams(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, LIGHT_HEAD_ALL.value)
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, LIGHT_HEAD_ALL.value)

        updated = true
    }

    fun setHazards(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_1.value or LIGHT_HEAD_5.value))
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_1.value or LIGHT_HEAD_5.value))

        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_1.value or LIGHT_TAIL_5.value))
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_1.value or LIGHT_TAIL_5.value))

        updated = true
    }

    fun setSignalLeft(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_1.value))
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_1.value))

        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_1.value))
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_1.value))

        updated = true
    }
    fun setSignalRight(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_5.value))
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, (LIGHT_HEAD_5.value))

        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_5.value))
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, (LIGHT_TAIL_5.value))

        updated = true
    }

    fun setAll(status: Boolean) {
        lightHead = if (status)
            enable(lightHead, LIGHT_HEAD_ALL.value, LIGHT_HEAD_ALL.value)
        else
            disable(lightHead, LIGHT_HEAD_ALL.value, LIGHT_HEAD_ALL.value)

        lightTail = if (status)
            enable(lightTail, LIGHT_TAIL_ALL.value, LIGHT_TAIL_ALL.value)
        else
            disable(lightTail, LIGHT_TAIL_ALL.value, LIGHT_TAIL_ALL.value)

        updated = true
    }


    fun convertToSend(): ByteArray {
        updated = false
        return byteArrayOf(lightHead, lightTail)
    }
}

data class CyberLightStatus(
    var lowBeams: Boolean = false,
    var highBeams: Boolean = false,
    var brake: Boolean = false,
    var signalLeft: Boolean = false,
    var signalRight: Boolean = false,
    var hazards: Boolean = false,
)

enum class LightConfig(val value: Byte) {
    LIGHT_HEAD_ALL(0x1F),
    LIGHT_HEAD_1(0x01),
    LIGHT_HEAD_2(0x02),
    LIGHT_HEAD_3(0x04),
    LIGHT_HEAD_4(0x08),
    LIGHT_HEAD_5(0x10),

    LIGHT_TAIL_ALL(0x1F),
    LIGHT_TAIL_1(0x01),
    LIGHT_TAIL_2(0x02),
    LIGHT_TAIL_3(0x04),
    LIGHT_TAIL_4(0x08),
    LIGHT_TAIL_5(0x10),
}

enum class Speed(val value: Byte) {
    STOP(0),
    FORWARD(1),
    BACKWARD(-1),
}