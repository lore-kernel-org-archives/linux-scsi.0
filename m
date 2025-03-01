Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091605D477;
	Sat,  1 Mar 2025 01:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793092; cv=none; b=gBQ2JdHfHlW0B+nw0QP4C2iyu2pn5KSglYLzxCMqTEAqPTJRkogTV/0KccmZGfz9RN7O2J8mSPZj5rzbehUpF6aKNUb3yT55RVKryL+Dtz4ozIR0NBDHRSh4A03arZPEJ4SPfs4W9laGypkTLQm+RI38u3OJhkiJH5KqcT9uDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793092; c=relaxed/simple;
	bh=SGtJkTVs1wfKFQ3djGT+YPLA+ozYMqVAUZLGJlKsATA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAQQE+Q/6Qz7Q2w0JaQRQq+2+aXhgTo0wECdu3ptOcfDdnCpbCJZBrUJ1ayL0Uu4VvpTr1wQcm8aqQx7yPMvE77HMKwD7kYnnHnNrE2gkhr2x8TZoe/WdCNKfR79aPuPmdOZvctbK6x4dXSSJzWD1XdOs+4eTVeYBtWPa0YI08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=DprpMahT; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="DprpMahT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2694; q=dns/txt;
  s=iport01; t=1740793090; x=1742002690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d9bNDS3toHZSghfkJ3+rrgH5/3IKTFtj1voiS02NofM=;
  b=DprpMahTq26bm2ZP5FqgEN5kEsyjDIB9HZbF5NynVHbG98ehhQL5Jgoj
   MXAAZR/NrcHkmU4D1IBVCnISUOD9vM8zqZZNb06VSVz+KQc9DXEb+xV7v
   oK785zbx0uM12ZjqSfwmH/FQV1SzW6TvAVzoxkrlvnLTryO7ir+GqBnW1
   AsWe56WvDT9cy2nPkhW0AGORimgblQXPM3IGJLcKxBzV5TSF42pYjP/e5
   OjZj3S725xYvRSpkScbgCXmRiia6uhlnDjHDwmu4lvonDVytQyBhEZr6i
   qV5UdVyA8TyT8bOnsYgvEvS1bSgIUOlKYM3Zt7V6uJ71Q0z8iOjQMu12L
   w==;
X-CSE-ConnectionGUID: +4LBonx1SQOEK4y61m+i7Q==
X-CSE-MsgGUID: JOTB7dy1SLyySxHxc5oMGw==
X-IPAS-Result: =?us-ascii?q?A0AMAAAuZMJn/4//Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBggEDAQEBAQsBgkqBT0MZL5ZFnheBJQNWDwEBAQ9EBAEBhQcCi?=
 =?us-ascii?q?xQCJjYHDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?wIBAycLAUYQUVYZgwKCZQOvEYF5M4EB3jSBboFIAY1KcIR3JxUGgUlEhA5vg?=
 =?us-ascii?q?VKDPoV3BIdWnWKBeokFSIEhA1ksAVUTDQoLBwWBcQM1DAsuFTKBFEM3gkVpS?=
 =?us-ascii?q?ToCDQI1gh58giuEVIRDhECFUoIRhDmGfoUGQAMLGA1IESw3FBsGPm4HoHs8h?=
 =?us-ascii?q?D0tVA0UghUWASk6knCSI6EGhCWhSBozqlaYfakxgW4KK4FZMxoIGxWDIlIZD?=
 =?us-ascii?q?44tFswGJTI8AgcLAQEDCZFlAQE?=
IronPort-Data: A9a23:cF3qt6hySZgiNIOhXCnTtU7rX161SxEKZh0ujC45NGQN5FlHY01je
 htvCGHTa/yCM2Pxf95xPI+2oEpX6p/UzNJqHQc4r389FytjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSEULOZ82QsaD9MsPra8EoHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqVbpsJdBmder
 MchDx0uMgHd3uf1we2CH7wEasQLdKEHPasFsX1miDWcBvE8TNWbHePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9IYbVGZgIzxnCz
 o7A10bePjtFOM3G8h6U40m8pv/EwCTed51HQdVU8dYv2jV/3Fc7BBQQE1Cyu+G0jFKzQfpbK
 kod4C1oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vtBDpyoPiWRGib+7O8szy/I24WIHUEaCtCShEKi/HnoYcunlfURc1iOLC6g8ezGjzqx
 T2O6i8kiN0uYdUjza63+xXDxjmrvJWMFlBz7QTMVWXj5QR8DGK4W7GVBZHgxa4oBO6kopOp5
 RDoR+D2ADgyMKyw
IronPort-HdrOrdr: A9a23:pdKXZqMQV45Q5cBcTu6jsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVbSO09QYVcemsAJsQiTtENg==
X-Talos-CUID: 9a23:NqekjWyB4ZNANotFcDz9BgVXRuQPdXvNlUzpBGKbVXc3EbjWSACprfY=
X-Talos-MUID: =?us-ascii?q?9a23=3AqnamXA6ZJbBE2DcSBsmyNMOLxoxKxJiEV0wcyK4?=
 =?us-ascii?q?iqti/JQxgMGqaqRuoF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,324,1732579200"; 
   d="scan'208";a="327455972"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 01 Mar 2025 01:38:03 +0000
Received: from fedora.cisco.com (unknown [10.188.102.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 2070B18000263;
	Sat,  1 Mar 2025 01:38:02 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH v2 2/2] scsi: fnic: Remove unnecessary spinlock locking and unlocking
Date: Fri, 28 Feb 2025 17:37:12 -0800
Message-ID: <20250301013712.3115-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250301013712.3115-1-kartilak@cisco.com>
References: <20250301013712.3115-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.102.227, [10.188.102.227]
X-Outbound-Node: rcdn-l-core-06.cisco.com

Remove unnecessary locking and unlocking of spinlock in
fdls_schedule_oxid_free_retry_work.
This will shorten the time in the critical section.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments by Dan:
	Replace test and clear bit with clear bit.
---
 drivers/scsi/fnic/fdls_disc.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 8843d9486dbb..a9ffa7b63730 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -311,36 +311,26 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 	unsigned long flags;
 	int idx;
 
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-
 	for_each_set_bit(idx, oxid_pool->pending_schedule_free, FNIC_OXID_POOL_SZ) {
 
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"Schedule oxid free. oxid idx: %d\n", idx);
 
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		reclaim_entry = kzalloc(sizeof(*reclaim_entry), GFP_KERNEL);
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-
 		if (!reclaim_entry) {
 			schedule_delayed_work(&oxid_pool->schedule_oxid_free_retry,
 				msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_TIME));
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			return;
 		}
 
-		if (test_and_clear_bit(idx, oxid_pool->pending_schedule_free)) {
-			reclaim_entry->oxid_idx = idx;
-			reclaim_entry->expires = round_jiffies(jiffies + delay_j);
-			list_add_tail(&reclaim_entry->links, &oxid_pool->oxid_reclaim_list);
-			schedule_delayed_work(&oxid_pool->oxid_reclaim_work, delay_j);
-		} else {
-			/* unlikely scenario, free the allocated memory and continue */
-			kfree(reclaim_entry);
-		}
+		clear_bit(idx, oxid_pool->pending_schedule_free);
+		reclaim_entry->oxid_idx = idx;
+		reclaim_entry->expires = round_jiffies(jiffies + delay_j);
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		list_add_tail(&reclaim_entry->links, &oxid_pool->oxid_reclaim_list);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		schedule_delayed_work(&oxid_pool->oxid_reclaim_work, delay_j);
 	}
-
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
 static bool fdls_is_oxid_fabric_req(uint16_t oxid)
-- 
2.47.1

