From: Thomas Babut <thomas@babut.net>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI	Adapter
Date: Wed, 09 Feb 2005 20:25:14 +0100
Message-ID: <420A639A.2020504@babut.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from tueddeln.de ([213.202.245.13]:36264 "EHLO srv.specialhosting.de")
	by vger.kernel.org with ESMTP id S261876AbVBITZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2005 14:25:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: matthew@wil.cx

Yesterday I tried Kernel 2.6.11-rc3 with newest sym53c8xx_2 driver 
(version 2.1.18n). But it still doesn't work. On boot the driver hangs 
up the system.

To remember:

0000:00:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 
Ultra3 SCSI Adapter (rev 01)
         Flags: bus master, medium devsel, latency 72, IRQ 11
         I/O ports at b000 [size=256]
         Memory at f8800000 (64-bit, non-prefetchable) [size=1K]
         Memory at f8000000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [40] Power Management version 2

With Kernel 2.4.29 and sym53c8xx driver it works fine. I still wish to 
run a Kernel 2.6 on that machine.

Regards,
Thomas Babut
