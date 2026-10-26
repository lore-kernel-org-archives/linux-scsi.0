Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792988239;
	b=xIZFphnCQ7/OEBrJiRwsXetoOKDSeuhQykO+wnH+5qQ+aBvlAyWPWajOC0bj1ny7Spog
	 FKNCXlmjYVXuGq/VpFlBrZJE/clOxB+XgMVR1FhfVh0vKeqCsxwFpIWleR+G+kUs5P30J
	 G/EHaO72YL7T0HHLouJQ7VI+IBr5s2CfUSbJM4Dtq4aYgOOaaGexbTVazRepH6794yiUs
	 9qQyDrxCYHvHojYrw1sem8Bm7oc1mhU2MXkOj/8C2iSQbieTKh8bgXzCDajD60Id21/ZO
	 wvRTm/iL4S41e6GTijMRO+aVlHaRi1r46UUSNzW8GPFPTw/q+ErC+P7+kieabSmSRLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792988239;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:X-Mailer:Thread-Index:
	 Content-Language:X-CMS-MailID:X-Msg-Generator:Content-Type:
	 X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=jB2vbdxVh2Blpp7G4TD4DP0cD49aJap9TRQ3JCYFASc=;
	b=dL/YZXqc+mOwKCQXPa/KzT1m3uLCW7WGl6jXAMptQQ1eQxYA66wnz7p3g0eYH/kTJnfz
	 935/JydLf13SJM+5J2gakC6YSumgW0oGuan6fQYhC581TKh6y6cz1Bp4AArT7kiRN3DU5
	 XSdPueB0WwKnD1wDi39RsPsnYj96+U7PaIykUu5ZqS113We3vv880Avy9AAMtqFNqZDSF
	 E+tle7ADF3upBuLdGCuG/NCiLmrRzJVb1whqsirjXFA4/3nTExi/KsgCYU/ipTfgWKSY2
	 6uOaQOgVH9ANJrH54tZlqZNXdBew33O8VpaLmKiFP2hat/94TdyciWlQf68Ws2x665Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=qxbkvByO;
	arc=none smtp.remote-ip=203.254.224.34
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27EC606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B27EC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=qxbkvByO
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261026041710epoutp04387240b54a0edb4b3814f2c540e6fd65~h_Uuyk8122586225862epoutp04B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 04:17:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261026041710epoutp04387240b54a0edb4b3814f2c540e6fd65~h_Uuyk8122586225862epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792988230;
	bh=jB2vbdxVh2Blpp7G4TD4DP0cD49aJap9TRQ3JCYFASc=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=qxbkvByOAf7MWYGeTUgtjeaGpj68H0Pu6x7bB6RjZ+sOkrFtlkjRbX1xazk+oBUas
	 oQpNNqwpXmogWfvuusX4bhpc5l20SMhTIy9Vvae/lDx5CTIAlULF5WrSwrq6vHKPjU
	 OJW7XI4mk2dr2G+h/dTS/Del5nBfGH+X5tCx8PS4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261026041709epcas2p173d4e54e374f7b0ef95ff10f697797a3~h_UueyIDg2080420804epcas2p1l;
	Mon, 26 Oct 2026 04:17:09 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.207]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jCgLs31VMz6B9mH; Mon, 26 Oct
	2026 04:17:09 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20261026041708epcas2p3fb96dfd2cf034999eca84afc33a7e981~h_UtUy_xq2527225272epcas2p3e;
	Mon, 26 Oct 2026 04:17:08 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261026041708epsmtip13a75e0de2225a4b5e41c76fa18a79a97~h_UtSe2qD0815808158epsmtip1F;
	Mon, 26 Oct 2026 04:17:08 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: <sashiko-reviews@lists.linux.dev>, <linux-scsi@vger.kernel.org>
In-Reply-To: <sashiko-outbox-182747@kernel.org>
Subject: RE: [PATCH v2 2/2] scsi: ufs: core: add is_sys_suspended state
 before recovery
Date: Mon, 26 Oct 2026 13:17:08 +0900
Message-ID: <000001dd6500$dd9d6cb0$98d84610$@samsung.com>
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
Thread-Index: AQK80fyFyDrF93QZWJpMeOvEKUoR1wHN7ETxAYa8KaUBtDpS9rUoFllQ
Content-Language: ko
X-CMS-MailID: 20261026041708epcas2p3fb96dfd2cf034999eca84afc33a7e981
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850
References: <cover.1792755091.git.hy50.seo@samsung.com>
	<CGME20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850@epcas2p4.samsung.com>
	<4eabe38e93631579a0cacda137a98053526fe030.1792755091.git.hy50.seo@samsung.com>
	<sashiko-outbox-182747@kernel.org>

Hi,
The commit message is too broad here: the error handler does not
always run a full recovery after a failed resume. It stops when
ufshcd_err_handling_should_stop() says so, and I will fix the wording in
v3. The behavior in the two cases you describe is the same as without
this patch, though:

- ufshcd_link_recovery() failed in __ufshcd_wl_resume(): the HBA is in
  UFSHCD_STATE_ERROR, which the error handler treats as final, and
  ufshcd_schedule_eh_work() does not queue it in that state. The same
  happens today when eh_work runs after the PM operation has finished.
  The early ufshcd_link_recovery() call in the error handler is the same
  operation that has just failed in the resume path, and it ran before the
  resume path's own recovery, not as a retry after it.

- ufshcd_link_recovery() succeeded and a later step failed: nothing is
  pending, so the error handler has nothing to recover. Without this
  patch, its early path would only have called ufshcd_link_recovery()
  once more; it never ran the full reset or ufshcd_recover_pm_error().

If the resume fails without having done a recovery itself (e.g. the SSU
command is failed with DID_BAD_TARGET and force_reset is set in
ufshcd_queuecommand()), nothing clears saved_err/force_reset, so the
error handler does run the full reset and ufshcd_recover_pm_error() once
host_sem is released, as intended by ufshcd_err_handling_prepare().

v3 will reword the last paragraph of the commit message accordingly.

Thanks,
Hoyoung


> -----Original Message-----
> From: sashiko-bot=40kernel.org <sashiko-bot=40kernel.org>
> Sent: Friday, October 23, 2026 9:00 PM
> To: HOYOUNG SEO <hy50.seo=40samsung.com>; linux-scsi=40vger.kernel.org
> Subject: Re: =5BPATCH v2 2/2=5D scsi: ufs: core: add is_sys_suspended sta=
te
> before recovery
>=20
> Thank you for your contribution=21 Sashiko AI review found 1 potential
> issue(s) to consider:
> - =5BHigh=5D scsi: ufs: core: ufshcd_err_handler() skips recovery after f=
ailed
> resume
> --
>=20
> commit c53108b377c62c7e01a8b52d302e15dfdce25f17
> Author: HOYOUNG SEO <hy50.seo=40samsung.com>
>=20
> scsi: ufs: core: add is_sys_suspended state before recovery
>=20
> This commit skips the early link recovery in ufshcd_err_handler() when
> hba->is_sys_suspended is set so that error recovery waits on
> hba->hba->host_sem
> instead of racing with __ufshcd_wl_resume() during system resume.
>=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 0e6e593c24cfd..4b4d473530b16 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -7052,9 +7052,14 =40=40 static void ufshcd_err_handler(struct wo=
rk_struct
> *work)
> >  		 * runtime resume. This avoids potential deadlocks that could
> >  		 * happen if we tried to resume the device while a PM
> operation
> >  		 * is already in progress.
> > +		 *
> > +		 * During system resume, host_sem is held from
> > +		 * ufshcd_wl_suspend() until ufshcd_wl_resume() returns, so
> wait
> > +		 * for it below instead of recovering the link concurrently
> with
> > +		 * the resume path.
> >  		 */
> >  		ufshcd_rpm_get_noresume(hba);
> > -		if (hba->pm_op_in_progress) =7B
> > +		if (hba->pm_op_in_progress && =21hba->is_sys_suspended) =7B
>=20
> =5BSeverity: High=5D
> The commit message notes that if system resume fails, hba-
> >is_sys_suspended stays set and ufshcd_err_handler() performs a full
> recovery as usual.
> However, when ufshcd_err_handler() wakes from down(&hba->host_sem) after
> ufshcd_wl_resume() -> __ufshcd_wl_resume() fails, it immediately checks
> ufshcd_err_handling_should_stop():
>=20
> drivers/ufs/core/ufshcd.c:ufshcd_err_handler() =7B
> 	down(&hba->host_sem);
> 	spin_lock_irqsave(&hba->host->host_lock, flags);
> 	if (ufshcd_err_handling_should_stop(hba)) =7B
> 		if (hba->ufshcd_state =21=3D UFSHCD_STATE_ERROR)
> 			hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> 		spin_unlock_irqrestore(&hba->host->host_lock, flags);
> 		up(&hba->host_sem);
> 		return;
> 	=7D
> =7D
>=20
> where ufshcd_err_handling_should_stop() is defined as:
>=20
> drivers/ufs/core/ufshcd.c:ufshcd_err_handling_should_stop() =7B
> 	return (=21hba->is_powered =7C=7C hba->shutting_down =7C=7C
> 		=21hba->ufs_device_wlun =7C=7C
> 		hba->ufshcd_state =3D=3D UFSHCD_STATE_ERROR =7C=7C
> 		(=21(hba->saved_err =7C=7C hba->saved_uic_err =7C=7C hba->force_reset
> =7C=7C
> 		   ufshcd_is_link_broken(hba))));
> =7D
>=20
> If ufshcd_uic_hibern8_exit() fails in __ufshcd_wl_resume() and the
> subsequent call to ufshcd_link_recovery() also fails,
> ufshcd_link_recovery() sets
> hba->ufshcd_state =3D UFSHCD_STATE_ERROR even though it restores
> hba->hba->saved_err
> and hba->saved_uic_err:
>=20
> drivers/ufs/core/ufshcd.c:ufshcd_link_recovery() =7B
> 	...
> 	spin_lock_irqsave(&hba->host->host_lock, flags);
> 	if (ret) =7B
> 		hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
> 		hba->saved_err =7C=3D saved_err;
> 		hba->saved_uic_err =7C=3D saved_uic_err;
> 	=7D
> 	ufshcd_clear_eh_in_progress(hba);
> 	spin_unlock_irqrestore(&hba->host->host_lock, flags); =7D
>=20
> Alternatively, if ufshcd_link_recovery() succeeds in __ufshcd_wl_resume()
> (clearing hba->saved_err, hba->saved_uic_err, and hba->force_reset) and a
> later step in __ufshcd_wl_resume() such as ufshcd_set_dev_pwr_mode() fail=
s,
> the saved error flags remain zero.
>=20
> In both cases, doesn't ufshcd_err_handling_should_stop() evaluate to true
> and cause ufshcd_err_handler() to return immediately after acquiring
> hba->host_sem, skipping full recovery and ufshcd_recover_pm_error()
> hba->while
> leaving the HBA in UFSHCD_STATE_ERROR or stuck with hba->is_sys_suspended
> set?
>=20
> --
> Sashiko AI review =C2=B7=20https://protect2.fireeye.com/v1/url?k=3D944015=
f7-=0D=0A>=20cbdc3cdd-94419eb8-000babe598f7-c051d8d5cf854368&q=3D1&e=3D01b7=
134f-5807-4f86-=0D=0A>=209107-=0D=0A>=20f67a15a683c0&u=3Dhttps%3A%2F%2Fsash=
iko.dev%2F%23%2Fpatchset%2Fcover.17927550=0D=0A>=2091.git.hy50.seo%40samsun=
g.com%3Fpart%3D2=0D=0A=0D=0A
