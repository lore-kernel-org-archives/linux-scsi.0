Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B943BB13C;
	Wed, 23 Sep 2026 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143791; cv=none; b=VoVhDmKT6xrkmlKATcP7I5V+psqgUR4n7cVRXan0mX62ajJBNNhi1zXjp2o6nJf+eWEfnJ3yfG4103t6CKSPFZPVCsAl7we0nIJY9rGr20TzOGeeNFJbfzyoi1avip7evz4OV8Mk/AJ1avyffHlBJBCGQN8Fj+nHWBmX/KMO5ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143791; c=relaxed/simple;
	bh=yK4GGOQ7q5Jsm1hYN2ke5S7Bqv10s370fwH9Yyni3vI=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kODsx93FKYOKSLmyVib4Zfcn35z2AqWeFj5th5O4POzdG8uLjA1Lbmlq5PWextVUbQPRaLSQO+qXVv9+RVArYuFIuai0jHk+jmMWVpd7qq7qKvgrD4GRx5/VCAJw3VL8xP1G98wuPD3CHFLJ/A3p5ZbhRch038oWml2sDS/dukM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IKQnwyxN; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IKQnwyxN"
X-UUID: 5f11ebfcb71511f1b1788b6acf885367-20260923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=yK4GGOQ7q5Jsm1hYN2ke5S7Bqv10s370fwH9Yyni3vI=;
	b=IKQnwyxNkwJqFWv0FtVHRGyimrXGeYSy4yUIrlmYvcJeK1HS6uB4lL30JIU8p6mZeRczirm1HP8iocRNj6lMkSNGFxGND9T3i26ThyMQx5yMnMAD0w6A0XDCPEKGd/M3VVb1qu6vzMVJ5PSiOh8MEVYkdHNkOck135wcRlj3ehk=;
X-CID-CACHE: Type:Local,Time:202609231409+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2f4c735d-1ce8-4d9c-afd7-a9fc806b29b1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:cf79dcfa-1cb6-4618-8a29-fa072b24d2a9,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5f11ebfcb71511f1b1788b6acf885367-20260923
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1828432630; Wed, 23 Sep 2026 14:09:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 23 Sep 2026 14:09:43 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 23 Sep 2026 14:09:42 +0800
Message-ID: <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 23 Sep 2026 14:09:42 +0800
In-Reply-To: <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>
	 <20260918143809.3034592-3-stanleyjhu@google.com>
	 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
	 <20260920135014.3528082-1-stanleyjhu@google.com>
	 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
	 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
	 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MTK: N

On Tue, 2026-09-22 at 09:30 -0700, Bart Van Assche wrote:
> A SCSI host controller reset must abort all pending commands.
> Requeuing
> SCSI commands during a host controller reset violates the API
> contract
> between the SCSI error handler and SCSI LLDs. I'm not aware of any
> other
> SCSI LLD than the UFS host controller driver that requeues pending
> commands upon a host controller reset instead of aborting these.
>=20
> .eh_host_reset_handler() is expected to reset all logical units and
> the
> host controller. The SCSI architecture manual (SAM) mentions
> explicitly
> that resetting logical units involves aborting all commands.
>=20
> Thanks,
>=20
> Bart.

Hi Bart,

I'm not sure if I misunderstood your point. SCSI reset=20
(ufshcd_eh_host_reset_handler) does indeed abort all commands
by trigger ufshcd_err_handler and call ufshcd_abort_all.
This shouldn't violate the SCSI API contract. But whether the=20
subsequent re-queue (DID_REQUEUE) violates, I haven't seen any=20
prohibition?

Because currently the UFS error handler (ufshcd_err_handler)=20
directly re-queues (By set DID_REQUEUE) the unfinish command,
and err handler might be triggered in many places, for example,=20
like UIC errors, directly resetting and re-queueing should be
reasonable and can be handled quickly.=20

If it cannot directly re-queue, then ufshcd_eh_host_reset_handler
would need another similar function that does not handle re-queueing.
But this looks unnecessary, direct re-queuing seems safe?

Thanks
Peter


