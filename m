Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216584;
	b=VsN7VOaSPHXVSwHtKlZcvkx/iNh4Pr82B18RYUnJo4LNhAjzmcPj4JeXzDBtxvmC6Wb4
	 5BhV14CvWudnGNj3FTXgW9g6+k07PeyG0Io1J4SB/xNvZAdv41Z+xI8AfAJHlq/4I8bz1
	 OTANLCPIHyEX7OFrsjv6GoIvoUrnVbk6fqcIkaR+9aaCzx3pGA8iEIBESC97EkQBVHCsL
	 ij6VP+cq1a0VwcAFKTqDx36aJwgcP5GI1BlGMBvC0pE+QSKGrh+jWnu0Io/Wp7vpF2ewH
	 xvKycPR/6DpExeahh+nYwhLtJzD/jF0xqYgaKJ1umJHpO57D7ShTZH9CrPeVSnrVQgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216584;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=4shBtDYiQZmdYbTA4PysIE1ShY1jUiCpZkoBe53ww9s=;
	b=MpyBaKEhEO+YKrufIJFKjcZ7SdKenQuffWjHzvw9TKnR3M+ANL4Y2TIJmcAg3gj8WXEh
	 J0+tqBRJUUh3poJnxe4E5DUE3bStlnn7ZxpYUyKxw48a3x2t6LVXF3PGGBayyubKKFNeJ
	 afRI/ArBMhyrIyehB7urf8c7Gzh1DuHLcBxWc6gAmBRUHfodzjYHLMYTaW9Tz85B/bpMp
	 SVLX9twKV6oSDmW+iokeFPyTOb/fJM2ElmsaFStDPuP4IfHSBUzT7XFF+nHhi8pt0oN3c
	 baYVCIMsFN2lXYaQqyauSqL/zt3OYpp55KLWdfDaZx2ZqMoEaXERzUNczbp/S/0oSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=MMWrvwNH;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A5D606D803;
	Mon,  9 Nov 2026 09:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3A5D606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=MMWrvwNH
X-UUID: 15549a98dc2011f1b1788b6acf885367-20261109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=4shBtDYiQZmdYbTA4PysIE1ShY1jUiCpZkoBe53ww9s=;
	b=MMWrvwNHlVLVSKQucqVlGd7hSvE03wY9DnP0fs0jy3czrTibv6Yq5tGB5qd3sQ3o1J/0DgrDJAgcKvTq4O7bQhSyrwlqbcRvbI0FfpuFxL3053MW8ohQxhhWHEFlMltst/wYbTSJD8PoZXMPxaLwLd8qYIpRAWW8jc3FXUnDsV4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:ac9d6d01-032c-4730-9f56-dad679bc4c84,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:dded7e8d-b3e7-4795-ae33-b1b4d51e21d7,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 15549a98dc2011f1b1788b6acf885367-20261109
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 817843880; Mon, 09 Nov 2026 17:29:38 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Nov 2026 17:29:36 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 9 Nov 2026 17:29:36 +0800
Message-ID: <4bbfec04002d51bb8364abcad78bb139b2a964c0.camel@mediatek.com>
Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, hoyoung seo <hy50.seo@samsung.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mkp@kernel.org>, <martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
Date: Mon, 9 Nov 2026 17:29:36 +0800
In-Reply-To: <762e1686-eacf-46a5-a8fd-62acba002fdc@acm.org>
References: <cover.1793931113.git.hy50.seo@samsung.com>
	 <CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
	 <e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
	 <9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>
	 <973576304.21793952182671.JavaMail.epsvc@epcpadp2new>
	 <f2d51c2730a748f8ae1f01d8328119ccea12d6ea.camel@mediatek.com>
	 <762e1686-eacf-46a5-a8fd-62acba002fdc@acm.org>
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

On Fri, 2026-11-06 at 11:15 -0800, Bart Van Assche wrote:
> Hi Peter,
>=20
> I don't think that's guaranteed. ufshcd_err_handler() tests
> hba->pm_op_in_progress only once, when it starts, and without holding
> any lock. An error handler that started before that flag was set
> skips
> the early path. For runtime PM it then blocks in
> ufshcd_rpm_get_sync()
> in ufshcd_err_handling_prepare(), waiting for the runtime resume that
> is in progress. If __ufshcd_wl_resume() waits for that error handler
> with flush_work(), neither can proceed. This is the deadlock that
> commit 35dabf4503b9 addressed and that the comment in
> ufshcd_eh_timed_out() describes.

Hi Bart,=20

Agreed, there is still a race window. But in practice, the
issue happens when wl suspend/resume sends a command.
But we cannot guarantee that there are no issues with=20
power/clock on/off.

>=20
> System PM has a similar problem. __ufshcd_wl_suspend() clears
> hba->pm_op_in_progress before it returns, but host_sem stays held
> until ufshcd_wl_resume() returns. An error handler that runs between
> system suspend and system resume therefore takes the regular path and
> blocks in down(&hba->host_sem). A flush_work() call from
> __ufshcd_wl_resume() would then never return.
>=20

Yes, unless we refine the system PM flow.

> Additionally, ufshcd_schedule_eh_work() does not queue the error
> handler if the HBA state is UFSHCD_STATE_ERROR. In that case
> queue_work() + flush_work() would not perform any recovery, and
> __ufshcd_wl_resume() would have no way to find out whether recovery
> succeeded.
>=20

Agreed, it looks like there are still more scenarios to
consider. And it is also complex too.

> Yes. The cover letter mentions this. That issue predates this series,
> and I think it should be addressed separately instead of holding up
> these fixes.
>=20
> Hence, I prefer the approach of v7 of this series.
>=20

Sorry, I missed the cover letter. Thanks for the reminder.
Let=E2=80=99s move this patch series forward.

Thanks
Peter
