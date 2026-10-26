Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989703;
	b=XB99jZjM/UU/kJ7fcSDijDQWuSQiK02S1h54DBBeeP3Af5EDDuTCW3nIvYOW3+jRXTLt
	 wpzrvm4NtD7LWIMqN5iytfNjWYNSHbr1fgBw+YMOHqyiLKXsXXLUxxBCAeyXSHtO18aPp
	 6eg2nRcIaPmkuY1YpfvgXXBe+8Ds1UiHqlo49vft4MLudl5SdiK4zi77A2spnouyq3b1X
	 6IJ8qEiX8J1YrSiXSJGU6wDwaQ9h9RcXqu5onH4CN7X0Lvkit7SWX7rwMQsSkqQ1mGotI
	 8jxcN3jC9DrLiCPiRp8POMR3236A0wTlNDxHRWLY7xiWdXaSPtkz28r0wZHuj6Lyqvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989703;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=8Uha6gBOHxxpMhg5C4HSAGVuxKhZmxnkljAaEvU5MkM=;
	b=iNvDaf6c8glP0gG0O7Ww1kbtRLmpzQmEXqROmHpzEk2+U0zKW5ep3iJLU0O3KqXISZnY
	 Qu0DCwaRaCoLAF6EcF66XPCsNvUvy0MoALWMKWqRxitSIAV8Cvg9P55hG7wXfLf5PZhZP
	 7ivhut0fx+N+MGiOqI02lnuUFldrQcBCI82CcQQd0w6FtfRv1YDkUZ+6u8u1EIM0GmioF
	 Sj13+3Jyf4Dp3kWriGutDc6cdZZw/PoWyce2ohri/wT1DvWnUVuiRouksbaXFuVC+AHVw
	 JWscoKkL7x/Ph+zjQp7EJbkDbzgJMHsJNxFm/+XihgZ/TvjckvUCJaqTD520PWlup3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=uYBHNih4;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C013606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C013606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=uYBHNih4
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261026044139epoutp034fd99340f7734dbbfab536f986649fbf~h_qHIQs3c0504005040epoutp03a
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:41:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261026044139epoutp034fd99340f7734dbbfab536f986649fbf~h_qHIQs3c0504005040epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792989699;
	bh=8Uha6gBOHxxpMhg5C4HSAGVuxKhZmxnkljAaEvU5MkM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=uYBHNih4LGnqNhzVOIdotzXDYvZ+IRjIFhXj9zoYDaXhgLHqnC5RiZXDl63aN3TpN
	 grVxEFRiTTDBoBXEHRZ84kFxPRTacLwEOztLgfGjFao4wn7bMbDM3+meFZP3apP8Wl
	 YkelrVcpvO5ZV5DuKFhRhvAGVQNb2Vd7MR/L7aBo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261026044139epcas2p2303decafac496954077a710720e638e1~h_qG3nwto1713717137epcas2p2f;
	Mon, 26 Oct 2026 04:41:39 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.199]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jCgv65V0zz6B9m7; Mon, 26 Oct
	2026 04:41:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261026044138epcas2p19feb1c8130a1c07b67b1f27eefb1c300~h_qGCWphS2359023590epcas2p1Z;
	Mon, 26 Oct 2026 04:41:38 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261026044138epsmtip1fff4495ec607331d61b51e7d3947f3a2~h_qF9SeyM2136321363epsmtip1I;
	Mon, 26 Oct 2026 04:41:38 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v3 0/2] scsi: ufs: core: Avoid redundant link recovery
 during system resume
Date: Mon, 26 Oct 2026 13:37:19 +0900
Message-Id: <cover.1792989286.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261026044138epcas2p19feb1c8130a1c07b67b1f27eefb1c300
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261026044138epcas2p19feb1c8130a1c07b67b1f27eefb1c300
References: <CGME20261026044138epcas2p19feb1c8130a1c07b67b1f27eefb1c300@epcas2p1.samsung.com>

If a LINERESET is reported and the hibern8 exit fails during system
resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
ufshcd_link_recovery(), and the two recoveries are not serialized.

Patch 1 makes ufshcd_link_recovery() clear the saved errors like
ufshcd_reset_and_restore() does, so the error handler does not act on
errors that have already been recovered.

Patch 2 makes ufshcd_err_handler() wait for host_sem instead of
recovering the link early when the hba is system suspended.

Changes in v2:
- Add patch 1. As pointed out by the Sashiko review, saved_err and
  saved_uic_err are still set after the resume path recovered the link,
  so with v1 alone ufshcd_err_handler() would run a redundant recovery
  once host_sem is released.
- Patch 2: describe the race and the system/runtime PM difference in
  the commit message, and add a comment.

Changes in v3:
- Patch 2: reword the commit message only, no code change. The error
  handler does not always run a full recovery after a failed system
  resume; it stops according to ufshcd_err_handling_should_stop() (e.g.
  in UFSHCD_STATE_ERROR). Describe this behavior and refer to the commit
  that added the early link recovery (Sashiko review).
- Patch 1: no change.

HOYOUNG SEO (2):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery
  scsi: ufs: core: add is_sys_suspended state before recovery

 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

-- 
2.34.1

