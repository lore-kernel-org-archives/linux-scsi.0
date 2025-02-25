Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086FE3209;
	Tue, 25 Feb 2025 21:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520425; cv=none; b=jve4yUAQnC6AfPNgUb2oJMT0x5i9jrTWL6UzvJcV9NHeUQiq0uVN5LcifG9SH1kq9p+uHzbfhnApuO655jyEjZdqZkReLT/0w1SMKsJ2+JXdtqByzSPxub938x57tY6aDghl9EYQ1l3JPf+QPX3gS43j5mF/lxLoBUHcZ725lI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520425; c=relaxed/simple;
	bh=a9iWC8XfKT2iWxL1/pufi5C17kDX3H5vS9xqiRBjA1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag2KJzJcnlfwleRSWwsS7NkcNZJZLeYS92NUQJqj8O+4uoAN4lYu2UZ7goQaNp7hnsowgvM7sK2bH1PzfG/AG4MtjtHKSjbdOyri6BOmnJw7NG/EvSbi6zq6hYrbBIKifjd6RnpvB0ztAIum0JrF95zg27z6bxadZeF2eHMUHDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jymFSTBT; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jymFSTBT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2267; q=dns/txt;
  s=iport01; t=1740520424; x=1741730024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xV31pOx/rJdHZvYfEZsBph50DKXh7XNCEjIHwJod13M=;
  b=jymFSTBTvpRZtMApYY8SsaCtrZ3rfeb+BUpU9upv/I4dG7SJBJoL9alD
   fMUFCw4sX4BSdsvCY7BSbDJy9s9w6dqAUQ3dvUXPLLBdP36RypNgDgG/Q
   4iE0kPxNORvr8CY2Ovz6fR4U/emMIem3MDbQvaagVxSEhYCU4sEPZ6Sp1
   qa1VojnuxHv/45WYUCIB/ZJjDwCti4KXX9ESqmrCWkzV9iocVu18G+2cv
   aYsqpANYERT7xFFuLodWDDATHQAv9Q5LHNQV4bzNAnuHNYyPOkBU18YzI
   kZ8DiiTzcSb+bTvZF+eL2yhRUm9ndmagZWT5X908FfHKq5JOe39+V19m4
   g==;
X-CSE-ConnectionGUID: xr7iMWwoQhaiW6hz8Xb8QQ==
X-CSE-MsgGUID: A3gncff9TA2Cjg2vbdOloQ==
X-IPAS-Result: =?us-ascii?q?A0ALAACsOr5n/4r/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBggEDAQEBAQsBgkqBT0MZL5ZFnheBJQNWDwEBAQ9EBAEBhQcCi?=
 =?us-ascii?q?xECJjYHDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?wIBAycLAUYQUVYZgwKCZQOvLIF5M4EB3jSBboFIAY1KcIR3JxUGgUlEhA5vg?=
 =?us-ascii?q?VKDPoV3BIdbnWWKBUiBIQNZLAFVEw0KCwcFgXEDNQwLLhUygRRDN4JFaUk6A?=
 =?us-ascii?q?g0CNYIefIIrhFSEQ4RBhVKCEYQ8hwGECkADCxgNSBEsNxQbBj5uB6ArPIQ8L?=
 =?us-ascii?q?VQNFIIVFyk6pRGhBIQloUgaM6pVmH2pMIFuBy6BWTMaCBsVgyJSGQ+OLRbPR?=
 =?us-ascii?q?iUyPAIHCwEBAwmRZQEB?=
IronPort-Data: A9a23:SXIqVailNNkRRXk9LWRKQL4yX161SxEKZh0ujC45NGQN5FlHY01je
 htvXG3VM/vfYGKnf49/b4jlpk0FuJ/UnYdqTQporiE8RS9jpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSEULOZ82QsaD9Msfje8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUI4Ll2JF5R8
 sUYITEyMBCR19K8kIuCH7wEasQLdKEHPasFsX1miDWcBvE8TNWbGuPB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWYQd/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9IYbWGpsKwR7Ez
 o7A102iDRcROtLO9RPf2XCj3PHFkQT/X7tHQdVU8dYv2jV/3Fc7BBQQE1Cyu+G0jFKzQfpbK
 kod4C1oqrI9nGSpQ9v3dxm5pmOU+B8WXpxbFOhSwASE0LbV5UCBC3QJVCVMbvQhrsY9QTFs3
 ViM9/vtBDpyoPiWRGib+7O8szy/I24WIHUEaCtCShEKi/HnoYcunlfURc1iOLC6g8ezGjzqx
 T2O6i8kiN0uYdUjza63+xXDxjmrvJWMFldz7QTMVWXj5QR8DGK4W7GVBZHgxa4oBO6kopOp5
 xDoR+D2ADgyMKyw
IronPort-HdrOrdr: A9a23:fKNrCqtc8ibVa95+eKsGnfYh7skDWdV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT2Dr8pbnn5E4sHxKDwReDV7
X-Talos-CUID: 9a23:nhh3jWwsY2ZrQsV1OeVcBgUEAJ8kV0LCy07QKk6HV2Z7GI2fGWaprfY=
X-Talos-MUID: 9a23:fpoQWQRr1eR14/MGRXTF3z5kP8lmspiHUmsPns8YscWjMStJbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,314,1732579200"; 
   d="scan'208";a="324767704"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 25 Feb 2025 21:52:35 +0000
Received: from fedora.cisco.com (unknown [10.188.0.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id 0FA0818000294;
	Tue, 25 Feb 2025 21:52:33 +0000 (GMT)
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
Subject: [PATCH 2/2] scsi: fnic: Remove unnecessary spinlock locking and unlocking
Date: Tue, 25 Feb 2025 13:51:46 -0800
Message-ID: <20250225215146.4937-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225215146.4937-1-kartilak@cisco.com>
References: <20250225215146.4937-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.0.187, [10.188.0.187]
X-Outbound-Node: rcdn-l-core-01.cisco.com

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
 drivers/scsi/fnic/fdls_disc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 8843d9486dbb..6530298733f0 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -311,36 +311,30 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
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
 
 		if (test_and_clear_bit(idx, oxid_pool->pending_schedule_free)) {
 			reclaim_entry->oxid_idx = idx;
 			reclaim_entry->expires = round_jiffies(jiffies + delay_j);
+			spin_lock_irqsave(&fnic->fnic_lock, flags);
 			list_add_tail(&reclaim_entry->links, &oxid_pool->oxid_reclaim_list);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			schedule_delayed_work(&oxid_pool->oxid_reclaim_work, delay_j);
 		} else {
 			/* unlikely scenario, free the allocated memory and continue */
 			kfree(reclaim_entry);
 		}
 	}
-
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
 static bool fdls_is_oxid_fabric_req(uint16_t oxid)
-- 
2.47.1

