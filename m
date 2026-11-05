Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793858352;
	b=ntk+mnRT3sZ7pT2q2A3Ci0JoUhq5E2LVsUKCPLJlceYE8gpLytm5qbRf0USvS0fwzzQ/
	 2ajLlqPyR6s8UQzKQuHTTPdRcTXdAZurTGmmMpHKs4fA3klVXKrn6NxJJJISj5LpztcUb
	 9BAemqLZeGqjBYJegx/XG1al+/zFcfNueXM+W+JPN5Wbsaty0N5AijJ80TomAJVHjVWxr
	 qqmg858qlQydD5urZ4lhfkXV+AtbwTBOtXCx4BNrRzjRJq+mD2wYkns7ykTrszJjRbd/L
	 F9Aa+4rlTZxsWghNGB0ph+gpbpLQI8GjDj+mY7FaxNv1SrmNvA/h3UzGFpeeXYmrj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793858352;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=/BbmuACGtbzAOpl3Wf0rhLYY2XYu/T/PZxVHApn7KDE=;
	b=La0eTRLErm64E7694MdUEW2eXnlONZm9prqMQJaRTmJYL3ROkfz9Ej1Zu9kYeh0LpWET
	 oqgMLlsCYQwADnNZxUl1mpDvkUeKjB7X5ITuM228AoOeAMuKqVQokO1He7SONNiFC0USU
	 ILSYBE+O1PYp0KFXv93C4s75yuAyeYOgtmBKHpsY6hM5FseyqDiyFxKue7CL/VDN9rg75
	 67etBu9/bpHv61Np8gbfqEviKQWQBD+cSdlY6vRR7S+8PhviHDJEZX8KEzMZqGBrNxVLo
	 TniL3crbZDjWc3RmzWJfM5Z/+gaLugjS0ChD5t4VYKvN7V1fqYd2S5XVJSpKvv2Sgsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BHPdM3W3;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C7A606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 05:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10C7A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=BHPdM3W3
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261105055907epoutp0100eeb18bb9ef59414c3f3f7d00eac990~lEKmuTC4a1029510295epoutp01f
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 05:59:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261105055907epoutp0100eeb18bb9ef59414c3f3f7d00eac990~lEKmuTC4a1029510295epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793858347;
	bh=/BbmuACGtbzAOpl3Wf0rhLYY2XYu/T/PZxVHApn7KDE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=BHPdM3W3dKPva3jJ3NKlkEh2HNsr/MVDXcQbKIS++terj2TL552zehirj5d/4CPv8
	 /351LhFmdlIUQiWJG1P5ATMpSxR0DRdpI4OsdUqFYoJ8mNoIUvOPJl8D4xIU25EW52
	 2lW26Tb0GrqL79jQGlAdEKwA0cZnR3rkXYJr3oYQ=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105055907epcas2p1cc414148af16714e99292f82a2d1c04c~lEKmPe6od0236502365epcas2p1J;
	Thu,  5 Nov 2026 05:59:07 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.212]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKs7t4tCgz6B9mL; Thu,  5 Nov
	2026 05:59:06 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261105055906epcas2p2520b4d9ab1ea8c31a5bedfef74718d69~lEKldGa211842318423epcas2p2K;
	Thu,  5 Nov 2026 05:59:06 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20261105055904epsmtip2cffb0098c2408ba424de81ba87e36e9d~lEKkWznHB1691916919epsmtip2Q;
	Thu,  5 Nov 2026 05:59:04 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<kwangwon.min@samsung.com>, <hy50.seo@samsung.com>, <cpgs@samsung.com>,
	<h10.kim@samsung.com>
Cc: <stable@vger.kernel.org>, <stanleyjhu@google.com>
In-Reply-To: <8939a53e-1b21-4dd9-b65c-cbe03b8b72ce@acm.org>
Subject: RE: [PATCH v6 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
Date: Thu, 5 Nov 2026 14:59:04 +0900
Message-ID: <003701dd6cea$c396cd10$4ac46730$@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH4JEezrlrww6xOutvb1msxx9OBXQGtTH96Ah1toR4BCq9oRLbC0xTA
Content-Language: ko
X-CMS-MailID: 20261105055906epcas2p2520b4d9ab1ea8c31a5bedfef74718d69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd
References: <20261105004333.1097899-1-kwmad.kim@samsung.com>
	<CGME20261105004353epcas2p1bd2370dd10156570c69f8f80da3cbcfd@epcas2p1.samsung.com>
	<20261105004333.1097899-3-kwmad.kim@samsung.com>
	<8939a53e-1b21-4dd9-b65c-cbe03b8b72ce@acm.org>

>  > Here is the timeline of an actual case for this that happened with
> kernel 6.18.
>  > =5B ... =5D
>  > 2. So after the query was timed out, the driver did SQ cleanup.
>  > Then the host updated CQ update and raised IS.CQES,  > Unfortunately,
> complete() was called the driver's ISR afterward.
>=20
> This timeline describes code that no longer exists upstream. Since commit
> 08b12cda6c44 (=22scsi: ufs: core: Switch to scsi_get_internal_cmd()=22), =
the
> device management path no longer calls complete(). Please describe the
> race in terms of the current code:

Let me add it below the timeline described previously.

> the query times out, the SCSI error handler calls ufshcd_abort() ->
> ufshcd_mcq_abort() -> ufshcd_mcq_sq_cleanup(), the request is finished,
> and the retry reuses the same reserved tag, struct scsi_cmnd and devman
> UCD. A late CQE for the first query then maps to hba->dev_cmd.tag via
> devman_ucd_dma_addr and completes the retry too early. That is why cq_loc=
k
> matters here. Please also keep lines in the patch description at 75
> columns or less.
>=20
>  > +static enum utp_ocs ufshcd_mcq_read_ocs(struct ufs_hw_queue *hwq,
>  > +					struct ufshcd_lrb *lrbp)
>  > +=7B
>  > +	guard(spinlock_irqsave)(&hwq->cq_lock);
>  > +	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
>  > +=7D
>=20
> READ_ONCE() is not necessary since the OCS is read with cq_lock held.

Got it.

>=20
>  > +	if (=21err && blk_mq_is_reserved_rq(rq)) =7B
>  > +		enum utp_ocs ocs;
>  > +
>  > +		err =3D read_poll_timeout(ufshcd_mcq_read_ocs, ocs,
>  > +					ocs =21=3D OCS_INVALID_COMMAND_STATUS, 20,
>  > +					MCQ_POLL_US, false, hwq, lrbp);
>  > +		if (err)
>  > +			dev_err(hba->dev, =22%s: OCS not updated. hwq=3D%d, tag=3D%d
> err=3D%d=5Cn=22,
>  > +				__func__, id, task_tag, err);
>  > +	=7D
>  > +
>  >  	if (ufshcd_mcq_sq_start(hba, hwq))
>  >  		err =3D -ETIMEDOUT;
>=20
> The SQ is still stopped at this point, so this loop can stop fetching fro=
m
> the hardware queue for up to MCQ_POLL_US (500 ms). Please move the OCS
> poll after the ufshcd_mcq_sq_start() call.

I didn't get what you meant. The loop just reads updated OCS periodically
and from what I know, it's based on the assumption that when a task is clea=
ned up by setting SQRTCy.ICU to one
and it's successfully done, the host updates OCS, even if SQ is stopped.
If you feel I get your comment wrong, please let me know.

>=20
> This code also waits for the interrupt handler to process the CQE. Why no=
t
> reap the CQE from this function? ufshcd_clear_lu_cmds() already does that
> by calling ufshcd_mcq_poll_cqe_lock(hba, hwq) after ufshcd_clear_cmd().
> Calling ufshcd_mcq_poll_cqe_lock() before reading the OCS would remove th=
e
> dependency on interrupt delivery and match the existing code.

Because a successful SQ cleanup leads to OCS update,
which subsequently leads to raising IS.CQES when MCQ is enabled.
I understand your idea with ufshcd_clear_lu_cmds, then do you intend
Ignoring IS.CQES event in this case?

>=20
> Additionally, does the UFSHCI specification guarantee that the host
> controller posts a CQE (e.g. with OCS =3D ABORTED) for every command that
> has been cleaned up? If not, this patch turns cases that are harmless
> today into a host reset. Please cite the relevant section of the UFSHCI
> specification in the patch description or in a source code comment.

This is the sentence that I referred to:
=22The host controller shall free up any resources associated to the nexus,
and shall post a Completion Queue entry with OCS =3D ABORTED if clean up su=
ccessful.=22


> Thanks,
>=20
> Bart.

Thanks
Kiwoong Kim
BRs.

