Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E99B4CA290;
	Thu,  6 Aug 2026 19:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044268; cv=pass; b=HJYKJhXxuojcEEAxmrwrgXwKiQKN2Er4RNCwoONfa8x+bty5SjjiZGEuKUSIINBjemTGKft5rNipSejbrNGEaftIf2fozPa9jq/skpIkx28+stOLGD/GEMBsenOldkh59iTk0pYXO7s6k0uFqQKwIirrsrlSMD2Gb2rfLxTQrEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044268; c=relaxed/simple;
	bh=mPiOuN91rK3XCdzE7LwpgNEWAFRw/M29CjFNw+wLpWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xztk1oyBjgbynLW3jzWd8LWcOQSyIeRi8+3he2klXe1WKOKeafN0RJ1I0llZYLRb6dVAVNQoBhTJeaHmfWVPWHyplKbM+nw+Nt4GhhXs5ZI9YFiNA8HLIpp5Z9JAJ+SXMp4FX8S4Pv5ZS92wa7B9xNyDXYGoV1l2aMLtb0FFGnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=bEqtlp2H; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="bEqtlp2H"
ARC-Seal: i=1; a=rsa-sha256; t=1786044243; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=c1AyH0bS5YF6uyE/MvEom7a0boqG64v8ZuxlezNtOf7cjBmdUR63jOWG2ONbZ4SIQBMj8x/MjinSlnb1epgwRo9gycwaOIUrDwEBFBY3gvJzFRD7MSTX0MJaAPb/KNY1C+7I6Q4ZXjSqXHCf+fzEfLo/HryXuKm+aFcHX2fSNHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044243; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qwA2JEJ7YTCewECkp2iVhinHMow8YkUY4BQcVqUpXXI=; 
	b=V4mIFkijctqNEa5C6gRoVwsFIJppkdRAyFkOfgJ/4YiDcCrdx0L5glF8dFIaI0uXeI7aFRRAGZ+I4S2N4LDMKrTuhSbi+jh034rHSCAk+P34nVjCR8q1Vcwtw/FAgZFOG7I1dhdPKUb4IZjT8SKnC0DhFNnFx8VYcmD50KfeMeo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044243;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qwA2JEJ7YTCewECkp2iVhinHMow8YkUY4BQcVqUpXXI=;
	b=bEqtlp2H9NVbnRyrr1QADvESOi1u8MHKZL/X1wcNc93mW+NQ1th7peH3nXitxBDX
	+/pT7rEx2xh7iauUsV9d/2HNiVioEQVBpC3Ot8ljIWhtfAyTVBI2aBlUVaXisYq2g1m
	TntPqNoOV30ZwHzks16HEj0omGuVoX0NX7JLJWzw=
Received: by mx.zoho.eu with SMTPS id 1786044241008227.7698100355734;
	Thu, 6 Aug 2026 21:24:01 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] scsi: elx: efct: free the request tag when the send frame WQE fails
Date: Thu,  6 Aug 2026 19:23:43 +0000
Message-ID: <20260806192345.328621-4-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_hw_send_frame() takes a request tag from the pool and then builds the
WQE. When sli_send_frame_wqe() fails it returns without giving the tag
back:

	ctx->wqcb = efct_hw_reqtag_alloc(hw, callback, arg);
	if (!ctx->wqcb) {
		efc_log_err(hw->os, "can't allocate request tag\n");
		return -ENOSPC;
	}
	...
	if (rc) {
		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
		return -EIO;
	}

Nothing is submitted, so the completion that would call
efct_hw_reqtag_free() never runs and the tag stays out of the pool. The
pool is bounded by the number of request tags allocated at init, so
repeated failures leave send frame without any.

Free the tag on that path. The efct_hw_wq_write() failure below is left
alone: it can return an error while this request is still queued on
wq->pending_list, and the tag is what a later completion would look the
context up by.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 6cc48fa3e656..db68516e8075 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -3009,6 +3009,7 @@ efct_hw_send_frame(struct efct_hw *hw, struct fc_frame_header *hdr,
 				ctx->wqcb->instance_index);
 	if (rc) {
 		efc_log_err(hw->os, "sli_send_frame_wqe failed: %d\n", rc);
+		efct_hw_reqtag_free(hw, ctx->wqcb);
 		return -EIO;
 	}
 
-- 
2.55.0

