From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Wed, 10 Sep 2003 16:41:49 +0900
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200309100742.QAA15260@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org

Hi Alan,

Thank you for your help.

Alan> This time the bus_reset() routine worked, which is an 
Alan> improvement over 
Alan> what you were seeing before.  But the device still didn't respond:
 
Haruo> If a device becomes an error, it seems that reset is not effective.
Haruo> Using ioctl (fd, USBDEVFS_RESET, 0) and this device,  
Haruo> Is checking whether a device can reset correctly by 
Haruo> performing effective?
 
Alan> Go ahead and try it.  I expect it will reset correctly when 
Alan> you test it like this, but it won't reset correctly after one of
Alan>  those errors occurs and the device stops responding.  
Alan>  That's just a guess.

Using ioctl (fd, USBDEVFS_RESET, 0), I tested reset. 
usb-storage of USB2.0 was successful.
When FDD was used in the case of USB1.1, 
mount became impossible after reset.

I adapt in your patch and continue a test.
--
Haruo


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
