From: Andries.Brouwer@cwi.nl
Subject: Re: Feiya 5-in-1 Card Reader
Date: Thu, 5 Sep 2002 10:41:48 +0200 (MEST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200209050841.g858fmZ28242.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://www.geocrawler.com/redir-sf.php3?list=linux-usb-devel>
To: Andries.Brouwer@cwi.nl, alaric@babcom.com, greg@kroah.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

> Speaking of sddr09 devices (of which I possess one), what's the current
> state of support for the sddr09?  Last I knew, at the time when I finally
> got mine working, the sddr09 was only supported read-only

For me it works read-write and out-of-the-box on a vanilla kernel.
(I added this stuff a few months ago. Found in 2.5 (which I use).
Am not quite sure about 2.4.)

Andries


[In case you try 2.5, a warning: later tens and early twenties
will eat filesystems if you have the wrong IDE hardware. But
2.5.32, 2.5.33 are fine here.]


-------------------------------------------------------
This sf.net email is sponsored by: OSDN - Tired of that same old
cell phone?  Get a new here for FREE!
https://www.inphonic.com/r.asp?r=sourceforge1&refcode1=vs3390
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
