From: John Levon <levon@movementarian.org>
Subject: [PATCH] FlashPoint typo
Date: Wed, 26 Feb 2003 19:21:53 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226192153.GB58846@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compsoc.umu.man.ac.uk
	([130.88.22.5] helo=mrtall.compsoc.man.ac.uk ident=exim)
	by probity.mcc.ac.uk with esmtp (Exim 4.12)
	id 18o77q-000EjL-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:21:54 +0000
Received: from moz by mrtall.compsoc.man.ac.uk with local (Exim 3.33 #1)
	id 18o77p-000FOP-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:21:53 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Against 2.5.63, untested

regards
john


--- linux-linus/drivers/scsi/FlashPoint.c	2002-12-16 03:52:14.000000000 +0000
+++ linux/drivers/scsi/FlashPoint.c	2003-02-26 19:27:17.000000000 +0000
@@ -3846,7 +3846,7 @@
 	}
 	else
 	{
-		if(!currTar_Info->TarEEValue & EE_WIDE_SCSI)
+		if(!(currTar_Info->TarEEValue & EE_WIDE_SCSI))
 		{
 			return(0);
 		}
