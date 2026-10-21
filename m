Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588346;
	b=EN3Y8gPutyNJyDhLrp3eSyioIt2LYSWxkeYx79uKLDWDpyyOg462j+v0gJMThT0rxnzH
	 DjB9LnfH13YbdDPWReAXMPzXrv7PGp1+mGQJ87lab/YZNDJNO7u9miCi9u67Y5pBk4r0X
	 CbnTfqHE6LcC9EUj6/T0WyHXBnXN3NR15WqkMdbp9H5UYru/ktr3SdARsdjjAZOHmxBBd
	 82abenQ5cdvR9oA3sI68/HfWy9M4oJwVk6bCsvNxGW/lquizPlnK1cGXAV0la2fwqK0Kg
	 RAjMhV+AZbziRC4wc8ZOWTrCKsIk031q76wKuP3VZ2LSIKfoj80s2TRvHmmSMDXqnKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588346;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=CCh0SxW270xNtSQFDeYWJHsYl+K2m/EyLsKL3nFhjpE=;
	b=w6KhWv71odxrNVipMd8T/bb9jN+zs/mXkDsuPTkl/YGinqNV1di8blED95atnnKopS4Q
	 iE5fWknTElOwaHk8vaOmhqOjmm4JyXfTCwvTssV6Wbhqs+P/bXclmZAXP59QbZZQvHQCj
	 PRG4sbmzzKC6+iijDdpZHreC8dyRPRcMRR4p10e6IpbMmMJGPKpgJY8YR5XMKJnn+BEcf
	 9s6xCuIxXSJXkiofWzmg07WeT3OMOtEMK3jKc4S92WvI/HSa3OufSMEyn/dgU+5QjIEq+
	 +p3YtcU1cQN3UIVERcuUW/0yE0uJEqbiV8JR0x4HiMHYLiYbhSSNojsmDpr7Lo7IwVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b="MGo9/OMR";
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B884606A319;
	Wed, 21 Oct 2026 13:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B884606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=MGo9/OMR
X-UUID: 0bae4332cd5111f18dc8c9802ae25ab1-20261021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CCh0SxW270xNtSQFDeYWJHsYl+K2m/EyLsKL3nFhjpE=;
	b=MGo9/OMR/V+PqVX95MehQ0ej0JAaWzYfLEwq/t8PrAgSlieKylcXPbGkUg6Rr9gSe+B4thovW+7QluIqb+MdMcxfa521UgqkWgAeVdM6N++qP5HjALjsD1xlaqRT5ejng+Ke6jtKIPLNR2rkKEcytGsd9DcHPgE5bCnrTKYiEVA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:b86e346e-8200-440e-b6d8-4a97220fba96,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:d2bd46ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0bae4332cd5111f18dc8c9802ae25ab1-20261021
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 3608404; Wed, 21 Oct 2026 21:12:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 21 Oct 2026 21:12:18 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 21 Oct 2026 21:12:18 +0800
Message-ID: <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart
 Van Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean
 Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Wed, 21 Oct 2026 21:12:18 +0800
In-Reply-To: <20261021040615.3566831-3-stanleyjhu@google.com>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>
	 <20261021040615.3566831-3-stanleyjhu@google.com>
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

On Wed, 2026-10-21 at 12:06 +0800, Stanley Jhu wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ff5977f7da68..4f9b34c1d112 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8185,7 +8185,11 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
> =C2=A0		dev_err(hba->dev,
> =C2=A0		"%s: cmd was completed, but without a notifying
> intr, tag =3D %d",
> =C2=A0		__func__, tag);
> -		__ufshcd_transfer_req_compl(hba, 1UL << tag);
> +		if (ufshcd_clear_outstanding_reqs(hba, BIT(tag))) {
> +			if (ufshcd_is_scsi_cmd(cmd))
> +				ufshcd_release_scsi_cmd(hba, cmd);
> +			err =3D SUCCESS;
> +		}
>=20

Hi Stanley,

If ufshcd_clear_outstanding_reqs(hba, BIT(tag)) returns 0,=20
should we also set err =3D SUCCESS? Since the tag is already done
=E2=80=94 either by the ISR or by ufshcd_abort =E2=80=94 shouldn't both cas=
es=20
be treated the same?

Thanks
Peter


