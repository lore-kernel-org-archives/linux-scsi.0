Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423104;
	b=jCrOkFrXG3nhD8oGjFfuhmdUIVsxUKmJz19zVENqc1lqs/WcewnBKlJ8A4/vYOaAdy2P
	 7AkjGAHfyRgou1aOwv8hZzWgJBSdSOJM+wAt/2HgxfJJ+U5NhWv9mQV31pV6sig6KRX2Y
	 MuFSjYcZCj49aAvRRTCn4fDq3XiyL4o+tzBfJ9MVaiXOSEiz/Ga5raIBi4aFii0+zuX+M
	 wqdx/XFv9mlr42JAA/H1Gs7u+3PeWeRlZmCi9DvG9nN9BtxByAx1Tke+LuluihtcHEEP/
	 SrnCKrDAdsH/cziFBN4sYVFR4C5IbzgAgu9Ui4e657fib0z9vzWDgA7ZgzxXytTQYXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423104;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NP3JpzShr+JNJh4jxN9t+BGs4YLYci7z8zxeFAb7l90=;
	b=cYIoIdWwnuFj4rfBbFtcxKxDIFJ+yk7QzIAgTOGZA0dAgh2+29JS17mOOANXaLmDYY6W
	 R0ir1Bqwy8hLiXUniyXV+abWkna2Pz5orVf3JvnsO5d8J0CPEMDXUSyxf9Cwz3rEYZ1d+
	 yo6Cy8IbQbZ1/0PzGatO5nYz1/9VKe5NGzDV505M+XZ877skYT79DdyF3ZnCGQsBoEebW
	 SAgzBwh+Sb/0cG8p4fpczjjNwDg2BLIs61Fp2JO8FNwM5EYT5CyK8y/W4QrCNdy8QilDS
	 A/03Ojb5bXBtlcGYcqaRD9eYK1/IZEPNwpNPMovNNjJw/3N2cwDsJYcf94IOf7mCmPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KL4IJB1K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24CF60A3812
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KL4IJB1K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725271F000C4;
	Mon, 19 Oct 2026 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792423103;
	bh=NP3JpzShr+JNJh4jxN9t+BGs4YLYci7z8zxeFAb7l90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KL4IJB1KdCdOPTJ2nBp1FUCp9lx9H8pXe8G5Pw4YHlM70qA8EmjKNyA+b84A4eStn
	 U1wgOzRYzK35rftQn0Mv64uIa64Dbak7iulpRAqgVe3rRNcpaw1M9qSNfk1XJ1fPNO
	 pBKBi7xaD/UOLVOzzLYLWogXxeYrzutv5uKxk6KjZasqAiooIwSa19x07KMZy+E6eH
	 DrcLhnTGgVtA3iMLuzWF/wBYucvVmzLmynjvlQPKdMZn3N77qTqzmx6ddCltSysl+M
	 nWeB0Bq8DOBPQFGiYTyDsb2zWZWXhDT0kF7DpBtbBxZQswxVrEO9+gBf+jbPditcI8
	 xshHCDrIZyz1A==
Message-ID: <sashiko-outbox-177674@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] scsi: ibmvfc: check for NULL evt in
 implicit LOGO and target delete path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261019135441.1420968-412-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-412-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:18:23 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: invalid state transition in ibmvfc_tgt_implicit_lo=
gout_and_del()
--

commit 99489de7e63442e984a1136b57de120f99e8b4e7
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path

This commit adds a NULL check for the event returned by
__ibmvfc_tgt_get_implicit_logout_evt() in ibmvfc_tgt_implicit_logout_and_de=
l()
before passing it to ibmvfc_send_event().

Link: https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 228daffb286de..66fe30b04b6a5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4403,6 +4403,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(str=
uct ibmvfc_target *tgt)
>  	evt =3D __ibmvfc_tgt_get_implicit_logout_evt(tgt,
>  						   ibmvfc_tgt_implicit_logout_and_del_done);
> =20
> +	if (!evt) {
> +		vhost->discovery_threads--;
> +		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);

[Severity: Medium]
Should this pass IBMVFC_TGT_ACTION_DEL_RPORT instead of
IBMVFC_TGT_ACTION_NONE?

ibmvfc_tgt_implicit_logout_and_del() is installed as tgt->job_step in
ibmvfc_del_tgt() when tgt->action is set to IBMVFC_TGT_ACTION_LOGOUT_RPORT:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_del_tgt() {
	if (!ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT)) {
		tgt->job_step =3D ibmvfc_tgt_implicit_logout_and_del;
		tgt->init_retries =3D 0;
	}
}

and ibmvfc_do_work() only invokes it while tgt->action is
IBMVFC_TGT_ACTION_LOGOUT_RPORT:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_do_work() {
	case IBMVFC_HOST_ACTION_TGT_DEL:
	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
		list_for_each_entry(tgt, &vhost->targets, queue) {
			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
				tgt->job_step(tgt);
				break;
			}
		}

		if (ibmvfc_dev_logo_to_do(vhost)) {
			spin_unlock_irqrestore(vhost->host->host_lock, flags);
			return;
		}
}

However, in ibmvfc_set_tgt_action(), when tgt->action is
IBMVFC_TGT_ACTION_LOGOUT_RPORT, only transitions to
IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT or IBMVFC_TGT_ACTION_DEL_RPORT are
permitted:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_set_tgt_action() {
	switch (tgt->action) {
	case IBMVFC_TGT_ACTION_LOGOUT_RPORT:
		if (action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT ||
		    action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
			tgt->action =3D action;
			rc =3D 0;
		}
		break;
}

Passing IBMVFC_TGT_ACTION_NONE here returns -EINVAL without changing
tgt->action, leaving the target in IBMVFC_TGT_ACTION_LOGOUT_RPORT instead
of transitioning it to IBMVFC_TGT_ACTION_DEL_RPORT like the other error
paths in ibmvfc_tgt_implicit_logout_and_del(). As a result,
ibmvfc_dev_logo_to_do(vhost) continues to return 1 and blocks rport
deletion in IBMVFC_HOST_ACTION_TGT_DEL / IBMVFC_HOST_ACTION_TGT_DEL_FAILED
(including during adapter removal when vhost->state is IBMVFC_HOST_OFFLINE).

> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +		__ibmvfc_reset_host(vhost);
> +		return;
> +	}
> +
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
>  	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
>  		vhost->discovery_threads--;

I hope this helps!
 Let me know if you need any further details.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-412-sashal@kernel.org?part=3D1
