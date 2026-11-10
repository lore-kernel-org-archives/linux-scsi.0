Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794277212;
	b=H6USU47cVKaz7rD9jDLrF3yYeDlRkQN2tpDbqALBMiaXBtv9i+rpP1eYL8sxJqsZKqaA
	 mV5I7U8jeMZ0GX0yFzW6vKflCQMZ8pym4H0lmioJ2JbXLkld7RiKIO8I2xK/GDfpNr5t0
	 bJ8ka9dPuOPjpTPXNhExLjwj1BSbs+mP+H5sNK3ZKF02csObzxu0XhXpb1RBCD+MmxFHN
	 lHywuDxiBGIlBJBLJ0j8HQLnC4qwLisdFAMHlIE40qM+EOxS5UQXfqZemc0oD/FNhegVD
	 W2Ca1KMKy0j9zcImIv0YYKm2SDrna6JlSC/plw0laHs7SofH6fYXfpUuIeENJjzl11g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794277212;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-Hop-Count:X-CMS-RootMailID:
	 References;
	bh=LM5Ro/28169MYrD+qPLx9oWh/Gmkt20lKaXjm4OmN3Q=;
	b=p5ih6CPXdLHF27MhGTTPHfEF69vBh0Tx8ThDCOLdhV6uq9bhlv2otF3qgFuAZbPstxM4
	 7kTxFW0wZhqiLReKacgvEqWqn9hr9yWi5GmNBH/e9xQGxj3dNY1L3zTPU+pVOC8E18bUw
	 lMqVH/0R/py2d/03cTgdeQrlxEo5XxRFmLkukIVaFkmkz/RlaHOQCj5f2Itk3G6zT+wBB
	 m8SHq7Mx86V3IZ7guvmlVsqvOPdmcevOga4RkYjCGrIcZjBqYEWLcAP3L2GyQI/3aS2X9
	 uPaYnbIMIy/T8O95XnO+9dTnQB7bM4jRKaVXXjEsJKdHwafW2zD2O2EsSAbz0fDsxzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=W45wB2gy;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B660A2600
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 919B660A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=W45wB2gy
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261110022003epoutp01722af7a6beda808fe18039af5cd99806~mjZw8IewA1236612366epoutp01a
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261110022003epoutp01722af7a6beda808fe18039af5cd99806~mjZw8IewA1236612366epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794277203;
	bh=LM5Ro/28169MYrD+qPLx9oWh/Gmkt20lKaXjm4OmN3Q=;
	h=From:To:Cc:Subject:Date:References:From;
	b=W45wB2gyGvL7pbbPpCLQmyfsfna4rx8rzZabBqSJCk1Q42pkiRyPxgNwron86WG0+
	 Ij7K3o0xzAjGIIGPJN1erP/JcZN+gj8hrYLgfzR5r1iCit7qmqw5sCCHMeuZiWjbrk
	 CJ22JtGaVMyJZdSWawC/pS+J6vM7ZvQH7dKpc1Ow=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261110022003epcas2p4b7216202d17ccaef7bf36ad02c0b8bbd~mjZwXQ-T10470504705epcas2p4K;
	Tue, 10 Nov 2026 02:20:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jNr2q0Rjjz2SSKr; Tue, 10 Nov
	2026 02:20:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261110020744epcas2p4576919ef0e67453825490cf76da0b888~mjPAb0dsr2516025160epcas2p4B;
	Tue, 10 Nov 2026 02:07:44 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261110020744epsmtip157a6112e405619d5919fad4975fb51ff~mjPAOudb50057900579epsmtip1B;
	Tue, 10 Nov 2026 02:07:44 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, peter.wang@mediatek.com, alim.akhtar@samsung.com,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgsproxy1@samsung.com,
	h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v9 0/3] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during PM
Date: Tue, 10 Nov 2026 11:03:12 +0900
Message-Id: <728258269.41794277203059.JavaMail.epsvc@epcpadp1new>
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
X-CMS-MailID: 20261110020744epcas2p4576919ef0e67453825490cf76da0b888
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Hop-Count: 3
X-CMS-RootMailID: 20261110020744epcas2p4576919ef0e67453825490cf76da0b888
References: <CGME20261110020744epcas2p4576919ef0e67453825490cf76da0b888@epcas2p4.samsung.com>

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

Changes in v9:
- Patch 1: add Reviewed-by: Bean Huo.
- Patch 2: if __ufshcd_wl_suspend() fails, release host_sem and return
  the error, as ufshcd_wl_suspend() does, so that the error handler does
  not block forever, as suggested by Peter Wang and Bart Van Assche.
  Describe the behavior change in the commit message. Drop the
  Reviewed-by tag of Bart Van Assche because the code changed.
- Patch 3: also require hba->pm_op_in_progress for the early link
  recovery, checked together with the runtime status in
  ufshcd_rpm_transition_in_progress() as suggested by Bean Huo. The
  runtime status of the WLUN alone is also set during the
  block layer steps before and after the runtime PM callbacks, which
  widened the window in which the error handler recovers the link
  without the PM callbacks holding the controller (Sashiko review of v8,
  Bean Huo and Bart Van Assche). Drop the Reviewed-by tag of Peter Wang
  because the condition changed.

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

v8: https://lore.kernel.org/linux-scsi/1582071873.61794200283414.JavaMail.epsvc@epcpadp2new/
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

 drivers/ufs/core/ufshcd-priv.h | 17 +++++++++++++++++
 drivers/ufs/core/ufshcd.c      | 32 ++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 4 deletions(-)

-- 
2.34.1


