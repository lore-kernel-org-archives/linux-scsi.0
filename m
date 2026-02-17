Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84D313555;
	Tue, 17 Feb 2026 22:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368093; cv=none; b=Jv7uzEJtWHasrHmwKqs08RggFuiNN/Cp78v70yxp5KZhQB4AZIHJlPgsCD8C4T0Re7iG6/sHrx9zlvwYTG6XckJrlhMZs4k87sy1zZhUlpxI1HDyf7rOW57TEKZqQqotAMiPL0RhGnKNedJjNDvOYMY8MaG+cDVs3KQKRWDi+Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368093; c=relaxed/simple;
	bh=6gMN/LTigEPpwMDUTPkx1Hrj/7uxu31YmRRLRXWT8Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1Fyo/kWcMdXKQKxrnlFt3DKyqrhIFKU/3/0adMdR2cxiGD+ew4hqbriPP/9WhLxesMXigKES3byd2zXnO/7iNyqAJB+GhUnR6rZNcTLduW8kV/T902scd2CfC3I464tuYzYJpJjsOgjT8B6HTm+8kJb3B6G/Pzp96K9MfNvC3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=EEV6hO5Q; arc=none smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="EEV6hO5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2098; q=dns/txt;
  s=iport01; t=1771368092; x=1772577692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3z7Zx4sDp8j3c555zicnlmyfdyukSSaDfixdzHmw4H0=;
  b=EEV6hO5QZNcqG6nPYmM7SiyzN3zRVi1vRZa59vyYQMCNChtmOSCRjS2T
   UB2FjuGLS8OqHvu4H6+QTNOquYTFK1KLs02FHn+yGbpBDAOooUyE5Qvsr
   cEaTat+N4BMlGrMAke2xaKG/Ub7rgEGsGt+GDpaJ1PPOELXGPq4Bv+e2i
   6MI8guvs1omhWXLG3RTT5IDCvmDzEj5VhLyx7XTOpF9nHYJDOsXqtcV0B
   qKrXXR86ltlzC1IwIEdGQBzWZrGCtpkq7Wr3NUZPuGjq9J34K7Gp3B+DV
   FiEqxkD5+vnbzHw9C/sl7YMbLcFMpAjwWEteLiTtqbMry/hX1JNy0JHaP
   w==;
X-CSE-ConnectionGUID: M3IzeBphTeig3f/7iN2T7A==
X-CSE-MsgGUID: qAKWLObyROKT6RSTkPavJg==
X-IPAS-Result: =?us-ascii?q?A0A7BgCL7ZRp/5X/Ja1aglmCSA+BT0MZMJQqoD6Bfw8BA?=
 =?us-ascii?q?QEPUQQBAYUHAo0fAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDrXmBeTOBAd4+gWQBCxQBgTiNV?=
 =?us-ascii?q?XSEeicVBoFJRIR9gVKDPoV3BIMwk2FIgR4DWSwBVRMNCgsHBYFmAzUSKhVuM?=
 =?us-ascii?q?h2BIz4XgQsbBwWHcw+JBXhugR+BDAMLGA1IESw3FBsEPm4HjjpBgjOBDoJAk?=
 =?us-ascii?q?0aSRoE1n1mEJqFYGjOqay6YWKlBgWg8gVkzGggbFYMiUhkPji0WxFYlMjwCB?=
 =?us-ascii?q?wsBAQMJk2cBAQ?=
IronPort-Data: A9a23:VwOQOKC9kxvveRVW/9Xiw5YqxClBgxIJ4kV8jS/XYbTApG4ghTMHy
 TRKXWHTaauJM2rwe49/Poi280gHvJGEmNZqOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jWmthh
 fuo+5eBYAX8hGYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE5q5PHkwcJY0k9+d4Wm8Jq
 v0+cgxSR0XW7w626OrTpuhEnM8vKozveYgYoHwllGufBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGY+BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FIvgeW9YIuJJ7RmQ+1Mt2Wng
 kXM7l7eIS1EDuejygKM7FCj07qncSTTHdh6+KeD3v5jmlC7xWEJDhASE1yhrpGRhke4HdlWM
 VQZ/DYjt4A29UqiVN67WAe3yFaGsxwWc95RFfAqrgCHz+zf5APxLm0NVCJAbpo+udM7Xycn0
 HeOhdriATEpu7qQIVqf87qSoDyyOAAPIGMCbDNCRgwAi/H5rZ8+lAnnVNtvEKepyNbyHFnYx
 zyXqiM3gZ0IkNUGka68+DjvhzOqu4iMTQMv4AjTdnyq4xk/Z4O/YYGsr1/B4p5oKIefU0nEp
 3MfmuCA4+0US5KAjiqARKMKBr7B2hqeGCfXjVgqG9wq8C6gvif5O4tR+zp5YkxuN67oZAPUX
 aMagisJjLc7AZdgRfUfj16ZYyjy8ZXdKA==
IronPort-HdrOrdr: A9a23:76t2jKzVP5wBJ/j2iZxLKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:CCwtzmE5628Y5RUtqmJCr28GF+o9ckHQzXiLLQjnCEAzdOK8HAo=
X-Talos-MUID: =?us-ascii?q?9a23=3AVUdxEw3/FpjvNNb/0GlEgNvg2jUj+o2NN2Qqm4Q?=
 =?us-ascii?q?8nOq4axZLBzSlhSqVTdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,297,1763424000"; 
   d="scan'208";a="669588945"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 22:40:23 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id EB67C1800031A;
	Tue, 17 Feb 2026 22:40:21 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	aeasi@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>,
	Lee Duncan <lduncan@suse.com>
Subject: [PATCH 2/5] scsi: fnic: Do not use GFP_ZERO for mempools
Date: Tue, 17 Feb 2026 14:39:40 -0800
Message-ID: <20260217223943.7938-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.109.174, [10.188.109.174]
X-Outbound-Node: rcdn-l-core-12.cisco.com

One cannot use the GFP_ZERO flag for mempool allocation, so use
memset() instead.

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_fcs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index f6d6ad64983f..2b543d570051 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -519,13 +519,13 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	frame_elem = mempool_alloc(fnic->frame_elem_pool,
-					GFP_ATOMIC | __GFP_ZERO);
+	frame_elem = mempool_alloc(fnic->frame_elem_pool, GFP_ATOMIC);
 	if (!frame_elem) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Failed to allocate memory for frame elem");
 		goto drop;
 	}
+	memset(frame_elem, 0, sizeof(struct fnic_frame_list));
 	frame_elem->fp = fp;
 	frame_elem->rx_ethhdr_stripped = ethhdr_stripped;
 	frame_elem->frame_len = bytes_written;
@@ -704,13 +704,13 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, int frame_size,
 	 */
 	if ((fnic->state != FNIC_IN_FC_MODE)
 		&& (fnic->state != FNIC_IN_ETH_MODE)) {
-		frame_elem = mempool_alloc(fnic->frame_elem_pool,
-						GFP_ATOMIC | __GFP_ZERO);
+		frame_elem = mempool_alloc(fnic->frame_elem_pool, GFP_ATOMIC);
 		if (!frame_elem) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				 "Failed to allocate memory for frame elem");
 			return -ENOMEM;
 		}
+		memset(frame_elem, 0, sizeof(struct fnic_frame_list));
 
 		FNIC_FCS_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
 			"Queueing FC frame: sid/did/type/oxid = 0x%x/0x%x/0x%x/0x%x\n",
-- 
2.47.1

