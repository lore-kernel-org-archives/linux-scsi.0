Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852447;
	b=EIHsA6DR3SoCjxE2r533+5oeWOtKm2wIIVvwMKmMKlMTWQDTD03LI8Fa/xH0+2VfwmIH
	 zDNUXgsLCtMKLvKqw45mKZc7pz693nRynZS2edGG5sV5TmEhetK+FQfiBZo+MOun+jLrw
	 wzXK4Yc4YFyUxwq1h4hFCZWNWgApoQzu+gbxueOgOqjzxcV4WTKEmkk9ybV3fKTz3AWng
	 gOzawz528pZ/2Uadk6dDPI/xOkJc1MbUuEqFMZTTBNFS0B7SMxbeHkpXyBhMI9th8on66
	 TdC5CyZHXB4Ornz80kD/8plHiat2NItSUAPYQs2OvoeGLMcrYEDbDCcP35zQE0d9rtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852447;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=slxoBHRYhaDWuQFRl3gCo2MDW72ELcaKt7lNPJR6Efk=;
	b=4Nx3x7y1WUSJWhZ49NvwfAZzAxn2YGgeBOWsaiaF7UiYKdp0fVo2H+za5ODfxTmIHRes
	 CBAtXHGBxJ443TSaB8AafPyH69lxQUp1xNGS463qH+bxc5KydcFmH8x0DKiNwtSSz/4D/
	 X/GYCf6kpEno1lPP0b1FocWPa80zhZ1c+hgFM2M0CSVLvBRDUn8Yjf22bcX8DmsHtuImx
	 3DMe0FpLTWcYu1f3uf8mAmtdfxqQKMH8+tbljBrGrNO3X/+0LxKws2qrffR8X1yCaZouW
	 KJSC9yMq7pxPCoYZSy9wI8Q6wZO7EcCjydIlM78bOY+Z9Pe8TORTBCuhh3QkNZ4YaIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=iwfUSbk7;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385FD606A33F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 385FD606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=iwfUSbk7
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261105042042epoutp0384e612ddae329dd20bda0947b13b6125~lC0qz4jHo2143021430epoutp03S
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:20:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261105042042epoutp0384e612ddae329dd20bda0947b13b6125~lC0qz4jHo2143021430epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793852442;
	bh=slxoBHRYhaDWuQFRl3gCo2MDW72ELcaKt7lNPJR6Efk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=iwfUSbk7ovbZ0HKDMP4Er6tFDzWFJqfPB16HqN3b2vkJtd2PjW70k/QoKbVR9Xcxa
	 EbneQk1O5gs/dFAc8aUUJjsh89pAyllpBae4MBagBPk+FmhArH8j9I4/R05jPoED11
	 4fDsYwpzydsIBBCAKi9afR/KkIU5S3H/beGUSFUw=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105042041epcas2p1d8577504c1d3e979743d325a4548ef3d~lC0qOsSII1238412384epcas2p1g;
	Thu,  5 Nov 2026 04:20:41 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.203]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jKpyK0hN7z3hhTF; Thu,  5 Nov
	2026 04:20:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261105042040epcas2p2af9610d36007ff1e247c8131aeb3edfc~lC0paTTrx2717227172epcas2p2P;
	Thu,  5 Nov 2026 04:20:40 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261105042040epsmtip1b7167f3bf268af48629fa3526988dc40~lC0pTSD5B2504825048epsmtip1b;
	Thu,  5 Nov 2026 04:20:40 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v4 0/2] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during PM
Date: Thu,  5 Nov 2026 13:16:15 +0900
Message-Id: <cover.1793851432.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261105042040epcas2p2af9610d36007ff1e247c8131aeb3edfc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105042040epcas2p2af9610d36007ff1e247c8131aeb3edfc
References: <CGME20261105042040epcas2p2af9610d36007ff1e247c8131aeb3edfc@epcas2p2.samsung.com>

If a LINERESET is reported and the hibern8 exit fails during system
resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the two recoveries are not serialized.

Patch 1 makes ufshcd_link_recovery() clear the saved errors like
ufshcd_reset_and_restore() does, so the error handler does not act on
errors that have already been recovered.

Patch 2 restricts the early link recovery in ufshcd_err_handler(), which
does not hold host_sem, to runtime PM. For system PM the error handler
now waits for host_sem, and for shutdown it stops.

The early link recovery is kept for runtime suspend and runtime resume.
During runtime resume it can still run concurrently with
__ufshcd_wl_resume(). Removing it there needs a closer look at the
deadlock that it avoids.

Changes in v4 (as suggested by Bart Van Assche):
- Replace the is_sys_suspended check of v3 patch 2 with a check for
  runtime PM, which also covers system suspend failure and shutdown.
- Add Fixes: tags.
- Do not serialize ufshcd_link_recovery() with a mutex: it calls
  ufshcd_probe_hba(), and a device command timing out inside it ends up
  in ufshcd_eh_timed_out(), which calls ufshcd_link_recovery() again.

Changes in v3:
- Patch 2: reword the commit message only, no code change. The error
  handler does not always run a full recovery after a failed system
  resume; it stops according to ufshcd_err_handling_should_stop() (e.g.
  in UFSHCD_STATE_ERROR). Describe this behavior and refer to the commit
  that added the early link recovery (Sashiko review).
- Patch 1: no change.

Changes in v2:
- Add patch 1. As pointed out by the Sashiko review, saved_err and
  saved_uic_err are still set after the resume path recovered the link,
  so with v1 alone ufshcd_err_handler() would run a redundant recovery
  once host_sem is released.
- Patch 2: describe the race and the system/runtime PM difference in
  the commit message, and add a comment.

v3: https://lore.kernel.org/linux-scsi/cover.1792989286.git.hy50.seo@samsung.com/
v2: https://lore.kernel.org/linux-scsi/cover.1792755091.git.hy50.seo@samsung.com/

HOYOUNG SEO (2):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery
  scsi: ufs: core: Limit early link recovery in the error handler to
    runtime PM

 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++++----
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 27 insertions(+), 4 deletions(-)

-- 
2.34.1

