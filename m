Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D11E38B7C3;
	Wed, 22 Jul 2026 12:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721941; cv=pass; b=KAiidgS/2uM6Hi87YOwRvUGe6PXmVkNOEyV8VgikebDIPQXYQaUTrJSyoRuWB+gXOOFJn4Wzyljv9XNCnhgv/SXSTCvUUXc2YAduXRZ887qJ1CxVBk0PuwvMN8olCxtsYqRbQ1u0ZGl4fToMPAcBw4+0IDxjnWAlCh0YiLwSQ1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721941; c=relaxed/simple;
	bh=dWvhnpuRbgx7dnx0GM5hsaiy8aoHpz67573QBttKddw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qISShQORraqqJiuddrA4sum4FNs0te/sO7W6iyH3gLSg5Jeqr9jdX+uBEfexAEwuBeDTQMVLQIMKoOTSh0iqXtU6341IFCiIgRWuUN41f7FQs6tq3s3sL4HzA2+YDDQ2JOBUNbTd6X10Q4Ezw63NbksgDDdHDz2WEg3G/ZLRbXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=bdRryqkV; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=VgkxJyg7; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="bdRryqkV";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="VgkxJyg7"
ARC-Seal: i=1; a=rsa-sha256; t=1784721877; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=BoLzV76oRECAGkr24w4JioDgoYX20dnOZArQk5AR4X9nazOjygFXHgaaqEyeyCF7dS
    1i+XOAJLfMgWKWc3lf0p1J7/g9JZheXToLQaYEjkqvrz4Ww6iApfopjD2l7e9s2zze/R
    c3okYONqsL6LeInBR748FSSqKQnzFlGrZ2ND7yZ3Cd0MtiKibx0VXyIt5Eclb12sER9k
    iNRotfew/OIqcylJB76wsxvei0+Jmxseo8iqUI/zRMMezODJOBZ9NKK4o58Ze+hvgjDF
    Ao6dN3kcOho17GDXWpmSg1xkxxP7Fp/nguegdVTqc8UE9LkJdIGqUfmMpuVfbJom3qNL
    EA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784721877;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dWvhnpuRbgx7dnx0GM5hsaiy8aoHpz67573QBttKddw=;
    b=cQSG6ssk4KGnIyqA/K1LQdQLEFLmmR02rgPZ8YS4JcZYQslPrpmjK5Pw4f5SfuR3fv
    tiAoIYJDEPUhGeBd//FrjxHyORjdvm9QSadVAEhY6goAsOPWReANWW0DMV/wnbeUZpaM
    1F21zw7a5JtiIFRDTHR7Z7Rs5gNEU6zZA+QmhbwXJm4YdiLhiupRkn0BbhbiBzbWxcny
    shPkiT5csvezOCkgOsRSDo1yG8C16xH4EM997Lk2jDU4hxO3k0UioPbcRDNlqhRh8YC0
    OBUNHaXEkV+wwR3WriwJi695oaql6nRc36ZQwI+ZJk4IDBYA36d9zlmoa6hJieYxqZi1
    LfiQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784721877;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dWvhnpuRbgx7dnx0GM5hsaiy8aoHpz67573QBttKddw=;
    b=bdRryqkVMdUzF6x/AJTna35oyiL6ooeJXvQA+cBKKgwhfOhQpMDyyjJtaV+LvQ8FyL
    o0837Uw360UFZFNAwNXyzaAn/QynLZvEDy8Uoi0rLtWhQRVC8jeFHEl5NrgGaWpVNCLB
    IgTZ8JF+4yjTAz8/9EUypVWbf72CEWNdpZz14znePXg7YFuI1yJEdKO7cDbjsj4cJOqP
    8pfFCCpJra6zYOURClqKNJb25wkPBpHsomFkWZS3XY/fXGXEU5S51yKyroagkwPe1sdR
    zoKdnFJMMph12zN16zjjvtmDhW4OtHsNk0DTA0Cv+WbexH6+kMYjbafMEKSsnQD+WDkt
    1vkg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784721877;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dWvhnpuRbgx7dnx0GM5hsaiy8aoHpz67573QBttKddw=;
    b=VgkxJyg7x/LL2EhQ5C+Dpgk95ZUbnF2QijoR/5ZS6F/Mk+GIgiioNVSkQVcXcTIF+k
    kocqExpxLXimFtizmPCA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926MC4WGZo
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 22 Jul 2026 14:04:32 +0200 (CEST)
Message-ID: <4cfee0a964332e0e7c1c6875ec5796360b4c22a5.camel@iokpp.de>
Subject: Re: [PATCH v2 4/6] scsi: ufs: rpmb: Validate request frame length
 before parsing
From: Bean Huo <beanhuo@iokpp.de>
To: Li Qiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com,  avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 peter.wang@mediatek.com, beanhuo@micron.com,  can.guo@oss.qualcomm.com,
 adrian.hunter@intel.com, tomas.winkler@intel.com
Date: Wed, 22 Jul 2026 14:04:32 +0200
In-Reply-To: <20260717153914.26321-5-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-5-liqiang01@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-17 at 23:39 +0800, Li Qiang wrote:
> The RPMB core only verifies that request and response buffers are
>=20
> nonempty. This callback reads req_resp at the end of the first request
>=20
> frame before validating the request length.
>=20
> Require a complete frame before that access.
>=20
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for U=
FS
> devices")
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
> ---
> =C2=A0drivers/ufs/core/ufs-rpmb.c | 4 ++++
> =C2=A01 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9..431f85b36876 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -69,6 +69,10 @@ static int ufs_rpmb_route_frames(struct device *dev, u=
8
> *req, unsigned int req_l
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba =3D ufs_rpmb->hba;
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* req_resp is at the end of a=
n RPMB frame. */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (req_len < sizeof(*frm_out)=
)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0req_type =3D be16_to_cpu(=
frm_out->req_resp);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0switch (req_type) {
> --
> 2.43.0

the two Sashiko findings are a separate story, this patch is ok to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>

