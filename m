Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C486136;
	Tue, 24 Jun 2025 03:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750735679; cv=none; b=HRE+1cbgpm75FYLQXOO8FMAg5H3Zmx8p8ytLbhlrnW5BaCvTg6p+kkyauFbqFXnHELMeh88XFBx+d7SdjoQWrIK4Z5oEOyi395yQ97YyPNcJgp7zJrLAI/77RLN6qyVdsk3vOG2iAiBP/CWlo95haiBjTrHK4riCdCrgNFwsMlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750735679; c=relaxed/simple;
	bh=RLEIRSjrgC2GMjEJKM5fjLmfrTS5grac6NjsH/mjjro=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=V/EADStwVKi82Yncb0iyg6R/a0Wkes796UAfGFbje+TzyQGSnK9WA6/EKnw2n9VeaAq5K7I327sI4PEUGtIMJJ/4O4xqWNi5d5oUriUnQ1yqQTVsbj88SvD9eocaxlV1jR6q9GPlFbSs6cxCj9eEFRGzm/JbSp0widxPtA2poTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=GUmuRjd3; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="GUmuRjd3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1750735665; bh=nmo+J8zIdQuvgWJj2E1ulnfVG/wxLiRfXsCfFWon/8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUmuRjd3nhWVu98EGzVnWs8lQ7OfevZtcjTX1f/3j0jXUUz5C1eX/32f1GVZqeKv2
	 xasKVo9aUyrevSNQv8at2AaBfcFpSOUXcjJg4XKEyTE9qLbNNBniA6AxcjinR0ItUB
	 jRtBB3eUqNc1zemnBwL1+fldqiJZhYgbX8DYNa7k=
Received: from VM-222-126-tencentos.localdomain ([14.22.11.162])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 4DA38C3D; Tue, 24 Jun 2025 11:19:26 +0800
X-QQ-mid: xmsmtpt1750735166tvilzjywo
Message-ID: <tencent_DB9950A0D2FA71F96EE7FDDF92F6DE959A09@qq.com>
X-QQ-XMAILINFO: NxPU7wltX8BLEPcb7EL3STuoaK9zZ8SLjiZxpVXaoqfSsYP5NNnfj5d7L6+5EP
	 0JAlui+cWm8bjdODdrO4lC6DEylgK7uH1t+GJfICnGSfcGbg3DQgyKpGhZHrhPG45qGg4gfwdfaC
	 9Efd+JgZ2/6P/5yQl3Fpl+okax/Pf7EwKsr9Wh7FbaGSKWBrBtoqGuqI5X3q0p79NYqh9pnWyHOG
	 ITf7pXjZirDCBdMFuR6WX2IKIK2Irs2dEYsnMZaG5sh0uCEhfAUB01HN/GHhfN6l5iO+Y4bQgkiY
	 GLAFoTF/4xHUjoQ0jnVtvgAd2yXS17zScsFoOj7PPJC6yczEvTqcm1H+GEu3FUbmBxLDgCiNLQkV
	 C5KTG+fpmSKfPfscB++MuwITDC/JUVuktOefuiLupBhE+8BIJ0hl2xFZRMmlSz4XiqO8CipksgU7
	 tIxA+m/e2oh5aYgkIXgADERU9qJxenIB29gzgZfGqcPb9Z21i+4VxgyxmnWf5Aaxp0yZopwPveWd
	 4yDZC/dh9yPbV8/vdujxpB3la924zKXslpOx/BeHPg7PVHwNbt2Ca5mF7XdlNsl/KKPpwzCRFguF
	 oWsC+yXeXZqZ9jj+VyLWY7/nLT1d/KWA56Y4FowNwO4j3la9Ozi5iMHyVDUsBGAamXtEO/I+/G3p
	 hk3S2KWghlKTvMxG52u/DwGDnaIuPFVHlbD6jrCSwop/vBx9rLRHW+eqjrrUL4xvEfa+jhcfglQo
	 U8rq9FXhvZUG8aa0U0Sauq1uYJGkDbl6XFIaHFQ8Hz5m/31ogpHQ293cF1XUJwmMnh7fnv5TS3DF
	 GAlZ4zo5TAGrlvqipm7WNB6jNIhBz8S1Y+qoItoN61eBg4YFRsPDH+PqwjVFqQMZmkaFGEFQ2ym8
	 bwLLX9PPVCCN/i2TvqNCo8HABcbr8WmDv4tWuknQLtYpgfK37wymOhJn7NxZNoO9yDSd6Xty3k65
	 0esN+oGR5WxP9xCyz1sacHhJefWFGmi43g1kgnB5Lmm9yuO5Zu3bdpnTZgSwleifBjz1MB7Pl7n0
	 jmSaWxNPMLTr30bUlP9IGsHXBWJ24=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: jackysliu <1972843537@qq.com>
To: lkp@intel.com
Cc: 1972843537@qq.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	jhasan@marvell.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	oe-kbuild-all@lists.linux.dev,
	skashyap@marvell.com
Subject: [PATCH] scsi: qedf: fix inconsistent indenting warning 
Date: Tue, 24 Jun 2025 11:19:19 +0800
X-OQ-MSGID: <20250624031919.2207851-1-1972843537@qq.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <202506240340.fv6cXpyc-lkp@intel.com>
References: <202506240340.fv6cXpyc-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix below inconsistent indenting smatch warning.

New smatch warnings:
drivers/scsi/qedf/qedf_main.c:2814 qedf_prepare_sb() warn: inconsistent
indenting

Old smatch warnings:
drivers/scsi/qedf/qedf_main.c:2816 qedf_prepare_sb() warn: inconsistent indenting

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506240340.fv6cXpyc-lkp@intel.com/

Signed-off-by: jackysliu <1972843537@qq.com>
---
 drivers/scsi/qedf/qedf_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 8767d9de819f..b46fc510557b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2810,11 +2810,11 @@ static int qedf_prepare_sb(struct qedf_ctx *qedf)
 	}
 err:
 for (int i = 0; i < id; i++) {
-fp = &qedf->fp_array[i];
-if (fp->sb_info) {
-qedf_free_sb(qedf, fp->sb_info);
-kfree(fp->sb_info);
-fp->sb_info = NULL;
+	fp = &qedf->fp_array[i];
+	if (fp->sb_info) {
+		qedf_free_sb(qedf, fp->sb_info);
+		kfree(fp->sb_info);
+	fp->sb_info = NULL;
 }
 }
 kfree(qedf->fp_array);
-- 
2.43.5

