From: George Mavrikas <mavrikas@ceid.upatras.gr>
Subject: Low speed problem with USB 1.1 mass storage flash disk
Date: Sat, 27 Mar 2004 04:32:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403270432.18010.mavrikas@ceid.upatras.gr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from diogenis.ceid.upatras.gr ([150.140.141.181]:59632 "HELO
	diogenis.ceid.upatras.gr") by vger.kernel.org with SMTP
	id S261669AbUC0Ccb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 21:32:31 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi everyone.

I have a problem with a usb 1.1 stick. While FreeBSD 5.2, WinXP and kernel 2.4 
get 1 MB/sec from the stick, in 2.6 (currently 2.6.4-ck1) I get something 
about 550 to 670 KB/sec.

My box has a P4P800 motherboard (865G, uhci, ehci). 
I've checked the stick with a nforce 2 mobo (ohci) and 2.6.3: 1MB/sec
I've checked an other stick with my motherboard -> 550KB/sec
I've installed an old 1.1 ohci card to my pc and still 550KB/sec

I 've contacted Matthew Dharm (mdharm-usb@one-eyed-alien.net), the current 
maintainer of usb-storage and after a dozen on mails nothing seems not OK at 
the usb level. The only weird thing is that the usb-storage driver reads with 
4 KB chunks, whatever the usb-storage settings in sysfs are, so I guess some 
upper driver does this.

Any ideas?

Thanx a lot all of you!


George Mavrikas,

UnixGroup, Computer Engineering and Informarics Department,
Univercity of Patras, Greece
