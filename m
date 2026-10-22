Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660199;
	b=fcrsBU7PKxOrdf1KkQwWqU4KA7BTJkObijZPPYCNl+XKEERd+JlzarJ49OllKlCzLHUc
	 tH8Gcot7eQTlgjQeG8lUJVHpHX7AyQdA/REP5QgfmKYVLItrdqXnBl5V+5xedsPaR/n6G
	 gXc60kUBXJ1dXRfiDsNZNDYJjtEPcODOg+A6KcEA8ijgiKb30fgYkXDih/r47CsiaA/Ri
	 dOok53ogCwvBf9STP3xaRST8r4KUi0d2lXQGceiOY1G0VrZfXYUBOvlo1TLTZ33M0M9B4
	 Qpuw3rYCoO6/f/s+GQl0zdjcUuUJ5CgIC2JLmXw9C6r2s7hA5bOQs33wo6Z2VMca5gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660199;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-CACHE:X-CID-P-RULE:
	 X-CID-O-INFO:X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:
	 X-UUID:Received:Received:Received:Message-ID:Subject:From:To:CC:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MTK;
	bh=jlF/kBcT0hhGl0loNqedHeNtTpaQZvYIpF5ZGyB+n9k=;
	b=eYTZYL/cnsqRmEST+CUC/NiglovG06g1mpL6KoJ2iPuhdxkZjYFtTCFRUzV+PRY8brLm
	 r7KkAy1u7VY0EFcQvE7hRmYVkgGRBBQ/1uiww2Ovf+vUn7mBNrYHReM9fg7DCQplf7I+i
	 yTAy/yhJfBKr5MHTlxoYbLz8vd20kXEDWcNuxUtnPyEKMC2rsKtlh2Wfj+kfW0cxnziLr
	 WDPQ4k02s9uVugTVrJh5vh3u9Oi+LFTkG/kzwPG4Yy53iTELsELqiYaqIB8Hf5NAUvKJt
	 sLoCSbdG+K+rZatnYN8BFqcv/g5LspGPfO0vS20/AZ9pPuzyr1AktC7Z1YLVq6EljXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=LleaQ26q;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A585C606A319;
	Thu, 22 Oct 2026 09:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A585C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=LleaQ26q
X-UUID: 569fc67acdf811f18dc8c9802ae25ab1-20261022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jlF/kBcT0hhGl0loNqedHeNtTpaQZvYIpF5ZGyB+n9k=;
	b=LleaQ26qZFhZaKd1/fEJRpoWHldjwUOK5vdiVbvnUNEIiWLAqY/+Sg9kDFFSMHprR1aTGp4M6RZS/jQ9tWOsZ0gaSWfydsD47XaGLTe1tL6DxrTFXr0srmAFzxYEaGEz5Sb5OJ24eLsteC9jPE9TvhX0KVniP1baO/hhJDJojTI=;
X-CID-CACHE: Type:Local,Time:202610221707+08,HitQuantity:5
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0a297712-07e7-4671-898d-3a33653d20e1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:390eeaba-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 569fc67acdf811f18dc8c9802ae25ab1-20261022
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 56340743; Thu, 22 Oct 2026 17:09:51 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 22 Oct 2026 17:09:50 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 22 Oct 2026 17:09:50 +0800
Message-ID: <ef0c66c3704f3426e5fb0d26e61adfefd35eb9fb.camel@mediatek.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in
 ufshcd_abort()
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: "Martin K . Petersen" <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, Can Guo
	<can.guo@oss.qualcomm.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Date: Thu, 22 Oct 2026 17:09:50 +0800
In-Reply-To: <fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>
	 <20261021040615.3566831-3-stanleyjhu@google.com>
	 <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
	 <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
	 <fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org>
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

On Wed, 2026-10-21 at 09:37 -0700, Bart Van Assche wrote:
> On 10/21/26 6:28 AM, Stanley Jhu wrote:
> > A return value of 0 here means the completion path, rather than
> > this abort path, has claimed the tag and may still be running
> > ufshcd_release_scsi_cmd() after it dropped outstanding_lock.
> Do we really need the code that checks that a command has completed
> without notification interrupt? I have never encountered any logs on
> any test setup that indicates that this happened.
>=20
> Thanks,
>=20
> Bart.

I remember that when the SSU timeout was only 1 sec, we'd pretty
easily hit the concurrent execution case between the timeout and
the complete path. But after change it to 10 sec along with patch=20
9a5f6c09d0fa (scsi: ufs: core: Simplify ufshcd_try_to_abort_task()),=20
it shouldn't happen anymore.

Thanks
Peter

