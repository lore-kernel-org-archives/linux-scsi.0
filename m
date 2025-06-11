Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681AE1E8329;
	Wed, 11 Jun 2025 18:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666718; cv=none; b=QmQAPc00p+xWtmZhClPR0Ruuvjq9e3xFy9TMwfxwXkSfOejtaipgg7APUxZSXTIz/Wl5OK8kGVkxJRMWFwkMub1Gt87tOs2JxKh51MV9q9K40IoTORHQ0YufAZ0DN9WhF/0ammct40Mi3ZgrzqWecVbEhdz01tiF2rPzMA56+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666718; c=relaxed/simple;
	bh=MnCr9OEVlQ7GknTARTds4npHpQMQRi/DiitUYHLyMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7Km6Lx7QvmUmeTzsFxetRwcD2GH7ackthP7krCEUlMTs3vTtuoYRMLX0SeUiq7e5+CTh19UrI3ZAGPSn2RJnbRd/AvB0dr2+R3EGbVKQCPPKBLKqdq42qIRiSADHf1CbL1vINHsohnJ7LFNS6XCID+FrKuJmbTKFASvjSp8VII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ZwI5Ool5; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ZwI5Ool5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=980; q=dns/txt;
  s=iport01; t=1749666716; x=1750876316;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JPGvyzDxmu2hP40yELBEjF/T5i9eYvf8QiI2IbJNsD0=;
  b=ZwI5Ool5XbvG4dZ0Z2H2XQRWp1Uiu0SyaT6qygGaWsJ1rPrUkJg2ePWN
   YexPNivbOdOm/7Aj6a5HQkfZXNNxsfXPyjGwFj1tOm8B/MAZiI1W6U/nd
   ESHB2bZi69HTic82NySvaiaZn4JaKLIbRw7KfQWynRkMcb7qN0aRGfKAI
   bBXMBbE0u38b/0tL1vrZIjuIWyORRxqmriK8E6BtQDBcRXTLfbH6tnkO5
   iwikHs8iPZN7opvCg87awc9HhgGKeotgdUpmQ6pFdcI0egSWkZd1krxaB
   Y0BMzc+/XpyRqZJq7TnUOvZI06WoiFe2xNrsLUSymlaJozgTADcFkpX/8
   g==;
X-CSE-ConnectionGUID: hk1LNjcYS5OHifG8YQVOZw==
X-CSE-MsgGUID: 6uluQsERS7iGcyBUhk5KJQ==
X-IPAS-Result: =?us-ascii?q?A0AnAABcyklo/4sQJK1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB4toAiY0CQ4BAgQBA?=
 =?us-ascii?q?QEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhl0rCwFGgVCDAoJvA?=
 =?us-ascii?q?69xgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSCUIE+b4FSgjiBBoV3BIMmFKEUS?=
 =?us-ascii?q?IEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEoQphl6ESStPhSGFBSRyD?=
 =?us-ascii?q?wc9QAMLGA1IESw3FBsGPm4HmASDcIEOgQKBPqYAoQuEJaFTGjOqYZkEqTiBa?=
 =?us-ascii?q?DyBWTMaCBsVgyJSGQ+OLRa7VSYyPAIHCwEBAwmQF4F9AQE?=
IronPort-Data: A9a23:2kDw7K9Gqi5PxeQEVJiCDrUDUH+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 WYfXTjUb6mJYmDxKd4jPo3lpE5TusCEnYBrTgtopHtEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtNs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2k2PtQ83OR8MFoT0
 twZJh9dXym9oNCplefTpulE3qzPLeHiOIcZ/3UlxjbDALN+G9bIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2bMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2b4aKI4HUFJg9ckCw+
 H/C4l3iLysha92wwiuvz3Kv28ztpHauMG4VPPjinhJwu3Wfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3SRRU0zhvYU3jj7Q5jYoOhIYuy5jDmAe1oJYKdSByF+
 XMDgcXbtLpIBpCWnyvLS+IIdF2028u43PTnqQYHN/EcG/6FohZPoag4DOlCGXpU
IronPort-HdrOrdr: A9a23:AEFlZ6lGAdWDl/p4AyTwxIUIc/zpDfIf3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzEht7t2uqEuEimpRGsVd0zs=
X-Talos-CUID: =?us-ascii?q?9a23=3AKbeAfGi+GMw8C4oSKfVUYeU6njJucn6E6FHSKH6?=
 =?us-ascii?q?DVEFJSbO6GW6pxoRWjJ87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AuYhoFgzcl5delUVTXQNSHUGyufmaqPqzDF00irg?=
 =?us-ascii?q?8gJaFGidhEQqdj2mUYLZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,228,1744070400"; 
   d="scan'208";a="374715695"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 11 Jun 2025 18:30:46 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPSA id 305B218000153;
	Wed, 11 Jun 2025 18:30:45 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 1/5] scsi: fnic: Set appropriate logging level for log message
Date: Wed, 11 Jun 2025 11:30:29 -0700
Message-ID: <20250611183033.4205-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-02.cisco.com

Replace KERN_INFO with KERN_DEBUG for a log message.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 7133b254cbe4..75b29a018d1f 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1046,7 +1046,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
 			atomic64_inc(&fnic_stats->misc_stats.queue_fulls);
 
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 				"xfer_len: %llu", xfer_len);
 		break;
 
-- 
2.47.1

