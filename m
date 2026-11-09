Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216901;
	b=y/3JEzjzpXK/gcEY1w3AYnm9HKFMFsN/dys9u/zPAU/rl91cPtnG38oA80KTjhICL7wi
	 XAMiW+UyJyx1I189prci1E53WFPqvt5r5QGDblwH2LVbocLSAfjEtmvf2FA/OqUKAruR7
	 fJuFOBkbbF1yK4qI7lES2Z0KH2dkR4cDbYF+o2wygrxnre8WnFFNVecezT4eDvkjNLOv5
	 Q5xceMpxgjq5MP5nRDtC87cOloAWGPuStAzjB1pOBwYJtHXeufYU1pbKjD5HufxU/w0ld
	 hF0odWN6Pr3Dmczf0Sv/MK9oby5jUoUDtX4R4gSGoBlDNc1A8TVy4MybGFU2q5x+obQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216901;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=81YlIANoCnX+eauMHLB/Ihy/9badxir/KWc4AzxQZns=;
	b=B3xGK2q75wfIfggov0zwEKHZz0wGG475ZrK2lBw9Lz5Gckl8y44pCJCC0ChskMVpP5bs
	 xFzQv0JZkKp7nDAmdT4BMPcKOzOxal3wP0KIrZN/Xt6phStMLJSUsu4gder4CR0ln2fyg
	 0eBEH31CY3p8bOJgadMh/rRn/rDVy8oToeDldKgfA4v53h4TZFztVGEPM6z6UqA/biu0X
	 o8NNfAHyg1kvRdAh0kg3I7jVPWNtxM+hoRdLCcQeKZoeGPLcMC9wG+wq8FO9EbuJaSixO
	 93UjGfIufVKN2qx8JCyoZGfQ+QgGelQpIcsUPK/dEU+Kp/OqsAqy1rfis5Y1hw9TZEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=r3qN1BuP;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C24606D808;
	Mon,  9 Nov 2026 09:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57C24606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=r3qN1BuP
X-UUID: d2888e44dc2011f18dc8c9802ae25ab1-20261109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=81YlIANoCnX+eauMHLB/Ihy/9badxir/KWc4AzxQZns=;
	b=r3qN1BuPHYjhAX6WFCngBzG1lILmEeyU21Cu+NehOUmcfNAPwpOj8LLegrql02Rle0qNg7I0sTndzFOOri3S1gaePnO5uAjOslr/MEhDi/ks2o94H46GIag3LqfhX6pAZz3oW8Kvv6B3gWXOLtLseCwOvCzZi444E3tx/USmRus=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:f2bfd003-dc7d-49c0-9fce-90dfc0d6be27,IP:0,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:3
X-CID-META: VersionHash:b0318ac,CLOUDID:0bcfdce3-3be1-4b1b-99d0-a5955c9e48c1,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	4|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d2888e44dc2011f18dc8c9802ae25ab1-20261109
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 791650720; Mon, 09 Nov 2026 17:34:55 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Nov 2026 17:34:54 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 9 Nov 2026 17:34:54 +0800
Message-ID: <5fef4ff73511a2613beaa7accdf635a1c634c449.camel@mediatek.com>
Subject: Re: [PATCH v8 2/3] scsi: ufs: core: Hold host_sem in
 ufshcd_wl_poweroff()
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Mon, 9 Nov 2026 17:34:54 +0800
In-Reply-To: <973576304.21794200282836.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
	 <CGME20261109041347epcas2p17b5c0fd7b693f92eb2af35b12a24de31@epcas2p1.samsung.com>
	 <973576304.21794200282836.JavaMail.epsvc@epcpadp2new>
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

On Mon, 2026-11-09 at 13:09 +0900, HOYOUNG SEO wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3b5580ac390c..1c935a8d016d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11574,6 +11574,8 @@ static int ufshcd_wl_poweroff(struct device
> *dev)
> =C2=A0	struct scsi_device *sdev =3D to_scsi_device(dev);
> =C2=A0	struct ufs_hba *hba =3D shost_priv(sdev->host);
> =C2=A0
> +	/* Released by ufshcd_wl_resume() if hibernation is aborted.
> */
> +	down(&hba->host_sem);
> =C2=A0	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> =C2=A0	return 0;
> =C2=A0}

Hi Hoyoung,

Although not checking the return value was an original=20
mistake, this patch would make the previous mistake worse
and cause a system hang. Could we at least add a check=20
to release the lock?

+	ret =3D __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
+	if (ret)
+		up(&hba->host_sem);

Thanks
Peter
