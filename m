From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Thu, 17 Feb 2005 17:31:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502171728080.627-100000@ida.rowland.org>
References: <20050217221803.091fd840@hebus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:14852 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261206AbVBQWbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 17:31:04 -0500
In-Reply-To: <20050217221803.091fd840@hebus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch adds a NOREPORTLUN blacklist flag for a disk made by "WDC" 
(Winchester?).  The drive's firmware crashes when it receives REPORT_LUNS, 
even though it claims to be SCSI rev 04.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
+++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
@@ -201,6 +201,7 @@
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
+	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},

