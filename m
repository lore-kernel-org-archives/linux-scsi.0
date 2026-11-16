Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833159;
	b=HBaYpBy1KiGnnLlHu/DJOFEGn3EovkNLcKLj1PdiCH1iISjFewrf47OMW8pyQSmbPggP
	 btulcFJM4PPDJ4rMj+jWuHtikwehi4ZCsoA6EatVU4j6JExkWDAcyj2mFW3xFiWPDMOQd
	 lvpM88kZbD1NVxm/KcnrboRJRNQvMq62ck0SyjDZNSAHjcMqW3td07PHI5SGNzsDIG42X
	 wN9wDyPhfOABPKKb8cyX93hV9WiDTEOQTRhaE9XsWrRjKOMUNnIzv3xiYHsfFv8Dizaav
	 JWjAYC0wlWgTCpYBiDNpfWsawcEq3v6LoOoZ5fWDB6WHfsr1ioxeVjO3Ha7e/wwT/lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833159;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=cdB9gyoruD/JGkgBZLLft28IeCpExjxTyxPIjL0jpBE=;
	b=1IJYkqoFKb6GRXHAyfxiMN3pVDHdgvw1VP7JFX1mSwTDXoESo6EDMI9F2feKkZrOBjHa
	 X6PUdo0+WnimfMTQS1rOExk6BLNOBwiNSB3jtGeYDreHTTZ04olGBpfnX7TwNXL1axx7B
	 BrvLpj0ABNo5nPSH7+XQT8Qy3I9QkgNd+fdiX02J0MoouT/A/a9WvjLUhJ23hFTfwaE3M
	 aJSlcACa4kbEK0US9RaoqzedfjfbD5P4tdqFcIZWY+CqtWHGFqh5gjGm9iQS+WMeMJ31a
	 mUUKnh75gdaDw3Z71L/rQZZ79kC6Sf6bN9awpdDEeQFV6/kAy/gGhNzlgkMSylS8wPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=O7oOT71U;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B29606A329;
	Mon, 16 Nov 2026 12:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12B29606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=O7oOT71U
X-UUID: a830fcbce1bb11f1b1788b6acf885367-20261116
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=cdB9gyoruD/JGkgBZLLft28IeCpExjxTyxPIjL0jpBE=;
	b=O7oOT71UVFjzofmFsyLfSzVugYlYB+8rFGx/w/cpSfaqk/2FnzftOMjEusya9UHGdSLwjQce7nxEHIh/0ClCc9TFzmQ3I+uljNoTCqilUPGsZJIHUWa7cikVSN2zCv3mJghQJWO4ymdlCC9D2f18yBWHP9Q5OXplbefTY5vM2s0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:b0469611-9e15-4f45-952e-4ac381f040de,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:22afec30-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a830fcbce1bb11f1b1788b6acf885367-20261116
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1137579909; Mon, 16 Nov 2026 20:45:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 16 Nov 2026 20:45:51 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 16 Nov 2026 20:45:50 +0800
Message-ID: <799eefce7dabf96c7377832cd5ae5196b0b5d174.camel@mediatek.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Recover link in
 ufshcd_set_dev_pwr_mode() on timeout
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, <linux-scsi@vger.kernel.org>, "Martin
 K. Petersen" <mkp@kernel.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart Van
 Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, "Bean
 Huo" <beanhuo@micron.com>, Brian Kao <powenkao@google.com>, Can Guo
	<can.guo@oss.qualcomm.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Hongjie Fang <hongjiefang@asrmicro.com>, Praveen Talari
	<praveen.talari@oss.qualcomm.com>, Hoyoung Seo <hy50.seo@samsung.com>, "John
 Garry" <john.garry@linux.dev>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2026 20:45:50 +0800
In-Reply-To: <20261113111202.3551341-2-stanleyjhu@google.com>
References: <20261113111202.3551341-1-stanleyjhu@google.com>
	 <20261113111202.3551341-2-stanleyjhu@google.com>
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

On Fri, 2026-11-13 at 19:12 +0800, Stanley Jhu wrote:
> ufshcd_eh_timed_out() calls ufshcd_link_recovery() when a command
> times out during a power management operation. Link recovery sends a
> NOP OUT, which needs hba->dev_cmd.lock and the only reserved tag.
>=20
> 1. Runtime resume sends a query with the reserved tag while it holds
> =C2=A0=C2=A0 hba->dev_cmd.lock.
> 2. The device does not answer and the query times out.
> 3. ufshcd_eh_timed_out() calls ufshcd_link_recovery().
> 4. In MCQ mode ufshcd_verify_dev_init() waits for hba->dev_cmd.lock
> =C2=A0=C2=A0 while __ufshcd_wl_resume() waits for the query. Resume hangs=
.
> 5. In legacy mode the query completes but the timeout handler still
> =C2=A0=C2=A0 holds the reserved tag. The NOP OUT fails with -ENOMEM and t=
he
> =C2=A0=C2=A0 host enters UFSHCD_STATE_ERROR.
>=20

Hi Stanley,

I have a question about the failure flow.
The WL resume flow should be:
Exit hibern8 -> send SSU CMD (Active) -> send DEV (query) CMD.
So it looks like the first two steps succeeded and then the
device command timed out?=20
Was it accompanied by a UIC error? If yes, at what point did
the UIC error occur?

Thanks
Peter
