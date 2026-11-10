Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289860;
	b=Z/rCe4ZWA9TNr1BVSLPAZevOB05IZClFOIyLg4tvlHYMkX9SkyHVeoaePa5BSL34/7kF
	 BWpr8gqjJ0Sc4RL9Zj2mLWKOP+lnJoZ1j3XkJCoGKztsNkasAc9SiBz7mXxLXH5jKYQMw
	 +YswcCfScZOhZCPZ7yIbMH0LOXqAySsk+xsaHSBIaiFxXSP2TyQpf1hHP0jWeLERP+uVn
	 4oAECtgdelkGSsiNyeYJgDOKYWTymRUcaear3dUAp/6osWUTuxWfzIwW3DMnr9lq2PUAM
	 cHXP8sNjUw3/iRLWGkqWvypSphiLmMpmRIqdE2eFidxPZJl3m8FJaM1RPvIM65+pTlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289860;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-CACHE:X-CID-P-RULE:
	 X-CID-O-INFO:X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:
	 X-UUID:Received:Received:Received:Message-ID:Subject:From:To:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MTK;
	bh=mOoY3fnVjQF3h8X66Tx8KOH3645rLJxZnhBe3Gi/WP8=;
	b=uPZbBIkAbzMIJl9apfloZeWBJtxfRlC1cO+g967OUNjKkZm47JeKlSKygQbNdrOqGEAz
	 4xKhnyNCzcWlLrRcjXipIIpYUfR2G3uVA1V/UvO5E0b4FOHNYha2H6XDzwuxL3PTMJIJT
	 clml+7q44+0k1ugk8nCZBaiOYRSOq5/F05iVxZvANVJyJaCpBARN4iRydzaB1vTqAiIzm
	 oVbHwtZgtoemCISPHkmNDnTCgM4KUpC+4Y/PG6OCykHELBnvOaHb/dNRRgPgZikeHsxdk
	 yXfSSBIjEoZB4Mesk4BrEYSIzkm1Wcl/+H6WLZHUx4AKs688l7WvCYcx6xcZUtgS19w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b="p/7FyZ/B";
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D8560A2611;
	Tue, 10 Nov 2026 05:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33D8560A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=p/7FyZ/B
X-UUID: ad1ed6e0dcca11f18dc8c9802ae25ab1-20261110
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=mOoY3fnVjQF3h8X66Tx8KOH3645rLJxZnhBe3Gi/WP8=;
	b=p/7FyZ/BFGCQ8ecWp8uLSd/d8QTkFTk7Alfho8ql/fV6590rVUKFV1RS/X6EexfaS0OEMaAIdbriBAsaYoKJ1LIKvmcCOuy/MmB0cXGbP04ZBxMIc5ezU+2WJoLN/p+HFKW1w3eO7gdOQsI5lfKo7BPSiEot45zw1ntR3cRr0RM=;
X-CID-CACHE: Type:Local,Time:202611101350+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:910833b9-19c5-4a78-a809-a84529920570,IP:0,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:3
X-CID-META: VersionHash:b0318ac,CLOUDID:8ed31057-a87d-42b7-8ffd-9e23ca174329,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	4|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ad1ed6e0dcca11f18dc8c9802ae25ab1-20261110
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1595384054; Tue, 10 Nov 2026 13:50:47 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Nov 2026 13:50:46 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 10 Nov 2026 13:50:46 +0800
Message-ID: <855918393f7613361da4dbfdfec89467afa4b3c8.camel@mediatek.com>
Subject: Re: [PATCH v9 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgsproxy1@samsung.com>, <h10.kim@samsung.com>
Date: Tue, 10 Nov 2026 13:50:45 +0800
In-Reply-To: <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
References: <cover.1794275305.git.hy50.seo@samsung.com>
	 <CGME20261110020747epcas2p20410190486c9b48b4b2a4e9d8a4c2292@epcas2p2.samsung.com>
	 <973576304.21794277202839.JavaMail.epsvc@epcpadp1new>
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

On Tue, 2026-11-10 at 11:03 +0900, HOYOUNG SEO wrote:
> ufshcd_wl_suspend() takes hba->host_sem and ufshcd_wl_resume()
> releases
> it, which serializes the error handler against system suspend and
> resume. ufshcd_wl_poweroff(), the hibernation poweroff callback, also
> suspends the device with UFS_SHUTDOWN_PM but does not take host_sem.
> An
> error handler that runs in the meantime can reset the link
> concurrently
> with __ufshcd_wl_suspend().
>=20
> It also leaves host_sem unbalanced: if hibernation is aborted after
> ufshcd_wl_poweroff() has been called, ufshcd_wl_resume() is called as
> the .restore callback and releases host_sem, which was not acquired.
>=20
> Make ufshcd_wl_poweroff() behave like ufshcd_wl_suspend() and keep
> holding host_sem. It is released by ufshcd_wl_resume() if hibernation
> is
> aborted. If __ufshcd_wl_suspend() fails, release host_sem and return
> the
> error as ufshcd_wl_suspend() does, otherwise the error handler, which
> waits for host_sem, would block forever.
>=20
> This changes the behavior on failure: the error is now returned from
> the
> .poweroff callback, which aborts hibernation, instead of being
> ignored.
>=20
> Do not use hba->shutting_down here: it makes
> ufs_mtk_system_suspend(),
> which is also the .poweroff callback of the MediaTek host controller,
> fail with -EBUSY, and nothing clears it when hibernation is aborted.
>=20
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for
> wlun")
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

