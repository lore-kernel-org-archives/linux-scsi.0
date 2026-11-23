Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415877;
	b=Xf3jSQqeDmuKyhyTsyvUptRmZeS5PiFAE4s4f/atmhSs5Bnrz5H/9BAZRsK75Yk1L9b/
	 VtYI1wks5LWzk8wnZXSc1+A4a6XVeeJ4scx8nhkIWl1LSFMi34M8YWAkpd5Hs4WzUEPI6
	 x5lqnYDzdCfAvTW7dCK42gu4vx5KQnLVXccfRpebdeGGmqIYjSNxSopolEd2sClDDVQK0
	 NLI79C0iRjHloVtInWUA8QtdAnpbQFPUaVtcd55+SnoKcpNz7YQe0o+/iKPXjTnt7Q5JB
	 B/casLEbZZ0dzP5qgIuJyVtr+f1am7Ij7HLifBsfNysgJA1oPIq2KNTL9M4tKFNKd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415877;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=DdMNQgJpDMYDJsZmmEdszlhxkoU8RfXRoHuJhyZmbHE=;
	b=YVBxVEHDWv6hQ6pUPCBZVzufRVPsRICDh/HP8Gjd23OKHk825MbEPTF2qZgGc307h0Do
	 O8nYwOpncewsxA1VX3uQfNUvEuempVM6Pcs3nviZnb3iU5WDVxLa/G2NOXVo0RGYC1Qg1
	 8KNePuaxXdGKTpkqNTIl2PIv+7ozRGhKFR0jdhavp15xDohyydDc4Gzk/4ZWjSV0kVW7D
	 aa4cP+1Xz4pbrackseLSrSYg7b4VfwfxKQ3WUVTvOtBFGKeerYYGinkDv7RguPImr6A5p
	 f1As4XqdGKV/FYzghQGknDftazLFZQwkdvXMdVNagzDkwCFdAMMKySMGRAN73eY9A6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BbJ3RqeW;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98EC606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 06:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D98EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BbJ3RqeW
X-UUID: 68895b66e70811f18dc8c9802ae25ab1-20261123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=DdMNQgJpDMYDJsZmmEdszlhxkoU8RfXRoHuJhyZmbHE=;
	b=BbJ3RqeWtLmojxo/mHDgMoRUOHIs1oHmKVIkX/zOWTHjcN/kqY28ZTXdePC9yn9HB8hXCwV7jcce6mfyoO5b9aK8q7rkRbevbdMr5St0qj3hw6nmXDQ7MMgDSJYunlZwz9NZZywLR+L7lJr2sHuVX9+fJhVRagWPy5QemjD1vMY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:0d947ef1-6a24-4bdc-acdd-ce43aeb1c9ac,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:3f54aa66-4b51-4c95-bb1b-80ac6aad9c96,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 68895b66e70811f18dc8c9802ae25ab1-20261123
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 900272496; Mon, 23 Nov 2026 14:37:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.53; Mon, 23 Nov 2026 14:37:51 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 23 Nov 2026 14:37:51 +0800
Message-ID: <554c21aab3ff35221d362efb3f1776dda29cf8d3.camel@mediatek.com>
Subject: Re: [PATCH] ufs: core: Remove the DMA addresses from struct
 ufshcd_lrb
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>, Bean Huo <beanhuo@micron.com>, Stanley Jhu
	<stanleyjhu@google.com>, Can Guo <can.guo@oss.qualcomm.com>, HOYOUNG SEO
	<hy50.seo@samsung.com>, John Garry <john.garry@linux.dev>, Hyeoncheol Jeong
	<hyenc.jeong@samsung.com>
Date: Mon, 23 Nov 2026 14:37:51 +0800
In-Reply-To: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
References: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
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

On Thu, 2026-11-19 at 16:50 -0800, Bart Van Assche wrote:
> The offsets stored in struct utp_transfer_req_desc are in double
> words
> on hosts without UFSHCD_QUIRK_PRDT_BYTE_GRAN. Using these offsets as
> byte offsets to compute ucd_rsp_dma_addr and ucd_prdt_dma_addr
> results
> in incorrect DMA addresses. These addresses are only used by
> ufshcd_print_tr() for error logging.
>=20
> Instead of fixing how these addresses are computed, remove the
> utrd_dma_addr, ucd_req_dma_addr, ucd_rsp_dma_addr and
> ucd_prdt_dma_addr
> members from struct ufshcd_lrb and do not report DMA addresses
> anymore
> in ufshcd_print_tr(). The contents of the transfer request
> descriptor,
> the request UPIU, the response UPIU and the PRDT are still dumped by
> that function. Remove the local variable cmd_desc_element_addr from
> ufshcd_init_lrb() since it is no longer used.
>=20
> This patch changes the output of ufshcd_print_tr() as follows: the
> "Transfer Request Descriptor phys@", "Request UPIU phys@" and
> "Response
> UPIU phys@" lines are no longer logged and the "PRDT" line no longer
> includes a physical address.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
