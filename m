Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216760;
	b=ceQzytUV4mpycYtYgg2v8L05vkdd/wZ2ijVncHHCjDO3KaUYIq5unM8uahh5fbqQo8yz
	 kS1xGruwxL+4G/0CSkD4hfn8dWUp65D24497hUThtL3c74RUU3dKxHLU+IHEJYyfcqzNI
	 6Aw/OjJ6AjoN82ZHlI8xNe+w2980ADjdiehlR0f0ENoVByfFoCYd7lvXT0ppx0a3uknAY
	 prxaSpS7dbo2CLjHMcJqkX3cIhQxy6otnz2oWhKfs7o2DmfeQ32w21DivamG+wPBAhpyj
	 xge7Hufq/cu5cAvlTumsgw5P7VhSaeUC4wltenhN5pCym9UvWevmA5nU9rvfS5+tYGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216760;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=vE6LKcUg9D7f+xaxU0MaTQO6MuWuVIL6PX2vdi0lTZk=;
	b=qGMZgg/o1P34N5/7VtuCzwV080nSqU3+5fNuC+aoiUDePMppllTH0LJI5zON/bdvjpsQ
	 9LZLr4FkAQjJnaXIVd2B5M5AWVTcPCG7oMqos2JXcP0FsJXylaEKtrEtHGPpBU26SaToL
	 3iNiBtcv+EGqrgoSx525NhaCpt/9sZCX/6h4m6HrpUn947JZBiGPF2XZphudCsxTKKbiv
	 B5g8g7yT8nmtooVuBbB7+p6d7ugTVbHGvW9LKzsE1KcUPLkyknwe5BSyYdBhRnXn+sgKN
	 SMss+IDuYhqyT1rIQ5G5hKU54Zw3wYNtj6AJW7Wqe6E9tWyrkpr4/OMNcR+Q+HqysHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=NPVbJegJ;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98532606A31C;
	Mon,  9 Nov 2026 09:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98532606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=NPVbJegJ
X-UUID: 7eff819cdc2011f1b1788b6acf885367-20261109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=vE6LKcUg9D7f+xaxU0MaTQO6MuWuVIL6PX2vdi0lTZk=;
	b=NPVbJegJtjDNVf5Q7EB1hFlwbE2aq54GiXdMfkp7MymlKkkaCOGsFaoWni79MiS01LUNuPsJK4+dKM4E30BEpwrOmsu/R5dpjwxGFUEE248S5H8zRer/MtBh/EYHxBJcknwtT4SLUt/rh271trAtSZewctDrtfjpKpsXJ4dz6ww=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:7595c2d4-7cab-4c07-812a-de16c2e4a454,IP:0,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:3
X-CID-META: VersionHash:b0318ac,CLOUDID:ed730657-a87d-42b7-8ffd-9e23ca174329,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:4|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7eff819cdc2011f1b1788b6acf885367-20261109
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 435016449; Mon, 09 Nov 2026 17:32:35 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Nov 2026 17:32:34 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 9 Nov 2026 17:32:34 +0800
Message-ID: <288dc44bd6dddb5265e6a1cafda38ee6fec46902.camel@mediatek.com>
Subject: Re: [PATCH v8 3/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Mon, 9 Nov 2026 17:32:34 +0800
In-Reply-To: <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
	 <CGME20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947@epcas2p1.samsung.com>
	 <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
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

On Mon, 2026-11-09 at 13:09 +0900, HOYOUNG SEO wrote:
> ufshcd_err_handler() recovers the link without taking hba->host_sem
> whenever hba->pm_op_in_progress is set. That early path was added by
> commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
> deadlock") because the regular error handling would wait for a
> runtime
> PM operation that cannot complete while the error handler is waiting.
>=20
> pm_op_in_progress is also set during system suspend, system resume,
> shutdown and poweroff, where the early path is not needed and runs
> concurrently with the PM path itself. For example, if a LINERESET is
> reported and the hibern8 exit fails in __ufshcd_wl_resume() during
> system resume, both ufshcd_err_handler() and __ufshcd_wl_resume()
> call
> ufshcd_link_recovery(), and the host and the device may be reset at
> the
> same time.
>=20
> Only take the early path while a runtime suspend or resume of the
> WLUN
> is in progress. The runtime PM core sets the runtime status of the
> WLUN
> to RPM_SUSPENDING or RPM_RESUMING while ufshcd_wl_runtime_suspend()
> or
> ufshcd_wl_runtime_resume() runs, and it is RPM_ACTIVE or
> RPM_SUSPENDED
> during system PM. Read it with READ_ONCE() without power.lock held in
> the new helper ufshcd_rpm_transition_in_progress(), next to the other
> ufshcd_rpm_*() helpers. The status is only available with CONFIG_PM,
> so
> the helper returns false without it.
>=20
> For the other PM operations the regular error handling is safe:
>=20
> =C2=A0 - the system PM callbacks hold host_sem from ufshcd_wl_suspend()
> until
> =C2=A0=C2=A0=C2=A0 ufshcd_wl_resume() returns, and ufshcd_wl_poweroff() h=
olds it as
> =C2=A0=C2=A0=C2=A0 well, so the error handler waits for them;
> =C2=A0 - during shutdown, hba->shutting_down makes the error handler stop=
.
>=20
> This changes the behavior during shutdown: errors that occur while
> the
> final START STOP UNIT command is being processed are no longer
> handled
> by the error handler. Recovery then only happens through
> ufshcd_eh_timed_out().
>=20
> Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem
> issue")
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> ---

Sashiko report issue is previous issue and should be=20
fixed separately.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
