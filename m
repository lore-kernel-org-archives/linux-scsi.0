Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793781249;
	b=D7QL/HsU0JPAZqqnapnytlOmrRF0M+PcMmcdXxEc75CNa7OoS/GXZc0AWWSGnGChMfDj
	 GtGPqz219pROL6TXGHb7W3/mAivs7YHISrb4KXCM4gToy4c9SuIG9tA+E8wc6h9N2DjJF
	 ecuwrfuBA72Rwb/3231Z70eB+l//UkbcHZfv6c/KY/aLM1UoriM/9tcznWDIl7h1Lwei7
	 94UEUHh2ck8vwAXXff+y4BPRo0uTKzoTphabGZXV1Np9W72dpYTmLYt00kbuy210vOFf5
	 P8B4Je6JWvCNtt/WUobS3IcdgMtaUn2QroHxGsXUeDsnPdQOoo4t6//qDssWPykOtsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2YCJxeNDUEEC/PN71eE101QfW+Gem1hsWQoiZvXYUpo=;
	b=gdYdhkJhIHjQ+EPPTv4xdDhQLzo8wavIwX/Do5uImV6W5WkxDbuh6HnqjC4DjFQ8sUAy
	 4bcUeQV2FIruenC3WtM9q2dGCrvSFkgVFOq8gyRoUiD0mD3IoEv9LRoIbWG2ZvtdgFiyI
	 Y4jvYEwRPEQv9hROtl24NZVfpgSRSQFT6ujGVNCtC+lc5PHy7tWUCQnPUkNWS65skVX+p
	 nj+OjEHj9Q/MnKmif4Uy5drtY5pfnBjLRyT0zezl6TI6teQnOxU0lAIQvlOBPsbA4P96p
	 6eoQuSMvTL05VDWIiPw7IvaG9MLFuvPF44468mGtZxsJ3/f0pJ8dJ2EuRJS5Q9t4ubA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=JC+mmpsm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6AB606A333
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 08:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C6AB606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=JC+mmpsm
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c40f5077425so6745066b.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 00:34:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793781247; cv=none;
        d=google.com; s=arc-20260327;
        b=YEgU93aM+RLN9RqOy3QpOQzITfjHNVzsBA63/HC9p34nLCDdEVHjw8cCFh9WoStaqk
         QrDKSPloK/Mo+IiAxN2xcqM+gMjJfTfN5U1GMsZXdNfUT6ZbHDuXBfAr806ErUkLZBbq
         ELQ/tdW1rxTGBi9qoRsCp5npXu5JeWKZDAXe9gJ7NTMOtqwas8VaG9U4TwakZJKi4Urw
         qv41wGGqJfsVcXCwZK+fBk6Cc8Vg3pibvIuZ1zV6ZPCgNHZFNoPcfHvCdeb2cc2lW1s8
         a0+r9YV/oyURRkmPxZzLspQBEID7H+ums86BsVT1ZaXyAmNcp8SZHe1fBN0j/0P60VCU
         aPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2YCJxeNDUEEC/PN71eE101QfW+Gem1hsWQoiZvXYUpo=;
        fh=9bKrd807YsE7hwm8o9HZNxw2wdhfpg5ug3iEWBKrPgo=;
        b=iI56mMGFtsYwFiiq5mk2N1M3rWncu6EKCR9jSCMBjaFveQi0X00OKtaZ2nYt4BeOKe
         5B1XivpRY7y1e90Y8AeExNAMs18PVGyMoMH8+VCXMqlTLctUwioseDd6HnRMV3XT7SIH
         Iw+s+aRh2c/6gKEuuoPlfjLmmiYX1KfcGqDTo/ITbFOmSr8D/oGg5QRDNMvQalNsBQX8
         NDazRgSGlN8YO+dktGaMfkOq+394M5osxvYu2XaTQwvMt+5AKvacdguIdAkvS2Y4EZIJ
         +WyR8zfyYZlaBMcca13qyiKMoJq8iqAwyUGoi5yirLMyIiVTGaE+c8jS3WWFXe/wdVLU
         druA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1793781247; x=1794386047; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2YCJxeNDUEEC/PN71eE101QfW+Gem1hsWQoiZvXYUpo=;
        b=JC+mmpsmFvRcGWyk7MvQCw2OSDrruSn/FK0wig1g86Vhn44uuNwMryQaHqyZtX6904
         HIKuCll1/oRuNl5oKXu0pgFHJRDX49sZzEnpUJdqfVjVKAXOs7UGU/YAr60wB9+0kH1d
         wGR48oinwrx0MZORinR6OKb8rMoAqVxlfSq7N56A2qUnak0YH1v4LALak0bpZvcWfS/B
         GwlUoxewBRUWN/KJOylI2RrFiBQtikUs4XFoK/lFMi9Ji4KSIXVeIeAnjKr4kIrFNktT
         8NAuA6AY0YbbuIMW7a/y+n7zBSbQGfr0P1n0YOJjY3NOOkB5SCjlujOY36ej0qKzpwX3
         MNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793781247; x=1794386047;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2YCJxeNDUEEC/PN71eE101QfW+Gem1hsWQoiZvXYUpo=;
        b=pwakSI19T2oXHWDg2hKMa9cL8u7EhgW9tDcBdWfjrj8Frr2rzzJuNM1FYOUof9TvaP
         4dqKq3dNgV2pYviJB/geFo9JHuDajAnFX7xUnyQIjpoy0iogYePss66xaAUwBIkbayw+
         JcH6Vgc1Hw+syI/bP2ISm1/ogK92dJ3hDtgotWLS3GfPHtU8ALjvSpEMWjoGHDBBl1al
         3Pjmn1n2uN3qXvHudplZQhsKuoJh/yENxTm6DuMiB0E91fr62DeHWmvahGJeT38IC+Os
         gMXwuxJkZKbRrUY/FUWIhthTXQX/VC5stz+2fIaFQmT7ZkP61diS+8f6WGlqVicGURSc
         nwnQ==
X-Forwarded-Encrypted: i=1; AKwUvBys0WdvO2rXFWXHPkrAN1x86WuPZNDS8hp5dz9IGv9ZceCPOozr0H/10a7YsqM4E7XsCmV4PMa8Y3xC@vger.kernel.org
X-Gm-Message-State: APuU4Z9Ie1EhcE7M10fXa3JaJW7cJO0Tq/+nEBfWFTkXPXeAwCttUEwB
	bhCvnGAV8NDn3lTmoDJ1a5LAcXCtTPeDWWST34IODev7NAlH5X0tr1+GmEi35WLi8mFAM4rzE9r
	nmY5gp/kTCHhYRcJheVLcakJHmRX+aJfwbjZz4bsC2g==
X-Gm-Gg: AYBFou2orOzRUTP2cFZPDyAhhuqpKw8hvlEMytvGlyyHSaOUc4xMHPnhBBjfbl8CaF7
	bGtKZpOy7/feyOXwZ2Bp5ltanAW8d99RRsYJ1iKnm342CEbsCr7q6uIcakl3aJTqAT0VK1Z37Qh
	NztfLeGsMevvGgdgO4udXk2q168lUCy9FVdU3HAh2Knnm6y1nefN581OTCB+X+5Pj9ba4RtKxph
	wQYkO/5awnjQGTgSIZznmq+6nm+tIKIhTAZGcN/O5tvhfokqJU83WnErNUghyCihew2Z1E4ovlW
	dUZbHHfyACgfUai5szAKkyz/4pPlBCCqxsZKfIg4ufVQ7P7Ge5JoPyJ6CxVqVbuJa6+pRnv+Gfs
	rAd4N3JhGeiOxaMD7NaanvlQLxv7yZqtB4SWl
X-Received: by 2002:a17:906:3fc5:b0:c41:3963:6f1f with SMTP id
 a640c23a62f3a-c4ca7aa1130mr1349702766b.4.1793781246769; Wed, 04 Nov 2026
 00:34:06 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104021411.1467970-1-vulab@iscas.ac.cn>
In-Reply-To: <20261104021411.1467970-1-vulab@iscas.ac.cn>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 4 Nov 2026 09:33:55 +0100
X-Gm-Features: AclHuK_YBUuZ7jqJLMCJGig30Mi42mmsmdNieb9-dYDSw-IglX71LlEBm73W7XQ
Message-ID: <CAMGffEkj=rzCiiek=p+9Qc2AjJ1Nkk00H8wFReQ9-0ptWHKobw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation failure
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 3:14=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn> wro=
te:
>
> pm8001_init_ccb_tag() is called after the Scsi_Host, the sas_ha and the
> driver's private data have been allocated, and after the PCI regions
> have been requested.  When it fails, pm8001_pci_probe() jumps to
> err_out_enable, which only returns the error: the Scsi_Host, sas_ha and
> private data are leaked, the PCI regions stay requested and the device
> stays enabled.
>
> Jump to err_out_ha_free instead, which releases all of those resources.
>
> Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding I/=
O supported to 1024")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx!
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 5af81c73a8f8..389649b36aab 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1178,7 +1178,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>
>         rc =3D pm8001_init_ccb_tag(pm8001_ha);
>         if (rc)
> -               goto err_out_enable;
> +               goto err_out_ha_free;
>
>
>         PM8001_CHIP_DISP->chip_post_init(pm8001_ha);
> --
> 2.34.1
>
