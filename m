From: Kevin Tappe <kevin@zerodivide.de>
Subject: compile warning g_NCR5380 2.6.0-test6
Date: Mon, 29 Sep 2003 22:51:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030929205134.GA462@nihil.tappe.netz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32421 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262813AbTI2Uwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 16:52:34 -0400
Received: from kevin by nihil.tappe.netz with local (Exim 3.35 #1 (Debian))
	id 1A44zW-00007f-00
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 22:51:34 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i hope this is the right emailaddress...

I've just installed the new kernel 2.6.0-test6 and get a compile 
warning in the g_NCR5380 module:

  CC [M]  drivers/block/rd.o
  CC [M]  drivers/block/nbd.o
  CC [M]  drivers/char/genrtc.o
  CC [M]  drivers/net/3c59x.o
  CC [M]  drivers/net/dummy.o
  CC [M]  drivers/scsi/g_NCR5380.o
drivers/scsi/g_NCR5380.h:55: warning:
`generic_NCR5380_biosparam' declared `static' but never defined
drivers/scsi/g_NCR5380.c:925: warning: `id_table' defined
but not used
  CC [M]  drivers/video/console/fbcon.o
  CC [M]  drivers/video/console/fonts.o
  CC [M]  drivers/video/console/font_8x8.o
  CC [M]  drivers/video/console/font_8x16.o

Bye,
Kevin
