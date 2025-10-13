Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1513308F0F;
	Mon, 13 Oct 2025 15:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370190; cv=pass; b=deCnDV8XNxr5M9QSt3f1Fs86YXGiwyZAZnOVvUZp9IP2chUXNoKmJRDx13hk5G2F7VHOcgOILlCZMmhvvCRp53w05DUcORTVMp2ehkiWG5pST1cNzyiclfF4xWaey/rSzYQkEN5qaZoPNmuT/cm5RGt+s3qYcPHWAt/Q1b8AMMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370190; c=relaxed/simple;
	bh=RBDJP7wCwRN4qqRQF3Sufkn/YuRjVpfSZxUcUC5/iCw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yl/9vtRNAoj5sI7Es2DE260BD0umC2K2drmF8vSvAeU7DedqKyrFBRGmntOjB4ArbJ9Ze9nZ8cv/jY3YQm9vJC0Xk0SjkVza/NDnQLHJxlSrJm3SDfZb4j0NB9LYYJuAB8A7DFVXkuYRNPRGD8u4LNC74OiXGY40fXW/aWEfGw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=nJgcKA94; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="nJgcKA94"
ARC-Seal: i=1; a=rsa-sha256; t=1760370178; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=j07uRXeu8FGGXGFYbnWi3KtlzuthTkzR01jmz6m4yirPWI8MGA2ox/f9QrmHxvEBW8
    6ZO3MZc1I7xMOiYBDfa7efoVsHuh1bA8P2hcqm79DO7Ua9cdaDkHL+M7W7wKzdoZ48N9
    8GSAgC8OQHy9ys2PzxiCW1UYVwRvEEhV4h70ezA0YvSYn5v4zjhsWw7DgjqDREMyL7pI
    3vWK1gJZrOOk5WYaGEgV+9iUlVRarK45rJKTqHB+YyIUZJuAOsqzySau7te+1FxUHhwC
    ZT0LbwYZEl8yeo5uQJc63WfGzuqoyoqfLJK4QbC/mwX974brTv/+pFTth2ND2moCpLtx
    Iogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1760370178;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=naovMIv2HR2F48aYkFfHnyPKv0+GZbANNu9J5/GObxo=;
    b=dxgrk8CCrzkgFWRlnwEOmLBcs8WLbEt9x/rL5FTu9cbK9oR5N97F1/WpeJ7PYlNj18
    6Z0HDWBy14kq9YfbAJueIMYv5dFncevqDkDELM0WBoIahQxtelDWaHCmVYc5S0cEykS1
    Sk83zDqrFIbbYV/S7Nfjx46oC/IYy0I1gtS6ZeaHZ8PvZK4St7KMvcsz8HBNYx8w2eVY
    pHaJ4SW+6NQu0KfEJNZwWi7ufqyjWlRz7yW3YRWQMHHMIGsVRQQeIxVOtFVRqKxkWFaq
    t3SiqkoWcWMlRmFw4lMA8sntyu7jKOqEFhLu16bwM0db75GoR2HHjIgUIGUfCm0Xoiq6
    uHwQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1760370178;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=naovMIv2HR2F48aYkFfHnyPKv0+GZbANNu9J5/GObxo=;
    b=nJgcKA94VR/CTZUQ2/Ob87xw29rcrWPh07qCKqFIXs39V8a/sx6MvJMBW1K+//1YCG
    dvRo7YsQPOofqMv7+1XCEOkVSJLYfgZK+Am052/N08NNyhoh1ECvKqTvQHXov6FsirhK
    fDc+sKdryD58GlXyG67+2p/QfHO7/nSyb19dqKRAHxpIYszFa8SCQ2sUE7vNn/FyrgAJ
    P/RkWz7r3HbLc50jul11DkMi39XsSZNcLVBdzQC8rpi04O9WP7BcU/RnvqYiBIYAaZyV
    yhQQ4p5bsKqq2EyT1xn/SiJcpRtRl85SrlB2+zggwXskB/NCO7jolAz+5s12b9HgTAHz
    UXOQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 53.4.2 AUTH)
    with ESMTPSA id z293fb19DFgvP5H
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 13 Oct 2025 17:42:57 +0200 (CEST)
Message-ID: <97c39c0cdb6b96d791fe05f8e5496a502a7e6ac6.camel@iokpp.de>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <beanhuo@iokpp.de>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2025 17:42:56 +0200
In-Reply-To: <CAHUa44HYNgiRU5yOrVq8gBwHEEAxGz6TyT0PrBpVOiFfKxYhOQ@mail.gmail.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
	 <893731e9c8e4e74bb0d967ab2e7039e862896dc5.camel@gmail.com>
	 <CAHUa44HdV8FJMayVg6TFz7oGZc1b6QntxMsUN8mdTV7pm7vkKQ@mail.gmail.com>
	 <a040353e95a67dc3bde09b5f3866aa628150c9db.camel@gmail.com>
	 <CAHUa44HYNgiRU5yOrVq8gBwHEEAxGz6TyT0PrBpVOiFfKxYhOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-13 at 14:22 +0200, Jens Wiklander wrote:
> >=20
> > For certain memory vendors, the serial number is guaranteed to be uniqu=
e
> > among
> > all devices.
>=20
> This is supposed to be generic and not rely on the behavior of only
> some vendors.
>=20
> >=20
> > For partitions or regions, we have appended the region number to the en=
d of
> > the
> > CID =E2=80=94 please check the patch for details.
>=20
> Yes, but how do you know that you don't overwrite a part of the serial nu=
mber?
>=20
> >=20
> > Regarding improving CID uniqueness, we could include the OEM ID or prod=
uct
> > number. However, this would make the CID longer than 16 bytes.
>=20
> UFS doesn't have a CID, but there's no need for one either. struct
> rpmb_descr has dev_id and dev_id_len. It can be any length, within
> reason.
>=20
> Cheers,
> Jens


Hi Jens,

how about combining wManufacturerID, wManufactureDate, wDeviceVersion,  Ser=
ial
Number (in unicode), plus the region number?


Kind regards,
Bean
