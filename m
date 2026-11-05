Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793838928;
	b=cd3gPVsbX8+UerdLrY/AY8SLeoqval6YTwKqA+s/A9Wtx+U64I5+pIcbiBLbjs6+Wita
	 itzhnZqvxLoqAK9KjJNRnlq3W0X1I1Acp1L2KUjkerrXOgC5TTbVzeWgfoE4M2H0FMC9Y
	 Hk5XPgajGOyuyU78+qYJE5NkgL0OmhbPfV1lDpE5f9cWuca9XBdGhVIoA+uqyqTSXJg5f
	 1vIaPiYhZg2xUXTOWPk7lfdahCjZSBnGpzKwr2fdZM1Amd0x+z8A/gDD11lGMSGtEj/N8
	 qbqpYpA4aMDJxs5fKLk2vth7vfdkOut1GE4vyIBsI2Xy0Z+HFgE7IVsgS17qjqylNwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793838928;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Content-Language:
	 Thread-Index:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=S5FsX/NpSuBPUfyvK8I/2kDkIUhUpYY48W0NYhcJ9ok=;
	b=OhLh1ohEkJ1IGtxiGeMtfjXQ2jQJN9GpuD5t/IUo5M6L9j2GHzjADUY3jHE2UjFoIQbJ
	 Fs8OWjSsWti9GQeLq+y4p4aLZZPGlJuUF6DSKSsgwxb2kCMEP5Mz32w1cz5FCUo/uvUZF
	 iohF6B52JyEnV6jM+Y793uLQyNzCg6iRVGxuNe9123e9SnVhW0ocnp3MskZcgbsjhWnUO
	 Wz8FTYVl8HTmcaPXEDVxXT+/3mPYFNkHq6oWAcQy4UAaKIkcAFpCLqHTTrcGgdnD5xr1U
	 EIdU4jOCqlz5dcw66V1AAe9Er9JpbUpqxPQ9ydkIkfmfJu/+kmShFesI9Q9RkYE5Jqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=h8GG4q30;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85044606A326
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85044606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=h8GG4q30
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261105003523epoutp0308e057ce4d973a948fb3e33039a0d010~k-v8w3H_-2824628246epoutp03q
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:35:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261105003523epoutp0308e057ce4d973a948fb3e33039a0d010~k-v8w3H_-2824628246epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793838923;
	bh=S5FsX/NpSuBPUfyvK8I/2kDkIUhUpYY48W0NYhcJ9ok=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=h8GG4q30teZCPxWbmU9pKD4p7SIEmrYlVKTW4zxhS/orvLVlMo1ec3+OEVOzrQyv8
	 lRxlIXnMaeRaswxS+fhMuMxN9CSZ/5okN5nI/xxUGwOy6DyDTeEPrCA41s2ywMlvdE
	 5THJP5tdvHd7QnXF+rk9ydyENRICQ9UzByXD6e80=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261105003523epcas2p4f4eb3c90c46d192fde2dfc4c739111f5~k-v8kq8AP0670106701epcas2p4A;
	Thu,  5 Nov 2026 00:35:23 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.208]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKjyM16FSz6B9m8; Thu,  5 Nov
	2026 00:35:23 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261105003522epcas2p1ae8b638bd53e74036ffbbd19f998a01e~k-v76pJOk2758827588epcas2p1R;
	Thu,  5 Nov 2026 00:35:22 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261105003522epsmtip1624cbbe1f0c93f2311b9856d2bf297b3~k-v72_icw2781227812epsmtip1J;
	Thu,  5 Nov 2026 00:35:22 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, "'Bean Huo'"
	<beanhuo@iokpp.de>, <linux-scsi@vger.kernel.org>
In-Reply-To: <d6b1da22-2a18-4966-83df-86cb9031fdde@acm.org>
Subject: RE: [PATCH v5 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
Date: Thu, 5 Nov 2026 09:35:22 +0900
Message-ID: <002d01dd6cbd$8aca10a0$a05e31e0$@samsung.com>
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
Content-Language: ko
Thread-Index: AQIWK9ALGATMX/ikzj5TTpeWtbxQmQGBABm1Ac320hYCyYvt5ALSlHSKtmXKivA=
X-CMS-MailID: 20261105003522epcas2p1ae8b638bd53e74036ffbbd19f998a01e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261104094925epcas2p1f25905de00c2548e1e1349fba5f18551
References: <20261104094914.180788-1-kwmad.kim@samsung.com>
	<CGME20261104094925epcas2p1f25905de00c2548e1e1349fba5f18551@epcas2p1.samsung.com>
	<20261104094914.180788-3-kwmad.kim@samsung.com>
	<41f787035d4a5d68b403bb0f443fe6ab533ff1ca.camel@iokpp.de>
	<d6b1da22-2a18-4966-83df-86cb9031fdde@acm.org>

> > READ_ONCE() is enough to read OCS, but the lock also is to make sure
> > ufshcd_compl_one_cqe() has finished?  the window is very small, and
> > the lock only costs something on this error handling path.
> 
> I overlooked that lrbp->utr_descriptor_ptr->header.ocs is what is being
> polled instead of the OCS field in the CQE. Kiwoong, can you please
> restore the code that obtains hwq->cq_lock?
> 
> Thanks,
> 
> Bart.

Got it.

Thanks.

