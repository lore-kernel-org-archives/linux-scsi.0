From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Sat, 13 Sep 2003 15:50:40 +0900
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200309130651.PAA12009@toshiba.co.jp>
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

Hi Alan

Alan  wrote:

Haruo> hub.c: port 1, portstatus 110, change 3, 12 Mb/s
Haruo> hub.c: port 1 connection change
Haruo> hub.c: port 1, portstatus 110, change 3, 12 Mb/s
Haruo> usb.c: USB disconnect on device 00:07.2-1 address 2
Haruo> usb-storage: storage_disconnect() called
Haruo> usb-storage: -- releasing irq URB
Haruo> usb-storage: USB IRQ received for device on host 1
Haruo> usb-storage: -- IRQ data length is 2
Haruo> usb-storage: -- IRQ state is -2
Haruo> usb-storage: -- Interrupt Status (0x0, 0x0)
Haruo> usb-storage: ERROR: Unwanted interrupt received!
Haruo> usb-storage: -- usb_unlink_urb() returned 0
Haruo> usb-storage: -- releasing main URB
Haruo> usb-storage: -- usb_unlink_urb() returned -19
Haruo> usb.c: kusbd: /sbin/hotplug remove 2
Haruo> hub.c: port 1, portstatus 103, change 0, 12 Mb/s
Haruo> usb.c: ignoring set_interface for dev 2, iface 0, alt 0
Haruo> hub.c: port 2, portstatus 100, change 0, 12 Mb/s
Haruo> hub.c: port 1, portstatus 103, change 0, 12 Mb/s
Haruo> hub.c: port 2, portstatus 100, change 0, 12 Mb/s
 
Alan> This makes it look like the device isn't probed again after 
Alan> usbdevfs does the port reset. 

Is it that a problem is in a device?

Alan> Yet another thing to worry about.  But since it's in 2.4, 
Alan> people probably won't worry about it very hard.

I think so.

Thanks!!
Haruo


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
