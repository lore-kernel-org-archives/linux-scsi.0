Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698263;
	b=0Eb+yGnCd/jfUuY/dYk9BZb5S3tOkp4AueMK3s51k+rnklYhMCD8vDhMcnYH5mU7D/2q
	 +dAuulKTN+cROrCj9+jfpOWwgEDYC99LIZ/CAaBCVeEwsq/rHEirev33v5IdgO8lxc+5C
	 IJ1KxGFfZzNookB01+SkvkG8Jc5v3y87eHAmuGdMWqXxuBoXakD+JWMSx+hM/O5jqLWjj
	 JcTrEuT2/0mX5XcBbrUGAT7frjm/5h+23wiAUUtfSgJFw9g5zJsaEKi+mtgxm65txWN1H
	 PTQhvSi5jLz1A+3FvRgbkg6QiNJKGGvqGAlxPg9MriuHGwt6euz/HJVTqEbWHjEnT9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698263;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=hBziOhEO/OH+Ym5ctOfF/18skeWTikMOhZou3O33X3M=;
	b=AArUyOV8tp08On8QxnK8DiYKFNYgJ0AUN4GakDXFrWc19RCi+YH1grGVbmFVVpz+QTtO
	 KA8aWK4itpRowHP3xZDJcJf/OasChSE6LBADKde6UqlbZ/bX4QHEmcUWPuy41g0hDKzd3
	 7O8e/TyLk+5Em2V3RvWUYnZXPtF1Xmr8jREhUehXsD/SCsoJuiOrBONxI8AaBqQzoAQWE
	 wF9uJEmaxXJ0pDcFExaHQ0FmnAvjI0UFxO8Cra9GL7cEMqDtFDafegs1wXJHVAQoVbT7C
	 sLCG8cIzPlC5ejybdcgT2Xk2iFE7MxE4NQ5frVuY8pdHpoTJOknCu7XF7/9F+KO3HJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=cJVMXjQ7;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A23B606A31E;
	Thu, 26 Nov 2026 13:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A23B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=cJVMXjQ7
X-UUID: e253bdfee99911f1b9cf3d4034dccee2-20261126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=hBziOhEO/OH+Ym5ctOfF/18skeWTikMOhZou3O33X3M=;
	b=cJVMXjQ7nRMDX5XETRN2MUOWAdY/VSHJcoqPUC4+YG+2joxZtqyR4HUKxZg8ioqpHx06AZ+x0K2eMUmntfetWv3T3kPIDUZIlM3ISQNj/II911ToQjyauZrwCkEZVT3vJU8KesiS38FbopI+3ZVDAHciEa871HypQVv0wzgFTOg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:aeaffbcf-2238-4158-b400-fe0e21b70ce7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:5b846131-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e253bdfee99911f1b9cf3d4034dccee2-20261126
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1573809449; Thu, 26 Nov 2026 21:04:16 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 21:04:14 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 26 Nov 2026 21:04:14 +0800
Message-ID: <00ba0aec941a72c8401eab7c3d4036caa2ae8aee.camel@mediatek.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: mediatek: round scalable clock bounds
 to clk_round_rate()
From: Peter Wang <peter.wang@mediatek.com>
To: <iasnezhkov@gmail.com>, <stanley.chu@mediatek.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<louisalexis.eyraud@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 26 Nov 2026 21:04:14 +0800
In-Reply-To: <20261126031008.27506-4-iasnezhkov@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
	 <20261126031008.27506-4-iasnezhkov@gmail.com>
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
> ufshcd_devfreq_target() determines scale_up via an exact equality
> check
> against clki->max_freq after rounding the target frequency. When a DT
> freq-table-hz lists a nominal value that a PLL-derived clock cannot
> hit
> exactly (for example, msdcpll_d2 on MT6789 delivers 191999939 Hz for
> a
> 192000000 Hz DT maximum), clk_round_rate() produces a rate that never

Hi Ilia,

I am curious why the HW generates this value of 191999939 Hz.
Should the HW need a calibration to generate exactly 192000000 Hz?

Thanks.
Peter

