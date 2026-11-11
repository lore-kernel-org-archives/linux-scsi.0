Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401446;
	b=FgQ9jsge8W8RQp0gKIB5t3O9FdiFP1K+INaoUp0+alWR+7poYTg/WBM8nwsLN4ToSRb4
	 rdjOUsOL1JlOjUZaKEhrStitVoJqQ03Ut6KorW3tvXeaNTtILIXiQ+g/5NIDHocdj3zTR
	 wVPCuWS2F0FNVFjHI8uP8fUAxaUto5kb/9YpVDm2meaGxoyVM73B9DumjkLxWJxCM+oUc
	 R3jkRMo1yaAHhSeAjRRIREGNjw4/jcugcY6NIGWljGwdA0TSpWd4UwPRTeq2u0ihGVdej
	 lhGJ1MwiSpQJtySi1/bmzHNqsX9rn57LTDkMu3UO2s42nSeTUilMeeenzBo/ICqI6oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401446;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=1d8r9KQbng6ph5F2BsQrdbPHx89gTkMAPbPsgYLnobk=;
	b=r2K79Rfa6/5G9z19zzdcmV3gnSFuvMKa8VOX4caq3M4QIWxwsc/MlGv/3RtZ6fjCDWk2
	 FiDutFMnqEiqcOn17IsA3egyfi8EtdjuAiXlhfFo5gdWYptURUew1v463pgsenpOU710F
	 6IW4VCONZCX8QIZTESYf4BohxIqIKfcN9/m8rO5KyZP+5n0AyM2NBH1JSi0Att21I8DLX
	 aFQENffPXRvB7cdrbbk7wwU2ORUnncOmVGkJW1MiAvOK/9qnC+V+4c8uU0i9iq4uJ9iVM
	 3ZCAPZB9qzG0gB+7F0PkJR72lGMd+4zsfeLe0zIMhiVwzwkEbTmiL/o9m08hecVmvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=ZCHkfhK6;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6003C606A31C;
	Wed, 11 Nov 2026 12:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6003C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=ZCHkfhK6
X-UUID: 7f2a89dcddce11f1b1788b6acf885367-20261111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=1d8r9KQbng6ph5F2BsQrdbPHx89gTkMAPbPsgYLnobk=;
	b=ZCHkfhK6aD4pojJUclrCx4D0wl2I+a0BDWFj6vCiblDUWYlDXJk5N9DVG78srqQSAsNU7IPFyKjZjRyeMM5cW43XutLyr4QVLlBbbTSAjsn0hylC1Ys+8fQSvekpOFYBPOsd40pCG+M7LJA5Q6jG7qGpb5LFjBGFgimUtLQl3xs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:5fc85684-c72d-4c1a-8f7b-1f9997a1bdd8,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:b0318ac,CLOUDID:088cb530-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	4|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7f2a89dcddce11f1b1788b6acf885367-20261111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1865187912; Wed, 11 Nov 2026 20:50:39 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Nov 2026 20:50:37 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 11 Nov 2026 20:50:37 +0800
Message-ID: <5e0d0879bb4af87db4a64a2ce6b5740efedefcfa.camel@mediatek.com>
Subject: Re: [PATCH v10 3/4] scsi: ufs: core: Make ufshcd_wl_poweroff()
 behave like ufshcd_wl_suspend()
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgsproxy1@samsung.com>, <h10.kim@samsung.com>
Date: Wed, 11 Nov 2026 20:50:37 +0800
In-Reply-To: <603443293.161794387787869.JavaMail.epsvc@epcpadp2new>
References: <cover.1794384665.git.hy50.seo@samsung.com>
	 <CGME20261111082306epcas2p21456a0a7d81ed5328ec01f022b87ee32@epcas2p2.samsung.com>
	 <603443293.161794387787869.JavaMail.epsvc@epcpadp2new>
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
> ufshcd_wl_poweroff(), the hibernation poweroff callback, calls
> __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM) directly and ignores the
> result. Unlike ufshcd_wl_suspend() it:
>=20
> =C2=A0- does not take hba->host_sem. An error handler that runs in the
> =C2=A0=C2=A0 meantime can reset the link concurrently with
> __ufshcd_wl_suspend().
> =C2=A0=C2=A0 It also leaves host_sem unbalanced: if hibernation is aborte=
d
> after
> =C2=A0=C2=A0 ufshcd_wl_poweroff() has been called, ufshcd_wl_resume() is =
called
> as
> =C2=A0=C2=A0 the .restore callback and releases host_sem, which was not
> acquired;
> =C2=A0- does not check pm_runtime_suspended(dev).
> __ufshcd_suspend_prepare()
> =C2=A0=C2=A0 leaves the WLUN runtime suspended if ufshcd_rpm_ok_for_spm()=
 is
> true,
> =C2=A0=C2=A0 which is the case if rpm_lvl and spm_lvl are equal. Then
> =C2=A0=C2=A0 __ufshcd_wl_suspend() triggers error recovery and returns -E=
BUSY;
> =C2=A0- does not set hba->is_sys_suspended, so
> ufshcd_err_handling_prepare()
> =C2=A0=C2=A0 does not restore the clocks and regulators if the .restore
> callback
> =C2=A0=C2=A0 fails;
> =C2=A0- ignores errors.
>=20
> Call ufshcd_wl_system_suspend() with UFS_SHUTDOWN_PM from
> ufshcd_wl_poweroff() to fix all of these, as suggested by Bart Van
> Assche. host_sem is held until ufshcd_wl_resume() releases it if
> hibernation is aborted, and released if the suspend fails. For
> UFS_SHUTDOWN_PM, __ufshcd_wl_suspend() does not convert failures into
> -EBUSY, so a positive SCSI or UIC status can be returned. A
> dev_pm_ops
> callback has to return a negative error code, so convert it.
>=20
> This changes the behavior of ufshcd_wl_poweroff(): an error is now
> returned from the .poweroff callback, which aborts hibernation,
> instead
> of being ignored, and a runtime suspended WLUN is left as it is like
> in
> ufshcd_wl_suspend().
>=20
> Do not use hba->shutting_down to stop the error handler: it makes
> ufs_mtk_system_suspend(), which is also the .poweroff callback of the
> MediaTek host controller, fail with -EBUSY, and nothing clears it
> when
> hibernation is aborted.
>=20
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for
> wlun")
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
