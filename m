Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795674429;
	b=cZN8VakcEpndgIq9rOv52ZBXsZYbHOYG/aVRD4oUfn3417FzgZhM27EjCsUWv/SQePbp
	 QXP98DQ460y8tVh9XWvPiDdyfYR8FpG0NlfuJfflQMAQ92sFkyYFZwxYjAXmDEF+SvdH5
	 Gr5kcknhg1PhJA0x9AWpSQL5jq+F2jSahtycWz/TVnPRNorL5jt9wSfhvMDQ/FAhTe0nX
	 BOcpdWp1fX9iiqW4/F95cmEbxNhqosXaVilaIqhS6prA5pwihDtoHgzTcPy0x7si985Tv
	 b+SvD/tqOHcnMMg0NhmjcytaMFqMVFKuRwElHJOND38K3daeTbx/m6nu/1omQk3q+Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795674429;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:CC:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=1D8mPUhCaEsrNElot8tnF/R4sri5CYIf/0Q3XZ/zvAs=;
	b=yfyAdgYUdGFLO9N6SoHyvjS6XVpL0xqAmQ8BEPP1XUsjjF7HV41lss8q+YuKBrSmEfiI
	 WxgP+5oQfuRHdhWYCDyXk/0uQ8SC+78spNnP3LLa+VWUMR2C/10zo9pFPeC+byCUHYwfp
	 vTD4+DZyUkoNVp3Nwmlob1A3BJxffXYXpasHDIrE4PVOWMAAN/H8OYCnQYl6I6g4naHnN
	 fYjk8TyeF/6CTHVQZ2ITdNDCrqrGBr4bnIJ+djP29PeT4qSbcNOAyNgOEyx4VbVP6uReY
	 if9lmsfsCqCTyqGV//LZCQtf0E+Ef2BatrBSYN86qa/0zBHMYK8t8w66JaKMGyLA/dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BzNfJwX4;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A78606A31C;
	Thu, 26 Nov 2026 06:27:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25A78606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=BzNfJwX4
X-UUID: 61979708e96211f1a7aecdb2598be72c-20261126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1D8mPUhCaEsrNElot8tnF/R4sri5CYIf/0Q3XZ/zvAs=;
	b=BzNfJwX4NxxWehmFX2R/keIXjxZs5cEdCNWjoTeQzANUA6e24YxZU3t2fEaUBoowpjADG/A2VJXiPX4vd9idA4EX0TXlwenRW8+J/U+OX05lDQG7o3fgSIsal37CMT8rz71Vj2+QkGnJGiWitDb74Uy/2R5NkLSLiY1P3LASK9o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:64a89749-c2c2-4185-a606-620f12ad19ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:44ba5d31-f289-4656-bb36-27baf4489f11,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 61979708e96211f1a7aecdb2598be72c-20261126
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1503983675; Thu, 26 Nov 2026 14:26:57 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 14:26:56 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 26 Nov 2026 14:26:56 +0800
Message-ID: <17e91a1ef61133b5c3e0e736577c9596091667ca.camel@mediatek.com>
Subject: Re: [PATCH v3 0/3] scsi: ufs: core: Add debugfs for PA TFS/FEC
 error counters
From: Peter Wang <peter.wang@mediatek.com>
To: Po-Wen Kao <powenkao@google.com>, <linux-scsi@vger.kernel.org>
CC: Konstantin Vyshetsky <vkon@google.com>, Randall Huang
	<huangrandall@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Bart Van
 Assche" <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Stanley Jhu
	<stanleyjhu@google.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<mkp@kernel.org>, Can Guo <can.guo@oss.qualcomm.com>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 26 Nov 2026 14:26:56 +0800
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
References: <20261125113435.1426680-1-powenkao@google.com>
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

On Wed, 2026-11-25 at 19:33 +0800, Po-Wen Kao wrote:
> From: Brian Kao <powenkao@google.com>
>=20
> This series exposes the MIPI UniPro v3.0 PA layer TFS/FEC error
> counters (0x15C3-0x15C7) under debugfs:
>=20
> =C2=A0 /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/
>=20
> Patch 1 fixes an existing teardown race by removing debugfs and
> disabling debugfs_ee_work before scsi_remove_host() removes the WLUN.
> Patch 2 defers debugfs creation until after device init while keeping
> debugfs_ee_work initialization before IRQs are enabled. Patch 3 adds
> the PA_TFS_* and UniPro 2.0/3.0 definitions and creates
> pa_err_stats/{host,device}/ based on PA_LOCALVERINFO /
> PA_REMOTEVERINFO.
>=20

Hi Brian,

The series looks good to me.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
