Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852161;
	b=NhtGiuFSF4Dnl0JPtsV5v4b+KysE9tKKiYjqYaLsYHVbwl3G9YqExkvtUy5h8pdpT+TF
	 5Rn2XyMZ8YIvwRE/9xk8Vsz1V7bc2fP1GmVjCsHWrG1j6sB7wwssU/4QIwnnJ0e/RHwtd
	 SBXvZWY1Tr8RnxMDpThGMElMwc7BUCnJS3K6WC8qSfYcQJBzYA4ZbffL1zL6UxFpEduBA
	 /3PSvEB06zqNR7Zkqo9Q2Xei6nEnMW7q+vd3v3FstJzoi1FXP/YsXewqQyFxh6Zcp7myn
	 gbQ9Fyvb2RHCg8At0L13hDoqiApPBsYH089uqMSKbnNHegJcNlv1Ua62YO1PKcLwCRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852161;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=PTDP7WG69NzViQWlu0aPWTRMmjri3oiyHsFITdaJblA=;
	b=cWFNGRmV4Xl6gv1MtNRqfoCY07An1etrZO5ujpO3CyiWNfjpfHczm+plMXdj1uH8uuoY
	 O7jUDo0dOarXMnyLoxruGVZmrwufrK5Zk59BhqT4rl7lw4dLywdAKFeTCVvsq5JNL+qne
	 bWnopChq1BCvQDGDf3AFYTbVozAWXPz8ifYjWeD1PBn4T3Gmip+AsdemCZx+w5gJR07xp
	 A8N4nnaNYIVi+N+KZqXM4oH+8BJ382Ppkubdk1NGDmuyA8+de68mZ0/uDy4hGeBzvwdh6
	 kQVmYLlevFdH03JsDpP+RS+KJSbNmMDnuzAsxwr653pNrmIBaO6Zk83vgPW6X4FJkSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72638606A326
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72638606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261105041555epoutp019d8da9837b47cb9b59ed36aab91f26b3~lCwfkruyj0715207152epoutp01N
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:15:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261105041555epoutp019d8da9837b47cb9b59ed36aab91f26b3~lCwfkruyj0715207152epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793852155;
	bh=PTDP7WG69NzViQWlu0aPWTRMmjri3oiyHsFITdaJblA=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=Tdgw+eU/LrbPCx5rVd2frAiDtGdshwmVb/S9DLDJktnetQFh4RU/X6EonhWJUB87q
	 lEejF6ON4dWl1Mu2t2CCvhWijf8mtMrzTAye+Nu7czp2HfblQqDFG+Teaj+jVFydvx
	 BYK7CBRvexq6cGONdPj2AnELB/+M9UHehm6XzDDQ=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261105041554epcas2p2312fe29fe79952fdfb5674613d5daea1~lCwevPLl81571115711epcas2p2m;
	Thu,  5 Nov 2026 04:15:54 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.200]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKprn638Rz6B9m7; Thu,  5 Nov
	2026 04:15:53 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261105041553epcas2p44a33fec882036232b8518af58f06f50e~lCwdzXOo02954629546epcas2p4q;
	Thu,  5 Nov 2026 04:15:53 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261105041553epsmtip1b7bd1621205a374f639e966ed70a6b35~lCwduNdJQ1989819898epsmtip1d;
	Thu,  5 Nov 2026 04:15:53 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
In-Reply-To: <a291e852-9ca8-48ad-8c4b-bf5de057203d@acm.org>
Subject: RE: [PATCH v3 0/2] scsi: ufs: core: Avoid redundant link recovery
 during system resume
Date: Thu, 5 Nov 2026 13:15:52 +0900
Message-ID: <000001dd6cdc$58d12790$0a7376b0$@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ/QZZDmtVAdWwyMiqPGLvdDdGG1AG1hp9yArw/7OsCKA0/NbWmOuiA
Content-Language: ko
X-CMS-MailID: 20261105041553epcas2p44a33fec882036232b8518af58f06f50e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d
References: <cover.1792989286.git.hy50.seo@samsung.com>
	<CGME20261103093825epcas2p3d741e7c61c82ea89cbd63299b853732d@epcas2p3.samsung.com>
	<20261103093358.1835628-1-hy50.seo@samsung.com>
	<a291e852-9ca8-48ad-8c4b-bf5de057203d@acm.org>

Hi Bart,

Thank you for the review and for the report. I checked the points in the
report against the code and agree with them. I will send a v4 that
follows the suggested direction as far as I could verify it:

 - Patch 1/2 is unchanged apart from a Fixes: tag.
 - Patch 2/2 replaces the is_sys_suspended check. The early link
   recovery in ufshcd_err_handler() is only taken while a runtime PM
   operation is in progress. For system PM the error handler waits for
   host_sem, and during shutdown it stops, so it no longer runs
   concurrently with __ufshcd_wl_resume(), ufs_mtk_resume(), system
   suspend or shutdown. This needs a new field,
   hba->runtime_pm_in_progress, because pm_op_in_progress does not tell
   which PM operation is running.

I kept the early link recovery for runtime resume as well, not only for
runtime suspend. The comment added by commit e23ef4f22db3 and commit
35dabf4503b9 describe a deadlock when the error handler runs during
runtime resume, and I could not confirm that the regular path, which
waits in ufshcd_err_handling_prepare(), is safe there. As a result the
race with __ufshcd_wl_resume() during runtime resume is not removed.
Do you think the early path can be dropped for runtime resume as well,
e.g. after commit 01d5e237b339?

For the remaining early path in runtime PM I did not add a check of
ufshcd_err_handling_should_stop() before the link recovery. I can send
it as a separate patch if you think it is needed.

I also did not add a mutex around ufshcd_link_recovery(). It calls
ufshcd_probe_hba(), and if a device command times out there,
ufshcd_eh_timed_out() calls ufshcd_link_recovery() again from the
timeout context while the first call waits for that command. A mutex
would turn this into a deadlock, so I would like to avoid it unless you
see a way around that.

Thanks,
Hoyoung

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, November 4, 2026 3:25 AM
> To: HOYOUNG SEO <hy50.seo@samsung.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; mkp@kernel.org; martin.petersen@oracle.com;
> stanleyjhu@google.com; alim.akhtar@samsung.com; kwangwon.min@samsung.com;
> kwmad.kim@samsung.com; cpgs@samsung.com; h10.kim@samsung.com
> Subject: Re: [PATCH v3 0/2] scsi: ufs: core: Avoid redundant link recovery
> during system resume
> 
> On 11/3/26 1:33 AM, HOYOUNG SEO wrote:
> > Any review or comment would be appreciated, especially on 2/2 and the
> > system PM vs. runtime PM difference.
> 
> Please take a look at the attached review report from an LLM. According to
> that review this series isn't ready yet for integration in the upstream
> kernel.
> 
> Thanks,
> 
> Bart.

