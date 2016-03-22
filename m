From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3 1/3] scsi: make some Additional Sense strings more grep'able
Date: Tue, 22 Mar 2016 20:32:03 +0100
Message-ID: <1458675126-19265-2-git-send-email-linux@rasmusvillemoes.dk>
References: <20160322075405.GA20141@infradead.org>
 <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37528 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcCVTcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 15:32:24 -0400
Received: by mail-wm0-f43.google.com with SMTP id p65so177778570wmp.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2016 12:32:23 -0700 (PDT)
In-Reply-To: <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

There's little point in breaking these strings over multiple lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/constants.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index fa09d4be2b53..58d94e3c3713 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -346,11 +346,9 @@ static const struct error_info additional[] =
 	{0x0407, "Logical unit not ready, operation in progress"},
 	{0x0408, "Logical unit not ready, long write in progress"},
 	{0x0409, "Logical unit not ready, self-test in progress"},
-	{0x040A, "Logical unit not accessible, asymmetric access state "
-	 "transition"},
+	{0x040A, "Logical unit not accessible, asymmetric access state transition"},
 	{0x040B, "Logical unit not accessible, target port in standby state"},
-	{0x040C, "Logical unit not accessible, target port in unavailable "
-	 "state"},
+	{0x040C, "Logical unit not accessible, target port in unavailable state"},
 	{0x040D, "Logical unit not ready, structure check required"},
 	{0x040E, "Logical unit not ready, security session in progress"},
 	{0x0410, "Logical unit not ready, auxiliary memory not accessible"},
@@ -363,11 +361,9 @@ static const struct error_info additional[] =
 	{0x0417, "Logical unit not ready, calibration required"},
 	{0x0418, "Logical unit not ready, a door is open"},
 	{0x0419, "Logical unit not ready, operating in sequential mode"},
-	{0x041A, "Logical unit not ready, start stop unit command in "
-	 "progress"},
+	{0x041A, "Logical unit not ready, start stop unit command in progress"},
 	{0x041B, "Logical unit not ready, sanitize in progress"},
-	{0x041C, "Logical unit not ready, additional power use not yet "
-	 "granted"},
+	{0x041C, "Logical unit not ready, additional power use not yet granted"},
 	{0x041D, "Logical unit not ready, configuration in progress"},
 	{0x041E, "Logical unit not ready, microcode activation required"},
 	{0x041F, "Logical unit not ready, microcode download required"},
@@ -559,8 +555,7 @@ static const struct error_info additional[] =
 	{0x2300, "Invalid token operation, cause not reportable"},
 	{0x2301, "Invalid token operation, unsupported token type"},
 	{0x2302, "Invalid token operation, remote token usage not supported"},
-	{0x2303, "Invalid token operation, remote rod token creation not "
-	 "supported"},
+	{0x2303, "Invalid token operation, remote rod token creation not supported"},
 	{0x2304, "Invalid token operation, token unknown"},
 	{0x2305, "Invalid token operation, token corrupt"},
 	{0x2306, "Invalid token operation, token revoked"},
@@ -641,8 +636,7 @@ static const struct error_info additional[] =
 	{0x2A0D, "Data encryption capabilities changed"},
 	{0x2A10, "Timestamp changed"},
 	{0x2A11, "Data encryption parameters changed by another i_t nexus"},
-	{0x2A12, "Data encryption parameters changed by vendor specific "
-		 "event"},
+	{0x2A12, "Data encryption parameters changed by vendor specific event"},
 	{0x2A13, "Data encryption key instance counter has changed"},
 	{0x2A14, "SA creation capabilities data has changed"},
 	{0x2A15, "Medium removal prevention preempted"},
@@ -759,8 +753,7 @@ static const struct error_info additional[] =
 	{0x3B19, "Element enabled"},
 	{0x3B1A, "Data transfer device removed"},
 	{0x3B1B, "Data transfer device inserted"},
-	{0x3B1C, "Too many logical objects on partition to support "
-	 "operation"},
+	{0x3B1C, "Too many logical objects on partition to support operation"},
 
 	{0x3D00, "Invalid bits in identify message"},
 
@@ -957,8 +950,7 @@ static const struct error_info additional[] =
 	{0x5D39, "Data channel impending failure throughput performance"},
 	{0x5D3A, "Data channel impending failure seek time performance"},
 	{0x5D3B, "Data channel impending failure spin-up retry count"},
-	{0x5D3C, "Data channel impending failure drive calibration retry "
-	 "count"},
+	{0x5D3C, "Data channel impending failure drive calibration retry count"},
 	{0x5D40, "Servo impending failure general hard drive failure"},
 	{0x5D41, "Servo impending failure drive error rate too high"},
 	{0x5D42, "Servo impending failure data error rate too high"},
@@ -1070,8 +1062,7 @@ static const struct error_info additional[] =
 
 	{0x6E00, "Command to logical unit failed"},
 
-	{0x6F00, "Copy protection key exchange failure - authentication "
-	 "failure"},
+	{0x6F00, "Copy protection key exchange failure - authentication failure"},
 	{0x6F01, "Copy protection key exchange failure - key not present"},
 	{0x6F02, "Copy protection key exchange failure - key not established"},
 	{0x6F03, "Read of scrambled sector without authentication"},
-- 
2.1.4

