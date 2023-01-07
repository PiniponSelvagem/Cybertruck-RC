package com.piniponselvagem.cybertruckrc

import android.annotation.SuppressLint
import android.media.MediaPlayer
import android.os.Bundle
import android.util.Log
import android.view.MotionEvent
import android.view.View.OnTouchListener
import android.view.WindowManager
import android.widget.Button
import android.widget.SeekBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers.Default
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.Dispatchers.Main
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import quevedo.soares.leandro.blemadeeasy.BLE
import quevedo.soares.leandro.blemadeeasy.BluetoothConnection
import quevedo.soares.leandro.blemadeeasy.exceptions.ScanTimeoutException


class MainActivity : AppCompatActivity() {

    private lateinit var ble: BLE
    private var dataControl = CyberControl()
    private var dataLights  = CyberLights()
    private var conn: BluetoothConnection? = null

    private lateinit var txtBattery: TextView

    private val lightStatus = CyberLightStatus()
    private val danceStopped = 0
    private var danceCurrent = danceStopped

    private var mediaPlayer: MediaPlayer? = null


    @SuppressLint("MissingPermission", "ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        ble = BLE(componentActivity = this)

        /* Setup ui element */
        setupTextBattery()
        /********************/

        /* Setup user input */
        setupButtonConnect()

        setupButtonForward()
        setupButtonBackward()
        setupButtonLeft()
        setupButtonRight()
        setupSeekbarDirection()

        setupButtonLowBeams()
        setupButtonHighBeams()

        setupButtonBreak()

        setupButtonSignalLeft()
        setupButtonSignalRight()

        setupButtonHazards()


        setupButtonDanceKITT()
        setupButtonDanceXMAS()
        /********************/

        /* Start coroutines */
        /*
        controlSendCoroutine()
        lightSendCoroutine()
         */
        combinedSendCoroutine()
        /********************/
    }


    private fun setupTextBattery() {
        txtBattery = findViewById(R.id.txt_battery)
        txtBattery.text = ""
        txtBattery.setTextColor(
            ContextCompat.getColor(
                this@MainActivity,
                R.color.background
            )
        )
    }


    private fun bleReadyToConnect(btn: Button) {
        btn.text = "Connect"
        btn.setBackgroundColor(
            ContextCompat.getColor(
                this@MainActivity,
                R.color.btn_connect
            )
        )
        btn.isEnabled = true
        updateBattery(-1)
    }
    private fun bleConnecting(btn: Button) {
        btn.text = "Connecting"
        btn.setBackgroundColor(
            ContextCompat.getColor(
                this@MainActivity,
                R.color.btn_connecting
            )
        )
        btn.isEnabled = false
    }
    private fun bleReadyToDisconnect(btn: Button) {
        btn.text = "Disconnect"
        btn.setBackgroundColor(
            ContextCompat.getColor(
                this@MainActivity,
                R.color.btn_disconnect
            )
        )
        btn.isEnabled = true
    }
    private fun setupButtonConnect() {
        findViewById<Button>(R.id.btn_connect).setOnClickListener { view ->
            if (conn == null) {
                CoroutineScope(IO).launch {
                    launch(Main) {
                        bleConnecting(view as Button)
                    }

                    // You can specify filters for your device, being them 'macAddress', 'service' and 'name'
                    val connection: BluetoothConnection? = try {
                        ble.scanFor(
                            // You only need to supply one of these, no need for all of them!
                            macAddress = "30:C6:F7:1E:8A:DA",
                            name = "Cybertruck"
                        )
                    } catch (e: ScanTimeoutException) {
                        null
                    }

                    // And it will automatically connect to your device, no need to boilerplate
                    if (connection != null) {
                        conn = connection

                        conn?.observe(characteristic = "70696e69-6379-6265-7274-7275636b0101", interval = 30000L /*30s*/) {
                            value: ByteArray -> updateBattery(value[0].toInt())
                        }

                        launch(Main) {
                            bleReadyToDisconnect(view as Button)
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        }
                    } else {
                        // Show an Alert or UI with your preferred error message about the device not being available
                        launch(Main) {
                            bleReadyToConnect(view as Button)
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        }
                    }
                }
            } else {
                CoroutineScope(IO).launch {
                    conn?.close()
                    conn = null

                    launch(Main) {
                        bleReadyToConnect(view as Button)
                        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    }
                }
            }
        }
    }


    @SuppressLint("ClickableViewAccessibility")
    private fun setupButtonSpeed(btnId: Int, actionDown: Speed) {
        findViewById<Button>(btnId).setOnTouchListener(OnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    view.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_press))
                    dataControl.setSpeed(actionDown)
                    return@OnTouchListener true
                }
                MotionEvent.ACTION_UP -> {
                    view.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_idle))
                    dataControl.setSpeed(Speed.STOP)
                    return@OnTouchListener true
                }
                else ->
                    return@OnTouchListener true
            }
        })
    }
    private fun setupButtonForward()  = setupButtonSpeed(R.id.btn_forward, Speed.FORWARD)
    private fun setupButtonBackward() = setupButtonSpeed(R.id.btn_backward, Speed.BACKWARD)

    @SuppressLint("ClickableViewAccessibility")
    private fun setupButtonAngle(btnId: Int, angle: Int) {
        findViewById<Button>(btnId).setOnTouchListener(OnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    view.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_press))
                    dataControl.setAngle(angle)
                    return@OnTouchListener true
                }
                MotionEvent.ACTION_UP -> {
                    view.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_idle))
                    dataControl.setAngle(dataControl.angleCenter)
                    return@OnTouchListener true
                }
                else ->
                    return@OnTouchListener true
            }
        })
    }
    private fun setupButtonLeft()  = setupButtonAngle(R.id.btn_left, -dataControl.angleMax)
    private fun setupButtonRight() = setupButtonAngle(R.id.btn_right, dataControl.angleMax)

    private fun setupSeekbarDirection() {
        findViewById<SeekBar>(R.id.seekbar_angle).setOnSeekBarChangeListener(object :
            SeekBar.OnSeekBarChangeListener {
                override fun onProgressChanged(seek: SeekBar, progress: Int, fromUser: Boolean) {
                    dataControl.setAngle(seek.progress)
                }

                override fun onStartTrackingTouch(seek: SeekBar) {
                    // write custom code for progress is started
                }

                override fun onStopTrackingTouch(seek: SeekBar) {
                    // write custom code for progress is stopped
                    seek.progress = 0
                    dataControl.setAngle(seek.progress)
                }
            }
        )
    }

    private fun setupButtonDashboardSimple(btnId: Int, statusChange: () -> Boolean) {
        findViewById<Button>(btnId).setOnClickListener { view ->
            val status = statusChange()

            val btn = view as Button
            if (status)
                btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_light_active))
            else
                btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_idle))
        }
    }
    private fun setupButtonLowBeams() {
        setupButtonDashboardSimple(R.id.btn_low_beam) {
            lightStatus.lowBeams = !lightStatus.lowBeams
            dataLights.setLowBeams(lightStatus.lowBeams)

            if (lightStatus.highBeams)
                dataLights.setHighBeams(lightStatus.highBeams)
            if (lightStatus.brake)
                dataLights.setBrake(lightStatus.brake)

            return@setupButtonDashboardSimple lightStatus.lowBeams
        }
    }
    private fun setupButtonHighBeams() {
        setupButtonDashboardSimple(R.id.btn_high_beam) {
            lightStatus.highBeams = !lightStatus.highBeams
            dataLights.setHighBeams(lightStatus.highBeams)

            if (lightStatus.lowBeams)
                dataLights.setLowBeams(lightStatus.lowBeams)

            return@setupButtonDashboardSimple lightStatus.highBeams
        }
    }
    private fun setupButtonBreak() {
        setupButtonDashboardSimple(R.id.btn_brake) {
            lightStatus.brake = !lightStatus.brake
            dataLights.setBrake(lightStatus.brake)
            btnSpeedSetInteraction(!lightStatus.brake)

            if (lightStatus.lowBeams)
                dataLights.setLowBeams(lightStatus.lowBeams)

            return@setupButtonDashboardSimple lightStatus.brake
        }
    }

    private fun setupButtonDashBoardSignalBlink(
        btnId: Int,
        statusChange: () -> Boolean,
        signalPrepare: () -> Unit,
        endCondition: () -> Boolean,
        signalBlink: (Boolean) -> Unit,
        signalDisabled: () -> Unit
    ) {
        findViewById<Button>(btnId).setOnClickListener { view ->
            val status = statusChange()

            if (status) {
                signalPrepare()

                CoroutineScope(Default).launch {
                    var statusBlink = false
                    val btn = view as Button
                    while(endCondition()) {
                        if (!lightStatus.hazards) {
                            statusBlink = !statusBlink
                            signalBlink(statusBlink)
                            if (statusBlink)
                                btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_light_blink_on))
                            else
                                btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_light_blink_off))
                        }
                        else
                            btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_light_active))
                        delay(500)
                    }

                    signalDisabled()
                    if (lightStatus.brake)
                        dataLights.setBrake(lightStatus.brake)
                    if (lightStatus.highBeams)
                        dataLights.setHighBeams(lightStatus.highBeams)
                    if (lightStatus.lowBeams)
                        dataLights.setLowBeams(lightStatus.lowBeams)
                    btn.setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_idle))
                }
            }
        }
    }
    private fun setupButtonSignalLeft() {
        setupButtonDashBoardSignalBlink(
            R.id.btn_signals_left,
            {
                lightStatus.signalLeft = !lightStatus.signalLeft
                return@setupButtonDashBoardSignalBlink lightStatus.signalLeft
            },
            {
                lightStatus.signalRight = false
            },
            {
                return@setupButtonDashBoardSignalBlink lightStatus.signalLeft
            },
            {
                dataLights.setSignalLeft(it)
            },
            {
                dataLights.setSignalLeft(lightStatus.signalLeft)
            }
        )
    }
    private fun setupButtonSignalRight() {
        setupButtonDashBoardSignalBlink(
            R.id.btn_signals_right,
            {
                lightStatus.signalRight = !lightStatus.signalRight
                return@setupButtonDashBoardSignalBlink lightStatus.signalRight
            },
            {
                lightStatus.signalLeft = false
            },
            {
                return@setupButtonDashBoardSignalBlink lightStatus.signalRight
            },
            {
                dataLights.setSignalRight(it)
            },
            {
                dataLights.setSignalRight(lightStatus.signalRight)
            }
        )
    }

    private fun setupButtonHazards() {
        findViewById<Button>(R.id.btn_hazard).setOnClickListener { view ->
            lightStatus.hazards = !lightStatus.hazards
            if (lightStatus.hazards) {
                CoroutineScope(Default).launch {
                    var status = false
                    val btn = view as Button
                    while (lightStatus.hazards) {
                        status = !status
                        dataLights.setHazards(status)
                        if (status)
                            btn.setBackgroundColor(
                                ContextCompat.getColor(
                                    this@MainActivity,
                                    R.color.btn_light_blink_on
                                )
                            )
                        else
                            btn.setBackgroundColor(
                                ContextCompat.getColor(
                                    this@MainActivity,
                                    R.color.btn_light_blink_off
                                )
                            )
                        delay(500)
                    }

                    dataLights.setHazards(lightStatus.hazards)

                    if (lightStatus.brake)
                        dataLights.setBrake(lightStatus.brake)
                    if (lightStatus.highBeams)
                        dataLights.setHighBeams(lightStatus.highBeams)

                    btn.setBackgroundColor(
                        ContextCompat.getColor(
                            this@MainActivity,
                            R.color.btn_idle
                        )
                    )
                }
            }
        }
    }



    private fun startDance(btnId: Int, danceLights: Int, danceMusic: Int, danceMusicLoop: Boolean) {
        danceCurrent = danceLights

        findViewById<Button>(btnId)
            .setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_light_active))

        CoroutineScope(IO).launch {
            val lines = application.resources.openRawResource(danceLights).bufferedReader().readLines()
            playSound(danceMusic, danceMusicLoop)

            var iter = lines.iterator()
            var line: String
            while (danceCurrent == danceLights) {
                if (iter.hasNext()) {
                    do {
                        line = iter.next()
                    } while (line.startsWith("#") || line.isEmpty())

                    if (line == "end")
                        break

                    //Log.i("dance", line)
                    try {
                        val lineSplit = line.replace(" ", "").split(',')
                        dataLights.setDance(lineSplit[1], lineSplit[2])
                        delay(lineSplit[0].toLong())
                    } catch (e: Exception) {
                        Log.e("Cybertruck", "error while executing dance: "+e.message.toString())
                        break
                    }
                }
                else {
                    iter = lines.iterator()
                }
            }
            dataLights.setAll(false)
            stopDance(btnId, danceLights)
        }
    }
    private fun stopDance(btnId: Int, danceWas: Int) {
        if (danceCurrent == danceWas) {
            danceCurrent = danceStopped
            stopSound()
        }
        findViewById<Button>(btnId)
            .setBackgroundColor(ContextCompat.getColor(this@MainActivity, R.color.btn_idle))
    }

    private fun setupButtonDance(btnId: Int, danceLights: Int, danceMusic: Int=danceStopped, danceMusicLoop: Boolean=false) {
        findViewById<Button>(btnId).setOnClickListener {
            if (danceCurrent==danceStopped || danceCurrent!=danceLights) {
                danceCurrent = danceStopped
                startDance(btnId, danceLights, danceMusic, danceMusicLoop)
            }
            else {
                stopDance(btnId, danceLights)
            }
        }
    }
    private fun setupButtonDanceKITT() { setupButtonDance(R.id.btn_kitt, R.raw.kitt_dance, R.raw.kitt_music, true) }
    private fun setupButtonDanceXMAS() { setupButtonDance(R.id.btn_xmas, R.raw.xmas_dance, R.raw.xmas_music) }


    private fun playSound(soundId: Int, loop: Boolean) {
        stopSound()
        if (soundId == danceStopped)
            return

        if (mediaPlayer == null) {
            mediaPlayer = MediaPlayer.create(this, soundId)
            mediaPlayer!!.isLooping = loop
            mediaPlayer!!.start()
        } else mediaPlayer?.start()
    }
    private fun stopSound() {
        if (mediaPlayer != null) {
            mediaPlayer!!.stop()
            mediaPlayer!!.reset()
            mediaPlayer!!.release()
            mediaPlayer = null
        }
    }


    private fun combinedSendCoroutine() {
        CoroutineScope(Default).launch {
            while (true) {
                if (conn!=null) {
                    if (dataControl.updated || dataLights.updated) {
                        if (dataControl.updated)
                            delay(100)      // limit send control update, seekbar generates a lot of them

                        val toSend = dataControl.convertToSend().plus(dataLights.convertToSend())
                        conn?.write(
                            "70696e69-6379-6265-7274-7275636b0201",
                            toSend
                        )
                    }
                }
                else {
                    delay(500)
                }
            }
        }
    }
    private fun controlSendCoroutine() {
        CoroutineScope(Default).launch {
            while (true) {
                if (conn!=null) {
                    if (dataControl.updated) {
                        //val angle = dataControl.angle
                        //val speed = dataControl.speed
                        //Log.i("control: ", "$angle - $speed")
                        conn?.write(
                            "70696e69-6379-6265-7274-7275636b0401",
                            dataControl.convertToSend()
                        )
                        delay(100)
                    }
                }
                else {
                    delay(500)
                }
            }
        }
    }
    private fun lightSendCoroutine() {
        CoroutineScope(Default).launch {
            while (true) {
                if (conn!=null) {
                    if (dataLights.updated) {
                        conn?.write(
                            "70696e69-6379-6265-7274-7275636b0301",
                            dataLights.convertToSend()
                        )
                    }
                }
                else {
                    delay(500)
                }
            }
        }
    }


    private fun updateBattery(value: Int) {
        if (value == -1) {
            setupTextBattery()
        }
        else {
            txtBattery.text = value.toString()
            if (value >= 40) {
                txtBattery.setTextColor(
                    ContextCompat.getColor(
                        this@MainActivity,
                        R.color.txt_battery_high
                    )
                )
            }
            else if (value >= 20) {
                txtBattery.setTextColor(
                    ContextCompat.getColor(
                        this@MainActivity,
                        R.color.txt_battery_medium
                    )
                )
            }
            else if (value >= 10) {
                txtBattery.setTextColor(
                    ContextCompat.getColor(
                        this@MainActivity,
                        R.color.txt_battery_low
                    )
                )
            }
            else {
                txtBattery.setTextColor(
                    ContextCompat.getColor(
                        this@MainActivity,
                        R.color.txt_battery_critical
                    )
                )
            }
        }
    }

    private fun btnSpeedSetInteraction(status: Boolean) {
        val btnForward  = findViewById<Button>(R.id.btn_forward)
        val btnBackward = findViewById<Button>(R.id.btn_backward)

        btnForward.isEnabled = status
        btnBackward.isEnabled = status

        if (status) {
            btnForward.setBackgroundColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    R.color.btn_idle
                )
            )
            btnBackward.isEnabled = status
            btnBackward.setBackgroundColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    R.color.btn_idle
                )
            )
        }
        else {
            btnForward.setBackgroundColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    R.color.btn_speed_lock
                )
            )
            btnBackward.isEnabled = status
            btnBackward.setBackgroundColor(
                ContextCompat.getColor(
                    this@MainActivity,
                    R.color.btn_speed_lock
                )
            )
        }

        dataControl.setSpeed(Speed.STOP)
    }
}