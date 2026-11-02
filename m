Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609157;
	b=Hrwo7+m1ox0ofOygP09TPTm1hsbSFC45kb2tEdTDuTaX0omnZsxzDGnZZeDyT1wEEtUC
	 hFtUl6UHcNQdiCn6Yi/bxVoJ4qB8GOEogBt+ll2WzCO/yhFv9XtNjEGmuwlKkM8At5EGg
	 WVzcBr91R8cSMnf2ILxpS6YNBM1zv6Mca1q1CPEC3UEf2/vT2ykhdqMdLTFS3bEPXhdlw
	 KpwoY0V+qpYtB40I/aj+y/LwPMjGRVq9Zx7ywFX4nAS7UUwa/Q8UBOHaMC1Vl4axnwKdg
	 4iegowFlVDeigkWWq3zKrSu2RBUUhz2scRczhE+ZnZeAo9Ij9psSWGarlTnD0WUmk8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609157;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=N7IcLcY/2Q1a/DaiRss1bOBrzubEkqeVJXqoWeZs/mA=;
	b=zqp/1sLsQhnlCMcJzhr/Hj8bBZRnVCM8IsiU47o1NKL9nP1BulLg3fZcJG17NMaOFJEP
	 ZuNJjC1rZhGBDj+NoXvvdTlnf1kSgqdmWQGmY3xcOMC5KfzP5mirOrBb3LUQCs82581fM
	 Udh7M1mMmsbVhgb/AJn3FXgSanhTxpQTe571tcOnR4V2yaxKcJyBcvjq+ajYj+5iB/CTe
	 UXkZhIVlfWAv7da2MuzqpDXHW5Ulel/rjg5Wb7em9LIzhyVFF3/NLD5EDhMBZo+Uz7Azd
	 duc6+aXto6kI00d+MIkHWH0K9t21MJN6qV27OtcqZqpsI1V8BZtp2UCl+9i94cHJG7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BfJwTguc;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3324F606A32C;
	Mon,  2 Nov 2026 08:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3324F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BfJwTguc
X-UUID: c91ae8cad69911f1b1788b6acf885367-20261102
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=N7IcLcY/2Q1a/DaiRss1bOBrzubEkqeVJXqoWeZs/mA=;
	b=BfJwTgucK/Ee5gFxohBBJAqLEbcpwChisbLKFv7HQWQZerUlApzn+FngR0nyV4u6Pqkn7wef23YK6+Ym3JFb72rWgqOFX7EDZBnMkgwLw+jsL30B/+/5ibqBXzrz3+15+ZanEKto0mztmLVS/O8bGWYfhji3/jE6uEbxBvNr0hg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:11d191ed-1025-4b65-ba0f-5c0fcb6f33d9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:71f6b1ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c91ae8cad69911f1b1788b6acf885367-20261102
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 302211017; Mon, 02 Nov 2026 16:45:41 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Nov 2026 16:45:40 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 2 Nov 2026 16:45:40 +0800
Message-ID: <bc9e2b99be871ef8c7e74a5ee7d573082cf61545.camel@mediatek.com>
Subject: Re: [RFC PATCH] scsi: ufs: core: Allow error recovery before the
 device W-LUN exists
From: Peter Wang <peter.wang@mediatek.com>
To: Asdlerto Korry <korryasdlerto@gmail.com>, "Martin K . Petersen"
	<mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, Can Guo
	<can.guo@oss.qualcomm.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Mon, 2 Nov 2026 16:45:40 +0800
In-Reply-To: <20261102003607.341651-1-korryasdlerto@gmail.com>
References: <20261102003607.341651-1-korryasdlerto@gmail.com>
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

On Mon, 2026-11-02 at 02:36 +0200, Asdlerto Korry wrote:
> ufshcd_err_handling_should_stop() returns true while hba-
> >ufs_device_wlun
> is NULL, i.e. until the first probe has added the device W-LUN. If
> the
> link fails during that first probe (for example NOP OUT failing after
> link startup), the error handler therefore never resets the host or
> the
> link: it only marks the state operational and returns, and the probe
> keeps failing until it gives up.
>=20
> On a Samsung Galaxy M52 5G (SM7325) the first link startup regularly
> ends in PA errors (LINERESET). With the W-LUN check removed, the
> error
> handler performs a real host reset and restore and the device comes
> up;
> without it, it never does.

Hi Asdlerto,

I=E2=80=99m a bit curious why the first link startup fails, while=20
the link startup after a reset and restore doesn=E2=80=99t.=20
Shouldn=E2=80=99t these two flows be identical?=20
I think the driver is designed on the assumption that the=20
basic init must succeed, and that only a re-init can make=20
recovery possible.

Thanks.
Peter
