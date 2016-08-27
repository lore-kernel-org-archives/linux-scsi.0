From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 1/3] documentation/scsi: Remove nodisconnect parameter
Date: Sat, 27 Aug 2016 12:29:59 +1000
Message-ID: <20160827022959.119870978@telegraphics.com.au>
References: <20160827022958.983743612@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=cleanup-nodisconnect
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver that used the 'nodisconnect' parameter was removed in
commit 565bae6a4a8f ("[SCSI] 53c7xx: kill driver"). Related documentation
was cleaned up in commit f37a7238d379 ("[SCSI] 53c7xx: fix removal
fallout"), except for the remaining two mentions that are removed here.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 Documentation/kernel-parameters.txt    |    2 --
 Documentation/scsi/scsi-parameters.txt |    2 --
 2 files changed, 4 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt	2016-08-27 12:29:57.000000000 +1000
+++ linux/Documentation/kernel-parameters.txt	2016-08-27 12:29:57.000000000 +1000
@@ -2543,8 +2543,6 @@ bytes respectively. Such letter suffixes
 
 	nodelayacct	[KNL] Disable per-task delay accounting
 
-	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
-
 	nodsp		[SH] Disable hardware DSP at boot time.
 
 	noefi		Disable EFI runtime services support.
Index: linux/Documentation/scsi/scsi-parameters.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi-parameters.txt	2016-08-27 12:29:57.000000000 +1000
+++ linux/Documentation/scsi/scsi-parameters.txt	2016-08-27 12:29:57.000000000 +1000
@@ -79,8 +79,6 @@ parameters may be changed at runtime by
 
 	ncr53c8xx=	[HW,SCSI]
 
-	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
-
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
 			See also Documentation/scsi/st.txt.
