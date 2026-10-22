Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660068;
	b=wHYDwzM4zuctkTKhvMmcTgNiLj/x7Dkwjh9mv9hviKWfCt9yp+KAAMMIv9mSSzAoSJZF
	 Fxl3gW9tQPtq9ehVfLxuIh1HEENeTtbkw1iDBrAvxKLR6u9PKyN2q2lFCWA5U49nI1OLW
	 o/bwNwQ7lKsDAqnxMTVyRS01ByFzIBJchLNCSvfRK1OuOi66XX2CZgw/1GMW+nhkiWD/f
	 jUyD1XFI2aVwRloENpJ4D7cNp281UgIYALpxwZGNeDOFsfgCX6OVVtQE31o7Ld1Qx2Mo1
	 +N8Dy+WFpK9bW+DMN1TzQBQG96V7w7xPGFfMUashZ68EtE4hR5KgRUnsPMMEklneYfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660068;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-CACHE:X-CID-P-RULE:
	 X-CID-O-INFO:X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:
	 X-UUID:Received:Received:Received:Message-ID:Subject:From:To:CC:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MTK;
	bh=Xvw1TCpRGeBB4Vz9XHET5yoHPXFGZm3ITHOiEjPX9lA=;
	b=0bxJnjM6lrbMyTp+BZH8dZVoem37bslYauKn2TZHUowakq267TsxmJZeZLsMEfYanqxN
	 WPT2kpx6RMGluUs2GNmONdAWv+8hkHpON7zOHuyuoie8fHEveQcz73CrXP9BY54W69z5r
	 hmPVJTuIWxsXMrVBnG6wRYVNou1HtK28QzqdHXz/RdzfW6sAEDPZT7msJ0r1dB5QsfOFw
	 BNs4IQQzBZsmb1MU6ejgSHDnVRD4sEA6s5ORqL8DMJDpMSn5DJ251uqWZj9cRfMEhpgzy
	 dpnSLs3QNrT9JgNiVODe+Rc+63F2u/lepKBn3DUDSRiAHKmuM9FAlnahTULLmR2LkWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=JY8EWeAB;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73739606A31A;
	Thu, 22 Oct 2026 09:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73739606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=JY8EWeAB
X-UUID: 072f2d74cdf811f18dc8c9802ae25ab1-20261022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Xvw1TCpRGeBB4Vz9XHET5yoHPXFGZm3ITHOiEjPX9lA=;
	b=JY8EWeABFdBjtd1IBSsTitUlQPW9HYG1yXOn40KbBDvi8Cice6pGwm4/iJjgfAXdQG+mbwq8eafB8OnnRCzthZUrryeYjSXan2CBNcEi7t2hqUeAJmqqKOh5UlAKMYVsJwTXMWc/LUht46xlQ0j6F+w4sKXBgevPqCQXLE/3WW0=;
X-CID-CACHE: Type:Local,Time:202610221707+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:6a6071e1-bdab-48ab-9842-c961c6d4f298,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:390eeaba-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 072f2d74cdf811f18dc8c9802ae25ab1-20261022
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 443468004; Thu, 22 Oct 2026 17:07:38 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 22 Oct 2026 17:07:36 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 22 Oct 2026 17:07:36 +0800
Message-ID: <27530c7b4e3c0853c1e6b94095a2193e2df71e15.camel@mediatek.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>
CC: "Martin K . Petersen" <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Bart Van
 Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, "Bean
 Huo" <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Thu, 22 Oct 2026 17:07:36 +0800
In-Reply-To: <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>
		 <20261021040615.3566831-3-stanleyjhu@google.com>
	 <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
	 <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MTK: N

On Wed, 2026-10-21 at 08:28 -0500, Stanley Jhu wrote:
> On Wed, 2026-10-21 at 21:12 +0800, Peter Wang wrote:
> > If ufshcd_clear_outstanding_reqs(hba, BIT(tag)) returns 0,
> > should we also set err =3D SUCCESS? Since the tag is already done
> > =E2=80=94 either by the ISR or by ufshcd_abort =E2=80=94 shouldn't both=
 cases
> > be treated the same?
>=20
> A return value of 0 here means the completion path, rather than
> this abort path, has claimed the tag and may still be running
> ufshcd_release_scsi_cmd() after it dropped outstanding_lock.
> SUCCESS tells the SCSI error handler it can retry or finish the
> command right away, so a retry could map the same command again
> while the completion path is still unmapping it.
>=20
> Returning FAILED here also matches the check at the top of
> ufshcd_abort(), which already returns FAILED when the tag is no
> longer set in hba->outstanding_reqs.
>=20
> Thanks,
> Stanley

Okay, that is correct. Thanks for the explanation.

Peter
