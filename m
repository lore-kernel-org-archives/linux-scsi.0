From: Cal Peake <cp@absolutedigital.net>
Subject: [PATCH] Documentation/kernel-parameters.txt: scsi param updates
 [RESEND]
Date: Mon, 8 Nov 2004 02:37:34 -0500 (EST)
Message-ID: <Pine.LNX.4.61.0411062327150.31630@linaeum.absolutedigital.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linaeum.absolutedigital.net ([63.87.232.45]:61870 "EHLO
	linaeum.absolutedigital.net") by vger.kernel.org with ESMTP
	id S261764AbUKHHhj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2004 02:37:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

This patch updates Documentation/kernel-parameters.txt with the proper 
SCSI LUNs params and adds a description for 'max_luns'.

thanks,

-- Cal

Signed-off-by: Cal Peake <cp@absolutedigital.net>

--- linux-2.6.10-rc1-bk16/Documentation/kernel-parameters.txt	2004-11-06 23:11:03.000000000 -0500
+++ linux-2.6.10-rc1-bk16-1/Documentation/kernel-parameters.txt	2004-11-06 23:21:07.000000000 -0500
@@ -652,9 +652,10 @@
 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
 			should make use of
 
-	max_scsi_luns=	[SCSI]
+	max_luns=	[SCSI] Maximum number of LUNs to probe
+			Should be between 1 and 2^32-1.
 
-	max_scsi_report_luns=
+	max_report_luns=
 			[SCSI] Maximum number of LUNs received
 			Should be between 1 and 16384.
 
