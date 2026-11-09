Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.167
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794244163;
	b=SoXU6gdDq5fkLvYVPgU2TPnY9F0fX9XeUuPuvxvB07nwOikLtHuPvKsdxJ0poZiVFkg5
	 z0egV1egRVZjdgNjrp7yorGI2/QIMmW7hEFPKw1yP7MWOmI3jBVvkIkIJrOM3TV5a6MXV
	 ItCotMhkHcSCeZUt7mPFEqPsGz+QAsHt6bkOc+LHBz9ovZ9FS1ajWaoIr/Yr3/uXuuoBx
	 12xqZMBXB9PJWnZGC+7U0ahxb0A9ANPvHdA08WqbfBgtwJq3uwb0M80b3fhDswajO5waE
	 VKPsRLxS2cwPExrikLCnkQNemKiI1SyV4JLtb7/cqvPzlkv17Il9QahPgngoYV3necw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244163;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=bLdW7+Mr9Zewlw32rr6lzio8Qz/uXoQyW69NFHyfIbc=;
	b=0fd1vIBuRuTv0Y1vP5p+y8LLBWT46pJlB6y18ylkNQQqWIA6v+SeEdjFk0JjZiyOwQWZ
	 beqO6u4Eb91VgsU0E3EuzfTbNRR7c2/48/h0jS8zylNFBzc+31k5yyvG/TXoq/SmUYafF
	 u41hn14G10vGcf/a4Y4wp+qqT1TUNIUVV33bqQYRgFvkUaSDRoeME2EyqFq7UO5lOJifI
	 E9wYlhC3JXm+woN8lXZWJ7CCw5PdTi/icadhfnCvYqHslShZiFe0e4J8MJbqL3K7ZW4Lr
	 /epLGawAKnESmqwxS/AjydnanycOU4qkMl+0aw5G5vywFXdK4yJsXzhzX5sABgYBsXg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=lbmhEReZ;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f8qbJOTa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.167
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFD5606A321;
	Mon,  9 Nov 2026 17:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEFD5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=lbmhEReZ;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f8qbJOTa
ARC-Seal: i=1; a=rsa-sha256; t=1794244133; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=g1ALZzJfzQC4GA+MGkZTLh3dYu+y2L59jQj98FzdhZyFL5PPThZL/5ZRbHEbUHhzOn
    bh6XazE/jI9wSwpZ+sgtnO+3Il9yw1RUz9hUwB5FfiGj/SkGLKdV7JB+LUuJ/CAH9+mV
    EZX4F9HevJ61xrmkmRlzGEYl6Y+DjV6dfCIt489NqMk5ROqNSHKPPHi0EAjtZR86FdS/
    rS6L1c8p43ltaAMOrCRTNCpYfL11d7SqCDQVj3FtVA/2agaeehpuCQs7i1l8BdylDZ/i
    SGnqJzLHYzSj8biplq/UZ4rm397V9W6qUDVRb6TuiekDAQ3Ri/HI4kF2Wap86w16ksb5
    vAEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794244133;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=bLdW7+Mr9Zewlw32rr6lzio8Qz/uXoQyW69NFHyfIbc=;
    b=VyF+Kf4mMFJvICe+f0WtCWAY51r0uN5iJy+b/F+DYOwM+AEfTUQCiL38GvjvJHlDxx
    RFjaSTAlysA8uQpD71wxOQ/zsnpgxsegHAJy12+II+Y6N97smqQPiN8z6pQOAdWhUIAy
    WNx9TOaccgEpxyVHQfIiX186WzWa7MGwbOBvyOUra+23wlygYkmJevGUb4RVXcUVsc13
    QM+gRbEGwyJ9+OcJ704fidV0sbLeaEhqOy/iM9FZwEF1fuCZ+8WGzKWdwCqCbtOZWaDF
    rtXIBDDd22OahPx7li+0QIZx0VkPZP+iezoSMgt9jzwTYxDCXUHSqsLZOf5Qjj0RlLc1
    2GJw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794244133;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=bLdW7+Mr9Zewlw32rr6lzio8Qz/uXoQyW69NFHyfIbc=;
    b=lbmhEReZ2hwUGH/U4T7YGQQu5NM79cQMmEsVtz/+YFgI7Nkikq4YSuqUDexr/Kunxv
    lRhpoW/WUUbv26rNz7KC20AAP9q5Pot+nnbWUPLUr2jWY2Ha8F+3Ls3F6VIkG+KG/t8N
    Fn+o3rVPuZuTDXdxhRTB9NjjN3ZwliCEsPqCb3F3qOpCgJTnnvIijA74sNGsKQtdFt69
    bj1M1Om26eILCFaKkzhKgoZ5s5Oh2Tb9Zi7aJKZMFED2rMClT5Z9V73eUVs57AOcdgUx
    pe/cCK0P83lJRs025XWTmahYPZxXiv83JBmHQkQ04LpEOUxlaoPJWvoOkxYLPEA8XQmw
    G/1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794244133;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=bLdW7+Mr9Zewlw32rr6lzio8Qz/uXoQyW69NFHyfIbc=;
    b=f8qbJOTaVoTjDFVtGgXbPmQyJoF6Xr/qxgELTfSdEDRL0ROEdKIe3uBHz+Yx52RAL+
    V/8lQwCTNN4UPLyDv2BA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.78]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A9H8rX6q
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 9 Nov 2026 18:08:53 +0100 (CET)
Message-ID: <26fb0dedfe5348270bf38c8f7ced1d49f1103d0a.camel@iokpp.de>
Subject: Re: [PATCH v8 3/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
From: Bean Huo <beanhuo@iokpp.de>
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bvanassche@acm.org, mkp@kernel.org, 
 martin.petersen@oracle.com, stanleyjhu@google.com, peter.wang@mediatek.com,
  alim.akhtar@samsung.com, kwangwon.min@samsung.com, kwmad.kim@samsung.com, 
 cpgs@samsung.com, h10.kim@samsung.com
Date: Mon, 09 Nov 2026 18:08:52 +0100
In-Reply-To: <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
	 <CGME20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947@epcas2p1.samsung.com>
	 <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-09 at 13:09 +0900, HOYOUNG SEO wrote:
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index e55c2a02c1f5..ae3eaf5ab017 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -413,6 +413,19 @@ static inline void ufshcd_rpm_put(struct ufs_hba *hb=
a)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pm_runtime_put(&hba->ufs_=
device_wlun->sdev_gendev);
> =C2=A0}
> =C2=A0
> +/* Whether a runtime suspend or resume of the WLUN is in progress. */
> +static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba *hba=
)
> +{
> +#ifdef CONFIG_PM
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum rpm_status status =3D
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0READ_ONCE(hba->ufs_device_wlun-
> >sdev_gendev.power.runtime_status);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return status =3D=3D RPM_SUSPE=
NDING || status =3D=3D RPM_RESUMING;



should the helper also check pm_op_in_progress?

return hba->pm_op_in_progress && (status =3D=3D RPM_SUSPENDING || status =
=3D=3D
RPM_RESUMING);


checking (status =3D=3D RPM_SUSPENDING || status =3D=3D RPM_RESUMING) fixes=
 for system
PM;=C2=A0

Checking pm_op_in_progress limits the early path to __ufshcd_wl_suspend() a=
nd
__ufshcd_wl_resume() during runtime PM, it was before this patch.

Or what else I missed?

Kind regards,
Bean


