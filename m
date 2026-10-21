Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792589322;
	b=f/ZCr1OeXmFtE38BqfnTRShII0w9IXKyKSyZzvnYbnV9jqxCu/9940kVDjdQJqN4n6QC
	 XhuAXSOf3Q8NWDuwcEP3labm/ptU7Pu+ZXyxdw1ks8gTdIDiThjVuO2U+fPKj+ssI5y0p
	 6IF+b115V5zd3lN6rgadknyDFbdC6HFbMAmuLPkru6GhxVTwiydDaYhozG24h64C/sFlP
	 tF7148Kqyn4hd3hqe5LXnvQgXxl/mDeB4Fsgdb5PbrFwC6UtRCC6RkfMnqcIOVzJ/jiLa
	 ZM2uJAQsgKITzQ5EnQEROkF6GU2BwfZI8DVsg1I1AYk1dLYxh1djbIPhVSYlH04cFHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589322;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:In-Reply-To:References:MIME-Version:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=aHoL/xV+lJSptWn1pnj9SxRHcMCta8KU7nBOlsKicA8=;
	b=zXY81WOwS4+QA2aUnIQyqNnuzAG/kplPHAHO/64FpFsorsQLG6uR+9UDLDVGILseWqRU
	 GqJ8xIDChTLyyPE7IbkXdmKA+TyiaUv8pMDzd3kgEzQBbzzvcFsFM/oBE4jOaGVQBUzBF
	 rs9c/Qn3u1GylvCpJ8epsyON5OF5Rb4vzMhwnGA0aSUHZkjr36Fkypfu2YR3Lyn5zYDt0
	 8tBI1QH6bAoHx9ng9/EjkjZkcJItLnYLZUVKln9/cWCCqWX/yYCflQN4TNsWBnHdqnuZY
	 yuxQJBRI+gImVeQJnzKh4HBlNjsuPX2vLorS8TtXT5C29ae8GwwxxoE/XiENpqefqoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ihyLRDDv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A52D606A323
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 13:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A52D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ihyLRDDv
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-535f598d126so254961cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 06:28:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792589321; cv=none;
        d=google.com; s=arc-20260327;
        b=EaUrvEFIMCqi1avwJhS0oaF3ZSSqalCQNhISTpW1G5bzFoe6YMIoJcjSfCyAwIqq0C
         jnCh8svOo+OK3Ljv6D7cMhhk+1KNM0uOxxgjBntN1+w5zVEz8RZB/AcpwQvtM9loPqyp
         2LDTLm5r3nFxuIxxceWukv+d29wXGLVjpdOcZCFrWS17YAeEWocyxBOnwYmphaM/lbNi
         KMUVaCo704Yowf86aY258buc/3BJrpWECe5geCTVLKm0IfENuFPyVrzRcYIQQQHDnGxu
         di/m8zcHg7Pfqv8p6QLEJ+r6EA5yloQqmFIn2tCdSDqQJO3Rx4XgK38bWVgee+nC09Vr
         NFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:references:in-reply-to:dkim-signature;
        bh=aHoL/xV+lJSptWn1pnj9SxRHcMCta8KU7nBOlsKicA8=;
        fh=t2ZoXSG+N2GpNUUkxYipK6meYocu1DKc3tl21oZmJKM=;
        b=kwaxcrppJG+Ds5ZAktKK7Z7z3OZ7Z4SbHDm4doCdyGy0ZHKUIQ2grxTqxSufpL+tGb
         vs8enXT/JrXjEd6tabFq/pVQZyW0m+4Csvlsi3KUAO9iBoMKpO73DP2UIYYCYgATT7+V
         f9vSYEH6ccwZ9ABguTtk/FWXBzzMzpig3Zsl/bxt572/2cPn+FJKbBOGPxQrQcQkd7CG
         0lc42NHlnA5OIwJcBZPXyHR9yKF2J/i7ny0M1k4lYSs6SDiJjJuYJE9RFU2+LHJC+YQL
         R0q1fl6LjC8CW6/ZmW4R3/bbYJE7vxj29JqX5Wh6xJw2J6vZFwqo44ytIZkojPIzs/8n
         NWwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792589321; x=1793194121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:references:in-reply-to:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aHoL/xV+lJSptWn1pnj9SxRHcMCta8KU7nBOlsKicA8=;
        b=ihyLRDDvbYTaqBdY46anGqX/Vs0AIF82chcKzRQAE54w0CAOMr+AVgOSg6FalBjknK
         7hC8Pp2HJbJer88B7T/fwg45cNh1q+IJ4R+kIBFJeTZP7iBPa4GIt2nTldiQT4opU6J/
         AN8mU6nlMvKX8xaP0T1HE5WG9TR+aMq9HFRPNbYCCWSFpo1jKJ0adpoUMOKG9Ywb3IFi
         oCT7RaV6Ej3SwRyetkv3IdR0UjhGmczHNnRT9aNNFWWwpwJK59Y//+VSQZ5kk8d8eyVU
         mTezC3lqP+qG+2e/qUmLvgX3/xKM/6P6bB0yR8CA0/mJWvHGjFwCvOjNSfiJaWAZuAtY
         HGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792589321; x=1793194121;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:references:in-reply-to:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aHoL/xV+lJSptWn1pnj9SxRHcMCta8KU7nBOlsKicA8=;
        b=L9h2EpXywy54ddXFmZLSWx1dD2Kbl0DwES3t3hlHE2d671XgTLhbySpJFQ4zM1qREg
         yPoXeHTlgjiOXiTvYmFOS/XheG5rOMW0dXn5Cy+ysyCBdQjQR05APHbdqW76Eh7mt3cs
         6a0bW3FKPPejC1yRwDZc8Sw7UN+tDjp2GesitR14KrqsWj9u/Zs23/UcwI3kJoaNlDy/
         XxxKZ3bYvGUa65W76gs0abMVMK+Y+P8bv9oaXFFRgSpiSzgYZllcJSTlj3Nq2Cz7Tdw8
         IipFdmnWsn3GQWBq2AzZUDsAMO4Q74PDcjnfyB0wBWfaEojDdvvgC7cG3KsnBrB8tjm2
         V3sw==
X-Forwarded-Encrypted: i=1; AKwUvBwoad7zqYRLEKXahKcCMcVf3BB+DHQnKvsSPZ40EAsBVim0fCqN9O2NPGLITRPfRXSVCPhcblsSs1pb@vger.kernel.org
X-Gm-Message-State: AFq9FYKASMYI2HXHZtqYEADGgg9+fRRgC2zci10FB7x01yHyoyvwJcU4
	Ai0y9RLpgw9+smgoHp0Svah6+Pfd1lcpUecnsQhcPDya1sN85IvfSFFV2ObAjApJ9j7mLGxiKWC
	b0Wl905hcz0N61s2IiLEKylT9CLtMMd8zmWb7Y5kp
X-Gm-Gg: AYBFou3grXbbAdaawpoiJhQ3dSCVZX3zPVhWf40ju25K82le3qshAmV7kujibBMSmlP
	VQXDTMMZjHu1NgbPXccVnoMeAC/YO7YGxhunreiG6vIVP5VlkOgGYVniUdRsiRimBut7BpHG9DV
	zdLTRPnA/0BwkKFFFmF+OZOUJuV+4RLVyH+4MklUAF0JtjeMf8vnwq0InBt3KYzMsp/5x5i0C6M
	sIk1hD67EE2m/UCYF/6pwGv11LyBJZBOniD3RKBxm1+nVL2fei/qCR8XNt+fAMdYO2BfpkpJ4yC
	wY7JgpqF6wBc8CR9pUsCw0Nqj/aUgvsno+RMi3rCMmaZCPl0MP2VyCJ1no6VLDmwLbpeZwV/yU0
	y0jieAM4Sezz8ZdAty0zqb5Mie55KdgmGpIBz5w4pKVt7Pdq3NEXjaJmDBRsTo3xB
X-Received: by 2002:ac8:5dd0:0:b0:533:9731:f0f1 with SMTP id
 d75a77b69052e-5368b32a9c3mr35503331cf.10.1792589320454; Wed, 21 Oct 2026
 06:28:40 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Oct 2026 08:28:39 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Oct 2026 08:28:20 -0500
In-Reply-To: <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
References: <20261021035450.3488805-1-stanleyjhu@google.com>
	 <20261021040615.3566831-1-stanleyjhu@google.com>	 <20261021040615.3566831-3-stanleyjhu@google.com>
 <db4d4e246ad6b4769f736db0d3d1678adf9d59cb.camel@mediatek.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Wed, 21 Oct 2026 08:28:39 -0500
X-Gm-Features: AclHuK_9yuJHTKtFtEEYtr3PTMFrReT2NVeEAvxb4V7BtW5ZNHdjV0Vtrr4xmu8
Message-ID: <CAE14pdcR7NPqK3W6Pfy+FkRrXSXB9wFuweOhLyFtSye_Bg4vWw@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] scsi: ufs: core: Fix double release in ufshcd_abort()
To: Peter Wang <peter.wang@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-10-21 at 21:12 +0800, Peter Wang wrote:
> If ufshcd_clear_outstanding_reqs(hba, BIT(tag)) returns 0,
> should we also set err =3D SUCCESS? Since the tag is already done
> =E2=80=94 either by the ISR or by ufshcd_abort =E2=80=94 shouldn't both c=
ases
> be treated the same?

A return value of 0 here means the completion path, rather than
this abort path, has claimed the tag and may still be running
ufshcd_release_scsi_cmd() after it dropped outstanding_lock.
SUCCESS tells the SCSI error handler it can retry or finish the
command right away, so a retry could map the same command again
while the completion path is still unmapping it.

Returning FAILED here also matches the check at the top of
ufshcd_abort(), which already returns FAILED when the tag is no
longer set in hba->outstanding_reqs.

Thanks,
Stanley
