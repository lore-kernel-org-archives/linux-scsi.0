Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793952187;
	b=DQy3Xd6wEnmtvuqMc0/beAYuvglXd0IQ2fzY64mnYOoYG0eHMnn98ufjh2f2IWZrhk5U
	 KYGdIt1zaqyQjs2FlfKZTMLqAG0KKWpUpJJxAdYwILH/wltqv6KMc1J2EZd72zh81Oyk2
	 B/IIEAik/RpGjYodIgRvcuQT+/fqrgrefgFbd2knaNbj3r/4zmSd+51DW/RWoJC+Foczq
	 V3fCx7T8vdeJkNYVavw5pb+jPYCxW1MNs+pafYz4L65XVn46K5qreYJI1wdqqrYo0Z5Au
	 sP1jmYjB0xNEH2S+o7An1A/D9gBsOVzeOHIrpDdRmIUYZHqJ8S0s2FBa0OS002CsDaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793952187;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:X-Hop-Count:X-CMS-RootMailID:
	 References;
	bh=iLBysE6phjT4HHU22Lu68jiD8gY2MEIXZr3J4Uqoc5I=;
	b=Y+jxb6bw2qo5MIzoDJLliGomUamuoLsivLaw6cKdiFuTCfI7ubsw0SJ7gNvZmNSTmeJm
	 KKtI904jsHVgqFbWix9As8Vpp5Ar1mqEOltomc+UKqShEGRaJ2cml6XRiikjeBYB1n8Mc
	 z2QYquKPgIX5fgi8Ls5gq0VHIkU6txleCyE4BwE9xzQoFyWn3HVeTn70nYFRccnI4g5/d
	 JsJI5MDuJ0sTPpjyGFuDookmBQWfaEcKcaZKW30lG1wSfLq9FpLNpgqc4ZyZ+Lwcoi6q8
	 ACJUPL7uVP+LGahZKZFdVBosFdflxKYSLXJlPjBvvzj3zfH2YrcxrXukYYT2vgZI1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Vo/k75ZW";
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876FA606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 08:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 876FA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Vo/k75ZW
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261106080303epoutp01e96f8cc1aa91d1c244b7dc14855c6d88~lZgGG3Dtm0133401334epoutp01L
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 08:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261106080303epoutp01e96f8cc1aa91d1c244b7dc14855c6d88~lZgGG3Dtm0133401334epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793952183;
	bh=iLBysE6phjT4HHU22Lu68jiD8gY2MEIXZr3J4Uqoc5I=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=Vo/k75ZWd2V0aXbOQJ/ZjNokCt7zzim6xeRKOa0qoWWe50cDN+hV7h+l9C+d69ez4
	 WgbjnzxxYG33Iwj82s97hNwrfLk3/AsT/vbb1iWYV361XTvClEeKa7NlQbPN5JhjfX
	 BCTiFmhV+NreS012f92rgReDvDV/hxhXbI4JDW9w=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261106080302epcas2p3c94ad8ec3e3d1e9769d7321ac06112fe~lZgFibAey0143201432epcas2p3L;
	Fri,  6 Nov 2026 08:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jLWrQ4nqzz3hhT9; Fri,  6 Nov
	2026 08:03:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261106075800epcas2p2438a353378a90f574dc09c3bcbf8a75e~lZbsHhTqX2914329143epcas2p2N;
	Fri,  6 Nov 2026 07:58:00 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261106075800epsmtip16779b70d510470a37afbf1447f973435~lZbsCOwow2929529295epsmtip1c;
	Fri,  6 Nov 2026 07:58:00 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: "'Peter Wang'" <peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bvanassche@acm.org>, <mkp@kernel.org>,
	<martin.petersen@oracle.com>, <stanleyjhu@google.com>,
	<alim.akhtar@samsung.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <cpgs@samsung.com>, <h10.kim@samsung.com>
In-Reply-To: <9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>
Subject: RE: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
Date: Fri, 6 Nov 2026 16:58:00 +0900
Message-ID: <973576304.21793952182671.JavaMail.epsvc@epcpadp2new>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLLI625VyEVqOdBlj4qNrrnpnoJ9gEwv8sVAdhl8tICWOG+3LUaMV2w
Content-Language: ko
X-CMS-MailID: 20261106075800epcas2p2438a353378a90f574dc09c3bcbf8a75e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f
References: <cover.1793931113.git.hy50.seo@samsung.com>
	<CGME20261106022020epcas2p2af29bc4d81ede559c5a74076721aba7f@epcas2p2.samsung.com>
	<e25861e1983785d6d96e4db40f6c175bc3d091d1.1793931113.git.hy50.seo@samsung.com>
	<9cf963e66f0e08efa9996b53d6b2f38eacd9c98a.camel@mediatek.com>

Hi Peter,

Thank you for the review, and for the Reviewed-by on patch 1. I will add
it. Note that I have already posted v7, which reorders the series
following Bart's comments:
https://lore.kernel.org/linux-scsi/cover.1793943246.git.hy50.seo@samsung.co=
m/

On your question about making __ufshcd_wl_resume() trigger the error
handler and wait for it instead of calling ufshcd_link_recovery()
directly: I think that is a different design from the one in this
series, and I see a few problems with it. I may be missing something.

 - While the system PM callbacks run, host_sem is held from
   ufshcd_wl_suspend() until ufshcd_wl_resume() returns. If
   __ufshcd_wl_resume() waited for the error handler, the error handler
   could not wait for host_sem (that would be a deadlock), so it would
   have to keep taking the early link recovery path during system
   resume. This series does the opposite, as Bart suggested: for system
   PM the error handler waits for host_sem, and the early path is only
   used for runtime PM.

 - The link recovery was put into the resume path on purpose. Commit
   35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails
   during runtime resume") says that the error handler got stuck when the
   h8 exit failed during runtime resume, and commit 62c015373e1c moved it
   to __ufshcd_wl_resume(). As far as I can see this is because
   ufshcd_err_handling_prepare() waits for the runtime PM operation that
   is in progress. Waiting for the error handler from the resume path
   would bring that dependency back.

 - __ufshcd_wl_resume() needs to know whether the recovery succeeded to
   decide how to continue, while the error handler returns no result, so
   it would have to look at the HBA state afterwards. It would also need
   to avoid queueing the error handler again if it is already running,
   similar to what __ufshcd_wl_suspend() does with
   ufshcd_eh_in_progress(), to prevent a second recovery.

 - Other callers of ufshcd_link_recovery() (ufshcd_eh_timed_out(),
   ufshcd_eh_host_reset_handler(), ufs_mtk_resume()) would still call it
   directly.

For these reasons I would prefer to keep the direct call in the resume
path and fix the race on the error handler side, as in this series. If
you see a way to wait for the error handler without the runtime resume
dependency, I am happy to look at it as a follow-up.

Thanks,
Hoyoung

> -----Original Message-----
> From: Peter Wang <peter.wang@mediatek.com>
> Sent: Friday, November 6, 2026 4:11 PM
> To: HOYOUNG SEO <hy50.seo@samsung.com>; linux-scsi@vger.kernel.org; linux=
-
> kernel@vger.kernel.org; bvanassche@acm.org; mkp@kernel.org;
> martin.petersen@oracle.com; stanleyjhu@google.com; alim.akhtar@samsung.co=
m;
> kwangwon.min@samsung.com; kwmad.kim@samsung.com; cpgs@samsung.com;
> h10.kim@samsung.com
> Subject: Re: [PATCH v6 2/3] scsi: ufs: core: Limit early link recovery in
> the error handler to runtime PM
>=20
> On Fri, 2026-11-06 at 11:15 +0900, HOYOUNG SEO wrote:
> > ufshcd_err_handler() recovers the link without taking hba->host_sem
> > whenever hba->pm_op_in_progress is set. That early path was added by
> > commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
> > deadlock") because the regular error handling would wait for a runtime
> > PM operation that cannot complete while the error handler is waiting.
> >
> > pm_op_in_progress is also set during system suspend, system resume and
> > shutdown, where the early path is not needed and runs concurrently
> > with the PM path itself. For example, if a LINERESET is reported and
> > the
> > hibern8 exit fails in __ufshcd_wl_resume() during system resume, both
> > ufshcd_err_handler() and __ufshcd_wl_resume() call
> > ufshcd_link_recovery(), and the host and the device may be reset at
> > the same time.
> >
>=20
> Hi HOYOUNG,
>=20
> Since ufshcd_err_handler already calls ufshcd_link_recovery, wouldn=E2=80=
=99t it
> be better if __ufshcd_wl_resume just triggers the err handler and waits
> for the kworker to finish, rather than calling ufshcd_link_recovery
> directly?
>=20
> Thanks
> Peter



