Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34072868B3;
	Mon, 16 Jun 2025 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091279; cv=none; b=rY6ZIorURvX5oOnhXGCYLHkQQYJAFERbjABlXULO8KrG4mJpaT6aqz9Te08CxxSMcqLYzcbl4Awu+EWdHAH99pDRJyj523hFTupKAIeGP8dsBSgOC0Rd2Iy2tRLOQU90rrHYD9OAn24yVRaySFcDJJ+deBubhmcemrIe+VkIOy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091279; c=relaxed/simple;
	bh=HURmsdBbKNOSAqNOenBr9m14Z0sOMDL8smrbOnA/p1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkS5kR0RwO6egxwj6sqOMsaaikiMWpDWHLQTfHRU8MK3TTkCFQNYsU15F6sZ1IMNlS+IBJkoSbAFOF6idYVwcftFqcvRIJoNm9R0Gl04TvK7wW7vXoIzbbO4jizpyb39PL74Q2QoT/JrKkiC4QpsmXQ8jdx5kR9+iJcvuv8HCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=N+LPfg/O; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="N+LPfg/O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1077; q=dns/txt;
  s=iport01; t=1750091278; x=1751300878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFBqO6pbNAK7jq9L1bG5wLn+UjI0z0smSksS5Y9zv6A=;
  b=N+LPfg/Oz2RRoLbTZTO/o5g9yvRqBWb1/fWXcgpIt8OL4ndBLHNtoz8O
   pDkR4ChJIOf78ke2Xqb1Vr2+vA6o81fjZjgUenZxJnRDW0GNOpSMwg7aE
   IFEyt4jRAhjFagUzgWYFpNBx9QCsbvo4xNkwwPSzSbKoAJIOrRkbTrZHr
   9wE6lfXt9Ry6Bs1Bg8D1b7xZq5ditiUhg6HNcy9BC2So5DyigsyH54Mhj
   zaRoaPWDXQNicNnPIfaHRFwh4cEG3nFRFQuQX/Ejym73icL3Fk99z/GDs
   h1IWUDrjX7CQJbHJeFLHIG3mgZus+Oe9UPU4jZuTsyhMeUFOa0+ZeuiYc
   w==;
X-CSE-ConnectionGUID: kIg4VixtRbSEoQ7TvlZwnw==
X-CSE-MsgGUID: b9xPorp1RVeXRrUqJcmfaQ==
X-IPAS-Result: =?us-ascii?q?A0ANAACbRFBo/5QQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSgOoElA1cPAQEBD1EEAQGFBwKLZgImN?=
 =?us-ascii?q?AkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZbAgEDJ?=
 =?us-ascii?q?wsBRhBRVhmDAoJvA694gXkzgQHeN4FugUkBjU1whHcnFQaBSUSCUIE+b4FSg?=
 =?us-ascii?q?jiBBoV3BIMmFJUzi3BIgR4DWSwBVRMNCgsHBYFjAzUMCy4VbjIdgg2FGYISh?=
 =?us-ascii?q?CmGX4RJK0+FIYUFJHEPBk9AAwsYDUgRLDcUGwY+bgeYC4NygQ6BAoE9AaYAo?=
 =?us-ascii?q?QuEJaFTGjOqYZkEqTiBaDyBWTMaCBsVgyJSGQ+OLRa7UyYyPAIHCwEBAwmPf?=
 =?us-ascii?q?4F9AQE?=
IronPort-Data: A9a23:BIWiv6Cl+O9POBVW//niw5YqxClBgxIJ4kV8jS/XYbTApDlxgWAHm
 2QYCGDXPa6DZWTzft0kbN7koE4D6JOHx98xOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZuCCaF/H9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gXWthh
 fuo+5eCYAH8hWYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEwNRhUH83LZEi8N1aBlgRy
 eIcGi8LcUXW7w626OrTpuhEj8AnKozveYgYoHwllGifBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWoHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237l1wtjOi2bIOPEjCMbc8Ejn6fv
 HqfxVr0MisACcW9wj+L+0v504cjmgu+Aur+DoaQ+vdsxlaa3HQeDgEbT3O/oP+wkEn4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc0QDEs2
 1CJnvvzCDBvuaHTQnWYnp+OoC2/IzM9N2IOZSYYCwAC5rHLpIA1kwKKTdt5FqOxpsP6FCu2w
 D2QqiU6wbIJgqYj06S94ECCmDm3p7DXQQMvoAbaRGSo6kV+foHNWmCzwVHf6fAFKMOSSUOM+
 SFd3cOf9+sJS5qKkURhXdkwIV1g3N7dWBW0vLKlN8dJG+iFk5J7Qb1t3Q==
IronPort-HdrOrdr: A9a23:xozmcqtMJXdssWrU/7ysx1cP7skDWdV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT2Dr8pbnn5E4sHxKDwReDV7
X-Talos-CUID: 9a23:ItKyc2M+tYQZYu5DWwhoqHAVCtwfeEbwy06PH1G8O3lvV+jA
X-Talos-MUID: 9a23:Mh7zGgROYDMtF6J/RXTm1SFaM91wup6QBXA3i6gfmcKBOyVJbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,241,1744070400"; 
   d="scan'208";a="384483412"
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2025 16:27:51 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPSA id 85E82180001E7;
	Mon, 16 Jun 2025 16:27:49 +0000 (GMT)
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
Subject: [PATCH v5 4/4] scsi: fnic: Set appropriate logging level for log message
Date: Mon, 16 Jun 2025 09:26:32 -0700
Message-ID: <20250616162632.4835-4-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250616162632.4835-1-kartilak@cisco.com>
References: <20250616162632.4835-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-11.cisco.com

Replace KERN_INFO with KERN_DEBUG for a log message.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v4 and v5:
    - Incorporate review comments from John:
	- Refactor patches
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

