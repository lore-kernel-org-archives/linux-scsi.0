Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698099;
	b=PoODTk0w/P3TJoYhMWPpE1BpmbNxAgpVxQnsWXV6ouNXWnL8jbNSZ9l8Lxc6WgcWRnHn
	 t73ID2DnmUA71mcetQUlC04Eb1hCb2ymTYbl+KLHOZkjrqmOsc/X6+ELKnZx6ERUI05P3
	 rlgQ3lq98MSWkYTg2vJxEezqqMjwbzOfhlaUM4O2CmbO0azQ2sEcgTps83JOLbm+2+hZV
	 05+ZuupIITaBLyiwlG911GegvS/FEwh9Il6lybq3+kit3C/kn9mTvl6Otfp0SCD0tWQtu
	 0HckssKcjXkwM+sb47OHEtwZ+ljSQypbC5inytOqTxX08x4RVCqHpkCtjkGrVLofRig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698099;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=WUvvXrsa8EZV4ZQ48zTHQQIBWcM+QD2e7+pOO8N3CPI=;
	b=PQm/JidNmNCXBu07qN7fo6JjgwCieilBO6VrdkgfFUNrVQNg+sSXgvbFXq5kkchQJzDD
	 wiPRvYxOOn1YfX5vdOFpTTsVisRFUwFBOfH39sf79it4KqnYlYTz8HCWDLUwsezP9mmhf
	 J/gAGbrDSCYMaKSVaiKQtliJcp97mMIRFpiKIFiLOXk1XHFiNqwS1ks4ANFM4hj0QQisF
	 ph8CMKqgJ9v94saauUWsoofJvpA4W7IvuL4ytemTOc3pnHxMYdewQ9QYyTxgRp20q1R2f
	 T7gAS+y46oVujNU0+bfG8AOs0vygMbnFctValBVBhqXTW9fG4m3Pq6UypbRmGYczOcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Xc1E496O;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C77606A31E;
	Thu, 26 Nov 2026 13:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4C77606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Xc1E496O
X-UUID: 803a083ae99911f1a7aecdb2598be72c-20261126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WUvvXrsa8EZV4ZQ48zTHQQIBWcM+QD2e7+pOO8N3CPI=;
	b=Xc1E496O+z8bQRUhw/meNCbP5KI8N13tczDWPAJA2R+U2b13CwCHG9jnZCrFarBIlmBcgamf+6Rl8Y5CUrVWgcYXjYCEdl+I10RztC1dGdVJoi6Yn57bUHSnidjTAW2RpIPdfmFjnuCWCa0YYi5jTY6GDChRsGYckmXGKQub2O4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:7f10b2a4-c08e-4ce1-ac68-5501bc1313d8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:0624191a-ae4c-4a2b-b1c4-72e411efd0c9,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 803a083ae99911f1a7aecdb2598be72c-20261126
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1292803900; Thu, 26 Nov 2026 21:01:31 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 21:01:30 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 26 Nov 2026 21:01:30 +0800
Message-ID: <4cd159bd4204d92dc0d9a79e6f7aa53c1fa9f2de.camel@mediatek.com>
Subject: Re: [PATCH v2 1/3] scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on
 pre-UniPro-1.8 hosts
From: Peter Wang <peter.wang@mediatek.com>
To: <iasnezhkov@gmail.com>, <stanley.chu@mediatek.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<louisalexis.eyraud@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 26 Nov 2026 21:01:30 +0800
In-Reply-To: <20261126031008.27506-2-iasnezhkov@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
	 <20261126031008.27506-2-iasnezhkov@gmail.com>
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

On Thu, 2026-11-26 at 03:10 +0000, Ilia Snezhkov via B4 Relay wrote:
> From: Ilia Snezhkov <iasnezhkov@gmail.com>
>=20
> ufs_mtk_pre_pwr_change() calls ufshcd_dme_configure_adapt() on every
> power mode change, which writes PA_TXHSADAPTTYPE (0x15d4) even when
> passing PA_NO_ADAPT. PA_TXHSADAPTTYPE was introduced in UniPro 1.8,
> and
> ufs_mtk_get_controller_version() sets host->hw_ver.major =3D 3 only
> when
> PA_LOCALVERINFO >=3D UFS_UNIPRO_VER_1_8 (leaving older hosts at major =3D
> 2).
>=20
> On pre-UniPro-1.8 MediaTek hosts such as MT6789 (UFS 2.2, HS-G3 rate
> B),
> the DME write fails on every gear change with
> "dme-set: attr-id 0x15d4 val 0x3 failed 0 retries". While mainline
> ufshcd_change_power_mode() ignores the PRE_CHANGE return value after
> commit d3eba21c7170 ("scsi: ufs: core: Introduce a new ufshcd vops
> negotiate_pwr_mode()"), older stable kernels still discard the
> negotiated parameters on PRE_CHANGE failure, and mainline still emits
> spurious DME-SET errors on every power-mode transition.
>=20
> Return early from ufs_mtk_pre_pwr_change() when host->hw_ver.major <
> 3
> so pre-UniPro-1.8 hosts do not write PA_TXHSADAPTTYPE, and simplify
> the
> remaining major >=3D 3 branch.
>=20
> Fixes: 7212d624f863 ("scsi: ufs: host: mediatek: Fix PWM mode switch
> issue")
> Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
> ---

Hi Ilia,

Thank you for fixing this bug.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

