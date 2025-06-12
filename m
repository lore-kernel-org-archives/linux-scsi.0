Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F5AC2F2;
	Thu, 12 Jun 2025 00:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687749; cv=none; b=c9PjrRdbOHbu0vBeUQPk9puNS/DvNsQ66ASIwgRqPhLrCBq+kdNBXYozb2BjrknOKXiG1QWaK7awZ5RQQV46Kt97cav9hZ2JuIY22zS3+EY5K36qWoiROblgTHEtgBHjXa3qz9PJKLiAyyLwp26N8hDQyEc3cACsPjiMjSqqxv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687749; c=relaxed/simple;
	bh=MnCr9OEVlQ7GknTARTds4npHpQMQRi/DiitUYHLyMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qSYvAURHY3lYZ03WjwDpggSt2o1DdfkHldrPatBsboUNDNUb21bzu/1j/p/ENF0cIO06xmT4P0ld6ka9nTrrbamzJLIfhsqmk31BolQK8+QgaC6L8KScHY9yxAFLwmu9mLm0dOVp0sm6YOHvqm3bn59AM+jXlDNnrG9Luirm6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=iUhG3LlO; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="iUhG3LlO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=980; q=dns/txt;
  s=iport01; t=1749687747; x=1750897347;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JPGvyzDxmu2hP40yELBEjF/T5i9eYvf8QiI2IbJNsD0=;
  b=iUhG3LlOQ/PdFdKFUo0yEvwx950E4QZprF/lH05PW4wG0nkqrJWFLsQu
   i2Ufv0oA7xUcfLAr+SdxwBLsS3pF4pu9rrE4LU0TT1AIS/gh0oSe0w7Pj
   rp0xskw2s6Wpv2eTZqY1bSevpO6PssyCXlNXRqKY32oo28GD0gdrR15Ca
   vh8/y1lwG0Wi1gfwTMfAk61QbO2auuurMxAPy4/v9NwBhrpsMAdyPSnXh
   BKXBN/c9Xzfm+eR5rSDu6CSPC1l7nv+JjSGdwrltOHkIHTuivSPM3/YpM
   ltgAMU+KH8Yd458OlyXfydD69ZDJx+rL2h/7PxVMHlczKXZcknxEnLvV3
   Q==;
X-CSE-ConnectionGUID: T8rS+4MeTJqtq/83iKzWEg==
X-CSE-MsgGUID: wIi/KUiPSwmT9MCNaxDEqg==
X-IPAS-Result: =?us-ascii?q?A0AnAAChHEpo/5IQJK1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB4toAiY0CQ4BAgQBA?=
 =?us-ascii?q?QEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhl0rCwFGgVCDAoJvA?=
 =?us-ascii?q?7ARgXkzgQHeN4FugUkBjUxwhHcnFQaBSUSCUIE+b4FSgjiBBoV3BIMmFKEeS?=
 =?us-ascii?q?IEeA1ksAVUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEoQphl6ESStPhSGFBSRyD?=
 =?us-ascii?q?wdKQAMLGA1IESw3FBsGPm4HmAuDcIEOgQKBPqYAoQuEJaFTGjOqYZkEqTiBa?=
 =?us-ascii?q?DyBWTMaCBsVgyJSGQ+OLRa7VSYyPAIHCwEBAwmQF4F9AQE?=
IronPort-Data: A9a23:ndgT6K/KlkWq8oQTPimhDrUDaH+TJUtcMsCJ2f8bNWPcYEJGY0x3y
 WNKWGCBM/uNajCheIh+bNvj8UlX7ZHQydZrS1M/rSpEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtNs/nrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kKbZcjubpSDF1s7
 OABb2BWbzORuM+5lefTpulE3qzPLeHiOIcZ/3UlxjbDALN+ENbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cPXWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2b4aEK4LWG5Q9ckCwu
 UPHuEfEAykhK9mjmB+u1Hu8qsLWknauMG4VPPjinhJwu3Wfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3SRRU0zhvYU3jj7Q5jYoOhIYuy5jDz9upJJoKUZkeOs
 WJCmMWE6u0KS5aXm0SwrP4lFbWt4bOBdTbbm1MqR8hn/DW28HnldodViN1jGHpU3g8/UWeBS
 CfuVcl5u/e/4FPCgXdLXr+M
IronPort-HdrOrdr: A9a23:t1bygqDOpXnx4EPlHemf55DYdb4zR+YMi2TDGXocdfUzSL37qy
 nAppomPHPP4gr5O0tQ+uxoWpPgfZq0z/ccirX5Vo3MYOCJggaVBbAnxZf+wjHmBi31/vNQ2O
 NdaaRkYeeAaGSS9fyb3OF9eOxQp+VuN8uT9IPj80s=
X-Talos-CUID: 9a23:YP7+p2Ex2WJCoTmVqmJbpFQvWZwAf0H/1WvJZB/jCEV7d5CaHAo=
X-Talos-MUID: =?us-ascii?q?9a23=3AxZmGxgx4SCvxaMiSPaP0/IWLJJ+aqLuPCQcurJQ?=
 =?us-ascii?q?+gNaBCX1VEBGUnBiaW4Byfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="374996469"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:22:25 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 0B9E318000448;
	Thu, 12 Jun 2025 00:22:23 +0000 (GMT)
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
	stable@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 1/5] scsi: fnic: Set appropriate logging level for log message
Date: Wed, 11 Jun 2025 17:22:08 -0700
Message-ID: <20250612002212.4144-1-kartilak@cisco.com>
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
X-Outbound-Node: alln-l-core-09.cisco.com

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

