Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945381;
	b=tL3B6psrDXno6KBMAuGhc+ZFBtcNHAlvwhaMzIqU8Sh9UdAb1HkI1S/0vTVuEMXM8YOf
	 doDbwf9KltEP0hpe3PoqGUBP7+yln5GvoUy0lpihgj0hime3H+m4DpKTa9CEc9WH63nPs
	 5oq/o5CtMbgtC4jgq+mopA9ty9IqqqtLRVlSfxjtkFqkLgxT7xjcWE/efvnzjJdco5TZt
	 k2eGrGXOaqKsnOwOWs9LeHLMN/JenKhcV2DRDFPNzvRvhxJyqbh7qeZzZ2Op+QkmdhoP/
	 MZtf3o1Tl0IO2swMUlEW/BjYf315fMVjiUUILeVtsh/79FiBRITy/z8VzBa7Xej0zlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945381;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=vkdvesY0qq3K2dD6/XbYf2PPk4M7/A8430gTiRL/0b0=;
	b=PzMTuQLkAUjT8OYbeS+r/zZE4y3/sl7Q/aSl7nUt/KdNqKyoZk0jfU1Q3jn8zIcYxD5r
	 2YdXKNS6LpJhvSZUCEp/QQ82hC/La3Un+brewAZvLaqVGmE+Iqknxs3mpeYEjqhtm0QHc
	 y03ZGqToPQkrT9CUTna4dvGno6JDQgXeh9YysKF5HwvG8P8qUGPjNAFGc3IxGYYGyD+/M
	 gJu6DcckYomLGPWhnk/YUZYpxb9lJEG9V2OP8AQJbN2J6lno/8xm6hntFYrMgBlgEo5nE
	 wTFCQfS+kg5a3Lk8W9qcEAi0r6baeLB6akaES84EyIpkgfVy72JO3N6FYh8Ohd6nfxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=f0X4FDwp;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB7606A338
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67FB7606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=f0X4FDwp
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261106060936epoutp0408777f2bcd0173289697d3daff50bc13~lX9Co6F7b2430424304epoutp04f
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 06:09:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261106060936epoutp0408777f2bcd0173289697d3daff50bc13~lX9Co6F7b2430424304epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793945376;
	bh=vkdvesY0qq3K2dD6/XbYf2PPk4M7/A8430gTiRL/0b0=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=f0X4FDwpSWlRvZjjKbpyGvgwY1SbEnMd9VUWjMFhD3BaKy7JfP3DIRbfQ6NuM5B2n
	 P9NivtXi6gV0CIKdXtN/iizwfeaEZ1+1P9blKbVrAylnKm0amLZKtY1Appy6pETaiQ
	 tpsPb4F+LbQrmLYdHjPB9HJekyM00H6FaHz73CQM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261106060935epcas2p3559caf5cdda3ca2483cbe60ea213acc4~lX9CMkPEF0476904769epcas2p35;
	Fri,  6 Nov 2026 06:09:35 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.210]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jLTKW3sbpz3hhTC; Fri,  6 Nov
	2026 06:09:35 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106060934epcas2p13055d05b271d0111eeca609efb4e4b07~lX9BThzER1167511675epcas2p1G;
	Fri,  6 Nov 2026 06:09:34 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261106060934epsmtip1805bfabf56ccc47c59fd956946b6d4bb~lX9BPEWJv0250102501epsmtip1s;
	Fri,  6 Nov 2026 06:09:34 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
In-Reply-To: <5f1692ad-d718-4446-bd62-57e7049be92a@acm.org>
Subject: RE: [PATCH v6 3/3] scsi: ufs: core: Set shutting_down in
 ufshcd_wl_poweroff()
Date: Fri, 6 Nov 2026 15:09:27 +0900
Message-ID: <015601dd6db5$65501c40$2ff054c0$@samsung.com>
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
Thread-Index: AQLLI625VyEVqOdBlj4qNrrnpnoJ9gG2+eacAZdllVQCEdgNN7UaISdw
Content-Language: ko
X-CMS-MailID: 20261106060934epcas2p13055d05b271d0111eeca609efb4e4b07
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1
References: <cover.1793931113.git.hy50.seo@samsung.com>
	<CGME20261106022021epcas2p20d78ac51e55f03348d496f45e96031e1@epcas2p2.samsung.com>
	<66845a28b3014bb53b7f1332c258009b80707297.1793931113.git.hy50.seo@samsung.com>
	<5f1692ad-d718-4446-bd62-57e7049be92a@acm.org>

Hi Bart,

Thank you for the review and the Reviewed-by on patch 1.

I will take your suggestion for ufshcd_wl_poweroff(): it will take
host_sem and keep holding it until ufshcd_wl_resume() releases it, so it
behaves like ufshcd_wl_suspend() and the unbalanced up() on the
.restore path goes away too. I will add the Fixes: tag (b294ff3e3449,
which added the WLUN .poweroff callback) and Suggested-by, and put the
patch in front of the one that limits the early link recovery.

For the patch that limits the early link recovery, v7 will:
 - use READ_ONCE() in ufshcd_err_handler() and WRITE_ONCE() in
   ufshcd_wl_runtime_suspend() and ufshcd_wl_runtime_resume();
 - describe the behavior change during shutdown in the commit message:
   errors that occur while the final START STOP UNIT command is being
   processed are no longer handled by the error handler, recovery then
   only happens through ufshcd_eh_timed_out();
 - correct the poweroff statement: the error handler waits for host_sem
   there, it is not stopped by hba->shutting_down.

I will send v7 shortly.

Thanks,

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, November 6, 2026 1:50 PM
> To: HOYOUNG SEO <hy50.seo@samsung.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; mkp@kernel.org; martin.petersen@oracle.com;
> stanleyjhu@google.com; alim.akhtar@samsung.com; kwangwon.min@samsung.com;
> kwmad.kim@samsung.com; cpgs@samsung.com; h10.kim@samsung.com
> Subject: Re: [PATCH v6 3/3] scsi: ufs: core: Set shutting_down in
> ufshcd_wl_poweroff()
> 
> On 11/5/26 6:15 PM, HOYOUNG SEO wrote:
>  > +	down(&hba->host_sem);
>  > +	hba->shutting_down = true;
>  > +	up(&hba->host_sem);
>  > +
>  >  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> 
> I agree with both issues reported by Sashiko:
> - ufs_mtk_system_suspend() is also the .poweroff callback of the
>    MediaTek host controller device and returns -EBUSY if
>    hba->shutting_down has been set. Since the .poweroff callback of the
>    WLUN is called before that of its parent, this patch makes
>    hibernation fail on MediaTek hosts.
> - If hibernation is aborted after the WLUN .poweroff callback has been
>    called, ufshcd_wl_resume() is called as .restore callback.
>    Nothing clears hba->shutting_down, so the error handler and user
>    access (ufshcd_is_user_access_allowed()) remain disabled.
> 
> Additionally, the existing code already has an unbalanced
> up(&hba->host_sem) on that path: ufshcd_wl_poweroff() does not acquire
> host_sem but ufshcd_wl_resume() releases it.
> 
> How about making ufshcd_wl_poweroff() behave like ufshcd_wl_suspend()
> instead, i.e. acquire host_sem and keep holding it until .restore releases
> it? Something like this (untested):
> 
> static int ufshcd_wl_poweroff(struct device *dev) {
> 	struct scsi_device *sdev = to_scsi_device(dev);
> 	struct ufs_hba *hba = shost_priv(sdev->host);
> 
> 	/* Released by ufshcd_wl_resume() if hibernation is aborted. */
> 	down(&hba->host_sem);
> 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> 	return 0;
> }
> 
> That serializes the error handler against poweroff the same way as for
> system suspend, fixes the unbalanced up() call and leaves
> hba->shutting_down alone. Please also add a Fixes: tag and move this
> patch in front of patch 2/3.
> 
> Thanks,
> 
> Bart.

