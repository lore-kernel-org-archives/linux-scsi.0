Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D38279DD3;
	Thu,  2 Oct 2025 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759412457; cv=pass; b=p6jHe7hzTbRrLuBXCeoYcXwaVu+sdWKIXvfuEkE/aEpbhC6wylypOmb6GcBXRm02cSInyciwFDEKqhQct6c9kgKq/IkKnr2S+N9pwn7tXjqwTzMUCXT1xheQT5WZOwfHdfnDmHXpG1spuymfTnQRciiyvrTL9xVJ493o5xUk42Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759412457; c=relaxed/simple;
	bh=JEb4nDsmkhXVTzgjqw0WZY5kgx7o1l+lwN3qdfye8i0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g57JqOVnrxTF5vaTDtTBBZlE6hy5FsTJqPjsGoaiQn70YlPToYUlbXMgbMOoSEJuER2isJO5I08FbKg8YZNHuqJ2AsVoZBypT3oXSGY1E3qVmvGCk/1v1ihJjbMxdkuhrkketjxBhL+U1PPZHRilMzJJl69Embm95hZnmzW/ET4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=oLyrUk2M; arc=pass smtp.client-ip=85.215.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="oLyrUk2M"
ARC-Seal: i=1; a=rsa-sha256; t=1759412267; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=HExv0ytQMYnMPjZUQs05Jn1DJfrj5uCQVcb6nxbpcMyo7NN2+wuFlTkS3zJhK2wi24
    NylmnBdO7fO93nUS+E75inP8mmJHE71Zx//6j+l9YlV1QoWqZa5wvW9oaPzrGMAYCjZU
    3tj+TJFnd/InVc4Xiv5womOUkJR74tFqnO4646unikXvdRf4rcWEruw1J1dv9l7DEask
    TZ1+GwFZPcCAgQ+vfFap7a8htD20EQr4O9TvMt4K9g8qlAn22ltEY5owynrV1Gy6LtDT
    D/lydXAw15x1GSRj93HOfvsifGXlADwS5zhGV1nxtxf9W/SddkEJwXXsUYo/BKYdEKZm
    XpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1759412267;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=rqQnv/rS7WUOtqAsgdkvgJpquhDc2e1pp1j6u9ylnj4=;
    b=trg64J57ATe4nrcj1Nc3LuVG0zgQ+tppK3IzCz8aJa2J8ZpwGjsoXyGq8o1eAiT5Qa
    pRKaMFqer9ftBJiUk3LqynPlgUc59MWRthuU8vZDECmhI7J69WHr2VkPaUUbhXYX31ry
    0gez9fcEEJPD2sEqFaqZLNYwB7V2WafvDl7O9ebRAEc2aZCVSXkL7IqaCznGkCj+h8Jm
    uTPO5pKeh9xno3A1ru/5pFhmSIV/Tt+FxUX1LMuljJysK7KqtIDjBOnDO0AU+JB2dZpB
    kRLuzaIcErmxSWrI9k/bMnuttJH7Vss7eyA3zXKnsAAKWpsQR4rKODdUXu8ZDpAkQmPv
    JPcQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1759412267;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=rqQnv/rS7WUOtqAsgdkvgJpquhDc2e1pp1j6u9ylnj4=;
    b=oLyrUk2MztlSuu+Op0DJ2FJgKrssL8z+WSCKnOjkzlBJ0MQazNjd5XynhgTxkxSUV4
    iGdVBYvn12pZUAwshKbzDP+ZnJXz85UypJ8mXb7vCPJRP+42lM3B3iYtTJOZwkF7J6mO
    EJ+M7NJNcIImZaRxtzWjLY68Ib877jX3vZx4eHFGCw8aANKqBl/b1HVFz26TB+8L9KGs
    +EE+1cFgqsC/MTULL022FMjGM5YxsZr0xqWLfjCvpvGol2S3P7nwRsTNoAp1D6i1ij+p
    Csb8gYGRNYeZqtQixXEX77vxJKYiuiIwKNKMFIIxTZyEXDMHKBwJZhKKjIyw7aozg3f5
    R9Qw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zJolXBtbIoYhB+fa1AL9w=="
Received: from [192.168.226.211]
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc6192DbifSK
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 2 Oct 2025 15:37:44 +0200 (CEST)
Message-ID: <6ae302f80fe866dcbeaf7f6f51e131b7b4722682.camel@iokpp.de>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <beanhuo@iokpp.de>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	ulf.hansson@linaro.org, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2025 15:37:42 +0200
In-Reply-To: <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <CAHUa44HA0uoXbkKgyvF4Rb9OJa1Qj-Wh7QAmQxXYAf3grLdktw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-01 at 09:50 +0200, Jens Wiklander wrote:
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -5240,10 +5240,15 @@ static void ufshcd_lu_init(struct ufs_hba *hba,
> > struct scsi_device *sdev)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 desc_buf[UNIT_DESC_PARAM_LU_WR_PROTECT] =3D=3D UFS_LU_POWER_ON_WP)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->dev_info.is_lu_power_on_wp =3D true;
> >=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* In case of RPMB LU, check if a=
dvanced RPMB mode is enabled */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (desc_buf[UNIT_DESC_PARAM_UNIT=
_INDEX] =3D=3D UFS_UPIU_RPMB_WLUN &&
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 desc_buf[=
RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 hba->dev_info.b_advanced_rpmb_en =3D true;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* In case of RPMB LU, check if a=
dvanced RPMB mode is enabled, and
> > get region size */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (desc_buf[UNIT_DESC_PARAM_UNIT=
_INDEX] =3D=3D UFS_UPIU_RPMB_WLUN) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (desc_buf[RPMB_UNIT_DESC_PARAM_REGION_EN] & BIT(4))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->dev_in=
fo.b_advanced_rpmb_en =3D true;
>=20
> Does this indicate that the other RPMB frame format is used?

yes, if BIT4 is 1, means Advanced RPMB is enabled, from the Spec:

"There are two RPMB modes; Normal RPMB mode and Advanced RPMB mode using EH=
S.
The RPMB mode can be configured by setting Bit4 of bRPMBRegionEnable parame=
ter
of the RPMB descriptor in the configuration stage. If the device receives a=
n
RPMB operation request of a different mode than the configured RPMB mode, t=
he
device shall respond with ILLEGAL REQUEST."


if it is in Advanced RPMB mode, and use sends normal RPMB frame, the device=
 will
respond ILLEGAL REQUEST in response.  but it is better to mute this noise, =
I
will add this in next version:  if it is in advanced RPMB, we will not call=
 RPMB
probe.

Regarding the advanced RPMB, its frame is quite different with normal RPMB,
since we need to pass EHS, not just RPMB frame as we use. It is better to h=
ave a
check you and us online, see which way is better to enalbe it in op-tee OS.


Kind regards,
Bean
