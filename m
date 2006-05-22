From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 8/8] zfcp: bump up version number
Date: Mon, 22 May 2006 18:27:30 +0200
Message-ID: <20060522162730.GA25291@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:59736 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750969AbWEVQaD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:30:03 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGU2bj064772
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:30:02 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGV32o126870
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:31:03 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGU1sJ000887
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:30:02 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: bump up version number

Bump up version number, skip "4.6.0" because this might
clash with zfcp version in certain distros.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

3a8775c71aa2bc0ea03b5a33fb30aba4dac63480
 drivers/s390/scsi/zfcp_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

3a8775c71aa2bc0ea03b5a33fb30aba4dac63480
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index a67d608..2df512a 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -52,7 +52,7 @@ #include <linux/ioctl.h>
 /********************* GENERAL DEFINES *********************************/
 
 /* zfcp version number, it consists of major, minor, and patch-level number */
-#define ZFCP_VERSION		"4.5.0"
+#define ZFCP_VERSION		"4.7.0"
 
 /**
  * zfcp_sg_to_address - determine kernel address from struct scatterlist
-- 
1.3.3.gd5e3d

