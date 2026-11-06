Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793948955;
	b=Eyh9AIyhgOmq4+HxFPhSX1ZAEgOcX25fBw8y7wXoNADw6c+Yor+srYmKpU0F2jsdYNWI
	 41U3S5Vddgp8ecN0m33oRNHqCNrHMjrFq4HQExmElTg2wdyMB96KxPzV5sp29fuB9iXZk
	 KUV19pCczmgu1ltP4RMejQFrHrvzHY+cSl7FqKdSI+3l0/FtJXB9ZQn7cyZvxSDYP5Gl7
	 TrjvxSNQ4MJ/m10jjQ04NjKFkO8gmHBcqQBrSt+kk7zi/cY6zHmVgeSPcGfl7sVQL2pNS
	 LMnMEHzcMfn3cLG2/bXPhAhgTNKojYlrRi3WVJhKTzjGYWt6Zm3HEoEH5J2QRpvOsTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793948955;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=uSP1e8tjhRCF2yov9TbbHsNIAFeukBIuVHEfqVmWF8k=;
	b=5i3grTVH8tSq8TPTPqakZhiS0bOMovaKtxp7Rj+i6bsMlRuMmUGk5RX5cfEmW1YqwviT
	 lp9eATMTOw5e33xr320gnfd0/q/IJQDu05ZUeg31nhwwDFiuCJPkveZgSS5nYQR0QH4vB
	 puWrMeXzSo1MCCurIIChIftVnR9tieka4v1jJ/MSTi+9vSNLsIhNF/Zfg2BCbPFBPYPVb
	 fjqL5jc8tCd8lqFifHYSJ6T0vtNSk2GWfNDZ5Y6DofHImP3sKy1tRI5cmPmKfH6Ni2+jI
	 fBlSoKLx3BgJDGkZjqLOFbXVZ1DJ4gKGvemcOoxBJH71OX3ee6e7u/UochnlnTTHwpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=H9k2j5Nx;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103AA606A32E;
	Fri,  6 Nov 2026 07:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 103AA606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=H9k2j5Nx
X-UUID: f0d1dad0d9b011f18dc8c9802ae25ab1-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=uSP1e8tjhRCF2yov9TbbHsNIAFeukBIuVHEfqVmWF8k=;
	b=H9k2j5Nx4VV9iSFTFhmHLoqoEZvz4dk5nYMGH5Ts1G8qfaQDzFUQtBXI4AWaRF6gqyDDpp9nwX33gF+B0ga44GgebwCdFarCEoKXPGwnZZ5IHPXhlafdRXx9D1umZER7nV0IIAtOO1UHdZR5ZnBIHlfPPLy6VlSOnLNLgNwf6MM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:e185a437-5967-4853-8447-8aa1cda2ad72,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0318ac,CLOUDID:4dded750-c3c8-4d20-8dd5-7bb1d154dc26,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:4|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f0d1dad0d9b011f18dc8c9802ae25ab1-20261106
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 828544094; Fri, 06 Nov 2026 15:09:00 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 15:08:59 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Fri, 6 Nov 2026 15:08:59 +0800
Message-ID: <95e5b0daac7835593c35755ed948ed8cec1dfcde.camel@mediatek.com>
Subject: Re: [PATCH v6 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Fri, 6 Nov 2026 15:08:58 +0800
In-Reply-To: <a0b59fb709e8c53a72e2839bb6b1635a4a20f395.1793931113.git.hy50.seo@samsung.com>
References: <cover.1793931113.git.hy50.seo@samsung.com>
	 <CGME20261106022020epcas2p397f84c634df3397fcb1c98d1837bb83f@epcas2p3.samsung.com>
	 <a0b59fb709e8c53a72e2839bb6b1635a4a20f395.1793931113.git.hy50.seo@samsung.com>
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
> ufshcd_link_recovery() resets both the device and the host and then
> re-establishes the link. Unlike ufshcd_reset_and_restore(), however,
> it
> does not clear hba->saved_err, hba->saved_uic_err and hba-
> >force_reset,
> so the errors latched before the recovery remain pending after the
> link
> has already been recovered.
>=20
> When ufshcd_err_handler() runs afterwards,
> ufshcd_err_handling_should_stop() sees these stale errors. The error
> handler then quiesces all queues and, depending on the latched errors
> (e.g. a fatal error or UFSHCD_UIC_DL_PA_INIT_ERROR), performs another
> full ufshcd_reset_and_restore() on a link that is already
> operational.
>=20
> Cache and clear the saved errors before the reset, as
> ufshcd_reset_and_restore() does, so that only errors raised during or
> after the recovery are left to the error handler. Put them back if
> the
> recovery fails.
>=20
> Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit
> fails during runtime resume")
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

