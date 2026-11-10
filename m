Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289898;
	b=NUp+kXtohfpy92E236l8Vme8yHxbBGpANOUngWRnZCv7dnI49/06xDYLbpBfUzpshbjY
	 n4WH4q3BnYPm6+gvvzzwH0Ea+F4tpjgKBDPkO510WTYDDlnQDKbrEANZ/iKxXHBtLYTdW
	 ylC0ioyPQYaDE5Micvd9dpdaDPBpXU1ohWhA1LTMqmMtaspr72qKicNIQuZ/FoWM18Y70
	 JoWdfda4HJbGzOInwObB1TT9Nd1PmG5pPcyeiKsIqE2Oo8VBhyoZwgA5okPlEGopfvSc1
	 TJeGIUjgcPHhXve6suSUaT+RMebAtb3940EtOd1n2i24o589rz3moavLRgEbbIKcgMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289898;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-MTK;
	bh=5pvdIdhYqQi2Vte+0X0VxMjKj39oPgLhvjyPOc1TyWQ=;
	b=bF/2vKTcDx7wsr3CSFF4VYUsqOSJ0ICy8h35WIdE90BUPALiM3T1BsqtXvp71sJ9x+ay
	 GnY00/yEepOqZleDIOb1RmNJC4sLDKEFLAVI2HG6fZ2t5YFzpy2vc+QXKVhqJjvsXOzTu
	 ywdeYzFiS90G0+gw34KqQLs617f+7IzbfsYhj/lQfpjUvOX0q4nZoRKRs1zkkzuMK5QuE
	 rWA/6rkAhtudUCRgEHh4T4Uwnvrp87OieFe7od8/wUY/rgkVl7oYLn/QDX34Nkk3X5QnN
	 BIr58qUDBP4R+TAc1i5F00AJzbqArVdW7SKHhnbcnGgG5qmH+M0N1UJQ3Z4bX5qsZng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=YWE2UJeg;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE51606A31C;
	Tue, 10 Nov 2026 05:51:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE51606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=YWE2UJeg
X-UUID: c71f4390dcca11f18dc8c9802ae25ab1-20261110
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID; bh=5pvdIdhYqQi2Vte+0X0VxMjKj39oPgLhvjyPOc1TyWQ=;
	b=YWE2UJegrSkElVunTmhw1c8CcQDhuj8DXkGUVOVYCXgt32peQe0CWPH2tKJwugZ9BjjaaZoWWXFttJUGU4Ne1KWBbfKLteoARCsoFquXu8/ItlULJP9tTdD1T8S+poEWjJaCb28wqmrJqjX9jcwkdYmAEmdVPh0iY5MiyNr0qEs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:c800898e-7ec5-46c0-945d-e7bd3011e3e7,IP:0,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:3
X-CID-META: VersionHash:b0318ac,CLOUDID:73d51057-a87d-42b7-8ffd-9e23ca174329,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:4|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c71f4390dcca11f18dc8c9802ae25ab1-20261110
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 251485632; Tue, 10 Nov 2026 13:51:30 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Nov 2026 13:51:29 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 10 Nov 2026 13:51:29 +0800
Message-ID: <47cdd8b1b52b448c9672c54ea1291079ddddd1a0.camel@mediatek.com>
Subject: Re: [PATCH v9 3/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Peter Wang <peter.wang@mediatek.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgsproxy1@samsung.com>, <h10.kim@samsung.com>
Date: Tue, 10 Nov 2026 13:51:29 +0800
In-Reply-To: <2052256418.81794277203434.JavaMail.epsvc@epcpadp1new>
References: <cover.1794275305.git.hy50.seo@samsung.com>
	 <CGME20261110020748epcas2p25076a34f183116ca4d8714dacf214958@epcas2p2.samsung.com>
	 <2052256418.81794277203434.JavaMail.epsvc@epcpadp1new>
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

On Tue, 2026-11-10 at 11:03 +0900, HOYOUNG SEO wrote:
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
> Only take the early path while pm_op_in_progress is set and a runtime
> suspend or resume of the WLUN is in progress. The runtime PM core
> sets
> the runtime status of the WLUN to RPM_SUSPENDING or RPM_RESUMING
> while
> ufshcd_wl_runtime_suspend() or ufshcd_wl_runtime_resume() runs, and
> it
> is RPM_ACTIVE or RPM_SUSPENDED during system PM. The runtime status
> alone is not enough: it also covers the block layer steps before and
> after the driver callbacks, where the early link recovery must not
> run.
> pm_op_in_progress is only set while __ufshcd_wl_suspend() or
> __ufshcd_wl_resume() run, which is inside that window.
>=20
> Both checks are done in the new helper
> ufshcd_rpm_transition_in_progress(), next to the other ufshcd_rpm_*()
> helpers. The runtime status is read with READ_ONCE() and without
> power.lock held. It is only available with CONFIG_PM, so the helper
> returns false without it. Both values are read without locking. As
> the
> window of pm_op_in_progress is contained in the runtime PM window, a
> stale value of either one can only make the error handler take the
> regular path, like an error handler that starts just before or after
> the PM operation.
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

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

