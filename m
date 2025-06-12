Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B308563A9;
	Thu, 12 Jun 2025 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766701; cv=none; b=qezF9w+NkMiCa4Cyee4lJD5idm2t3cxVt5ww3AMd4DJ1dkKLnFfkefeI5ngjC59h9h6T8npctPtBT+Xo4agr6j+uSbb0eF+qb9keJ05+uq/9fwZYn2XjSojPGp/sPWftuxfJaNDWjGdZfK0h1PbSfcPNY9yU5PT3IMsx9Xr35K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766701; c=relaxed/simple;
	bh=MnCr9OEVlQ7GknTARTds4npHpQMQRi/DiitUYHLyMJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kieL2/pq1DcNy/QJcf/FS1LFzNStEj/6C+1/l/YbbYoLZfxC99UjkXkW8+SfjygM3VWiiCchs3LY4PDzu8JyYLtATuSTCS8SDbht9N3NzNcWU48ZHsvMQYSGUN55EnPjTmGnKQ5x/MjXy5nQ5/NELhxcmt6WkR1ceAvl0ioXFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=AFD4bsda; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="AFD4bsda"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=980; q=dns/txt;
  s=iport01; t=1749766699; x=1750976299;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JPGvyzDxmu2hP40yELBEjF/T5i9eYvf8QiI2IbJNsD0=;
  b=AFD4bsdaZ2y+EYI8Rl39rq7qq2B7zL4SW2pbFDA+hFBXur5zj9PouXcX
   WIA5EfcUR9rNL5uoMyb1yuPlyCoAI4Krk1eYbQKVvLpsptIHN+HCKi4ty
   yffpef47ZOcyTy9O+uw6UbozqgTEa8QEnZowsHNcF93T4mr2n5I17wHlz
   24gW4fty+Aheup7PgrQFNXTHCUTSGuwCrPEy0N0CwBHXPGMcp3OUSYvkH
   UE3aAEaP6BTEjrVPkRhx+ndHpJlRsUoknCU5SC8jNx6WzPlj43II9bm4d
   pQzzICT0lw2FuuDt0Ig6ixdz0NFYPquMSxNqVGFX4pQSq4iaNsYxsCc26
   g==;
X-CSE-ConnectionGUID: UHXx/6+hRdmWREKvtgUf9g==
X-CSE-MsgGUID: IoL56DG8RdeXlKEd25dndA==
X-IPAS-Result: =?us-ascii?q?A0AnAACoUUto/5MQJK1aHAECAgEHARQBBAQBggAHAQwBg?=
 =?us-ascii?q?kqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFB4toAiY0CQ4BAgQBAQEBAwIDA?=
 =?us-ascii?q?QEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhl0rCwFGgVCDAoJvA7AGgXkzg?=
 =?us-ascii?q?QHeN4FugUkBjUxwhHcnFQaBSUSCUIE+b4FSgjiBBoV3BIMmFKEeSIEeA1ksA?=
 =?us-ascii?q?VUTDQoLBwWBYwM1DAsuFW4yHYINhRmCEoQphl+ESStPhSGFByRyDwZHQAMLG?=
 =?us-ascii?q?A1IESw3FBsGPm4HmAmDcIEOgQKBPqYAoQuEJaFTGjOqYZkEqTiBaDyBWTMaC?=
 =?us-ascii?q?BsVgyJSGQ+OLRa7VSYyPAIHCwEBAwmPdYF9AQE?=
IronPort-Data: A9a23:75mY7q9NOHGaT4ytkawBDrUDUH+TJUtcMsCJ2f8bNWPcYEJGY0x3x
 jYZWGGEbq7fN2TyL9Elaojl8hxUupDcxtRrTwBvqi5EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtOs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kLHb0Ivbg0AVtC8
 MMiBRMTch++ibO5lefTpulE3qzPLeHiOIcZ/3UlxjbDALN/GdbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cPHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2YIuKJYLUFZQ9ckCwh
 2XiojrVLUEgONGvzRmo/ijxiunDtHauMG4VPPjinhJwu3Wfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3SRRU0zhvYU3jj7Q5jYoOhIYuy5jDmAe1oJYKdSByF+
 XMDgcXbtbhIBpCWnyvLS+IIdF2028u43PTnqQYHN/EcG/6FohZPoag4DOlCGXpU
IronPort-HdrOrdr: A9a23:835l+K5gdOKyxKjy4QPXwPvXdLJyesId70hD6qm+c3Bom6uj5q
 KTdZsguyMc5Ax6ZJhCo6HiBEDjexLhHPdOiOF7AV7IZmbbUQWTQb1K3M/L3yDgFyri9uRUyK
 tsN5RlBMaYNykesS+D2mmF+xJK+qjhzEhu7t2uq0tQcQ==
X-Talos-CUID: 9a23:DgqrA2FSCFIZxY3CqmJa1H4EXZ5mckfRyUjqDmymFWlURuyaHAo=
X-Talos-MUID: 9a23:3oPBZgR/ezi9E+roRXTNgxU/autHs56iBXAJsrgK4ZSIMyBZbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="389776689"
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 22:18:17 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPSA id EA4191800015F;
	Thu, 12 Jun 2025 22:18:15 +0000 (GMT)
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
Subject: [PATCH v4 1/5] scsi: fnic: Set appropriate logging level for log message
Date: Thu, 12 Jun 2025 15:18:01 -0700
Message-ID: <20250612221805.4066-1-kartilak@cisco.com>
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
X-Outbound-Node: alln-l-core-10.cisco.com

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

