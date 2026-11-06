Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949056;
	b=3AkvssQ/SYZQqzRryU+nbNfRVpw9d28vUX3CuWGhaG2EpOSiCHsK7DYzZP83WlI7s94m
	 YCQUHNQsIOsZp7kOI7nwAOikKNN4huMte7nO49Dk/odxV4o8DamDwH+D8Wsg8frL/Wlfc
	 RGdvsUCfrG2mQl9C0mwgpxTRN8vGWDh0ma5U3hAyVrorkUvGGvNItC8X0JjLPKkv0johD
	 vDQETJoBsTq/1pdGkHObwPti9ozoozMo3Ta/3DMo45gMUYQLUKwHL1ZSfD2Zbnr/SlTyZ
	 0GbnYlzAZ0BhnELt5gtHRCQfONMmtlHUZZJWbp/zB9Y7pL2J2aFnT3gtXJun7qw65Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949056;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=GDx8yrSUZQtOXGwB9S0pld6gi71CG5ajteuuC4N0NiI=;
	b=jo5KfnjfViBOA/MBpWy1vC7clX+wvWUD/ds6lrz6aVMOSQ6i+RECryR0OMxca0N86+0G
	 yqWPFVYrn5rXGU00ySxnehuBQLneeg0pbjao0U6a0bd3NqDorSXOvEP3uPL1MnBd36g0L
	 rkgusLbh0svwKv5to8J4BZDnNawn4EWScC9naiup/jqCGOiLl2yRiyhYgBRT/UmX9wKPG
	 NLlJFQ2WeGVV6ObNrEInx9Bnm39eDvnKG+4psdDZoAxBXrZiYGYlYbQBRjJlz5GxNeVfv
	 MfXj0DuqH/etRTE2JSBTzfiL7LrO1jU+nHisuG+Kv69U3lRs7ZnkyHcOYXCfWbfwXXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=eFdIm9Np;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B53606A32C;
	Fri,  6 Nov 2026 07:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15B53606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=eFdIm9Np
X-UUID: 32933266d9b111f1b1788b6acf885367-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=GDx8yrSUZQtOXGwB9S0pld6gi71CG5ajteuuC4N0NiI=;
	b=eFdIm9NpDTbL+311HJUX5dbCrEHGyzc4zJCM1M1VQ3oh7zgRe31oNyPNS0VOA8Hl2zB5i9wlGirtS96xYf04v6Bu+AXYpvltxxVvzOWYP2xttZMRsGfCBCibG91a/BzJHxkunyjOpwLdROJql9JkNYbYMyROnl797+4/eZPGOlI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:c5f9c54b-a76a-40bb-abde-a626a826bd67,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0318ac,CLOUDID:1c3174bb-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:4|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 32933266d9b111f1b1788b6acf885367-20261106
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 271690412; Fri, 06 Nov 2026 15:10:50 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 15:10:49 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Fri, 6 Nov 2026 15:10:49 +0800
Message-ID: <9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>
Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Fri, 6 Nov 2026 15:10:49 +0800
In-Reply-To: <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
References: <cover.1793931113.git.hy50.seo@samsung.com>
	 <CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
	 <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
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

On Fri, 2026-11-06 at 11:15 +0900, HOYOUNG SEO wrote:
> ufshcd_err_handler() recovers the link without taking hba->host_sem
> whenever hba->pm_op_in_progress is set. That early path was added by
> commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
> deadlock") because the regular error handling would wait for a
> runtime
> PM operation that cannot complete while the error handler is waiting.
>=20
> pm_op_in_progress is also set during system suspend, system resume
> and
> shutdown, where the early path is not needed and runs concurrently
> with
> the PM path itself. For example, if a LINERESET is reported and the
> hibern8 exit fails in __ufshcd_wl_resume() during system resume, both
> ufshcd_err_handler() and __ufshcd_wl_resume() call
> ufshcd_link_recovery(), and the host and the device may be reset at
> the
> same time.
>=20

Hi HOYOUNG,

Since ufshcd_err_handler already calls ufshcd_link_recovery,
wouldn=E2=80=99t it be better if __ufshcd_wl_resume just triggers=20
the err handler and waits for the kworker to finish,
rather than calling ufshcd_link_recovery directly?

Thanks
Peter

