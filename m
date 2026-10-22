Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660250;
	b=u+lNDoDhgqRsCxC2hxLTTtxRC2DaGnD7QvaqQW46Z8g2QFvtV2+1um6WZZ+3vCV/H5gG
	 3YYAJYKgoOLr7qw9ROd+CyVFcF6dknVO9237ek6BJHF+PKrCki9mZJmoClvuU44x57s36
	 yb1s3l0tFPzlvA72OIwTpuSuuijX1iHasM0y1t22wzjEnwEfD0YtEoUFlBSdvm3z7+DJf
	 qZw/hmGwSxm5u3jn8o24Be9YqzVebAtqf1kvPTJWl7Iw6nUnuPatfYL9n7mXNOTNXQqoh
	 XHgBJibmRR6pyXkh7gZcf/V3ofKFdAWaVoM/10biTQiOFwRRVqKWoWCd1XArN918VaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660250;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=sC5+6Bwpg8Flndcyoy/sLjGpBG22wsqv9rEoNRXgEiQ=;
	b=2fpaClnz2c1MsgEEBV2c6aghnkVFdzNLp+xO4PSsbegqGr/KQdzrxjVxzPPsrVRRSbbf
	 HyuEyKcWgfXz8s1GN0CDK8vSKaG4x7Z42yVq2MxErSTkPQslINkoItzZobTY+rjG1v59U
	 W0AnjrCn5PtL4Pkq2FMNoS3HmtgDw86YypiJThy2mdha/TmZ7rsaPIT/reEXzz3SUiPCO
	 6M0hJBqjfuc12XVb1N0v0nj8Ko6aE2V3sTUIPOoWJ0Tbfzp6MSzQMe9zQuHeZPQTN4pDm
	 lzowMyRXdpASDICCsY8bxwlbMpzZwqKKO1uY4sFL84fsKe4FQUPvywn8ssQdYUD28fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=M9UMmh6k;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230D606A31A;
	Thu, 22 Oct 2026 09:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0230D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=M9UMmh6k
X-UUID: 749b63a0cdf811f18dc8c9802ae25ab1-20261022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=sC5+6Bwpg8Flndcyoy/sLjGpBG22wsqv9rEoNRXgEiQ=;
	b=M9UMmh6kYZUVSqkAc70pbJ9WDXEXOjArU/Ls2vyPhJmc+V8jgqda151ru90fexJp4cP4x55z4ZfEpPtMygcmoe6sM5JEfo9tmslVnpq1+Sng1u5pNey3xC9039+7eNsbXuyMFBkvuEclPV1xK2uWOuL1nW3imjSVNp9wRnOFrIk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:7882e0e4-61df-44a6-ba40-4909908ebe8d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:bf16eaba-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 749b63a0cdf811f18dc8c9802ae25ab1-20261022
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 292985790; Thu, 22 Oct 2026 17:10:41 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 22 Oct 2026 17:10:40 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 22 Oct 2026 17:10:40 +0800
Message-ID: <dc069f4e97eeb589dc3a222017f2daad067ed0ff.camel@mediatek.com>
Subject: Re: [PATCH v5 5/6] scsi: ufs: core: Remove
 completed-without-interrupt path in ufshcd_abort()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart
 Van Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean
 Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Thu, 22 Oct 2026 17:10:40 +0800
In-Reply-To: <20261022034443.3034432-6-stanleyjhu@google.com>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
	 <20261022034443.3034432-6-stanleyjhu@google.com>
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

On Thu, 2026-10-22 at 11:44 +0800, Stanley Jhu wrote:
> In SDB mode, a command that times out right as the controller
> finishes
> it can be completed twice:
>=20
> 1. The command times out and scsi_timeout() schedules ufshcd_abort().
> 2. The controller finishes the command and clears its doorbell bit in
> =C2=A0=C2=A0 REG_UTP_TRANSFER_REQ_DOOR_BELL, while the completion handler=
 has
> not
> =C2=A0=C2=A0 yet cleared BIT(tag) in hba->outstanding_reqs.
> 3. ufshcd_abort() sees the doorbell bit clear and calls
> =C2=A0=C2=A0 __ufshcd_transfer_req_compl() without clearing BIT(tag) in
> =C2=A0=C2=A0 hba->outstanding_reqs.
> 4. The normal completion handler or the logical unit reset that
> follows
> =C2=A0=C2=A0 sees BIT(tag) still set in hba->outstanding_reqs and complet=
es the
> =C2=A0=C2=A0 same command a second time.
>=20
> This branch only exists for a rare corner case, a completion
> interrupt
> that is lost or arrives late. Remove it to simplify the abort path
> and
> leave such a command to the SCSI error handler, like any other
> command
> that cannot be aborted. The cost is a slower recovery in this corner
> case, which is acceptable since it only happens after a timeout.
>=20
> Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
> Cc: stable@vger.kernel.org
> Link:
> https://lore.kernel.org/r/fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org
> =C2=A0
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
>=20

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

