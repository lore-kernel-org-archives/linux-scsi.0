Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795763484;
	b=Dpk5RNvvzqTlpC4HFSRyyolaDRb5Axpibvvq5dlxRNfBIiYyVO19PViZW9LXaTok7Orr
	 StFy8E/v8G3A3c3soJoYF5i8jattG/Hlbrc9nQJ1oKTCh50qYB4/itOvm61bDV9ACIkfP
	 i5M4fpMic+0YMiPn3kXSU8DQKlE2qpJG3yH7r6HfYgYGyY0dDjYBByL69PGwQyp9RQJ0Q
	 tEicr5mMTN0559EkgRjBUvJtxbUv9pFFXlikXllqPUbPnfDNs1TmDbPRsygXznDagXKWq
	 V6c8Uj8Buo0/Ia/PFbyaIKll1BiHAdsbQ6rMmGqprAXbqBM2kLt0vD0YEOWe6+XPEqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795763484;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=3QOsyC3d/SLSTb/1ylJFJGSRibhbpTAj/BABfWdbacQ=;
	b=a3IL3oqfwEik9TQIs1DwCyl3+cbxe8Y2U45mr0/NRbGHuk3wRgz/e6PseQzdcwHC7CVY
	 qaQxdH3npeTzNDSRub2ofRN+Tch3gLIXHhM6eU/nYHWW4ZH26XWT57kSY7V5GB9zGZuAg
	 V8OnBrXt/viUN9tFT7HYQpV7W5B03+xmv5Qy0nBaBjRhNuZzD+FnlXpUj7ZheLywrFzv0
	 7i52lFYOnY8mTXcHKOzJk/w1i3gz48uv3T2tnE+f0nxpf40/Y4NVtbRjdHgYIVau/EHVk
	 hQcRMafWvPd1BN6zZF5TG7Dx0ITS6DGCY5B2opxEqx77EKogRSWnGTBpIVimLPv/1Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=KAyNRYEc;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68E606A31C;
	Fri, 27 Nov 2026 07:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D68E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=KAyNRYEc
X-UUID: bc18490aea3111f1b9cf3d4034dccee2-20261127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=3QOsyC3d/SLSTb/1ylJFJGSRibhbpTAj/BABfWdbacQ=;
	b=KAyNRYEc0yxSK1mEAif+XKz27wXZeW2TkzNp4Is/8C+yPUkd9E85iVjOKKejlArwpwyMWj889U/kPoGmRyMeJv1Dnw204fur2uQ6fxPaW3uJwYGxbfBQnuFkpy9t8Xm08VPu4NmmUon7j6q6idiLAg7bMqdwI5gLGoBXVkmthFc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:991cbaab-06fd-43bf-bbc5-31bd3059cd0a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:4de1db66-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bc18490aea3111f1b9cf3d4034dccee2-20261127
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1755776022; Fri, 27 Nov 2026 15:11:15 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 27 Nov 2026 15:11:14 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Fri, 27 Nov 2026 15:11:14 +0800
Message-ID: <57233f9eb3071e5393e2b4d84603303c0de39d28.camel@mediatek.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: mediatek: round scalable clock bounds
 to clk_round_rate()
From: Peter Wang <peter.wang@mediatek.com>
To: Ilia Snezhkov <iasnezhkov@gmail.com>
CC: <stanley.chu@mediatek.com>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <matthias.bgg@gmail.com>,
	<angelogioacchino.delregno@collabora.com>,
	<louisalexis.eyraud@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 27 Nov 2026 15:11:14 +0800
In-Reply-To: <179574206826.56397.7920531590189565888@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
	 <20261126031008.27506-4-iasnezhkov@gmail.com>
	 <00ba0aec941a72c8401eab7c3d4036caa2ae8aee.camel@mediatek.com>
	 <179574206826.56397.7920531590189565888@gmail.com>
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

On Fri, 2026-11-27 at 09:14 +0800, Ilia Snezhkov wrote:
> Hi Peter,
>=20
> It is not a missing hardware calibration =E2=80=94 it comes directly from=
 the
> fractional-N PLL PCW quantization against the 26 MHz reference
> crystal
> (clk26m).
>=20
> On MT6789, msdcpll has pcwbits =3D 22 and pcwibits =3D 8 (14 fractional
> bits, 2^14 =3D 16384), with VCO range 1500..3800 MHz, and
> ufs_sel_max_src
> is msdcpll_d2 (msdcpll / 2). To target msdcpll =3D 384 MHz (msdcpll_d2
> =3D
> 192 MHz) at postdiv =3D 4, VCO =3D 1536 MHz, so the required multiplier
> is:
>=20
> =C2=A0 1536 / 26 =3D 768 / 13 =3D 59 + 1/13
>=20
> Because 1/13 is a non-terminating binary fraction, no integer PCW
> value
> can represent 384 MHz exactly in 14 fractional bits:
>=20
> =C2=A0 pcw =3D 0xec4ec (967916) -> vco =3D 1535999512 Hz -> msdcpll =3D
> 383999878 Hz -> msdcpll_d2 =3D 191999939 Hz (-61 Hz)
> =C2=A0 pcw =3D 0xec4ed (967917) -> vco =3D 1536001099 Hz -> msdcpll =3D
> 384000275 Hz -> msdcpll_d2 =3D 192000137 Hz (+137 Hz)
>=20
> (With postdiv =3D 8, VCO =3D 3072 MHz =3D 26 MHz * (118 + 2/13), the
> closest
> PCW values give 191999939 Hz and 192000038 Hz =E2=80=94 still never exact=
ly
> 192000000 Hz.)
>=20
> So the CCF __mtk_pll_recalc_rate() / clk_round_rate() result for
> msdcpll_d2 is deterministically 191999939 Hz, which never matches a
> nominal 192000000 Hz entry in freq-table-hz under
> ufshcd_devfreq_target()'s
> exact `freq =3D=3D clki->max_freq` check.
>=20
> Best regards,
> Ilia

Thank you for your detailed explanation.
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
