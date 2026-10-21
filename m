Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588169;
	b=Jj9JiYjkXADRf+Y0p1iYRTCcaFFmC11lStUWiYQoFkkf4oHtKxePGLGOpS1l+V0ZQ0X5
	 RvvADKq8ve3S59d9ZZo1nprxY+BUUMhVEnQFTCArIgbmNudCbFhwwWzsS0Wb6LDWlP43O
	 GBxMU1JNxPchhk3L4HeM0FTEGvW7CPZY2Q/4JpPdr9K8fvY8ZXapWQOrpcu0cXyTaxD3V
	 O11Sy5y5glurrwgeIOU4x3gLJD5YoXLshyrNAQtUqySzs9cmEk82uDk1wywbBDMfhZgvI
	 8P1uwbEmPkIiMs0Q/AbO36dQlIk9Gx5mzX2aD6ctnbsP4Z2GhHWqi2OdtZh9G+dcC+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588169;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=ALjN0/QTvgvP/A3smoh4RmmzgPoOEfQg0Vc73ChwCI4=;
	b=JevbG7aBhAfRrJmBSHMJIPP6CK9Zh0WYNu1XsuN2EWOkvqBVtQvc5hKH0F11uXlleMYa
	 RiMtXekS96D0nt0/kMFoGo8jOgt6eoOyi54prHb9NGWB7BI14M/vGrheek/8vUc9IHIPA
	 Me9giTsoF+6CQC0/HuOeN/2TqZ8fVbkQFv+ZOeL3Wv4AxYXc0zRq3rfUscHa6wdD55VKW
	 Civ85icLwRSaJ/T5v1L1g3kQsqXusT3zA419Mwtv2a48O4uW9zWQSZeVeG8+4HC1ijU5v
	 5X5pqUzwpBsui8Z6E6r/HMTXCQbNRuseKelqJHXnDN6dbOwrJnhnokfmyNmeEwPEWQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Px0BUNR7;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C88606A319;
	Wed, 21 Oct 2026 13:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43C88606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Px0BUNR7
X-UUID: a278e58ecd5011f18dc8c9802ae25ab1-20261021
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=ALjN0/QTvgvP/A3smoh4RmmzgPoOEfQg0Vc73ChwCI4=;
	b=Px0BUNR7x6qemFCfx7Drk54vRMD1SMuwShpZPYWtzhUyCq4Hm93hSJOQ7TBUXKtNPm1KS0OFI7HZcJqk2pIiNKqBhsEch9hb2UNNxMOxTnaJOuoJkV3uGvskF9pzZFL3PLkS3PP6QGoiL87Q7scBW5QpBT1dFN1pEdAWXmk9E0c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:c5739957-0aed-46a8-ab76-6c7d912dd19a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:7ab846ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a278e58ecd5011f18dc8c9802ae25ab1-20261021
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1737463512; Wed, 21 Oct 2026 21:09:23 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 21 Oct 2026 21:09:21 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 21 Oct 2026 21:09:21 +0800
Message-ID: <70cc95fb8f1ad9a855015377b7e100d02ab7a589.camel@mediatek.com>
Subject: Re: [PATCH v4 4/6] scsi: ufs: core: Fix double release in
 ufshcd_eh_timed_out()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<mkp@kernel.org>, <linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Bart
 Van Assche" <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Bean
 Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Wed, 21 Oct 2026 21:09:21 +0800
In-Reply-To: <20261021040615.3566831-2-stanleyjhu@google.com>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>
	 <20261021040615.3566831-2-stanleyjhu@google.com>
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
> In SDB mode, a command that times out during a power management
> operation can be released twice:
>=20
> 1. The command times out while its normal completion is running.
> 2. The completion path clears BIT(rq->tag) in hba->outstanding_reqs
> and
> =C2=A0=C2=A0 releases the command. It has not called scsi_done() yet, so
> =C2=A0=C2=A0 SCMD_STATE_COMPLETE is still clear.
> 3. ufshcd_eh_timed_out() recovers the link, sees SCMD_STATE_COMPLETE
> =C2=A0=C2=A0 clear, clears BIT(rq->tag) in hba->outstanding_reqs without
> checking
> =C2=A0=C2=A0 whether it was still set, and releases the same command a se=
cond
> =C2=A0=C2=A0 time.
>=20
> Return SCSI_EH_DONE when ufshcd_clear_outstanding_reqs() returns 0,
> as
> another path has already claimed the command.
>=20
> Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout
> before SCSI EH")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

