Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795698191;
	b=XXmFGXZC9NqVs7Plc64HMCj/DanYt2ujocs4RrVdsdRWAFfxwv6dJjYDgNKIMD7gIPmm
	 1Qz6ElUHpcps6QN0D9Zluyt6AIPWBGRtRAdeYDu4VGmh51S75i4y+wzJJaXF5Zc/HFN6S
	 MIqO+g/ifoG866laBj2Zarj9cd5gCEWSNcySPu/26MEeguDS8WXAJz6W1Ec5ZLBRsE+2T
	 n5LzF/Y9yc9Ret0FLWzU0FZX+4AWkU+Lk3jfUrsMA6fCrGQaJJAtLCh0dC8W0XFm2IbdR
	 BqSm1M33cybIAkWpliULkYIWD8ppfMXMbJYg5jrwOUL9tWUpL1BbM49Cgk82OKbr+sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795698191;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=Fa6NXrsDozB7gjepeSR0YoULRjFFJmjFRwH3pYoOlpE=;
	b=4/deXhPQ7N9jz9sH+QZ6b+Os2PGAtTQRZXkGYF2rVGDb6qlJndJ+2dSKNblkb1gt1+W2
	 DDvtwg1+Bi9CRpKYNcCwDii+PPm+UPr52bmERutWITaklfJbG43DwPIdF/cZ5soSYRxI+
	 qJYG/vjJCV+aELWVWBLmsGJ3iJBBHWq78MWLyv4EwKGwufpVka88cy73tEbGpJnUv7YUT
	 L9FL4kUm6Vu1BfRDBFjSnUVovJDunrYdjpX5RToIdZuKF/9PBS9n/pBvVFRJDKL93oAit
	 TIUUvMjhZiFvixGVrTi/xUjOJDnaBDyFLln+mRW/OYq6Va5geZLJ/cnVor1it3KMOPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=L9sZyiyH;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F48606A31C;
	Thu, 26 Nov 2026 13:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3F48606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=L9sZyiyH
X-UUID: b84950f0e99911f1b9cf3d4034dccee2-20261126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Fa6NXrsDozB7gjepeSR0YoULRjFFJmjFRwH3pYoOlpE=;
	b=L9sZyiyHsr3q9lywOqwHskdf/OW4mcIlcfaEkOM0KkwjKgi13ujvS0dVN1wuysk1/OlHufb3ETvCCuTYxB61n4FeuhTDwzr4vsFiW53cplED1fKK0h1nl+8FKM7YdrootPr4ZrcGPPqOok6WkIR3GKo1ce71IgD1wb1UeaqGg50=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:5d6a261f-39be-4ed2-8af0-2caa2ed6974f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:a4a2d266-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b84950f0e99911f1b9cf3d4034dccee2-20261126
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 287361875; Thu, 26 Nov 2026 21:03:05 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 21:03:04 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 26 Nov 2026 21:03:04 +0800
Message-ID: <7b7d94ab4283b82aec13eae3f9c1d2e77873d88f.camel@mediatek.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: mediatek: allow clock scaling when
 ufs_fde is absent
From: Peter Wang <peter.wang@mediatek.com>
To: <iasnezhkov@gmail.com>, <stanley.chu@mediatek.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<louisalexis.eyraud@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 26 Nov 2026 21:03:04 +0800
In-Reply-To: <20261126031008.27506-3-iasnezhkov@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
	 <20261126031008.27506-3-iasnezhkov@gmail.com>
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
> ufs_mtk_is_clk_scale_ready() enables UFSHCD_CAP_CLK_SCALING whenever
> ufs_sel, ufs_sel_max_src, and ufs_sel_min_src are present, treating
> the
> FDE (AES) clock as optional. However, _ufs_mtk_clk_scale() bails out
> early on !fde_clki, so on SoCs without a ufs_fde clock (such as
> MT6789)
> ufshcd believes scaling succeeded and updates clki->curr_freq while
> the
> ufs_sel mux never switches parents.
>=20
> Only require clki (ufs_sel) in _ufs_mtk_clk_scale(), and gate
> clk_fde_scale on fde_clki being non-NULL alongside its min/max
> parents.

Hi Ilia,

The logic is basically fine, but I'm a bit curious:=20
would this change cause MT6789 to enable UFSHCD_CAP_CLK_SCALING?

Thanks
Peter
