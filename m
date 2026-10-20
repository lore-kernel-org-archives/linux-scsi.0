Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792466201;
	b=wylvF3BSNbkqmMMjeWC2Sq0cAOl5pD2/169rQL3jDV2kwT1cKDbjVGn+myw21vwB1zeA
	 Hz3VHSVL2rlxzmk1swuoRWdFPPAkJyHXThpB6EAJCL35QTbCRRp12UQlZuckaa7ndAsv/
	 TXnt5kJNe0xPNJGDMf93HULG1cnTO0+k3iUvd9/tIgINLgLHZbfYezMnqU91vO//cncS3
	 3RmPrqlrxexoO0ztpAiDm2UsJ0IX2gguvrTC+dAfcX8l5Ru4t4auUwbRnQISp7oBi7hNf
	 ppKo0MDvZtGrpPVIo/ArjyL7LAXurAflfzZ84lmy0BJm7OKdcw0dPLQNJ45QKJXwPrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792466201;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-CACHE:X-CID-P-RULE:
	 X-CID-O-INFO:X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:
	 X-UUID:Received:Received:Received:Message-ID:Subject:From:To:CC:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MTK;
	bh=O5ZOaJ6Z72XIUmbexIu+QOXH2D6iRVNezvOias5DY8g=;
	b=LoVGGNYhwhCy0Bf4PY3lGB8cZsqRuR4t3IrbxEugL3bdz5zJlPjhQkwwVbZTk5++qTkr
	 VpxqevK0Tn5xnnmKyP30q6xpMmiyjnGuNyefFmtBN8zmGYOIOdj9bnSgq466CZNt9HNo4
	 UItCoWEcYTB/iNPI5H/8Op91bjBDRH9BEY+poQpNDKqedkaweB7Zzrjf6KSbkCCDJKwBD
	 rQP/XdpG52h5i3aLTfB73VCo9ctwZ5X8XmyGo2XSqIPsejSr3aw9DoIqxsyXpd06EtWBE
	 akIN+HEwJ02BE6m5y60wS/H1YbyGD8N+pFZJ9JF7cMqd9/ZLrNH94cYwjMqueuVLHrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rn5zoPNc;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DE1606A319;
	Tue, 20 Oct 2026 03:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2DE1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=rn5zoPNc
X-UUID: a2be2850cc3411f1b1788b6acf885367-20261020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=O5ZOaJ6Z72XIUmbexIu+QOXH2D6iRVNezvOias5DY8g=;
	b=rn5zoPNc4IJvWRuInHlTlCE7JrZGZJUUulEX79KpOZ4HDzkBS9VXc0Qrvcg9EAed93rQSQ0cKjZXcUCeYJFBc+TlROv/TkosuEejR7Y2gFr0Ws1DgS1RvlkyVQj0G2Uy3qasSjBAREadrdqrJ1aq56876x31Rg4Qs7YJYg3hSY0=;
X-CID-CACHE: Type:Local,Time:202610201115+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:554d706c-e344-4800-b1aa-339d3bc82788,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:049cddde-9ead-4216-888d-582ad3e48a93,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a2be2850cc3411f1b1788b6acf885367-20261020
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1674679277; Tue, 20 Oct 2026 11:16:26 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 20 Oct 2026 11:16:25 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 20 Oct 2026 11:16:25 +0800
Message-ID: <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>, Stanley
 Jhu <stanleyjhu@google.com>, "Martin K . Petersen" <mkp@kernel.org>,
	<linux-scsi@vger.kernel.org>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, Can Guo
	<can.guo@oss.qualcomm.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Date: Tue, 20 Oct 2026 11:16:25 +0800
In-Reply-To: <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
References: <20261017084403.875420-1-stanleyjhu@google.com>
	 <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
	 <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
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

On Mon, 2026-10-19 at 13:43 -0700, Bart Van Assche wrote:
> Hi Bean,
>=20
> There are two problems with calling ufshcd_compl_one_cqe() from
> ufshcd_abort():
> * ufshcd_compl_one_cqe() must only be called for SCSI commands while
> =C2=A0=C2=A0 'tag' may refer to a device management command.
> * SCSI commands must not be freed by a SCSI abort handler. Otherwise
> =C2=A0=C2=A0 a use-after-free may be triggered in scmd_eh_abort_handler()=
 when
> it
> =C2=A0=C2=A0 tries to call scsi_queue_insert() or scsi_finish_command().
>=20
> Bart.

Hi Bart,

So, should we remove the call to __ufshcd_transfer_req_compl from=20
ufshcd_abort, which was added by commit=E2=80=AF
64180742605f (=E2=80=9Cscsi: ufs: Fix the SCSI abort handler=E2=80=9D)?

Thanks.
Peter

