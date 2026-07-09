Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46743890EA;
	Thu,  9 Jul 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783608594; cv=pass; b=cBw4urkE446d1l+/kTVPlF9zP+RpRuMIFPbf+YSPYJAKTnYVQGdIAEUSUKiIUI7TogTdzGPxYBsMtna4h1YIg9AXsFDPI0mUJuC/W2SvoP9fHfe02Lu8g2l4mSP7ZJfTffAlCnFz1W6I7Z7jFshUP0L+4F3d+YHwxFyMmumtJOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783608594; c=relaxed/simple;
	bh=cThylUwJ/9f4okQW+8eU2MvlyJNg3yB4jm2Pa4NCeN4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RHNF3bNdWR5sB5CVeWJ5B3Y2MtGB07aJfn2t/JuvK1+nqg2ZDBuhqym/0AMozLiXX3EE+2cv7RN5cKIDS8KWg5l8cYkqluLRAwzEFaBO61krqUL6HOvRqb2VynD6PurGQeIyOdidfh+xc2DczzNcfyKczA4RNsdZZjAKYYs9/dU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=NcGTau66; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=wRWu19P+; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="NcGTau66";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="wRWu19P+"
ARC-Seal: i=1; a=rsa-sha256; t=1783608581; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=STxS/tIqRoLoScRjenGG0bMT0CYHO/mtkFuORapJvQyZPF+jU5JEgX0NfxyQ7AJv9I
    pDwhbmLwp23WUfk1fjKiTTKY7DmxH4u2ahwQFyhcH525JRLyEY9FPXAp44Gwlhj37iPp
    3v4xk2Togr2L2S3Ykv/oXmH7hGudxl1O5AnrF4y4MQjdFw0jQ4/qjJSEBGXoF4RT7AVI
    NioS2mSXRYFkMYKw0SPl3ho9lcOo+dSaDeybySflCsvXoGnuTC1tMA7haywL4JlGMpiX
    9YxL+ZelzFoTHqX9zxGpEFo76Fe3ta+RoSeOO6vmlTksDdpfOQBb4Tl5oEXvRko+/2/q
    HYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1783608581;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=cThylUwJ/9f4okQW+8eU2MvlyJNg3yB4jm2Pa4NCeN4=;
    b=B/sgthHBEf4f8iqh1EW9xKC8JRePCa1bCj0N5ek9/5TlW7yOHmY047IRTFWi8/aE/s
    rQl4GN1JoKsqRCupfpNk/svykE1+qMQXz3IbAOn7B9gdZQyWoxPuDgFO6P0mDNNebrD7
    85FXqu7U73zulAZjXcFriy8Sp/zMRQ+VHRFKbZ/NRQXLrRciW8oHnIdJbhI/pidUNKy0
    OFsycRJ++w7X6vNs9bCem4s7JybLLDft2EiBMbQVGvdhdjbQYjq4rtGd4ODNUQUdo1Xh
    2nvI/1tUYHHfCuhM82VLYNda4zGdwTQdM9A8aPG25bnirtEmoceDwAIXqE7P50jxNlCT
    kKbA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1783608581;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=cThylUwJ/9f4okQW+8eU2MvlyJNg3yB4jm2Pa4NCeN4=;
    b=NcGTau668lMF7Zor0PTx3DPRDORJNRWOKatca28A4ENhoJjiTKAt54lWmML/9UKhle
    5DU3RppHL955CGKhlAN3tK9RP/2CPUV3vnnUdutQ2D0TxnadI9WYMzICpgKLapZZqxxR
    6CNktl5ZUe6XzVihBQZoXqCj+xhKiS6M0CIEYysRNm5UAW0Bo/GH37QGlQs8PAYPk4qI
    haxNTIiJBMhOFjiiKUIjZ1SAbI8qSbG7sY8j5PtpMPvKfde/W06EaqvZYhqb4UF/8YjQ
    73b0OVrChLPQtrnm0nV25dTmb8R6r9cvzkZMRRqudmHRNAAoP0O2fG/C1xctp75NVznH
    +DzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1783608581;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=cThylUwJ/9f4okQW+8eU2MvlyJNg3yB4jm2Pa4NCeN4=;
    b=wRWu19P+/rhIr/Jc9ENiGcLNrAov470a4nLBc+VH7Uy6ZmxPDlp8BZR/qU1bDOBHks
    gQQ6+Z8VCLl+sQUw0ZCg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d388269End1Vm
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 9 Jul 2026 16:49:39 +0200 (CEST)
Message-ID: <3335691dad233520fcc6947545739dccc37a98ec.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: cancel RTC work in active-active
 suspend
From: Bean Huo <beanhuo@iokpp.de>
To: Guangshuo Li <lgs201920130244@gmail.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bart Van
 Assche <bvanassche@acm.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,  Can Guo <can.guo@oss.qualcomm.com>, Adrian
 Hunter <adrian.hunter@intel.com>, Thomas =?ISO-8859-1?Q?Wei=DFschuh?=
 <linux@weissschuh.net>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2026 16:49:38 +0200
In-Reply-To: <2160d030b5a6414335c84cb89632384866d94e1a.camel@iokpp.de>
References: <20260708124934.764281-1-lgs201920130244@gmail.com>
	 <2160d030b5a6414335c84cb89632384866d94e1a.camel@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Guangshuo

would you like to update your patch with the consideration of RTC update re=
sume?


Kind regard,
Bean


On Wed, 2026-07-08 at 23:04 +0200, Bean Huo wrote:
> On Wed, 2026-07-08 at 20:49 +0800, Guangshuo Li wrote:
> > UFS RTC support schedules ufs_rtc_update_work to periodically update th=
e
> > device RTC. The work can issue query commands and access the UFS host
> > controller.
> >=20
> > __ufshcd_wl_suspend() cancels ufs_rtc_update_work in the common suspend
> > path before calling the vendor suspend callback. However, the
> > active-active path, where both the device power mode and link state sta=
y
> > active, jumps directly to vops_suspend after flushing exception handlin=
g
> > work. That jump bypasses the RTC work cancellation.
> >=20
> > If the RTC work runs while the vendor suspend callback is gating or
> > otherwise changing hardware state, it can access the controller during
> > suspend and trigger an SError.
> >=20
> > Cancel the RTC work in the active-active path before jumping to
> > vops_suspend, matching the common suspend path.
> >=20
> > Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
>=20
>=20
> this fix tag is wrong, should be:
> Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() du=
ring
> UFS suspend")
>=20
> since 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support") placed the ca=
ncel
> after the vops_suspend: label (after the POST_CHANGE vops call), so the
> active-
> active goto vops_suspend path did cancel the work. then b0bd84c39289 ("sc=
si:
> ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend", moved the
> cancel
> up above the PRE_CHANGE vops call to close a race in the common path. Tha=
t
> move
> is what removed cancellation from the active-active path. So the correct =
tag
> is
> Fixes: b0bd84c39289, not 6bf999e0eb41.
>=20
> > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > ---
> > =C2=A0drivers/ufs/core/ufshcd.c | 1 +
> > =C2=A01 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index d3044a3089b5..9d5571a7aec2 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *=
hba,
> > enum ufs_pm_op pm_op)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_disable_auto_bkops(hba);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0flush_work(&hba->eeh_work);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
>=20
> RTC updates stop permanently after the first active-active suspend. you n=
eed
> to
> add resume:
>=20
>=20
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 376a314189e4..06f253b08b65 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10339,6 +10339,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a,
> enum
> ufs_pm_op pm_op)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req_link=
_state =3D=3D UIC_LINK_ACTIVE_STATE) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ufshcd_disable_auto_bkops(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 flush_work(&hba->eeh_work);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 goto vops_suspend;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> @@ -10548,10 +10549,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *h=
ba,
> enum ufs_pm_op pm_op)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (ret)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto set=
_old_link_state;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ufshcd_set_timestamp_attr(hba);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 schedule_delayed_work(&hba->ufs_rtc_update_work,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
> msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 schedule_delayed_work(&hba->ufs_rtc=
_update_work,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ufshcd_keep_autobkops_enab=
led_except_suspend(hba))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ufshcd_enable_auto_bkops(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>=20
> Kind regards,
> Bean
>=20
>=20
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto vops_suspend;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
>=20

