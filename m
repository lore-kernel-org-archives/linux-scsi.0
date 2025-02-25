Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E330920FA9B;
	Tue, 25 Feb 2025 21:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520320; cv=none; b=m3Sqf6Vy9PBl/HJNp0I5FAjVZl8PPvtvW0L9NhlPjWK/Co0mf0SjKfrEJkTtRAsSWVs49cipu/QEuLYCyWZU/9BfvG9XUgnlgSAkC9+KWYGrVjtbeohBwJJjkuf+/NDOBVelkq+hHJ85rvJ7kiqkzdATrrc4cH3A7Z/0bYQF9rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520320; c=relaxed/simple;
	bh=/mVb1cWmahOS0hdzk0lGF9RbsSLIIt2giyY6mwneQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bJem0/6PQL8Fh2THk9JZZhvObrVrTPU+gU156y6Ab/jy0fgKr+g402j9Sx0b4KDiTZ/O57h9C84+P6SzRrAAHtwSUQr9771d7F+7aLxl/r6mCt3VIbx81UzpBIQC8AWcTasYOjwPyGcrY8BBskiYgSQhVq59OLBkBugrtX3i3Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=GJVmQA6y; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="GJVmQA6y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2219; q=dns/txt;
  s=iport01; t=1740520318; x=1741729918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3MonZo2jXloOtsIh/XS4/JCVgUFE8L/wLWsGXbbJe80=;
  b=GJVmQA6yInGZMiaPl6JCOzMCmdHL05zfkoYhInXDhmKhO1iGPNHfaklD
   QeDAC9bWUqEwljtp3W9aLIbGjJoCF/riUKDhBNt/wqP97ncQH7ks0P3DR
   3WHIAzlv6vpG4hglpZTkyqsKW453H5kCe6S4anjURqEXREilp+fmO1M9p
   GH1gsM5wBGRe+g4qbpKqjqth8OuilJQ9+TIiEztPG/rQ1HymtBQ4i2atH
   9+bcwvFUhgju8UvWhXQB2tEUUeCmKgJWWBq9ufTFt8rv0U15vCuXsAxs4
   E9YuSu62QZhGX9dOqwfy69x/fRnI6HBsQjYIQwQSO362HDwT3koO4lUNh
   g==;
X-CSE-ConnectionGUID: KE9Qo0bbSXGDID3eKMJerg==
X-CSE-MsgGUID: +K+bT5CWQNGDdrO7PyF2Sw==
X-IPAS-Result: =?us-ascii?q?A0ANAACsOr5n/4r/Ja1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBT0MZL4xyp2qBJQNWDwEBAQ9EBAEBhQeLEwImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZdKwsBRoFQg?=
 =?us-ascii?q?wKCZQOvLIF5M4EB3jSBboFIAY1KcIR3JxUGgUlEhH2BUoM+hXcEh1unakiBI?=
 =?us-ascii?q?QNZLAFVEw0KCwcFgXEDNQwLLhWBRkM3gkVpSToCDQI1gh58giuEVIRDhEGFU?=
 =?us-ascii?q?oIRiz2ECkADCxgNSBEsNxQbBj5uB6ArPIQ8gQ4UgiwpOqURoQSEJaFIGjOqV?=
 =?us-ascii?q?S6YT6kwgWc8gVkzGggbFYMiUhkPji0Wz0YlMjwCBwsBAQMJkWUBAQ?=
IronPort-Data: A9a23:oGEi/6B2brRCaRVW/wLiw5YqxClBgxIJ4kV8jS/XYbTApGsh3zcDn
 DdNDTvQOf6MNmLxLot+Ot++p0MEuZ/Sx4MxOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZsCCeB/n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gWGthh
 fuo+5eCYAX/hmYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE4Ng/NUZuN4cjyslbIE0V+
 N89Cj0XYUXW7w626OrTpuhEnM8vKozveYgYoHwllWifBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGE/BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FcrjeWzYYKIIbRmQ+0WvQWSm
 j/twF3fLT0WLvvA8SurqEmz07qncSTTHdh6+KeD3vJjhhuYz3YLBRsKWEGTpfi/g1S5HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceQT0sy
 0/MnN7zAzFrmKOaRGjb9bqOqz62fy8PIgcqYS4CUBtA+NL4oaktgR/VCNVuCqi4ipvyAz6Y/
 tyRhDI1i7NWiYsA0L+2uAiexTmtvZPOCAUy4207Q16Y0++wX6b9D6TA1LQRxawowFqxJrVZg
 EU5pg==
IronPort-HdrOrdr: A9a23:xFetjq/azUuT4MjXH8duk+DrI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HNoB1173HJYVoqMk3I+urwW5VoI0m8yXcd2+B4VotKNzOIhILHFuxfxLqn6yH8GiH46+5W3b
 ptfuxDEtHqZGIK6PoSmDPZLz7lq+P3l5xBQozlvhNQcT0=
X-Talos-CUID: =?us-ascii?q?9a23=3A1Ebptmk2CNcu6gu+JKXsbgjZVW3XOV7wnU7Xe0W?=
 =?us-ascii?q?yMlZGZJy5ElKz3YFpicU7zg=3D=3D?=
X-Talos-MUID: 9a23:Pr8M8QWvTBq8+Vrq/HzPxzteaexX2oKBJEwXtso+qufeDjMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.13,314,1732579200"; 
   d="scan'208";a="325569053"
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 25 Feb 2025 21:51:56 +0000
Received: from fedora.cisco.com (unknown [10.188.0.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPSA id 154BC18000294;
	Tue, 25 Feb 2025 21:51:54 +0000 (GMT)
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
Subject: [PATCH 1/2] scsi: fnic: Replace fnic->lock_flags with local flags
Date: Tue, 25 Feb 2025 13:51:45 -0800
Message-ID: <20250225215146.4937-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
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

Replace fnic->lock_flags with local variable for usage with spinlocks
in fdls_schedule_oxid_free_retry_work.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 3a41e92d5fd6..8843d9486dbb 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -308,23 +308,24 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 	struct fnic *fnic = iport->fnic;
 	struct reclaim_entry_s *reclaim_entry;
 	unsigned long delay_j = msecs_to_jiffies(OXID_RECLAIM_TOV(iport));
+	unsigned long flags;
 	int idx;
 
-	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 	for_each_set_bit(idx, oxid_pool->pending_schedule_free, FNIC_OXID_POOL_SZ) {
 
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 			"Schedule oxid free. oxid idx: %d\n", idx);
 
-		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		reclaim_entry = kzalloc(sizeof(*reclaim_entry), GFP_KERNEL);
-		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 		if (!reclaim_entry) {
 			schedule_delayed_work(&oxid_pool->schedule_oxid_free_retry,
 				msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_TIME));
-			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 			return;
 		}
 
@@ -339,7 +340,7 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 		}
 	}
 
-	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
 static bool fdls_is_oxid_fabric_req(uint16_t oxid)
-- 
2.47.1

