From: John Bradford <john@grabjohn.com>
Subject: [TRIVIAL] [PATCH] fix spelling mistake
Date: Wed, 11 Dec 2002 17:23:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200212111723.gBBHNxuE008792@darkstar.example.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="%--multipart-mixed-boundary-1.8785.1039627438--%"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--%--multipart-mixed-boundary-1.8785.1039627438--%
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Description: ASCII English text
Content-Disposition: attachment; filename="patch"

--- linux-2.4.20-pre1-orig/drivers/scsi/README.ncr53c8xx	2002-12-11 17:14:48.000000000 +0000
+++ linux-2.4.20-pre1/drivers/scsi/README.ncr53c8xx	2002-12-11 17:18:24.000000000 +0000
@@ -1025,7 +1025,7 @@
 then it will for sure win the next SCSI BUS arbitration.
 
 Since, there is no way to know what devices are trying to arbitrate for the 
-BUS, using this feature can be extremally unfair. So, you are not advised 
+BUS, using this feature can be extremely unfair. So, you are not advised 
 to enable it, or at most enable this feature for the case the chip lost 
 the previous arbitration (boot option 'iarb:1').
 

--%--multipart-mixed-boundary-1.8785.1039627438--%--
