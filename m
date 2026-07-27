Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0BB3D5229;
	Mon, 27 Jul 2026 21:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186577; cv=pass; b=Ac/8J+yoSOyKXSrtS6iHIVwKAaGgbEnmbLxWZiMd/GxdZ1ShXnIEjNQd9BYshSd8mKa/NvlgUwwtzGCrcdqg1nABg8okcKvq/p/lSk+5HflvEc2Cv1+tQDq78htpxsYSchq/DuTw1aezoqRTXi/vDp5hRk00OXzoMeXIc6jwsbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186577; c=relaxed/simple;
	bh=Jg5FIPMrvrO8cTB5HVaUx5fELfYq+wq3zGZQVK5QunY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pAoCCIveoWSoYrr+h2WIPjiolJhjoWjFLY/lo4qTQp9+GrYdWv1T/HSMOx1jW7JO8cWNP5bqF2qfR3A3pvlmCKXAT/ArgfJmnbJSmMkccu/FWgBPzWvlc9vNLJjyhmUD6pj2Eo/FykMaQ60CZmx+ePdk2ETDizWG1h2eeTwuCNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=ZdmjDloz; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=prKjAlrp; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="ZdmjDloz";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="prKjAlrp"
ARC-Seal: i=1; a=rsa-sha256; t=1785186548; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ThST4VsMyy8BJ8tQCrlqr10mdS587clj4x4nYkfjupRJ1o69g3RggJc9dkpybC+wdz
    FSjTGj2ZmJSg+PxOAsor9MfoV7XCngl4q7vatriDdo4wmFfGiX7XsMUk4wXiZrAJfxg/
    y2YqQU/VZPdAgWN7M19idJKAfH33DrBhkq/XC5P6MyqgNvKwFlYYJCBlx01FcePmPvl/
    zy0d02hytp8DQG24TuLJXZncqBkREbUydG6JdZNIsa8kVTJDNPwF53qdemeb3mueYr4A
    7mDw4ogBZRlSrJMDfbHaQ0YWb71EfmU7JSD0LDxcW5Xb8USf+1g6L4JNlk/y2G72rTI7
    lf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1785186548;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Jg5FIPMrvrO8cTB5HVaUx5fELfYq+wq3zGZQVK5QunY=;
    b=Hr5EKu7idravn7XdyuylShF2ql9Al5Z10+NUEVSStLetZTnB0NBS05Bp192eDopUyr
    dmc/HQVmv5WO7zDORGzJ20+cnZnrZFSHVslNKR0XHBe12gJInUd22VrJ2lZrhySkvYpW
    jbtKmYE2RhLFFfPkbAsFZPK9RdHFH7A/GQaaLB1yQvn/SPciKzvZXDq78+oxkcgaT6du
    FZT2NBUOvaAf+fKPikDVlVtYGxrVCELiC/NFJViwvHjMb/QAocxzOxfa0Aft4zAYGfsx
    zVswamS1BQGeXDwXdZTOXhSt9PDynz9BTFoI3onFxWBozv++BJjPnHJG7wYypid7CF9M
    051g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1785186548;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Jg5FIPMrvrO8cTB5HVaUx5fELfYq+wq3zGZQVK5QunY=;
    b=ZdmjDlozppW/15zs63SyezRNL6hdvMrgt+J1xq6KH2ThrsQ2FHZBYcPe4zPbLZDqSS
    j5nXs8vfN2UbwzutLvnwKYbjNPqI6FAAFpmrkRaOApmAPADHhUaM3n0dO8BE5FNebFCZ
    LnYJuODaXk4tgjP3P04j/ML+8JMbcoehlzg9tNzdoCY5EK7K6TAeWagCC+2Wwhut0p/y
    D7yNRI6W8WU22RZW7D/x7tdo3DdjPYnRiRik1Ei7a8QCCZ3FdDFbAc4rBNqd/XzlkFBK
    2G+4HqMahwbc5S6T9c2SD8d/paw/42Qq2bQ6ndZTb5uz7R3Fydc6Pkra1LxHF7tZOa9y
    uUAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1785186548;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Jg5FIPMrvrO8cTB5HVaUx5fELfYq+wq3zGZQVK5QunY=;
    b=prKjAlrphf2Jff5ro4W5nWYZGQnfvwz2OI0GBni2PzlpJtIRG8kIvnIwQxwhFe/nve
    H0X7vzlWTl2rsdPr/OBg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGWUpI6wexrZDe39LpN4CCBnmnSdnfYp+l1hO4Q="
Received: from p200300c58714771a364c499a9faa202b.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926RL98XA1
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 27 Jul 2026 23:09:08 +0200 (CEST)
Message-ID: <f818a63492504f213b5e91023617e14138cef020.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
From: Bean Huo <beanhuo@iokpp.de>
To: Ao Sun <ao.sun@transsion.com>, "alim.akhtar@samsung.com"
 <alim.akhtar@samsung.com>, "avri.altman@sandisk.com"
 <avri.altman@sandisk.com>,  "bvanassche@acm.org" <bvanassche@acm.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "peter.wang@mediatek.com"
 <peter.wang@mediatek.com>, "can.guo@oss.qualcomm.com"
 <can.guo@oss.qualcomm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, Hongyan Xia <hongyan.xia@transsion.com>, 
	Jiazi Li <jiazi.li@transsion.com>
Date: Mon, 27 Jul 2026 23:09:07 +0200
In-Reply-To: <20260723034440.217-1-ao.sun@transsion.com>
References: <20260723034440.217-1-ao.sun@transsion.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-23 at 03:45 +0000, Ao Sun wrote:
> From: Ao Sun <ao.sun@transsion.com>
>=20
> Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL
> pointer dereference in the device teardown path if ufs_rpmb_probe()
> fails.
>=20
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS
> devices")
> Signed-off-by: Jiazi Li <jiazi.li@transsion.com>
> Signed-off-by: Ao Sun <ao.sun@transsion.com>
> ---
> =C2=A0drivers/ufs/core/ufs-rpmb.c | 2 --
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0=C2=A0 | 1 +
> =C2=A02 files changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9..62120dc2e9da 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -152,8 +152,6 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->rpmbs);
> -
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct rpmb_descr descr =
=3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0.type =3D RPMB_TYPE_UFS,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0.route_frames =3D ufs_rpmb_route_frames,
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b5..60227069db06 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10988,6 +10988,7 @@ int ufshcd_alloc_host(struct device *dev, struct
> ufs_hba **hba_handle)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->nop_out_timeout =3D =
NOP_OUT_TIMEOUT;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_set_sg_entry_size(=
hba, sizeof(struct ufshcd_sg_entry));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->clk_=
list_head);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&hba->rpmbs);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_init(&hba->outs=
tanding_lock);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*hba_handle =3D hba;


Thanks for splitting this out, this is much easier to reason about.

For the two lifetime issues Sashiko reported (the container/rdev circular
reference and the devm_kzalloc() ownership), both are real but pre-existing=
 and
independent of this fix. Let's keep this patch focused on the NULL deref an=
d
handle those in the teardown-order series, this one can go in on its own.

Reviewed-by: Bean Huo <beanhuo@micron.com>

Kind regards,
Bean
