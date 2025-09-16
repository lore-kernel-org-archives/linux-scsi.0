Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219EE1A9FAA;
	Tue, 16 Sep 2025 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029278; cv=pass; b=hW17lE+3HgV9vMENcQcPGAQnp3vFW4MnmkGGD9naa1OhNlOh+rza1Ne4oKron+RQ2veKb6EArfQuttUM+ROQ6BE9+rcG4KeItWtOGBuTIXh0ofXY2hSZC7ah6x/jlmcEcBLItqI/+JoehLrJyKMdzDxl9llt53VfH+fVGv6m5Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029278; c=relaxed/simple;
	bh=ZKGaBXz0dirkpFmQ20Dt7lwNCKmmAwoFe1wxgn8JQNU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T6fEuNSx144pgY1cRvvDisT/gXqFXer0/KMmg6SJ7/BbzqhjVPyJ0xoYsLbf0p1GSaH5ZXmrVPlTyqA8LNVHosDRXqtNzd4yR7IyXFOlfWsdnkHvJpJxXR0BEmOrroy4iklsy0wyLLD2q3xdDs6yfoCanKQ2TzmpsbbRV6bS5vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=aJKP3blV; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="aJKP3blV"
ARC-Seal: i=1; a=rsa-sha256; t=1758029257; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=NICNy7MM5WvmWtThUQQhPs00UVzxGo+/AFA68CwWS/E+DXocyNj+AdKK8d7YS1KGO2
    eTRngWC69iEEd8H+arMn2A4k8mWKcmTFopsRjnXyT5RGmvv/jRlLtcVQ7IjMoN0tRGpR
    chk+CLMcwzKadbZDX8GGNT+CUqZ3Pd7WVGN17EhGQVJHzQCMbhWLnpjredqpJNXHXx5e
    4exBlUg9gdlptVm7I1I6ANShrdzep0kNPtE8g0oGBx6rB/iEDLdx+OOh5BgJp4U3VW1I
    cdCgZSMc/RAc+xzaBqwoCikD6FoTnrFknSDm//fzGqc+ZhrRchCPaHTBYrUeGMdic1+3
    CRWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758029257;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ZKGaBXz0dirkpFmQ20Dt7lwNCKmmAwoFe1wxgn8JQNU=;
    b=ARadL9LgBCAF02ifZGeyLJRJyTqvGUV5qvP5rENzpM337TUDW/hlYjsRAf7O/JL+8L
    WWVLPzz2VQar/U5SJHZYm1ZbfDX5kNNu3Kq6h5jFVKw5rBGlEIWJAFEWDx3uwo47Lf9S
    HxAGlnRtvYUuyBWu+BPBvMUBQHrpr0T1TA63A4cxVesEXA1bgDAQELzEA2KQS01KvWML
    U0KKFG67vxw9HxBVtnZ+foNidnbiLRkSWKD4lB6ngtKGmvHGYkszG0HD5XObLcFiLPLG
    sxBLFLSP3WX9pUUSH7KHX+9kRFFphggyNu2ukqcZiIuAEKycWgD8YkdQVpoBEpjoOAXc
    MVxg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758029257;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ZKGaBXz0dirkpFmQ20Dt7lwNCKmmAwoFe1wxgn8JQNU=;
    b=aJKP3blV0spaU5VBv306FDMdHu0YsvLOY4fct9L/LqKtJ0JefM+3RCFDu1m/k1v398
    XbgaTCyTwkKn08kA3IyK3K4xx4YLJ/kDBdYhIpz4jA45tnyyad9lJU2pm5brj6Oe2zmx
    8xDvh2gYFh7ykkGb+rDMvrvtl3KoqDQcXRvlSMVkeIm7vMLdpyte5MIPQkcm4fdquqrt
    zch8vLin7GjU+j+rbopFGLqpCd+1ilCoSJfzrHkxHKWMdn2snVQxmP35gHEDzkkzX9P6
    Ygy1B81bR2x3LWq6JxkKNQYF1mlZtgQlhIj4AN6FGFy1i21blC+jKi6Um5ymSBoE9de4
    w7rQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 52.1.2 AUTH)
    with ESMTPSA id z039d318GDRZ786
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 16 Sep 2025 15:27:35 +0200 (CEST)
Message-ID: <d80650f1b6515c4d97c4f34754d0328d38fb8a0d.camel@iokpp.de>
Subject: Re: [RFC PATCH v1 2/2] scsi: ufs: core: Add OP-TEE based RPMB
 driver for UFS devices
From: Bean Huo <beanhuo@iokpp.de>
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com, 
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 mikebi@micron.com,  lporzio@micron.com, Bean Huo <beanhuo@micron.com>
Date: Tue, 16 Sep 2025 15:27:34 +0200
In-Reply-To: <0f08376b-569a-48d6-a551-e10b72b32354@acm.org>
References: <20250915214614.179313-1-beanhuo@iokpp.de>
	 <20250915214614.179313-3-beanhuo@iokpp.de>
	 <0f08376b-569a-48d6-a551-e10b72b32354@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Bart,=20

On Mon, 2025-09-15 at 15:06 -0700, Bart Van Assche wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Use serial number as devi=
ce ID. Copy ASCII serial number data.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * This provides a unique de=
vice identifier for RPMB operations.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0strncpy((char *)cid, sn, siz=
eof(cid) - 1);
>=20
> strncpy() into an u32 array? Really? There are multiple alternatives
> available in the kernel that are better than strncpy(). Are you sure
> that you want to use strncpy()? Additionally, does copying a string into
> a u32 array introduce any endianness issues?
>=20

I will change to:

u8 cid[16] =3D { };

/* Copy ASCII serial number into device ID (max 15 chars + NUL). */
strscpy(cid, sn, sizeof(cid));


> > +MODULE_DESCRIPTION("UFS RPMB integration into the RPBM framework using=
 SCSI Secure In/Out");
>=20
> RPBM or RPMB?
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0str =3D kmemdup(uc_str, uc_str->len, GFP_KERNEL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0str =3D kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
>=20
> Is the above change perhaps a bug fix that is completely independent of
> the rest of this patch?

sure, will be added in next version. thanks for Reviewing!

Kind regards,
Bean

