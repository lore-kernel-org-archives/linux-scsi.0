Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945750;
	b=upGZAV5Ly3Q6uAPVxIpquDdSxU8qvOjhXqrDT/Uf2y6uHkjh26oHNvENrtayyzey6iux
	 kcOkjoShZ79MngiCjFpRKX0uy7oZvgbRh+bRza/zmYU/ZOyKC4ykM5uZy24hkOSlcd+MD
	 N+P07dYJRLGBpS0TEc6HhMpE/h/ZnGdWmQzKL+3SuxFPUX4UkQXq7SbwiRSym3URiNKkQ
	 U99na+PYGniipZqiWbXY6LoSSa0TQyPeidXddjyXOUdlpGDdtbR30TaSZk0FCSh7GtPpO
	 /t0Y7BWosIOdrtywJnQN2+3Z/xq0a8lC80gaWwgGamlAsVLBOt6v4npWCWwCc0yi+uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945750;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=GFeHYWApL6F6xJIiHGXOImj1G4qS3MWe2g4FeLzj7JA=;
	b=cl/G4Ov2D6HvoklZr6ZgP1znYmb6/oYfL1JMSD+msxjexGp5BJcno79Jukk0gsPFwk4K
	 EE8a64qfau9avNMcNZf0dmzmXUGRL+YDBSfOvA8xIDnN2nhr0tURXf9E+0feCuDHxBShy
	 KwugIuTd4PTOY6N5h3+i2XLeYv3G01NmWuK4MVjBzj7/ik4GmHucp66zYr8v9w9f8sosw
	 yAoIjOgKhJqDwQ74fIVqKGVlEt0I4yIyi+Aj2Hg4EU2aooL4kS2qjkDGJ9rJEkZuLpSFm
	 +G7+n/jjKFTCWvmjLiFB7G9RIRS0NyN9UJJ1+Ne/duSCAeAThTUmixilfWnrL6r/Egg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=rcPBOMs6;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA82606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA82606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=rcPBOMs6
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261106061546epoutp0177afb0763a06a5132652540cade06505~lYCbAQcaJ2171221712epoutp01N
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:15:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261106061546epoutp0177afb0763a06a5132652540cade06505~lYCbAQcaJ2171221712epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793945746;
	bh=GFeHYWApL6F6xJIiHGXOImj1G4qS3MWe2g4FeLzj7JA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=rcPBOMs6D3VJPIT4/kCKNutop6zCnTU1YZJG2U2W8CGFtmUvW3coAcy0rUmSajY7e
	 IvJ1BsytdeA6SHQ67pp2yNfWZeyYnUhO4W/De0vpHR01asaYFbkb+FRitCcduRmOal
	 UURluFbt+hmji/LR6HSW/Nqr4MoWvHg8qgocVZ/o=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261106061545epcas2p29fff792cbb5ccea4d2239d1b3638cfdc~lYCauEjwb3043930439epcas2p2f;
	Fri,  6 Nov 2026 06:15:45 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.202]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jLTSd3SG8z2SSKf; Fri,  6 Nov
	2026 06:15:45 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261106061544epcas2p4b1ebab9e2c0e041ee52ff724caf8a9e8~lYCZwU4Y00225202252epcas2p4y;
	Fri,  6 Nov 2026 06:15:44 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106061544epsmtip1652be0ab1c65b393e154ded275b9a90b~lYCZru48D0539705397epsmtip1O;
	Fri,  6 Nov 2026 06:15:44 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v7 0/3] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during PM
Date: Fri,  6 Nov 2026 15:11:15 +0900
Message-Id: <cover.1793943246.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261106061544epcas2p4b1ebab9e2c0e041ee52ff724caf8a9e8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106061544epcas2p4b1ebab9e2c0e041ee52ff724caf8a9e8
References: <CGME20261106061544epcas2p4b1ebab9e2c0e041ee52ff724caf8a9e8@epcas2p4.samsung.com>

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

 drivers/ufs/core/ufshcd.c | 28 ++++++++++++++++++++++++++--
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 28 insertions(+), 2 deletions(-)

-- 
2.34.1

