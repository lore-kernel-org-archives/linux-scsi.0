Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401414;
	b=JXD0GttpAyRqmiTatX6oNeFZUAS2jHf4N1yivIDhir0RZjPQ/NJnCyVOaslYAq3So9OS
	 Kqpw+w8zuMJqBPnikBD5k/7dN59xV0Dxi2U60S4eEOxEcakYglDFc/fwMfznzcjY5StUM
	 lyzwtOcAn+PNut+jT8idDyjf0FZEuHF0SHwq0sR7sscsmtmiakGAs+c/itBcuSP6LEa/r
	 Sa+xi8TErZJUhYery7nCbT8rkTuk+gdDd2zQin58yg8BnxD0J6PvWKeaF25vS6CCOlkFq
	 pyo79UJpTekWSONO+n8Kq7qqR9bgg/3emI0PbKG6usvQAnoNpjtpP1dn683r8Nr9Vmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401414;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=mrGNZCUzPDaJczrHsIg+6hazgBMTWN0anmPu2cVsnyY=;
	b=2ZyRRWWyN/kG1DBHp8B5HwUjeDenhxtQE6VQl6Tcbo/dEsFoNroPYbohGca1h9xUYnR3
	 RZyUatcZVgHJsY9eDOyLoPbPi7AZBH7CViC4xA1e8M1uA7e9B85gmFxJMan6amdaFNw/r
	 5be7m6MZhl8QFcIR5SNKFk1JU0UAFMYBg73RZalU/GKOjfNJE8+YuffooGo4FaBB3qR3H
	 /3GEVdcf8O4GlxxlkYc0Ka0Ph95Pu3aFUvRxZEsY1ZtiVWBFi+Nlr2ntRzSmta9+cE9Tj
	 VGbIGodRYmmOkg78lt97kULXM+PXoRhyE0/+RCgP6SVnsKZpkGqZzhHbbKKZdU101Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=vFAjyLBF;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864A7606A324;
	Wed, 11 Nov 2026 12:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 864A7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=vFAjyLBF
X-UUID: 694574c4ddce11f18dc8c9802ae25ab1-20261111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=mrGNZCUzPDaJczrHsIg+6hazgBMTWN0anmPu2cVsnyY=;
	b=vFAjyLBFEohEuXcf10EfMQa89sPjLk/Bn2OAOZlVJa+qGoGPgNRslgXvOMkFVeUeUu0qAZ5Dyf8MT4zIUlujq0f7wz0CrsSdvRKqoY6hbpMlobcNMzFwg+bbML+7BlBLfWOj9HsxiD7kmd/JJHuNOgFXsfEFgjJdeWrfmlbJ/o8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:c6b2e43e-32b0-4d5f-a710-37aac466fc9c,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0318ac,CLOUDID:1f8bb530-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	4|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 694574c4ddce11f18dc8c9802ae25ab1-20261111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2052694986; Wed, 11 Nov 2026 20:50:02 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Nov 2026 20:50:01 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 11 Nov 2026 20:50:01 +0800
Message-ID: <c62c15bcbf9c0fe55e19de14794022b691f0398b.camel@mediatek.com>
Subject: Re: [PATCH v10 2/4] scsi: ufs: core: Add a helper for the system
 suspend callbacks
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgsproxy1@samsung.com>, <h10.kim@samsung.com>
Date: Wed, 11 Nov 2026 20:50:01 +0800
In-Reply-To: <331418503.141794387787744.JavaMail.epsvc@epcpadp2new>
References: <cover.1794384665.git.hy50.seo@samsung.com>
	 <CGME20261111082305epcas2p28dd4b104523c10c82457a29e7e89c56c@epcas2p2.samsung.com>
	 <331418503.141794387787744.JavaMail.epsvc@epcpadp2new>
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

On Wed, 2026-11-11 at 17:18 +0900, HOYOUNG SEO wrote:
> Move the body of ufshcd_wl_suspend() into ufshcd_wl_system_suspend(),
> which takes the PM operation as a parameter, so that it can be shared
> with ufshcd_wl_poweroff() in the next patch. ufshcd_wl_suspend()
> calls it
> with UFS_SYSTEM_PM.
>=20
> No functional change, except that the error message printed when the
> suspend fails now contains the name of the new function.
>=20
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
