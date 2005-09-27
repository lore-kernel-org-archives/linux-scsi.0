From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: rewriting drivers that use SCSI_ABORT_SUCCESS and so on (fwd)
Date: Tue, 27 Sep 2005 10:26:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509271025560.23502@numbat.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:60372 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S964859AbVI0I3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 04:29:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Igor Rondarev <igor.rondarev@lynx.ru>

---------- Forwarded message ----------
Date: Tue, 27 Sep 2005 11:44:46 +0400
From: Igor Rondarev <igor.rondarev@lynx.ru>
To: geert@linux-m68k.org
Subject: rewriting drivers that use SCSI_ABORT_SUCCESS and so on

Hello Geert!
I'm now trying to rewrite LSI Logic MegaRAID ATA 133-2 driver for 2.6.13 kernel.
I saw you posts regarding to similar problem on some Internet forums. LSI driver
also uses obsoleted SCSI_ABORT_SUCCESS and other definitions and scmd->state variable, which is not present in current SCSI source code. Have you found any solutions, or any ideas how to convert them correctly to the new SCSI API? Unfortunately, i'm not a big expert in linux kernel programming. LSI stopped supporting of this software RAID adapter, but i still need it in my linux box.
Hope you'll answer me :)
With best regards,
Igor V. Rondarev
Lynx BCC Company
Saint-Petersburg, Russia
