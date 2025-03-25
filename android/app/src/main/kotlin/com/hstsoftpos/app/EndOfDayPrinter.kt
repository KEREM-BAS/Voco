package com.hstsoftpos.app

import android.content.Context
import com.urovo.sdk.print.paint.PaintView

class EndOfDayPrinter(private val context: Context){
    private val paintView: PaintView = PaintView.getInstance(context)

}