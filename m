Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500880;
	b=LXj9vghIasJT4WnrPFuFadZBOtGZkZ1uwW8jEADJt6R9Ag9NynCNeWrbkh/rjornG0//
	 zK14vgZuMmbEMJub3IRM8gdhKKSbZ1J1wkkYRrRuJb9gmV3v7EZuoVVt4T+wHX29KduqV
	 ELHhen9wfiw6BPgWoCz3o+lH2AYOOgisfpCBt3IR8h+ZV5GHGeExPUW3Mkj1SSJ9Bbmp8
	 Ddb/sZ8ojF+MepZKIU1mhaHrnOtrn5V74m9grfOb82vvaJrf2kYrlE30NpOW+kZ1YWLkP
	 IZCvIiyOEdV7+AFTmitvhoyK8pFyQ7AJbvYMlPE+AT417T9X5dNp+OWlE4Q+QnpfF4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500880;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=JKy9gF86DBJHYr3P4LCSvi1G0WTrhHdbiVY1875cvho=;
	b=3MnDZ4SGiPe+VyR0oYNpDX9cOlObOaLYQuoIPTuTwe3Yf86kKgubwX0SX5zQ5nMGGmnF
	 zolvbforHNilEvW3kwXkD8UcrcxFZ8F/Q8niFQc4S7rEAZlS9y3Xwk8W8dRbYzEfjhnVs
	 M2AMk9mWhcHoYvcu0CPLUXHskSqSfX7ggE+9fWfi6Dp5SLKm6teYp0FUlrGg92mnFbIO4
	 72CxFKg9y/G+J6YnCvJlP0/RwVTco91a7qHBb487XUdBadyp9dvb9sS57LlpKbH99j3yj
	 PPwC/fS1qDCzmKCLPRRmA4VRJT7UZGELeEpoQaRjiyCw+jutAbt+RX4dGYAfpfikVVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=IlwKhcco;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C5E606A31E;
	Tue, 24 Nov 2026 06:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61C5E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=IlwKhcco
X-UUID: 4e65dde2e7ce11f18dc8c9802ae25ab1-20261124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=JKy9gF86DBJHYr3P4LCSvi1G0WTrhHdbiVY1875cvho=;
	b=IlwKhcco/bEK81/nSNNZNYh0CaCuWIwz7QL8sYieleTVnIPDh1dKJsvGsdQ4uCuqmzGtWJ257nVsc1QlhG/jCJYk70u8yVddlceh0+4UqbdqH2xY7XcVO0rNQe9PIBdlVCOWi6CrGZAp0nUyGsYEjGP/YUAEoEBgvVZlRZDStUo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:e281b0b3-0c5c-4952-b20c-069ccdb56385,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:07822ec4-463c-4628-987d-7a9605ae5537,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4e65dde2e7ce11f18dc8c9802ae25ab1-20261124
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 95448549; Tue, 24 Nov 2026 14:14:28 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 24 Nov 2026 14:14:28 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 24 Nov 2026 14:14:28 +0800
Message-ID: <0849f8a091ab35cfc2220ec5fb275f0fc95461a5.camel@mediatek.com>
Subject: Re: [PATCH v4] ufs: sysfs: Add WB partial flush mode support
From: Peter Wang <peter.wang@mediatek.com>
To: Daniel Lee <chullee@google.com>
CC: <James.Bottomley@hansenpartnership.com>, <martin.petersen@oracle.com>,
	<alim.akhtar@samsung.com>, <avri.altman@sandisk.com>, <bvanassche@acm.org>,
	<tanghuan@vivo.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Tue, 24 Nov 2026 14:14:28 +0800
In-Reply-To: <CALBjLoAtLCcQJ2TQD4uuTJR-eiD1Dqr+Q2oV1+8K4pnOKRuOvw@mail.gmail.com>
References: <20261117004729.635562-1-chullee@google.com>
	 <f63d7506b930b710d9a31f082b97a0e43e75dd50.camel@mediatek.com>
	 <CALBjLoAtLCcQJ2TQD4uuTJR-eiD1Dqr+Q2oV1+8K4pnOKRuOvw@mail.gmail.com>
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

On Mon, 2026-11-23 at 15:32 -0800, Daniel Lee wrote:
> Hi Peter,
>=20
> ufshcd_is_wb_attrs() determines whether a query request sets INDEX
> via
> ufshcd_wb_get_query_index(hba) or leaves it as 0.
>=20
> Per JESD220G Table 14.28, 0x42, 0x43, and 0x44 (along with 0x3F) are
> Type "D" (device-level) attributes and must use INDEX =3D 0, even in
> LU-dedicated WB mode. Only 0x1C-0x1F, 0x40-0x41, and 0x45-0x46 are
> "A/LU/0 or D" (Note 15) and use ufshcd_wb_get_query_index(hba).
>=20
> This was updated in v4 per Bart's review [1].
>=20
> [1]
> https://lore.kernel.org/linux-scsi/9d58cbf3-e0cc-41b8-8958-df8abd505524@a=
cm.org/
> =C2=A0
>=20
> Thanks,
> Daniel
>=20

Hi Daniel,

Thank you for your detailed explanation.
I missed this part of the spec.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>


