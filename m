Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387796;
	b=zwsbmqGO1bd3GkjOmWNOmbs6hw963zfoARS4+qom+xiGOuvt1jwSXNiPJnkmOLEYunf4
	 3soI8V4zDqV7HoXY0XaU8BRfuys5gHa0Ow+XzGnSN5KFDfi/yGhxzZXkwbQXAZsnfiznm
	 227uPtEgOfqlcbp/VIDV/iWEF7isRU8q3rsGOakB+AO3PTnGFDK3QHT2GyQ0HkXgdNCkG
	 X8ViR/1dpUWiop9GubA8+EIn01sofU78cjOIYhBrLYaG34J4aiBXAPIeP8kpCSo6h8SZl
	 hPXYd3qYtUiL5iwrzIdo6Mf39roD0AT+0f8lY6d+yByDpkwwp0kQHCmVGyyflwTcLZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387796;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:X-CMS-RootMailID:
	 References;
	bh=R8gjkRE1IcDx2bNy/NxQyJAvYqaX3SEZSKAM03VXgsI=;
	b=LRpVevXJFjXpQ8VI5xSSaz9FJRhCJeUJwU5inHFCeq0FXWTxHJnkTxkaivAlrlR/pWTA
	 VIsyPi9ikH1Jm/PUQNeM+0NhSkaLurPgxvxS8CaGTd/S0yh7Yjlzi5hGFUDsX6KHyQ7ya
	 Xus/GghlTzQ5huj2gJFxL7yH0IHiT32V6FwyEZQCU5uBCmVeus6rybYMLzj5or9OCXTxH
	 oIE8bg4z+ScU+E8Rp2BM3iW+TW2skb5PwbbTfrGppv830oETn+nLMHz9peFM4YELluHqy
	 zWz6TY9kg8IIA89s8+iocDQM10LejEoRRku+NbQvxT76cvu9YLmWW81bNQcu8QmFcjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nK39PK2S;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502E60A3806
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7502E60A3806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nK39PK2S
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261111090308epoutp02679a71ab433e75f6328e5499e00abcdc~m8i_pY6E42406324063epoutp02J
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 09:03:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261111090308epoutp02679a71ab433e75f6328e5499e00abcdc~m8i_pY6E42406324063epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794387788;
	bh=R8gjkRE1IcDx2bNy/NxQyJAvYqaX3SEZSKAM03VXgsI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=nK39PK2SjvmJWvgQo2YDf2ogxF0Hzx2/46Wpkaqdjc9juvkmn1azol27lhoVPuhDH
	 JwTJvREjueu/ihoI0Rf+2edT7bgQIlQj0pxjJR++c2Z1mURZKmVpljuUcisMKqqF+3
	 dhWLF+zSAoAOIOqZ22QPiw6AnEKogE3QI4OTDM7o=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261111090307epcas2p408e90b03f96a3c64fa2de1feeb3c04f7~m8i98urRf1585815858epcas2p4U;
	Wed, 11 Nov 2026 09:03:07 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jPcxR23mRz6B9mB; Wed, 11 Nov
	2026 09:03:07 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261111082303epcas2p180a7cf157dedd181634550630fe78df5~m7-_-JeMR0143401434epcas2p1N;
	Wed, 11 Nov 2026 08:23:03 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261111082303epsmtip2d30515ca4dbc97624c0bfea3ee3409ac~m7-_zm7nK1487814878epsmtip23;
	Wed, 11 Nov 2026 08:23:03 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v10 0/4] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during PM
Date: Wed, 11 Nov 2026 17:18:30 +0900
Message-Id: <2052256418.81794387787276.JavaMail.epsvc@epcpadp2new>
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
X-CMS-MailID: 20261111082303epcas2p180a7cf157dedd181634550630fe78df5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261111082303epcas2p180a7cf157dedd181634550630fe78df5
References: <CGME20261111082303epcas2p180a7cf157dedd181634550630fe78df5@epcas2p1.samsung.com>

If a LINERESET is reported and the hibern8 exit fails during system
resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the two recoveries are not serialized.

Patch 1 makes ufshcd_link_recovery() clear the saved errors like
ufshcd_reset_and_restore() does, so the error handler does not act on
errors that have already been recovered.

Patches 2 and 3 make ufshcd_wl_poweroff() behave like
ufshcd_wl_suspend() by sharing its implementation. In particular it now
holds host_sem, so that the error handler waits for it, and the release
of host_sem is balanced if hibernation is aborted.

Patch 4 restricts the early link recovery in ufshcd_err_handler(), which
does not hold host_sem, to runtime PM. For system PM and poweroff the
error handler now waits for host_sem, and for shutdown it stops.

The early link recovery is kept for runtime suspend and runtime resume.
During runtime resume it can still run concurrently with
__ufshcd_wl_resume(). Removing it there needs a closer look at the
deadlock that it avoids.

Changes in v10:
- Patch 1: no change.
- Patches 2 and 3 (were v9 patch 2): move the body of
  ufshcd_wl_suspend() into a helper that takes the PM operation and call
  it from ufshcd_wl_poweroff() too, as suggested by Bart Van Assche.
  This also handles a runtime suspended WLUN, sets hba->is_sys_suspended
  and converts a positive status into -EBUSY (Sashiko review of v9).
  Drop the Reviewed-by tag of Peter Wang because the code changed.
- Patch 4 (was v9 patch 3): make the check a static function in
  ufshcd.c named ufshcd_in_wl_rpm_callback(), and use READ_ONCE() and
  WRITE_ONCE() for hba->pm_op_in_progress, as suggested by Bart Van
  Assche. The Reviewed-by tag of Peter Wang is kept; the functional
  change is the same as in v9.

Changes in v9:
- Patch 1: add Reviewed-by: Bean Huo.
- Patch 2: if __ufshcd_wl_suspend() fails, release host_sem and return
  the error, as ufshcd_wl_suspend() does, so that the error handler does
  not block forever, as suggested by Peter Wang and Bart Van Assche.
- Patch 3: also require hba->pm_op_in_progress for the early link
  recovery, as suggested by Bean Huo and Bart Van Assche. The runtime
  status alone is also set during the block layer steps before and after
  the runtime PM callbacks (Sashiko review of v8).

Changes in v8:
- Patch 1: add Reviewed-by: Peter Wang.
- Patch 3: use the runtime PM status of the WLUN (RPM_SUSPENDING or
  RPM_RESUMING) instead of the new member hba->runtime_pm_in_progress, as
  suggested by Bart Van Assche.

Changes in v7:
- Patch 1: add Reviewed-by: Bart Van Assche.
- Hold host_sem in ufshcd_wl_poweroff() until ufshcd_wl_resume()
  releases it, instead of setting hba->shutting_down, as suggested by
  Bart Van Assche. This fixes the failure of ufs_mtk_system_suspend() and
  the state left behind when hibernation is aborted. Add a Fixes: tag
  and move the patch before the one that depends on it.
- Use READ_ONCE() and WRITE_ONCE() for hba->runtime_pm_in_progress, and
  describe the behavior change during shutdown in the commit message.

Changes in v6:
- Go back to a single flag instead of the system PM flag of v5, and set
  it in the runtime PM callbacks (Sashiko review of v5).
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
- Patch 2: reword the commit message only, no code change (Sashiko
  review).
- Patch 1: no change.

Changes in v2:
- Add patch 1. As pointed out by the Sashiko review, saved_err and
  saved_uic_err are still set after the resume path recovered the link,
  so with v1 alone ufshcd_err_handler() would run a redundant recovery
  once host_sem is released.
- Patch 2: describe the race and the system/runtime PM difference in
  the commit message, and add a comment.

v9: https://lore.kernel.org/linux-scsi/728258269.41794277203059.JavaMail.epsvc@epcpadp1new/
v8: https://lore.kernel.org/linux-scsi/1582071873.61794200283414.JavaMail.epsvc@epcpadp2new/
v7: https://lore.kernel.org/linux-scsi/cover.1793943246.git.hy50.seo@samsung.com/
v6: https://lore.kernel.org/linux-scsi/cover.1793931113.git.hy50.seo@samsung.com/
v5: https://lore.kernel.org/linux-scsi/cover.1793865172.git.hy50.seo@samsung.com/
v4: https://lore.kernel.org/linux-scsi/cover.1793851432.git.hy50.seo@samsung.com/
v3: https://lore.kernel.org/linux-scsi/cover.1792989286.git.hy50.seo@samsung.com/
v2: https://lore.kernel.org/linux-scsi/cover.1792755091.git.hy50.seo@samsung.com/

HOYOUNG_SEO (4):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery()
  scsi: ufs: core: Add a helper for the system suspend callbacks
  scsi: ufs: core: Make ufshcd_wl_poweroff() behave like
    ufshcd_wl_suspend()
  scsi: ufs: core: Limit early link recovery in the error handler to
    runtime PM

 drivers/ufs/core/ufshcd.c | 65 +++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 13 deletions(-)

-- 
2.34.1


