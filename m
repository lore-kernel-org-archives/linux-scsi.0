Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761906;
	b=OokcBeMFKZFHNZSmeaOcRDC959OS+0nmZQszEVeC2W+Km3fF00oboh3rkFhwUOP5LXcn
	 mWYht2CIZVl/SA/X0TVFX/ucuLlzWeH7qndjHBIEACklMCYcN19ZrOCKVivbMk9oyvKFE
	 mz3EJTHSpUwMoQcNe5yvZ/WHRbCB3o3oUJ4DXErJFS99yKebViMJD12svLBuaKUX62FuK
	 uBwpU06Ac108NrjGAt4AEkLi0Jdy/AzIX/WZLiUguB1NxgZ3T+jyPeQNJZyfjmQ99vX2O
	 zun5ooB5d+jzMM21YdEd+aa/q9Qlv5Sg9HXCdl7jQAURg+ZTxk70pnl5bkTyeTCJjPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761906;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=773F4lyJ6saT/RbUKk1mmsiaJd9WVNhH/WCIiJ+eX08=;
	b=phcCJEauviwYzW3368zdA4+lWLhFsrg/5CZdzADTO0vcwXH04EBxhURGu6QPIU6vdAXe
	 /iOJRIwq24dw/J1X+JvVq1bKwU0/L6F9e9EDB5yP457dzs6mDm/UQrmEPWkHHb6ghKtgA
	 gPygvYBb3C0Xg7wUcxQSE+s3nbxPnDyfJ6No56iSiKygiMZk4+w8cvk5DJmy71CnI/uys
	 UxYYv/VaXsWOVFV6InNgqYh7O94kJsamPtsXmx/4vJPIKIuS0JUG3NwV9So6NOuFu+Ijj
	 O7LErMohzYZELIe6vY+rBgz98XAhz2diXis6TBa1/UWO55/apczEspevtpk7x3OSSaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=o+SPqwlp;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E70606A321;
	Fri, 27 Nov 2026 06:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10E70606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=o+SPqwlp
X-UUID: 112e51eaea2e11f1a7aecdb2598be72c-20261127
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=773F4lyJ6saT/RbUKk1mmsiaJd9WVNhH/WCIiJ+eX08=;
	b=o+SPqwlpszB1NcPgKkLn4CW3CLu0BLqz2CkpgkOdTkqWeVRgTsL9HLb/MyJNO6UAnnsYxC51wefBb0cATYqEIGXJxmAIC3Rk3L+jKlyKFqRhHzMSeSiw654003/cxAdYkA1sCm73dv4L6ogl83l5TInl1Ekpkx3m1dXCpHCJL1g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:1c583b22-d2ff-4680-8cb9-6840180f1726,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:177edb66-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 112e51eaea2e11f1a7aecdb2598be72c-20261127
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 539966578; Fri, 27 Nov 2026 14:45:00 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 27 Nov 2026 14:44:59 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Fri, 27 Nov 2026 14:44:59 +0800
Message-ID: <484a58e10c4bc9cde24ef731a4bd3051b9decac6.camel@mediatek.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: mediatek: allow clock scaling when
 ufs_fde is absent
From: Peter Wang <peter.wang@mediatek.com>
To: Ilia Snezhkov <iasnezhkov@gmail.com>
CC: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<louisalexis.eyraud@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 27 Nov 2026 14:44:59 +0800
In-Reply-To: <179574184161.52486.4990124402659702610@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
	 <20261126031008.27506-3-iasnezhkov@gmail.com>
	 <7b7d94ab4283b82aec13eae3f9c1d2e77873d88f.camel@mediatek.com>
	 <179574184161.52486.4990124402659702610@gmail.com>
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

On Fri, 2026-11-27 at 09:10 +0800, Ilia Snezhkov wrote:
> Hi Peter,
>=20
> No =E2=80=94 this patch does not change whether UFSHCD_CAP_CLK_SCALING is
> enabled.
>=20
> ufs_mtk_is_clk_scale_ready() only checks ufs_sel, ufs_sel_max_src,
> and
> ufs_sel_min_src, so on any platform (including MT6789) whose DT
> provides those three clocks, UFSHCD_CAP_CLK_SCALING is already
> enabled
> today and devfreq already runs. Platforms that omit
> ufs_sel_{min,max}_src
> still have UFSHCD_CAP_CLK_SCALING cleared as before.
>=20
> What was broken without this patch is that when a DT provides ufs_sel
> and its min/max sources without ufs_fde, _ufs_mtk_clk_scale()
> returned
> early on `!fde_clki`, so ufs_sel never actually switched parents
> while
> ufshcd still treated the scaling transition as successful and updated
> clki->curr_freq.
>=20
> With this change, MT6789's already-enabled clock scaling actually
> switches ufs_sel between 26 MHz (tck_26m_mx9) and 192 MHz
> (msdcpll_d2)
> as intended.
>=20
> Best regards,
> Ilia

Hi Ilia,

Sorry, my question was not clear.
Because MediaTek sets the minimum gear to G4:
hba->clk_scaling.min_gear =3D UFS_HS_G4;
So if the host does not support UFS 4.0 or above, there=20
should be no reason to enable clock scaling.
And MT6789 is UFSHCI 2.1, as I remember, so clock scaling
should be disabled and ufs_sel_max_src/ufs_sel_min_src=20
should not be set. So I am curious why they have been set,=20
and what behavior would clock scaling change in the power mode?

Thanks
Peter
