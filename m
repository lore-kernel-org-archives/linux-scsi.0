From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] gdth: schedule GDTIOCTL_OSVERS for removal
Date: Tue, 9 Aug 2005 23:55:14 +0400
Message-ID: <20050809195514.GA10945@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.192]:11323 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932345AbVHITq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2005 15:46:59 -0400
Received: by wproxy.gmail.com with SMTP id i17so835561wra
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2005 12:46:56 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Achim Leubner <achim_leubner@adaptec.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+)

--- linux-vanilla/Documentation/feature-removal-schedule.txt
+++ linux-gdth/Documentation/feature-removal-schedule.txt
@@ -135,3 +135,11 @@ Why:	With the 16-bit PCMCIA subsystem no
 	pcmciautils package available at
 	http://kernel.org/pub/linux/utils/kernel/pcmcia/
 Who:	Dominik Brodowski <linux@brodo.de>
+
+---------------------------
+
+What:	GDTIOCTL_OSVERS ioctl
+When:	November 2005
+Files:	drivers/scsi/gdth.c, drivers/scsi/gdth.h
+Why:	Duplicates uname(2).
+Who:	Alexey Dobriyan <adobriyan@gmail.com>

