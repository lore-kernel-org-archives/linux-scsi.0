Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794200288;
	b=Q8zSJFxMlGHauwOWLBkqfcA0txZ2RJB+OXn7kCto/aTv1pciJ8qVBQ4qfJ8VE7Ey0CIi
	 WuIPLaWWpNmnPYgCAlaUDELaFDxBfDZTKupxvlc2jYsZ9xbAGaPPNALatW4peuXMHKWWX
	 vRWdsMU1pwshza8Yz3LNPFeHsoXpyZurcTs1q4xtFhmQDoOTKj+wG6q9rWSPVJyyCyAs4
	 rx6xWsyB41aV7WBdA54Rm0cFSALWAOxQkx5hvN836zhZkc5vhLdKtN5PI3Gux4ro1uZy3
	 1XejzeJv36crJq5Lff0yXtRbASrzMHsig68IAEk4Y/ZRj/wijsE9z+wXK91eh9fclgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794200288;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:X-Hop-Count:
	 X-CMS-RootMailID:References;
	bh=O2XanF82UjSIAS7PEuwwcfkX19Dhk35pqkpHuLENn0I=;
	b=Mz9bxntRsiODMEJr5XJFmZUWG9tFlvsSSc62B4CvRQckEbI7rCTVYTiHuWtvV3TFKzun
	 MfR3FI4dT64/qRYs/sgVz9BKn/8/0re00UpkJ98KPZiHNZlrGaMNZwUKYg6jA4H976FdY
	 zUWGduuCCICLb9lDQv4Wq9lwdxGezzbpRqRiDJPYVsGm2J3BurDepLbmP2fdjck10ZfHg
	 ou1j43vTjcJ62IWLv80dCkRb/rMZBJgQNaJVnKRAioyoU/1hPX4UZzT9qqQtmYoyAiF95
	 ThVZfA1IQln9TiX77aaN37Z8hb1sdOIN3Ww7PK77iQGcSz9qyhZ9cwdhhylyv1BnWdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=oFdwjmxL;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693C606A323
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C693C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=oFdwjmxL
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261109045804epoutp03586e05625643fb98917b3d69d8d49eee~mR6cC6Efc1271012710epoutp03A
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 04:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261109045804epoutp03586e05625643fb98917b3d69d8d49eee~mR6cC6Efc1271012710epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794200284;
	bh=O2XanF82UjSIAS7PEuwwcfkX19Dhk35pqkpHuLENn0I=;
	h=From:To:Cc:Subject:Date:References:From;
	b=oFdwjmxLt66T7h1tNqymxh/JCeUibo/Dh8Uiidw10eTOFdjXJcctwyeZOBr+iAfal
	 Wxr/KciCeMKKpVeIukRW4g6Be1KHRB8C3i/51mDrbuDIMnetDpXxLgceIZGssKMq2N
	 ZOwp/5LZXQ5YBqN2DR6r5trTh7wXHBtBRQR1b8wY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261109045803epcas2p1ed91a2070bd39532ec846a1903c4b79f~mR6bXTSPd1665916659epcas2p1I;
	Mon,  9 Nov 2026 04:58:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jNHbb315Cz3hhTD; Mon,  9 Nov
	2026 04:58:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261109041344epcas2p4b70fa3981f37f910e0363e35d465e144~mRTvZG94O1297712977epcas2p4N;
	Mon,  9 Nov 2026 04:13:44 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261109041344epsmtip11a8268715c7903a0ce684c2e3bb87a1d~mRTvT1P5A2715127151epsmtip1D;
	Mon,  9 Nov 2026 04:13:44 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v8 0/3] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during PM
Date: Mon,  9 Nov 2026 13:09:14 +0900
Message-Id: <1582071873.61794200283414.JavaMail.epsvc@epcpadp2new>
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
X-CMS-MailID: 20261109041344epcas2p4b70fa3981f37f910e0363e35d465e144
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20261109041344epcas2p4b70fa3981f37f910e0363e35d465e144
References: <CGME20261109041344epcas2p4b70fa3981f37f910e0363e35d465e144@epcas2p4.samsung.com>

If a LINERESET is reported and the hibern8 exit fails during system
resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the two recoveries are not serialized.

Patch 1 makes ufshcd_link_recovery() clear the saved errors like
ufshcd_reset_and_restore() does, so the error handler does not act on
errors that have already been recovered.

Patch 2 makes ufshcd_wl_poweroff() hold host_sem like
ufshcd_wl_suspend() does, so that the error handler waits for it, and
fixes the unbalanced release of host_sem if hibernation is aborted.

Patch 3 restricts the early link recovery in ufshcd_err_handler(), which
does not hold host_sem, to runtime PM. For system PM and poweroff the
error handler now waits for host_sem, and for shutdown it stops.

The early link recovery is kept for runtime suspend and runtime resume.
During runtime resume it can still run concurrently with
__ufshcd_wl_resume(). Removing it there needs a closer look at the
deadlock that it avoids.

Changes in v8:
- Patch 1: add Reviewed-by: Peter Wang.
- Patch 2: add Reviewed-by: Bart Van Assche. No other change.
- Patch 3: use the runtime PM status of the WLUN (RPM_SUSPENDING or
  RPM_RESUMING) instead of the new member hba->runtime_pm_in_progress, as
  suggested by Bart Van Assche.

Changes in v7:
- Patch 1: add Reviewed-by: Bart Van Assche.
- Patch 2 (was v6 patch 3): hold host_sem in ufshcd_wl_poweroff() until
  ufshcd_wl_resume() releases it, instead of setting hba->shutting_down,
  as suggested by Bart Van Assche. This fixes the failure of
  ufs_mtk_system_suspend() and the state left behind when hibernation is
  aborted, and the unbalanced release of host_sem. Add a Fixes: tag and
  move the patch before the one that depends on it, so that the series
  stays bisectable.
- Patch 3 (was v6 patch 2): use READ_ONCE() and WRITE_ONCE() for
  hba->runtime_pm_in_progress, and describe the behavior change during
  shutdown in the commit message.

Changes in v6:
- Go back to a single flag instead of the system PM flag of v5, and set
  it in the runtime PM callbacks. The error handler no longer reads two
  variables that are not updated atomically (Sashiko review of v5).
- Add a patch that sets hba->shutting_down in ufshcd_wl_poweroff()
  (Sashiko review of v4).

Changes in v5:
- Patch 2: track system PM (hba->system_pm_in_progress) instead of
  runtime PM, so that the early link recovery is only skipped where
  host_sem is held.

Changes in v4 (as suggested by Bart Van Assche):
- Replace the is_sys_suspended check of v3 patch 2 with a flag set in
  __ufshcd_wl_suspend() and __ufshcd_wl_resume(), which also covers a
  system suspend failure.
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

v7: https://lore.kernel.org/linux-scsi/cover.1793943246.git.hy50.seo@samsung.com/
v6: https://lore.kernel.org/linux-scsi/cover.1793931113.git.hy50.seo@samsung.com/
v5: https://lore.kernel.org/linux-scsi/cover.1793865172.git.hy50.seo@samsung.com/
v4: https://lore.kernel.org/linux-scsi/cover.1793851432.git.hy50.seo@samsung.com/
v3: https://lore.kernel.org/linux-scsi/cover.1792989286.git.hy50.seo@samsung.com/
v2: https://lore.kernel.org/linux-scsi/cover.1792755091.git.hy50.seo@samsung.com/

HOYOUNG SEO (3):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery()
  scsi: ufs: core: Hold host_sem in ufshcd_wl_poweroff()
  scsi: ufs: core: Limit early link recovery in the error handler to
    runtime PM

 drivers/ufs/core/ufshcd-priv.h | 13 +++++++++++++
 drivers/ufs/core/ufshcd.c      | 24 ++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

-- 
2.34.1


