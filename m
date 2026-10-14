Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071EB4BEE30;
	Wed, 14 Oct 2026 10:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791972165; cv=pass; b=SUx7/qH+NROJbYo33qWbAF2qcqsXs91Jn9+YI0UACr9WpXP49t/zXBFcYX45VEbfJmKoluUg+CvT4y2FILLR/IjapV1INZkulYy0ScoGz+91h6ZeE4+JHlpscshpTKPRmbk21GHdjMsfvlq0ZviRG7z2szzhtOkwky7BvHm65ZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791972165; c=relaxed/simple;
	bh=LU7vNk9YRQ1bVdmZHWK7IWnOehUVxwe+e/ZzXKTUHlU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NDBGIaAU892dI7JsGDfqH/ztSM3vXiSz/sofVIPdS3WDKb5lb/D+DDwoHMQU6ICGmDzIkwvrKujuVed+xQIEOiOfoykxV28mEozzpAERSbqCeXvzS0nF904Q6dUFcktEqGQSzg4ga1EUv2X7i0rIdCA4k7fG8pU/Si6krhQHLPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=P6g4o/PQ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Bfzu6UdI; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="P6g4o/PQ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Bfzu6UdI"
ARC-Seal: i=1; a=rsa-sha256; t=1791972158; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Wt9QYJIMbvQvExV74rkMMGrMtoQl1RaxB5LYWO3T6/DlIKABs/uGFGREwSfLcK/OU2
    NRz/0ASbebaI71zaeHA7GLEg1vYsb8IYI0yoTEFCjTyPqbWzCcnwUk21epbMG7EtrYXg
    FUW2dMpsXO31YPJUdMNbN+W4FOyfbrVRyvqGXkc+r330QhweUG5r5lnGxOjukoaYou0e
    Mg4jMHim2Lks+L4Fi01dh3Xu4++SZscZwW0Dh+6otezF1Sws0jTNUYzEPs8R5UXylm4w
    M6HEtyzXodIiLuNDEEB31McD8JaQXJwJjB2ux0BpgxDXzvs3pBgpZ4wv5xFhKeLPrWV0
    ISKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791972158;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=LU7vNk9YRQ1bVdmZHWK7IWnOehUVxwe+e/ZzXKTUHlU=;
    b=GeyvGAA2a3F8s8kPAVIEiOQBzf50+Vsq+ajLDWj+bOZRn9y7YCF+SeFJ/kpkufixmf
    Q4AGcnTOK3MrimoKBzFL4PutsyLCkmi+wNfu+tAeFbtdr/MoZp618H7O5/JAHiazNJwb
    Lw1dfQb7eyDVEvKeeofbwjj1iITEoLDOq9SW/I8vuD35tQgsWkOlM5qjMpWMJq4BKk0I
    oLK5JhtxAXajN0w+RzHzyWXiRM86m0vy8LO2dJxTiRNdotp8C75eUzil2hgTOK7tzpBe
    7TZkSlMBenMKlTE/MXYfgKcNEDquCs6fo0nqa9uNuoNBjDltDjJOTM94ZOH3Jq4m7r61
    Clmw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791972158;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=LU7vNk9YRQ1bVdmZHWK7IWnOehUVxwe+e/ZzXKTUHlU=;
    b=P6g4o/PQEa7sOu7vq6bz9ksS5oOFG8rXp8Sb3ZvpQV+4nU9RKC0UjOkPFHvB6GlMoL
    HckKNmuSlu5AkDDlMDTylMiPjjUDX+ZOgyadgvR+hfMeVYvJQrNTmOKtYesngsTt9Ine
    nef2Ylfn4513+wNzdOHSUeLBOsYLe4rHNixeWU7zSNHmBMp3KG6431CMtV3numvg/Udp
    rBRoB/pFhc+d9UREEJ23PKLyUYRAyVP8hXG487Du2bML2LuW0qdmJH1Lda88Uh4XXOTC
    HUS+55GgLJAChL1+fOEDQ7VCgbpXhSq1vQ4PBGuNruGEOXICXF1eyhbgptBEaFA74ADC
    WBgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791972158;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=LU7vNk9YRQ1bVdmZHWK7IWnOehUVxwe+e/ZzXKTUHlU=;
    b=Bfzu6UdIjU7MKlW6t+Y3RAb9MvujxZ5P6Od2FD/gM+n+LyrYsjaCcAEpQvjl4dHiET
    ++bNgTJ1YzZoz7zCSoDA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.108]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29EA2b3Nq
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 14 Oct 2026 12:02:37 +0200 (CEST)
Message-ID: <4275c168417c7f5b8f89f06dc15b7459a6346ec0.camel@iokpp.de>
Subject: Re: [PATCH 1/3] scsi: ufs: bsg: Validate request_len before
 accessing request
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>, Bart Van
 Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 12:02:36 +0200
In-Reply-To: <20261013102913.948718-2-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
	 <20261013102913.948718-2-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-10-13 at 18:29 +0800, Stanley Jhu wrote:
> ufs_bsg_request() and ufs_bsg_exec_advanced_rpmb_req() read the
> request buffer without checking job->request_len, which userspace
> controls. A short request causes an out-of-bounds read. Found by
> syzkaller.
>=20
> Reject requests shorter than the structure each path reads.
>=20
> Fixes: 64d4864714c2 ("scsi: ufs: bsg: Remove unnecessary length checkup")
> Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in
> ufs_bsg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
> =C2=A0drivers/ufs/core/ufs_bsg.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 7a66917b3fc0..dab1f05aff38 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -73,6 +73,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hb=
a
> *hba, struct bsg_job *j
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hba->ufs_version < uf=
shci_version(4, 0) || !hba-
> >dev_info.b_advanced_rpmb_en)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (job->request_len < sizeof(=
*rpmb_request))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rpmb_request->ehs_req=
.length !=3D 2 || rpmb_request-
> >ehs_req.ehs_type !=3D 1)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0
> @@ -142,6 +145,11 @@ static int ufs_bsg_request(struct bsg_job *job)
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bsg_reply->reply_payload_=
rcv_len =3D 0;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (job->request_len < sizeof(=
*let )) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0bsg_reply->result =3D -EINVAL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_rpm_get_sync(hba);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0msgcode =3D bsg_request->=
msgcode;

Stanley,=20

The check was removed by my commit 64d4864714c2 when adding arpmb support, =
since
msgcode check was thought to be enough, thanks for fixing it.=20


Reviewed-by: Bean Huo <beanhuo@micron.com>


