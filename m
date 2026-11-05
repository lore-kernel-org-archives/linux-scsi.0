Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849671;
	b=UwgB0Stl5a1QUYpHFT6qgfu8kxTNEWJYzncRnWtdz7JRW80TcG39FMAhNVATWWxNQfKa
	 7BtZteZbNLwlp+vhEbAVxhfzvcYaRoLJEJ4bqXUAdjTZYN6Zd11kIm7DjkJ2dxa6F6T0J
	 83S0ycDJLwn2r5h5QyYHwaUAJQTHOCoRZ6ScnZ04tXnoaFJmx1YRYhz3B5xOXfg30dy8s
	 BRp1J2WzkiqFVuT1/GLOilhnqczKsKYVaIKChagZOtqyhVZc0Lnddrxun4LGGRtiU/v5H
	 UiOyIhgdks7kEwi/ofCuRfXlUAjWTjTPXuLnF/z422UztlOIEBC0CoXH8h8yaet7P7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849671;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=wqQeqShnEFAGPe29OtG3KFou809AHeH9DP4h7PajO7A=;
	b=xn1ThPZF8S8R0QK2q0tuCxEwh1VVSpSluTKs8zrX1d6ARMOsiJBt9y3FlpLvYyW5uwhp
	 75IufPNeEl7aZ1pUogyQiV+qW0pqcT3m8jmhg1VKepeEqy8PvurKRu0XiQR4GDG1oKuLA
	 +YamRufKek35e8mvD/pec9I/0Y7rcWhapr5oj0EppELts5L06jd21VNmGyvbpdgIIzBrc
	 3nCYKQl7IsvidHW+Il1ZgTFKSJtJrQTrf3jt1MAeHngqDmaQESQpAxh2UK2tcKx+LyuKc
	 V7lyM1VRCMyMdFfNJ771jVSQXlLSk0Y71N/Mu62DlQzvQkUt0GzmK5rw9Ie5rbwskig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=cKaGZeuH;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7F5606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC7F5606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=cKaGZeuH
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261105033427epoutp048e7defbacf80420c47c2f185083b904f~lCMS77U-20981109811epoutp04T
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261105033427epoutp048e7defbacf80420c47c2f185083b904f~lCMS77U-20981109811epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793849667;
	bh=wqQeqShnEFAGPe29OtG3KFou809AHeH9DP4h7PajO7A=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=cKaGZeuH++WTRTs78MzlTCZrEoKIqK4UQN8KS7Sa/0IQqWDbRw1DM1IaOymQtYTiz
	 LBaImINUP3R7KhV3AF42HdoZiGx4ZvIsRurJ3WOPbu29Fnizwd8RA8lymqLxOnZIWB
	 0bLNjyWcWGJFvjdMWD7/IvMDsCRyOlWHryCBHkKo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105033426epcas2p1d2160ff091330c7e6922ab88a2ff03ed~lCMSINNn13146231462epcas2p1r;
	Thu,  5 Nov 2026 03:34:26 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.200]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKnwy2wmfz6B9mB; Thu,  5 Nov
	2026 03:34:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261105033425epcas2p48e03f124a57ef06e37671dcdafa2cfeb~lCMRN5V-Z3116631166epcas2p4B;
	Thu,  5 Nov 2026 03:34:25 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261105033425epsmtip1076a61c25b744bbe3c6462f4fca4508b~lCMRHBO1x3255132551epsmtip1J;
	Thu,  5 Nov 2026 03:34:25 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<kwangwon.min@samsung.com>, <hy50.seo@samsung.com>, <cpgs@samsung.com>,
	<h10.kim@samsung.com>
Cc: <stable@vger.kernel.org>, <stanleyjhu@google.com>, "'Bean Huo'"
	<beanhuo@micron.com>
In-Reply-To: <8446dc27-9518-4b0c-b9e9-116458210616@acm.org>
Subject: RE: [PATCH v6 1/2] ufs: core: skip ABORT TASK for device management
 commands
Date: Thu, 5 Nov 2026 12:34:25 +0900
Message-ID: <002101dd6cd6$8e510b20$aaf32160$@samsung.com>
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
Thread-Index: AQH4JEezrlrww6xOutvb1msxx9OBXQK0O2N1AUyogGgCjTU/mba088Fg
Content-Language: ko
X-CMS-MailID: 20261105033425epcas2p48e03f124a57ef06e37671dcdafa2cfeb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004352epcas2p307ea40aadb636015545cee6e79470a03
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
	<CGME20261105004352epcas2p307ea40aadb636015545cee6e79470a03@epcas2p3.samsung.com>
	<20261105004333.1097899-2-kwmad.kim@samsung.com>
	<8446dc27-9518-4b0c-b9e9-116458210616@acm.org>




Kiwoong Kim
BRs.

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Thursday, November 5, 2026 10:28 AM
> To: Kiwoong Kim <kwmad.kim@samsung.com>; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; alim.akhtar@samsung.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; kwangwon.min@samsung.com; hy50.seo@samsung.com;
> cpgs@samsung.com; h10.kim@samsung.com
> Cc: stable@vger.kernel.org; stanleyjhu@google.com; Bean Huo
> <beanhuo@micron.com>
> Subject: Re: [PATCH v6 1/2] ufs: core: skip ABORT TASK for device
> management commands
> 
> On 11/4/26 4:43 PM, Kiwoong Kim wrote:
>  > @@ -8046,6 +8046,9 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba,
> int tag)  >
>  >  	lrbp = scsi_cmd_priv(cmd);
>  >
>  > +	if (!ufshcd_is_scsi_cmd(cmd))
>  > +		goto clear_cmd;
>  > +
> 
> ufshcd_abort() already has the following code for the SDB path:
> 
> 	if (blk_mq_is_reserved_rq(rq))
> 		err = ufshcd_clear_cmd(hba, tag);
> 	else
> 		err = ufshcd_try_to_abort_task(hba, tag);
> 
> and ufshcd_abort_one() skips reserved requests. Hence, ufshcd_mcq_abort()
> is the only caller that can pass a device management command to
> ufshcd_try_to_abort_task(). Please handle this the same way for both paths.
> Either add the check in ufshcd_mcq_abort(), similar to the SDB path, or
> keep it in ufshcd_try_to_abort_task() and remove the now redundant check
> from ufshcd_abort().
> 
> If the check stays in ufshcd_try_to_abort_task(), please also update its
> kernel-doc header. That header says that UFS_QUERY_TASK and UFS_ABORT_TASK
> are sent unconditionally.
> 
>  > Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()")
>  > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>  > Reviewed-by: Bean
> Huo <beanhuo@micron.com>  > Reported-by: Bart Van Assche
> <bvanassche@acm.org>
> 
> Please move the Reported-by: tag above the Signed-off-by: tag.
> checkpatch also expects a Closes: tag after Reported-by:.
> 
> Thanks,
> 
> Bart.


