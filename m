Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958271;
	b=ttv6J4MUM2PmaPyku+mYL3JR35y/63MC1OnsBFOSaef1ph7dmiYckOgcGH9PkZITk4Gj
	 zPn0sjIf6O8bg8k1HL+wFCCVuGn/13ZOwFfd3z/SIBgUF1U9zDl5hSQiBKYRnY+szdJHr
	 ZuYFu3JDgPCsYfDkgjSgmrFNO8L0thx/pCCdCmTr6pV7SX6QvierKk9gZYDm9mOmmI5GB
	 PGvuS1PqL8ZWkHbojxlFklJ0wFVT7qJ/v+hi8ZjetBB34e6hBV+KfAvxy26p0nPxGBV5t
	 jryJ5b8SR4WpY2JvAsbxFgeAe36aM3L2FraVizuHlaOZcsOq1t3jSYeNsKNlduSk7cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958271;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=7qkLSDNsHpPtdGpuP2oAobTT9Cy/VQKjkzXpjdW9loI=;
	b=CPnMK5E7HdiyUSXnzc5oZ1XxXoAty+45tf8QdCFfRMZDYmA0M6OF1flgJbg664gAAo8Z
	 DTAy9GS1nEJy0Eu8Ccxn1lQzTNtTgxACEkVyQCh16v49j+jJq6A8XG0mgriGCYBIaQyJh
	 HAdk4EOltERnNasUMXkc3a+s39TKvlHMFKkxm8fOayCnbDoBdI6a68T+uMVDcba7JUlLe
	 n+ycazstPxcsUkeNaMrtx3odQU/WVUxKqqFkTO9mkc/ZEA06rkJ2K9qDfvmkDQf+td6s9
	 QQA+D/GR1WHhVc4P+CY6eqy1Mvv3prKt6b+Izm6BATABvC0UuX5VQ9s7/4D0/7KHaEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=KIde3eX7;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05D606A326;
	Fri,  6 Nov 2026 09:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D05D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=KIde3eX7
X-UUID: a40d2accd9c611f18dc8c9802ae25ab1-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=7qkLSDNsHpPtdGpuP2oAobTT9Cy/VQKjkzXpjdW9loI=;
	b=KIde3eX7Dl41VfHQjfUWsAA3knK1Si3j9mwGfSmIKcYlrjSZeU8MZd9nTYzHZIEFhmNWQqWmWyiHqe5wJwu1cnfOVXNNfRj57KSCeLeHJvCTJFUrxAKua6EaiWxGPG6ghBNu+0shkEw2OgzxeD8vRqCDVDkOa0suc6OPHsXcS+g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:55f36f11-552f-472e-ae12-009cc7d0d318,IP:0,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:3
X-CID-META: VersionHash:b0318ac,CLOUDID:c87fcae2-c507-49f8-9d86-f8f27ad8f799,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:4|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a40d2accd9c611f18dc8c9802ae25ab1-20261106
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1301741046; Fri, 06 Nov 2026 17:44:20 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 17:44:19 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Fri, 6 Nov 2026 17:44:19 +0800
Message-ID: <f2d51c2730a748f8ae1f01d8328119ccea12d6ea.camel@mediatek.com>
Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Peter Wang <peter.wang@mediatek.com>
To: hoyoung seo <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Fri, 6 Nov 2026 17:44:19 +0800
In-Reply-To: <973576304.21793952182671.JavaMail.epsvc@epcpadp2new>
References: <cover.1793931113.git.hy50.seo@samsung.com>
	 <CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
	 <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
	 <9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>
	 <973576304.21793952182671.JavaMail.epsvc@epcpadp2new>
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

On Fri, 2026-11-06 at 16:58 +0900, hoyoung seo wrote:
> Hi Peter,
>=20
> Thank you for the review, and for the Reviewed-by on patch 1. I will
> add
> it. Note that I have already posted v7, which reorders the series
> following Bart's comments:
> https://lore.kernel.org/linux-scsi/cover.1793943246.git.hy50.seo@samsung.=
com/
> =C2=A0
>=20
> On your question about making __ufshcd_wl_resume() trigger the error
> handler and wait for it instead of calling ufshcd_link_recovery()
> directly: I think that is a different design from the one in this
> series, and I see a few problems with it. I may be missing something.
>=20
> =C2=A0- While the system PM callbacks run, host_sem is held from
> =C2=A0=C2=A0 ufshcd_wl_suspend() until ufshcd_wl_resume() returns. If
> =C2=A0=C2=A0 __ufshcd_wl_resume() waited for the error handler, the error
> handler
> =C2=A0=C2=A0 could not wait for host_sem (that would be a deadlock), so i=
t
> would
> =C2=A0=C2=A0 have to keep taking the early link recovery path during syst=
em
> =C2=A0=C2=A0 resume. This series does the opposite, as Bart suggested: fo=
r
> system
> =C2=A0=C2=A0 PM the error handler waits for host_sem, and the early path =
is
> only
> =C2=A0=C2=A0 used for runtime PM.
>=20

Hi hoyoung,

I think both ways could solve this issue. But excluding system PM fast=20
recovery seems more complicated. Perhaps we should wait for Bart=E2=80=99s
thoughts, but for me:
1. When wl resume fails, having different error handling would confuse
me.
2. Does the runtime resume error path still have a chance of concurrent
recovery?


> =C2=A0- The link recovery was put into the resume path on purpose. Commit
> =C2=A0=C2=A0 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 ex=
it
> fails
> =C2=A0=C2=A0 during runtime resume") says that the error handler got stuc=
k when
> the
> =C2=A0=C2=A0 h8 exit failed during runtime resume, and commit 62c015373e1=
c
> moved it
> =C2=A0=C2=A0 to __ufshcd_wl_resume(). As far as I can see this is because
> =C2=A0=C2=A0 ufshcd_err_handling_prepare() waits for the runtime PM opera=
tion
> that
> =C2=A0=C2=A0 is in progress. Waiting for the error handler from the resum=
e path
> =C2=A0=C2=A0 would bring that dependency back.
>=20

Yes, but now error handler recovery will be handled first, so it won=E2=80=
=99t
reach=20
ufshcd_err_handling_prepare. So, there should be no deadlock concern,
right?


> =C2=A0- __ufshcd_wl_resume() needs to know whether the recovery succeeded
> to
> =C2=A0=C2=A0 decide how to continue, while the error handler returns no r=
esult,
> so
> =C2=A0=C2=A0 it would have to look at the HBA state afterwards. It would =
also
> need
> =C2=A0=C2=A0 to avoid queueing the error handler again if it is already
> running,
> =C2=A0=C2=A0 similar to what __ufshcd_wl_suspend() does with
> =C2=A0=C2=A0 ufshcd_eh_in_progress(), to prevent a second recovery.
>=20

It only needs to queue_work and wait for flush_work, and believe that=20
the error handler calling ufshcd_link_recovery will make everything
good.=20
Otherwise, __ufshcd_wl_resume has no way to handle it either, right?
Even if it is queued twice, the second time it will check=20
ufshcd_err_handling_should_stop and do nothing.


> =C2=A0- Other callers of ufshcd_link_recovery() (ufshcd_eh_timed_out(),
> =C2=A0=C2=A0 ufshcd_eh_host_reset_handler(), ufs_mtk_resume()) would stil=
l call
> it
> =C2=A0=C2=A0 directly.
>=20

My earlier thinking was that if an error occurs during resume,=20
doing recovery directly is faster, because it isn=E2=80=99t necessarily
accompanied by an err handler worker.
But if the err handler might also be triggered, it would be=20
better to simply trigger the error handler, let it perform the=20
recovery, and wait for it to finish. Would that make more sense?

Thanks
Peter


