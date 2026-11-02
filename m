Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793582408;
	b=Idr4ZxDBrlcfDx4OEFU5pxOZaMjybta1PG/GNNnvwDh/WkRzol3t5NG/hqk21OYkBsoK
	 ZsnFg2Iax6u89sBBpNJnsRlkjGBxMtSOy4O4njXKBMXgjEf2teaOLiK3PsPL/Ybmpm1R/
	 lkrcitqWwLfQWTMYhS2aqxhpt+Of3qAhg2I727x+jGF0NW2mqvLqn+ufL0qP5tSgDcImj
	 MSxuvf4NVELxxnrx0NM0Hbi5clVAOaDpMlo/2O65RIcFse0RjowdJkIR7AgqtJrewcb34
	 6cuU7Nh7UmAH908K63iwdAGXXaGv1AQ9nDC8yrlu24/gcJLk1kdVFnkhMptiQCzc2Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793582408;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=45c0jE9HbkCdxpNTN8bnPDNo8QDvZYgC9R9p9K09uiI=;
	b=AgYdtTBhn3dyS/xRSEkjpcMrIUX9vkSGAtVe0f0vzrbYqt0FXC7Lmoa9LZg2kysSoXMt
	 ouWA95v8hUrkS3QAHRE3VJ7UUFX89uutYFcwqS3ZqHN/G/5tiKhF0u2Bse0Rp6idVlYX9
	 oaujatOhvCgm3LxE3ZM881rCM0rDqL8NoidC5+s65YNMF2X7YQDcCbWvvZiKkYXCv6AQP
	 NXuSnG2ggbgjXi4qh1O4U5eOTbs9C+IzpSr5hdEGRbOIEzGuAQWcI2cmatB9Lb1Oo4wvv
	 Cc0C99zgeSidvzpA1Jn72zx/LIfvlm7o+S0USCdwSBeRrcUBsjlXs+968i3rJhmJ7cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=TBpEvXw+;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FB0606A324
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 01:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9FB0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=TBpEvXw+
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261102011956epoutp0350a4f56e8431a46d9e19904bf73ab4a7~kFa-tbuEf1837118371epoutp03f
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 01:19:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261102011956epoutp0350a4f56e8431a46d9e19904bf73ab4a7~kFa-tbuEf1837118371epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793582396;
	bh=45c0jE9HbkCdxpNTN8bnPDNo8QDvZYgC9R9p9K09uiI=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=TBpEvXw+eQcHTgYbRPLCH7v3jCI+B0Rrm0JynVRSYTaIouxC1sdB1B9vXVr3lYxBB
	 YIQBIyDMArHp2CkRjDNWxwi5Ipp0zV2rgOjeZAwREoLv1KNtmKIfNB0tXAec8h5qCJ
	 WthrGvagwle40tS7Wqhn+Y8pHoiag6xdESiLt2W0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261102011956epcas2p4c07a8d4d77f017588ab97018446033db~kFa-apy1X1402414024epcas2p42;
	Mon,  2 Nov 2026 01:19:56 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.202]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jHv582yf6z3hhTF; Mon,  2 Nov
	2026 01:19:56 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261102011955epcas2p1eee400f7f34ac4f375b310edcf5e5472~kFa_teMAf2392223922epcas2p1V;
	Mon,  2 Nov 2026 01:19:55 +0000 (GMT)
Received: from KORCO164647 (unknown [12.80.211.160]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20261102011955epsmtip2f37bfb1c2eedea39030867a8cfaec312~kFa_oA2UX2236222362epsmtip2A;
	Mon,  2 Nov 2026 01:19:55 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bean Huo'" <beanhuo@iokpp.de>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <cpgs@samsung.com>
In-Reply-To: <101b87d76029565d274ae96d66c8a343cab910d3.camel@iokpp.de>
Subject: RE: [PATCH v3] ufs: mcq: fix dev cmd abort path and add OCS poll
 after sq cleanup
Date: Mon, 2 Nov 2026 10:19:55 +0900
Message-ID: <000601dd6a68$44e7d510$ceb77f30$@samsung.com>
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
Thread-Index: AQHS6DuEV2CopjC7B98uMO/T9TG5nwKNTbBWAxtTbRC3AbkXEA==
Content-Language: ko
X-CMS-MailID: 20261102011955epcas2p1eee400f7f34ac4f375b310edcf5e5472
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053
References: <CGME20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053@epcas2p2.samsung.com>
	<20261030111045.982094-1-kwmad.kim@samsung.com>
	<101b87d76029565d274ae96d66c8a343cab910d3.camel@iokpp.de>

> I think this should be two patches, each needs different fix tag:
Got it.

> > --
>=20
> I didn't understand why here there is =22--=22, this shoudl be =22---=22?
I just tried to separate two contents, but it seems like I made you confuse=
d. Let me remove this.


> this is another patch, and OCS poll patch needs a fixes tag too, for the
> MCQ abort support.
Got it.

> Kind regards,
> Bean

Thank you for your comments.


Kiwoong
BR.

