Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865669;
	b=X9Ad6xLUf7Wqay2l4iqQMxm7hL/1hN6bHjmZBH0SmyWOvXjEyDM7J99WpLtKnm5G0boq
	 7GV8nEq5IwIepN0TJnUJ21Gb5AC1pn1crMXcKFtpQM3Z1oVrpEFQM8ypHGfmqFvraOfyw
	 Xu7Dms3MPWI7DoCUB3e+6rP3Op0thCHKzlE5o92aTTwcRyUS13WDz0ERPa7fOCjRfiTkp
	 UdLKmrY/ndZirrPZSxCDPQi1EaeedeCBPoxYDZ0cp/vYyud8HNd0tfUdEpdRoOSHJOHJ2
	 zIEn77r8uRAYeyIDmPGMBeox86UkBmBgm2qxLRBAj30wC5hXIqJ0Sw5KoHAkITZWAGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865669;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=v1MkJ4J0mfLz8Q87keMkS5YeOHx6gfWC9UWYhcEUaUo=;
	b=4fzNcH6Jjzgh5vEB6CPmCGXS6bHUZ2gNDEMVQAUDnq4GkAZ22p2d9Rm2Le7/HFpTG5lp
	 cYfRaER78h+8QaNT+RLQZxisJi33DnDoSPQKbW01oiEySKuGCQazVKUkKPR76JED7a0zg
	 OHdJ8oAmm92ny3FScP4AyYOO8XvkzvahHeYi1MHxHA/zsGFSFp95taMnj1szQivwK+vHz
	 xbVZspJxucGQQQ6P20HN/IJxX/zXgvTBERvjMmpAHEwp3yUOsCYD7J95DP/auCo/9aEjw
	 XMsT8YtcxB22TDyw3KBJHoyT2nbSbRyMZdYEU8qQM75Vr2Ub+canEp4KHuYRCyX7Rmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=YpAjqECD;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F80606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4F80606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=YpAjqECD
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261105080100epoutp022bf0e093bec65b3f758e797ed37799cb~lF1Bjmgjq0947409474epoutp02w
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 08:01:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261105080100epoutp022bf0e093bec65b3f758e797ed37799cb~lF1Bjmgjq0947409474epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793865660;
	bh=v1MkJ4J0mfLz8Q87keMkS5YeOHx6gfWC9UWYhcEUaUo=;
	h=From:To:Cc:Subject:Date:References:From;
	b=YpAjqECDE67ObxviVYd2bvOU1fZjTx+HNM6ZuANCN7q9XAp0UsKWmAT7x25WGMw6J
	 UXrF6cu4J4ws17uGlyO68b8URrC6s1vSeNp3gnME3qlyPZ9Bkyo+3dWQVG1d9gNvDw
	 7K08kMCz7dAkkCXhWionM6wUwna3iLSI41Y4O0/o=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105080059epcas2p13b122d76629c8bc38629386fec64b43d~lF1A_SrqH1098910989epcas2p17;
	Thu,  5 Nov 2026 08:00:59 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.209]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKvrW49zGz6B9m9; Thu,  5 Nov
	2026 08:00:59 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261105080058epcas2p33d17a4cc3163920fd24a3c378f21e3ae~lF1AA9tFg2411424114epcas2p3R;
	Thu,  5 Nov 2026 08:00:58 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105080058epsmtip26215f46886a6318c01ec921c4cd212df~lF0-8QdSH2425224252epsmtip24;
	Thu,  5 Nov 2026 08:00:58 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	bvanassche@acm.org, mkp@kernel.org, martin.petersen@oracle.com,
	stanleyjhu@google.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v5 0/2] scsi: ufs: core: Avoid redundant link recovery from
 the error handler during system PM
Date: Thu,  5 Nov 2026 16:56:34 +0900
Message-Id: <cover.1793865172.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261105080058epcas2p33d17a4cc3163920fd24a3c378f21e3ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105080058epcas2p33d17a4cc3163920fd24a3c378f21e3ae
References: <CGME20261105080058epcas2p33d17a4cc3163920fd24a3c378f21e3ae@epcas2p3.samsung.com>

If a LINERESET is reported and the hibern8 exit fails during system
resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the two recoveries are not serialized.

Patch 1 makes ufshcd_link_recovery() clear the saved errors like
ufshcd_reset_and_restore() does, so the error handler does not act on
errors that have already been recovered.

Patch 2 skips the early link recovery in ufshcd_err_handler(), which
does not hold host_sem, while a system PM operation is in progress. The
system PM callbacks hold host_sem, so the error handler now waits for
them.

The early link recovery is kept for runtime PM, shutdown and poweroff,
which do not hold host_sem. During runtime resume it can still run
concurrently with __ufshcd_wl_resume(). Removing it there needs a closer
look at the deadlock that it avoids.

Changes in v5:
- Patch 2: track system PM (hba->system_pm_in_progress) instead of
  runtime PM, so that the early link recovery is only skipped where
  host_sem is held. ufshcd_wl_poweroff() holds neither host_sem nor sets
  hba->shutting_down, so poweroff keeps the early link recovery as
  before (Sashiko review).

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

v4: https://lore.kernel.org/linux-scsi/cover.1793851432.git.hy50.seo@samsung.com/
v3: https://lore.kernel.org/linux-scsi/cover.1792989286.git.hy50.seo@samsung.com/
v2: https://lore.kernel.org/linux-scsi/cover.1792755091.git.hy50.seo@samsung.com/

HOYOUNG SEO (2):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery
  scsi: ufs: core: Do not recover the link early in the error handler
    during system PM

 drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++--
 include/ufs/ufshcd.h      |  2 ++
 2 files changed, 25 insertions(+), 2 deletions(-)

-- 
2.34.1

