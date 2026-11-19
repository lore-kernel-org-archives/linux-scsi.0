Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060476;
	b=2QUd4Z2vKnr66J9MGwhKXnjQAeP3g4EDoe8Ypa+lkkvI3X34n1ng9yRqyxVXIsW9Qn3Z
	 /w1uWamtm/QwX7V6fNg1v/aKb3d3O65IvQCxqVDWkh9jOjoQ5BELoQK3/kODlDYJ1n3vC
	 ifKPVjD0tWRkRAW8oCgAxMUW9fIP+msZ8/3AMtj8xhJ1Ecq9zQamQW39eN7F/XAt1ZwuK
	 svJ8K+s5zAbWykU5xtCQPXvPKzkWGxPxUUOrqQfkrw4DxBi8V4mTQD9H3wxnmdOwzA/eJ
	 bVtgawy8URylWXiVX8zpNXAGCwSzE5KPYD1xPbspNaxdk/SvBbYQ/qJXhsdVgAyMHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060476;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=mOW7wpw7pclv2woSYadjIG+K3Lf/RuEbJvV+kxBzPXI=;
	b=bYwFVjPSbTKMfSAo30NDcHTnst9Dd5Jnatm/N01grvbC+z0vvOHlcULaROJv+5x7cdpe
	 vGyAC8S4226Q2+Suq7Yd/1UqxIngBm/mndAve4nQFrYynPqhAUXNc1zPDIJMjWQvwbvUg
	 7xa6tcXzSdmlQjpJ+9gYVd0SqOt/nfmVZuuGcgXZ3jvMjPqbRrq4rNJoVJ70TsprRdLfr
	 nJ7v1hbFbnIKopQOjDdoee0fjXRlidreaMlK9z+BawfsfNITkxhPDMZ1L7O1SNhDSV2bN
	 mcnqe00DWk/wgpYTfvZTppx6JkMerZ63pVtWAJG1u7jn9132jMXUOcMR8EeDlQnksYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=pDabrebX;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B261B606A330;
	Thu, 19 Nov 2026 03:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B261B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=pDabrebX
X-UUID: ec518188e3cc11f18dc8c9802ae25ab1-20261119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=mOW7wpw7pclv2woSYadjIG+K3Lf/RuEbJvV+kxBzPXI=;
	b=pDabrebXJUxCMWehX64IETRX14jtV66wlrIxOlPbhrEt48/31phBfP5K+xXuwk1BRmvZL5I1eMr+Z7NrX/Eck5qlDfLYA5m3KG/CjzdBJhrfqq844TVlg0dmZWw61HlP55ott1gW/nicPlkyMcXY6wpSguzLvqmJQn2UHPWGfZw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:1fca2fb0-5a42-4770-94c5-2313d5ec51ce,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:55ea0d31-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ec518188e3cc11f18dc8c9802ae25ab1-20261119
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2002578042; Thu, 19 Nov 2026 11:54:30 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 19 Nov 2026 11:54:29 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 19 Nov 2026 11:54:29 +0800
Message-ID: <403821fa1be0c7ec5c0b2c0235957bfa9818fd7e.camel@mediatek.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs-mediatek: use devm_regulator_get() for
 the va09 regulator
From: Peter Wang <peter.wang@mediatek.com>
To: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>,
	<chaotian.jing@mediatek.com>
CC: <chu.stanley@gmail.com>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
	<stanley.chu@mediatek.com>, <sashiko-bot@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 19 Nov 2026 11:54:29 +0800
In-Reply-To: <20261118032015.974-2-laixiangwu@cmss.chinamobile.com>
References: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
	 <20261118032015.974-2-laixiangwu@cmss.chinamobile.com>
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

On Wed, 2026-11-18 at 11:20 +0800, Xiangwu Lai wrote:
> ufs_mtk_init_va09_pwr_ctrl() obtains the va09 regulator with
> regulator_get() but the reference is never released with
> regulator_put(), neither on driver unbind nor on probe failure. The
> other regulators handled by this driver (dvfsrc-vcore) are already
> obtained with devm_regulator_get_optional().
>=20
> Use devm_regulator_get() so that the reference is released
> automatically when the UFS device is detached.
>=20
> This alone is not enough, though: ufs_mtk_init() powers the M-PHY on,
> which enables the va09 regulator, and nothing powers it off again on
> the way out -- the variant operations have no .exit callback and
> ufshcd_pltfrm_remove() only resumes the device.=C2=A0 The devm release
> would then hit WARN_ON(regulator->enable_count) in _regulator_put()
> and leak the enable reference.
>=20
> Balance the use count by adding an .exit callback which powers the
> M-PHY off, in the same spirit as the .exit callbacks of ufs-exynos
> and ufs-qcom.=C2=A0 ufshcd_hba_exit() invokes it both on driver unbind an=
d
> on ufshcd_init() failure after the variant init, so the enable count
> is always balanced by the time devm releases the regulator.=C2=A0 It
> relies on the state tracking in ufs_mtk_mphy_power_on() and is a
> no-op if the M-PHY was never powered on.
>=20
> Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator
> operations")
> Signed-off-by: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
> ---

Hi Xiangwu,

Thanks for fix this bug.
Reviewed-by: Peter Wang <peter.wang@mediatek.com>


