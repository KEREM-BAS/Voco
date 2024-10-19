package com.hstpos.app

import android.content.Context
import android.graphics.Bitmap
import com.urovo.sdk.print.PrintFormat
import com.urovo.sdk.print.paint.PaintView
import com.urovo.sdk.print.paint.PrintContentBean
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.common.BitMatrix

class ReceiptPrinter(private val context: Context) {

    private val paintView: PaintView = PaintView.getInstance(context)

    // Modified createReceipt method to accept transaction data as a Map<String, Any>
    fun createReceipt(paymentData: Map<String, Any>): Bitmap? {
        // Initialize receipt content
        val contentList = mutableListOf<PrintContentBean>()

        // Add store name as a header
        val companyHeader = PrintContentBean().apply {
            content = "HST MOBİL AŞ"
            fontSize = PrintFormat.FONT_LARGE
            align = PrintFormat.ALIGN_CENTER
            isBold = true
        }
        contentList.add(companyHeader)

        // Add store name as a sub-header
        //val title = PrintContentBean().apply {
        //    content = paymentData["companyName"]?.toString() ?: "HST Mobil"
        //    fontSize = PrintFormat.FONT_LARGE
        //    align = PrintFormat.ALIGN_CENTER
        //    isBold = true
        //}
        //contentList.add(title)

        // Add separator line
        addSeparator(contentList)

        // Add payment information
        val orderId = paymentData["orderId"]?.toString() ?: "N/A"
        val amount = paymentData["amount"]?.toString() ?: "N/A"
        val transactionStatus = paymentData["responseMessage"]?.toString() ?: "N/A"
        val transactionDateTime = paymentData["createDate"]?.toString() ?: "N/A"
        val transactionDate = transactionDateTime.split(" ").getOrNull(0) ?: "N/A"
        val transactionTime = transactionDateTime.split(" ").getOrNull(1) ?: "N/A"
        val installmentCount = paymentData["installmentCount"]?.toString() ?: "1"

        val orderInfo = PrintContentBean().apply {
            content = "Fiş NO: $orderId"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(orderInfo)

        val transactionInfo = PrintContentBean().apply {
            content = "Durum: $transactionStatus"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(transactionInfo)

        val amountInfo = PrintContentBean().apply {
            content = "Toplam: $amount TL"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(amountInfo)

        val dateInfo = PrintContentBean().apply {
            content = "$transactionDate"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(dateInfo)

        val timeInfo = PrintContentBean().apply {
            content = "Saat: $transactionTime"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(timeInfo)

        val installmentInfo = PrintContentBean().apply {
            content = "Taksit Sayısı: $installmentCount"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_LEFT
        }
        contentList.add(installmentInfo)

        // Add separator line
        addSeparator(contentList)

        // Add card information
        val pan = paymentData["pan"]?.toString() ?: ""
        val cardHolderName = paymentData["kartHolderName"]?.toString() ?: "N/A"

        val cardInfo = PrintContentBean().apply {
            content = "**** **** **** ${pan.takeLast(4)}"
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_CENTER
        }
        contentList.add(cardInfo)

        val cardHolderInfo = PrintContentBean().apply {
            content = cardHolderName
            fontSize = PrintFormat.FONT_NORMAL
            align = PrintFormat.ALIGN_CENTER
        }
        contentList.add(cardHolderInfo)

        // Add QR code for the transaction (optional, using a URL or transaction info)
        val qrCodeUrl = "https://hstmobil.com.tr/"
        val qrCode = PrintContentBean().apply {
            content = qrCodeUrl
            printType = PrintContentBean.PrintType_QRCode
            widght = 200 // QR code width
            height = 200 // QR code height
            align = PrintFormat.ALIGN_CENTER
        }
        contentList.add(qrCode)

        // Add separator line
        addSeparator(contentList)

        // Add footer message
        val footer = PrintContentBean().apply {
            content = "Alışverişiniz için teşekkür ederiz!"
            fontSize = PrintFormat.FONT_SMALL
            align = PrintFormat.ALIGN_CENTER
        }
        contentList.add(footer)
        addSeparator(contentList)
        // Add fiscal validity warning for POS receipt
        val fiscalWarning = PrintContentBean().apply {
            content = "Bu fiş yalnızca bilgilendirme amaçlıdır,"
            fontSize = PrintFormat.FONT_SMALL
            align = PrintFormat.ALIGN_CENTER
            isBold = true
        }
        contentList.add(fiscalWarning)
        val fiscalWarning2 = PrintContentBean().apply {
            content = "mali bir belge niteliği taşımaz."
            fontSize = PrintFormat.FONT_SMALL
            align = PrintFormat.ALIGN_CENTER
            isBold = true
        }
        contentList.add(fiscalWarning2)
        // Add separator line
        addSeparator(contentList)
        // Generate the receipt as a Bitmap
        return drawPrintBitmap(contentList, 700)
    }

    private fun addSeparator(contentList: MutableList<PrintContentBean>) {
        val separator = PrintContentBean().apply {
            content = "----------------------------"
            fontSize = PrintFormat.FONT_SMALL
            align = PrintFormat.ALIGN_CENTER
        }
        contentList.add(separator)
    }

    /**
     * Custom method to generate a receipt bitmap from a list of content.
     */
    private fun drawPrintBitmap(contentList: List<PrintContentBean>, height: Int): Bitmap? {
        // Initialize the PaintView
        paintView.init(height)
        var paintY = 30 // Initial Y position for printing

        for (bean in contentList) {
            when (bean.printType) {
                PrintContentBean.PrintType_QRCode -> {
                    // Handle QR Code printing
                    val qrCodeBitmap = getQRCodeBitmap(bean.content, bean.widght, bean.height)
                    if (qrCodeBitmap != null) {
                        paintY += paintView.drawBitmap(qrCodeBitmap, bean.offset, paintY, bean.align).toInt() // Cast Float to Int
                    }
                }
                else -> {
                    // Handle text printing
                    paintY += paintView.drawText(bean, paintY).toInt() // Cast Float to Int
                }
            }
        }

        // Get the final receipt bitmap
        return paintView.getBitmap()
    }

    fun getQRCodeBitmap(qrCodeContent: String, width: Int, height: Int): Bitmap? {
        try {
            val bitMatrix: BitMatrix = MultiFormatWriter().encode(qrCodeContent, BarcodeFormat.QR_CODE, width, height)
            val bitmapWidth = bitMatrix.width
            val bitmapHeight = bitMatrix.height
            val pixels = IntArray(bitmapWidth * bitmapHeight)

            for (y in 0 until bitmapHeight) {
                for (x in 0 until bitmapWidth) {
                    pixels[y * bitmapWidth + x] = if (bitMatrix[x, y]) {
                        android.graphics.Color.BLACK
                    } else {
                        android.graphics.Color.WHITE
                    }
                }
            }

            val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
            bitmap.setPixels(pixels, 0, bitmapWidth, 0, 0, bitmapWidth, bitmapHeight)
            return bitmap
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }
}