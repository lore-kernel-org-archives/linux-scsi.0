Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992191;
	b=thyclzI9cbHQzcOdoUsml+Ny6EScwz3gAEivRO302LGVeXd7AXScFjKS+CbULa3aPGsu
	 njhoRlyZNAgbWQRipkxc3AW2bqln1LTn3i899h9PVvGYL9K5HeLF6YDIG9DTv0plOxpKP
	 WY2UzoorSRspZskOqqqHy2i2oiHo28yq5XobgRKdlhcdPdmM8HDV+izQSVWuBWBL8eB/l
	 usgmWaS485tpSZTsFfFZstyN8/0X7kah9eg9mNSO2atrT3lc05WxkKP5FHZisWVHBwvQn
	 mFBkYTjvtAPgZ7CAAbfHwUwK9+sood2LQf+E0vJAQmWtisfyv5OCTGa/WsoQyIPDyCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992191;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=ibNij6yZxrWsBHWu4Pq0Js8TIgxWW+Y0Ro4CWUNEGHg=;
	b=cb28u5PdjfID8AGymuztn+dn2JQIRfwzj6QJ72xZWGzaICIix/Jqe1sUUsDGjdoO0EKo
	 GuQ5/XVj7N/i7Z2Q/RFI1tfZzQ0m8QbHc4URoI9tXJfm7LgFasxmRBvFyLND86176nYB7
	 9FOIjFcO/kZhB9HSFeC80+JkRXx/T1JJMsNIggqEHtbzeDzVZM8U86SZufYVb2iubfYh7
	 f52ynaab7ui3Qm2eHWn5e4Rsmdmgw5suAUVqxenqN7J2BrYgRigCAuHqT22BYg4dmReht
	 tx+kz1bzj6PjPU22j2lkybotDb7+L9T+n0LoPPaTOsF+/fQHXXm+BmJohmi+vnEmSXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=oDncGNEG;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11B9606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 05:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A11B9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=oDncGNEG
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261026052307epoutp049040af9891d806962861a5c80efe5e18~h-OULricU2743327433epoutp04K
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 05:23:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261026052307epoutp049040af9891d806962861a5c80efe5e18~h-OULricU2743327433epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792992187;
	bh=ibNij6yZxrWsBHWu4Pq0Js8TIgxWW+Y0Ro4CWUNEGHg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=oDncGNEGdsZFIrei2W4IZtUsMHsBZ4grRaJbFIcqKLd+0qe7xoXCovZ0VdrWW0FVf
	 fWXVE2yiyjoyuZdSFgT1Q5U419wa6ulTP/7LBpV8wWCxmDaSWH/Ei+p6QGeZb+rRXe
	 KKLYhJzqnKMxXWIMJ14ooOwib1WRVYGw2JmJ8GEo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261026052307epcas2p3480f9f1f127bce8b4a909278415d2d2b~h-OT36iz71320013200epcas2p3M;
	Mon, 26 Oct 2026 05:23:07 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.202]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jChpy5hP0z6B9m5; Mon, 26 Oct
	2026 05:23:06 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261026052306epcas2p166bb6661beb7b60ba1c294034103469e~h-OTBPVT70384703847epcas2p1x;
	Mon, 26 Oct 2026 05:23:06 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261026052306epsmtip123a71c4e105db4c972be2d4da86cb7ae~h-OS8mAb61606016060epsmtip1D;
	Mon, 26 Oct 2026 05:23:06 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v1] scsi: ufs: Change the error check sequence for auto
 hibern8
Date: Mon, 26 Oct 2026 14:18:51 +0900
Message-Id: <20261026051851.1845934-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261026052306epcas2p166bb6661beb7b60ba1c294034103469e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261026052306epcas2p166bb6661beb7b60ba1c294034103469e
References: <CGME20261026052306epcas2p166bb6661beb7b60ba1c294034103469e@epcas2p1.samsung.com>

Auto-hibern8 enter and exit are performed by the host controller without
a UIC command, and the auto-hibern8 idle timer only runs while no UIC
command is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is
therefore usually reported while hba->active_uic_cmd is NULL.

Since commit fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl()
easier to analyze"), ufshcd_uic_cmd_compl() returns early when
hba->active_uic_cmd is NULL, before ufshcd_is_auto_hibern8_error() is
called. Such auto-hibern8 errors are no longer recorded in hba->errors,
so ufshcd_check_errors() is not called for them and the error handler is
not scheduled.

Check for auto-hibern8 errors before checking for an active UIC command,
as was done before that commit, but keep returning early when there is
no active UIC command so that a NULL cmd is never dereferenced. Only
report the missing UIC command if no auto-hibern8 error was found.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze")
---
Changes in v3:
 - Check auto-hibern8 errors before the NULL check again, so that errors
   reported while a non-hibernate UIC command is active are still
   detected (Sashiko review).
 - Return early when no UIC command is active instead of falling
   through, to avoid dereferencing a NULL cmd (Sashiko review).
 - Add Fixes tag, reword subject and commit message.

Changes in v2:
 - Check UFSHCD_UIC_HIBERN8_MASK for auto-hibern8 only when cmd is NULL.

v2: https://lore.kernel.org/linux-scsi/20261022074249.3098100-1-hy50.seo@samsung.com/

Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d085d394858f..4541776e8d38 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5941,16 +5941,22 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	struct uic_command *cmd;
 
 	guard(spinlock_irqsave)(&hba->host->host_lock);
+
+	/*
+	 * Auto-hibern8 is performed without a UIC command, so check for
+	 * auto-hibern8 errors before checking for an active UIC command.
+	 */
+	if (ufshcd_is_auto_hibern8_error(hba, intr_status)) {
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	cmd = hba->active_uic_cmd;
 	if (!cmd) {
-		dev_err(hba->dev,
-			"No active UIC command. Maybe a timeout occurred?\n");
+		if (!(hba->errors & UFSHCD_UIC_HIBERN8_MASK))
+			dev_err(hba->dev,
+				"No active UIC command. Maybe a timeout occurred?\n");
 		return retval;
 	}
 
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		/*
 		 * Store the UIC command result in the lowest byte of
-- 
2.34.1

