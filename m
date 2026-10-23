Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755552;
	b=vo6wdQP4FVo8b47PUUWf09QlylWCSiegUca7lkD0nzTqcBWrLx7D3CDjQOzgw0L6upXy
	 VNlHuEKa8U2KXRWDpuPXrSpHQYx4laBC6UcRfPI2BE3DwwIQuWtxPATPoNj8FpFGOvJsn
	 8/MSV91BA2pzLBytkWKg1f/hYI6TrbTprPUQnqi5WppLTML+84cs+BoCDt320+jvIR3i3
	 Lda1XiGFH/4YhHIWJaSGm21rGsxgPv7FpBuNVB3fl2Az4VjA2LlpyXmHzpWUWiJ7x4AEN
	 vVB2YFrNZyyeVa1l7jPOGEKiPQU+96q50lr9YRIFt/oziFIvd1PJci6TIkKc32eDXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755552;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=S+vCK1YIdasZf4CYFvvYVy8frf6VJ05KbEUpJ4Pi40s=;
	b=gZDcjl6KLc+b6NQkRRyRxUj8VUwcmDz5NGCU+uxJ8IRn3sYSJo6/pjaiS2wEuV13hfD4
	 d/Hu+TplUjLS/5SEYOZHZjWhsQO2JuzqYr4U4KULV9fZkMdDle670vyk6QAlQwqYug4hf
	 JQzvVV8G6sWyrd8xWlNj0z6sIWm5hF6YH/wNFEoIbvTlc5Fsl39RE8846TxRJXzgOAMXh
	 mr9bJqYgZc4fSfTyjDaZBS/rwncM3t0lenTdbiZKrzzEE9XAgtl1j8/RIgPSDLmPzEzDg
	 syHPcr36DERV9w42IzvYCZ7WArYhQJs9d/iy6VM/tbN56J8aVBlWv2uW1cEwaoEDdXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=sThAEvrd;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A771C606A31D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A771C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=sThAEvrd
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261023113908epoutp023bb5372874d93af077d7daedebfe8f01~hJaxH5cn31767617676epoutp02S
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 11:39:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261023113908epoutp023bb5372874d93af077d7daedebfe8f01~hJaxH5cn31767617676epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792755548;
	bh=S+vCK1YIdasZf4CYFvvYVy8frf6VJ05KbEUpJ4Pi40s=;
	h=From:To:Cc:Subject:Date:References:From;
	b=sThAEvrdfO4fX4NqsBPXz/lrm3kx8BMcRJT1+oKJrkgIuVyqBkQwBMb6hpx8XEJHR
	 0nok3+4DqUsg+DxeFGVtcik7KaA6dTYUaYl53shjR4AdFenrEstkucJNZ+7ukAE1cQ
	 eMIXeQ7AaKxf3MlqwJSByr75dH5xRLc0ojSphYls=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261023113907epcas2p41c0623414bb6fe91917a13e48db5600f~hJav_0z6z1753517535epcas2p4m;
	Fri, 23 Oct 2026 11:39:07 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.205]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jB1JC0dG6z6B9m6; Fri, 23 Oct
	2026 11:39:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261023113905epcas2p36f5e7bf1d3954ac8c666a25a922fc031~hJauitFHw2175721757epcas2p30;
	Fri, 23 Oct 2026 11:39:05 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.81.221.204]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261023113905epsmtip1c4b2e52ba9070c8f9aef7078737e67f4~hJaucArbO0611306113epsmtip1h;
	Fri, 23 Oct 2026 11:39:05 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com,
	kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: HOYOUNG SEO <hy50.seo@samsung.com>
Subject: [PATCH v2 0/2] scsi: ufs: core: Avoid redundant link recovery
 during system resume
Date: Fri, 23 Oct 2026 20:34:50 +0900
Message-Id: <cover.1792755091.git.hy50.seo@samsung.com>
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
X-CMS-MailID: 20261023113905epcas2p36f5e7bf1d3954ac8c666a25a922fc031
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261023113905epcas2p36f5e7bf1d3954ac8c666a25a922fc031
References: <CGME20261023113905epcas2p36f5e7bf1d3954ac8c666a25a922fc031@epcas2p3.samsung.com>

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

HOYOUNG SEO (2):
  scsi: ufs: core: Clear saved errors in ufshcd_link_recovery
  scsi: ufs: core: add is_sys_suspended state before recovery

 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

-- 
2.34.1

