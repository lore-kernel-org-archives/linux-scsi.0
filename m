Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588209;
	b=PXVfFc4XQ62WDQKn4GuDsrN+2JO6NIYIY1w1mKF84Gc1bsCxni+oaJRWb6qSfX10jKbR
	 lTSolw1xQrGn+Sbf1N/nDI0pkhE4qv7NS413WFz7ILoUVY4VtusBV638pXP8BXbX31pW9
	 WOGadQtN35SfjOeckgyT3zMR+ZzFSu1u37GIMrcUzPVhe4YwrfeuT+gC1XW4K7o9Ubtnx
	 CbWbd8ksJahSFrCk6jYyJINDom4zmJxzWCw8QpDh48GZdaXqFZ/WI/6rYPvB4AeiXg3pK
	 bE8OqAo3jpdZ5rQ+ECLqbH99OFbiKIdq37/MY8k+MSuHEcx1Gg+gCGNBwpZPvtPlzvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588209;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=PS/twxFacQXAoiWN1rP01NeV2b6MFLIvq5Qi7h+ZC8U=;
	b=n8V3Q4pW5DBnIdxX7pbMKOKyTrk1XTZeXCjk+ZH59EscwP6Y4p++qOPnE50qH1E9bORv
	 yi8FGJuPYKCg2OPVdhKHZ0LwXtB5h+JA8xPuK7l0PUjXvehyt4K0dHIxF+ZFbvYB1rDfg
	 IG4gmsKXRQ06Y3wvv6R5tYMqT2dQNeTqUrtitntFjspm0MTNI2ctPo5LsDXwrcVdJLXc8
	 bIskpxLctfhTPirVTrnFmz6ZdKTy8ypSWqfB71fRd4mA7ECqkh/OUpX6CqkmL39Ki5bRU
	 GiSJGVhqbgoeCRCSnPZ7O9DlXF9SKh5OjXJz38qgmZJm5bwZ4s76WQINCRqJgv24IYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=RKP4649W;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C132606A31A;
	Wed, 21 Oct 2026 13:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C132606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=RKP4649W
X-UUID: ba421fbecd5011f18dc8c9802ae25ab1-20261021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=PS/twxFacQXAoiWN1rP01NeV2b6MFLIvq5Qi7h+ZC8U=;
	b=RKP4649W6j0WGfJKD4toZcznAEG9ZUUNfEfMZkCppEAD1XDxZwh9GJfFBREnJdHTuVxlbShzSG1yQ9M2PIIpvzxdKxHDHQaFOYhVdRZcfkG4zoc61w+N0+kOoycyi6X7nHvfw3GQdD6NoLTt58ZrMLqQYjHolERtoFwFqLQ7xlM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:888f8b78-7778-4c86-8e75-a49c574b1832,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:1863e68a-9b15-4dfd-88b6-b4385d95ae05,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ba421fbecd5011f18dc8c9802ae25ab1-20261021
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 338125444; Wed, 21 Oct 2026 21:10:03 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 21 Oct 2026 21:10:02 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 21 Oct 2026 21:10:02 +0800
Message-ID: <d286f784b3aa4d90e151a195b316613fa282fd02.camel@mediatek.com>
Subject: Re: [PATCH v4 6/6] scsi: ufs: core: Do not release a reserved
 request in ufshcd_abort()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart
 Van Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean
 Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Wed, 21 Oct 2026 21:10:02 +0800
In-Reply-To: <20261021040615.3566831-4-stanleyjhu@google.com>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>
	 <20261021040615.3566831-4-stanleyjhu@google.com>
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

On Wed, 2026-10-21 at 12:06 +0800, Stanley Jhu wrote:
> In SDB mode, aborting a timed-out device management request drops a
> clock hold that the request never took:
>=20
> 1. ufshcd_dev_man_lock() takes one ufshcd_hold() for the whole device
> =C2=A0=C2=A0 management command. ufshcd_queue_reserved_command() submits =
the
> =C2=A0=C2=A0 request without taking a hold of its own.
> 2. The request times out and ufshcd_abort() clears its slot with
> =C2=A0=C2=A0 ufshcd_clear_cmd().
> 3. ufshcd_abort() claims BIT(tag) in hba->outstanding_reqs and calls
> =C2=A0=C2=A0 ufshcd_release_scsi_cmd(), which calls ufshcd_release() for =
a hold
> =C2=A0=C2=A0 the request never took.
> 4. When ufshcd_dev_man_unlock() drops the hold from step 1,
> =C2=A0=C2=A0 hba->clk_gating.active_reqs goes below zero.
>=20
> Release the command only if it is a SCSI command.
>=20
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()")
> Cc: stable@vger.kernel.org
> Link:
> https://lore.kernel.org/r/2060a8da-581b-46d1-a510-779f4df716cd@acm.org
> =C2=A0
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
