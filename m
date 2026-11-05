Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849766;
	b=iQRUFlXGwWphVMg4JWYSym3N7X1QnfcFIwPdsEvEBAQSVv4aDX9oUM2yCcbD8MDFVvSK
	 yDimrPxska9wc15D0Rhqek0dIAPZq0sM+bzCz5S+PKr6xC8nGg4fctXVOOeUcVx2bX4Bd
	 br9ZxAtpI1R6dQ43U0f3IZG36UD+eDAhsTnQPcN7u/y39CMMtHhbNV12449HC2edtFs3j
	 YWLwPtJznZ1BbylK87fzOJ0jEMCtc6ij4Unjcgn7guupkbUL2WYjJbzNUWpyiMelfq/5h
	 rrkumKDU4CzV2FT3e67obktQEA3l0kHFC5KBH1mi7FHJGHHUhrcnYvWpoM+gcqFMCOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849766;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=/UkOAk105tSeqwzWa7vSrP7Yqx4TdmyROC7jJQ7HWUo=;
	b=LNW2Ri3+fJzIf7iLEubtNItkYxNnX/RJwRF/UJTwbX8htelO1Vj4ppA1aKL5enyX8OKJ
	 3vvDiL4dYKjINhrnzT1C7RzR8wLf1Ae3CV1uZKqsaIK1L8velLvyq2gAhrxtfIC7xaf6T
	 8uzbFnAKhlIyo0L2THCzHLNjcs504LhRm3dGWJfgpZGePTvW6PKQ6iJ93grAP/OJ6D63g
	 4mx43WYk1m6UeNDXVMh7sVqFbv/i4iWTBRFphXkPqlfHwtTco4MPKF38G/JSM/XB1ia3w
	 6RordoNJIz2CzaR35M7MBK0p9xPa7CHsbQBsC9Hib2XqaGie1iw9v8jsiU0gAZ4GI0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bo9was7f;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CBC606A32D
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85CBC606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=bo9was7f
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261105033603epoutp032a096e5f400d987cdb9c3543f725cc4b~lCNsBNgIT1020010200epoutp03L
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261105033603epoutp032a096e5f400d987cdb9c3543f725cc4b~lCNsBNgIT1020010200epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793849763;
	bh=/UkOAk105tSeqwzWa7vSrP7Yqx4TdmyROC7jJQ7HWUo=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=bo9was7fuGordlkA0Lzi06yPAGg8O/NbJB803BfzMdHxpwEz/pp+8i0xoT7P0J+sj
	 2uu5BO5L0jHAbnabvRy1uIFvbwCb0qTdTiCQRGD6fkLqEkGQsy9wTXjlMUZu9uBf5g
	 R8AqtbtW684q6meRdnbwWQfmWKEQlySWmPcR7g5M=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261105033602epcas2p39bd058f27805180bbc2929b158cd8730~lCNrRt4f61904919049epcas2p3K
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:02 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.205]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKnyp15tGz6B9m5 for
	<linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261105033601epcas2p388c17157b9467e7be73322cf1a9be0f2~lCNqeIy2t2423324233epcas2p3T
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:01 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20261105033601epsmtip2331483cea2e8bcc86c9f082a7f8bc78b~lCNqcvNI70193801938epsmtip2E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:36:01 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: <linux-scsi@vger.kernel.org>
In-Reply-To: <8446dc27-9518-4b0c-b9e9-116458210616@acm.org>
Subject: RE: [PATCH v6 1/2] ufs: core: skip ABORT TASK for device management
 commands
Date: Thu, 5 Nov 2026 12:36:01 +0900
Message-ID: <002201dd6cd6$c77249a0$5656dce0$@samsung.com>
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
Thread-Index: AQH4JEezrlrww6xOutvb1msxx9OBXQK0O2N1AUyogGgCjTU/mba08/nA
Content-Language: ko
X-CMS-MailID: 20261105033601epcas2p388c17157b9467e7be73322cf1a9be0f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004352epcas2p307ea40aadb636015545cee6e79470a03
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
	<CGME20261105004352epcas2p307ea40aadb636015545cee6e79470a03@epcas2p3.samsung.com>
	<20261105004333.1097899-2-kwmad.kim@samsung.com>
	<8446dc27-9518-4b0c-b9e9-116458210616@acm.org>

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

Got it.

Kiwoong Kim
BRs.


