Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769762;
	b=gxFYcXI4Y9o2uHxtn7DSTMaDhps3ZDTWyVKicGC3ytRa1/vGiQV0MxA/rU//EmryvlHR
	 LCoQ+pG9Ypd8dXeerea5Wf698ebRfADjP0P0TZuvURpWseWwcMBbxWZBeSI2Nw9EEa0qK
	 VUvG76At39C/ALHFdZOyH+2Gso3twc+Ot6/bzwIlJduqaUNg9VSKktPMH5/+LutKxV/nW
	 0aXGwnVr12GOTzJxmJDyzZHy8p3axRt2/vZGwTgwKVowUD3Br0uIsXZtnJRex1r6e78Mz
	 oEOIVYL+QFpxMW69hUN6O6XhmWVVoZDSvHSn9B5NnRRdjglMGdm4CRyOp1ksXLaKnmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769762;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=HU4p+15+80Ye18LW21Qwrjg3TVjPohSwpa0SIJZNMDU=;
	b=LttnffZZ/nQmWYuMuig2nIMcYFHFyFUkdp2ImuGEk1vzxapEmhq/lFOCKNnP2zQTfIfo
	 plqE7g+2RrToN+lAOTFPTJ8mtR2vLKg15cXQZwBiBB/iPrNJTV7CseSZZi8muOTFJWobu
	 i7uqdJd6IR32a8LZdvLEBF0k13aa1QeHaLVnpFHp8+bzrfusNqfaRfs7OdSvThPqJShfb
	 CofZfrTBmW7fj84v5oPGuLextH+ozD5xJhS4BogA1fqnv4p7hE9jyQpaolUY/kR2pmt+D
	 DCDC9WIHG5RzS+m/1+wcgDK170+RluuLUH+QWCPsg6VGnepW9DbjIQZUY51FGTjYlLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ne4KdRHR;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B844606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 05:22:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B844606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ne4KdRHR
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261104052232epoutp0339d93edffaae06b5d43493acef622939~kwBYQI-9P0086900869epoutp03r
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 05:22:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261104052232epoutp0339d93edffaae06b5d43493acef622939~kwBYQI-9P0086900869epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793769752;
	bh=HU4p+15+80Ye18LW21Qwrjg3TVjPohSwpa0SIJZNMDU=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=ne4KdRHRdNHBuNlaCaTaTx8Aoegx7pu5JNZQCCv2LUvOfq5TjrJYAJ0VB01R/iOOs
	 hwnmhZD1oivbgnX2+ofucmTlvqh9zYnLRcLz5+KMCV8QVvQeT2QxC8iXCaiwpEkdYO
	 eYdn76FDQ8/UpQwHzVFHB8MB6lCc1558PQsTlgmk=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261104052232epcas2p1d09ba275c71bd2de1affc73a56d614cc~kwBX7FEfR0568105681epcas2p1c;
	Wed,  4 Nov 2026 05:22:32 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.210]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jKDN76Sp2z3hhT4; Wed,  4 Nov
	2026 05:22:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261104052231epcas2p2f5795904d91eaef272b48e6e323242f2~kwBXJydhh0965009650epcas2p22;
	Wed,  4 Nov 2026 05:22:31 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261104052231epsmtip12eefb7eb7b6fcfbc580539526a9a6945~kwBXG37VO0895008950epsmtip12;
	Wed,  4 Nov 2026 05:22:31 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <703c41b5-537f-4897-b852-fed4097a0193@acm.org>
Subject: RE: [PATCH v4 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
Date: Wed, 4 Nov 2026 14:22:30 +0900
Message-ID: <000a01dd6c1c$7d786830$78693890$@samsung.com>
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
Thread-Index: AQG/liA4KQmJMUor0I2rrPNxMaALVAGMm7eLAjQQascCmhUI4rcmFg7Q
Content-Language: ko
X-CMS-MailID: 20261104052231epcas2p2f5795904d91eaef272b48e6e323242f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261102055317epcas2p48b638d0c25fd024ce01960afd1e6dee6
References: <cover.1793598099.git.kwmad.kim@samsung.com>
	<CGME20261102055317epcas2p48b638d0c25fd024ce01960afd1e6dee6@epcas2p4.samsung.com>
	<8c4bbbd746e7fc1d8c27b6b87b2d684abb74a3b3.1793598099.git.kwmad.kim@samsung.com>
	<703c41b5-537f-4897-b852-fed4097a0193@acm.org>

> > +static enum utp_ocs ufshcd_mcq_read_ocs(struct ufs_hw_queue *hwq,
> > +					struct ufshcd_lrb *lrbp)
> > +=7B
> > +	guard(spinlock_irqsave)(&hwq->cq_lock);
> > +	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
> > +=7D
>=20
> READ_ONCE() is sufficient. I don't think that the spinlock helps here.
> Additionally, if the spinlock operations are left out, the function
> ufshcd_mcq_read_ocs() is no longer necessary and can be inlined in its
> only caller.
>=20

It seems like your proposal works in terms of reading OCS,
but I guess there could be a race at a nearly same time among different CPU=
s
because UFS driver uses the same tag =23 for device commands.

Of course, it would take CPU C long to reach up to clearing cmd->state,
so that what the timeline shows will be unlikely to happen, I think.
I was just concerned about the possibility.

Anyway, let me take your proposal to revise this.


WITHOUT cq_lock

 CPU A: ISR                      CPU B: Error handler     CPU C: IO thread
 ----------                      ---------------           ----------------=
---
 set OCS=20
                                   READ_ONCE sees OCS
                                                                scsi_prepar=
e_cmd()
                                                                -> clears c=
md->state

 scsi_done(cmd)
 -> cmd->state is set to SCMD_STATE_COMPLETE and test_and_set_bit returns n=
on zero
(cmd->state is already set when the cmd is timed-out)
 -> blk_mq_complete_request called (Unexpected)


WITH cq_lock

 CPU A: ISR                      CPU B: Error handler     CPU C: IO thread
 --------------------------   ---------------           -------------------
 set OCS
                                   lock(cq_lock) ...waits...
 scsi_done(cmd)
 -> cmd->state is set to SCMD_STATE_COMPLETE and test_and_set_bit returns 0
 -> just return
 unlock(cq_lock)=20
                                   lock acquired
                                   READ_ONCE sees OCS
                                                                scsi_prepar=
e_cmd()
                                                                 -> clears =
cmd->state

> > +		err =3D read_poll_timeout(ufshcd_mcq_read_ocs, ocs,
> > +					ocs =21=3D OCS_INVALID_COMMAND_STATUS, 20,
> > +					MCQ_POLL_US, false, hwq, lrbp);
> > +	=7D
>=20
> An error message should be reported if the above loop times out.
Got it.

>=20
> Thanks,
>=20
> Bart.

Kiwoong Kim
BRs.

