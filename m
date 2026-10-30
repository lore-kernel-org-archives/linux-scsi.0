Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793347252;
	b=25tFoFUDFYN7Cs4XCzqsVlhJJAz2hEpqzCIzjjsUB+f8vhA8iOT6MsApjXUV8ASa2z81
	 Cs5O36bXxUirmj3QCnelwVi1JpgZl2tfjc0/NOjbusjpxoCR+Wd8AvHqTkKO/0cV2ce0D
	 xhAwL1LNPJfwXWd10CipNd/9kL+8ws8XJ5JJM8RHD064dTg0Tp5KKbxAacEtyDDq3bWvR
	 J2TKCvlYvQ8pucDZpplOYfGJKN9v6zkslbVG4IFBZl+RgDaVaEelUhS+w1ASnDdItDQZq
	 iUUfzGGpRR61fkI8BfeSPe7MjkKUa2TYxMvYskzR3IqH60x9PxVnv1ZDHmNqP5U9qAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793347252;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=gi+EdD1IbZiL8Wyo/cERszuoHUVwYTFxrU1yZuz35bE=;
	b=BVptMnyXCPXPrGNP/EcWbOcLhwdRnpttkYuS+AI3XSAYuLa4JHIn2E/VmYMcCxYwFy4X
	 kLtlkEBRsOIxtnDgXQbd9UlVIHo8F3VdnddcF9nJKUURZRuZ8CKs0GD/jgyG1PyW55JEo
	 BcUW2oq6M61xVr+75UEqp5CUye0oMXJwz1QrIY98mEH4HI9hMoXTZrnNHbdtz0cjvgxyt
	 SC0Ol4ovqnFsBY21wEFJlGLryJSjC4jXmA1wxarIUjLGCfEueE+D/7+1eO1nQ2bE38htm
	 BjgC0XUoAAqseNFVn1gkK7fBK1x78RlfwPz18S7kQI5JnfT05p5uGC5bneJvVWlhw4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=EOfIDC5C;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3F606A31A;
	Fri, 30 Oct 2026 08:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFE3F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=EOfIDC5C
X-UUID: 022a3134d43811f1b1788b6acf885367-20261030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=gi+EdD1IbZiL8Wyo/cERszuoHUVwYTFxrU1yZuz35bE=;
	b=EOfIDC5CggrD96IY1+ZuEOF7CgEzaVPwxeh92VwhnRXhw0olxxgF5kftKJBZEnIDCdWRAuiNj1gLZILwPZiOCV6Y0f7vu1mqgGmxr9gUAiSF4V3SmfR0TlmUFBHsTC0l7A+zGGEwZaNFainQMX5GraNSFLxNrylmrPeyP0u4iyQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:44eb3c99-d2a7-453c-bc3e-05e07d95c225,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:b0318ac,CLOUDID:5b2ae7ec-b50c-48b5-b20a-bfe3130e16d3,B
	ulkID:nil,BulkQuantity:0,SF:81|82|83|102|836|865|888|898,TC:-5,Content:0|1
	5|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 022a3134d43811f1b1788b6acf885367-20261030
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1508496471; Fri, 30 Oct 2026 16:00:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Oct 2026 16:00:42 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Fri, 30 Oct 2026 16:00:43 +0800
Message-ID: <c6c84b433923fb2c4d332dfd79875be9ebbd1681.camel@mediatek.com>
Subject: Re: [PATCH v2] scsi: ufs: mcq: Reap aborted CQEs before returning
 from abort
From: Peter Wang <peter.wang@mediatek.com>
To: Jeuk Kim <jeuk20.kim@gmail.com>, <bvanassche@acm.org>
CC: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
	<avri.altman@sandisk.com>, <beanhuo@micron.com>, <can.guo@oss.qualcomm.com>,
	<cw9316.lee@samsung.com>, <hyenc.jeong@samsung.com>,
	<j-young.choi@samsung.com>, <jeuk20.kim@samsung.com>, <john.garry@linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<mkp@kernel.org>, <ping.gao@samsung.com>, <rafael.j.wysocki@intel.com>,
	<stanleyjhu@google.com>, <vamshigajjela@google.com>, <stable@vger.kernel.org>
Date: Fri, 30 Oct 2026 16:00:43 +0800
In-Reply-To: <20261030011321.1868029-1-jeuk20.kim@gmail.com>
References: <20261030011321.1868029-1-jeuk20.kim@gmail.com>
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

On Fri, 2026-10-30 at 10:13 +0900, Jeuk Kim wrote:
> From: Jeuk Kim <jeuk20.kim@samsung.com>
>=20
> ufshcd_mcq_abort() can return before the OCS_ABORTED CQE is reaped.

The Initiate Cleanup procedure polls SQ_CUS until the=C2=A0
MCQ_POLL_US (500000) timeout expires. So is this issue caused by=C2=A0
the hardware completing the cleanup operation only after the=C2=A0
timeout had already expired?

Thanks
Peter
