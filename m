Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ECD3EE1C4;
	Wed,  8 Jul 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544666; cv=pass; b=OUxNwH0cPHM1dEw+4bLHbeRSD6Hju7l8AFSC86Ok4N8J++ctbt0AFV6Dj/bPAU7sOtsqCbYYxS/8IbkFdhYhLjgU/hmuQxf/SVFuFHG1ju9cH2U+r2dWRWh+h0mQxUzWUwedyOTQAjG1qJEbsdWveSou6dzLLYWK3/Sm7ONeuAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544666; c=relaxed/simple;
	bh=7fk8AUfmXj+Dqs6Mk9/EUnTAYtvJbFOcQ2V8dY2oHbo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VSRMRIFExjDva/lRbW2QcRRa3LbO2L56t6pwnCei7sd0Y4ofEX68bB63Zfik+ih3VONdNMj1FT3O6nuYHZCk9YB5KhPw1x8DUroLmbbo2SUEJQwguYv2HMFUU6WdN9kpsrkeS3iOQwtgXKXMgI+7HW8iWP4SIaE4kvoHcxUolnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=U5o+q4yX; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=yVFoj0cX; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="U5o+q4yX";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="yVFoj0cX"
ARC-Seal: i=1; a=rsa-sha256; t=1783544652; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UUNQ2EzGYnzxtnZKiWD9aTL3ILGMt/JgcffUUJDkKilVB/53pNqXnvDRhroanGqYIU
    XQzYGVGhD8eY6kOIY9wXavWC9/VRLNzp200atHhqRK9mRuy2Fcx/gZ42Rpkq96V/eXUb
    VSset9uI/A3h2IxQNdCn6l04ZdPkImcYKjD6HSUBtwNz9mPyDDQW2Zd+/b0jgmTWXAEA
    nl68jNt0fnbF7ogaaq83rouHkcwgqo6yCa28vKohY9lBl50rLj3F9dAp6C9QPFt//qCg
    d3zn1hUa6HXwS4I1Jl1MTrNDiGWFP06VtwqBzdVMh0Xw32v5YrM6pRz2czNeYTEQq0Tk
    a/3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1783544652;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=uNZt4boGDfu478+WIMDn9z9zXl+uGBpTgPXTSWQdNC0=;
    b=GUIx+KkkaUrb7+Z25yzCsSbWMHPlA5ju6XVHup/RuwtXRxbFMpNJiJz82t2wyQw4UX
    dpqfYVxkmEskyQhdoa2zMVfXzqnS0Tf+Vxr8z63K/5S/VdYhF8qthcBfDWcoI6BHdwQz
    jTFN24PKfVJbRjFzJW0ZaHDUM3Bs0+Ulb7Dj5SLJIM47jOc9xJgeTT8bVSOyo08MzDMV
    Arupr3a17AhE4rQdlfFoPb7R87k1S19Fu7T26lF+mXMtwGyuLxPS2Zoh12U5/jez9Vjf
    61qcIlQRrSoA9hbVeZLuygj0+Shbc2tlXZk//02r5IGIr4iQgpo8JJeV3lXM6Fvrs//M
    tvLA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1783544652;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=uNZt4boGDfu478+WIMDn9z9zXl+uGBpTgPXTSWQdNC0=;
    b=U5o+q4yXOHEQQoqD++cwkbaQ1wGfKpexHKUySROaTRi71re34p5+RDbOGh4LausN+D
    SMjkTMLSaOtO5tuiRo5U11wgwQcKOoIuqRIsBCMQDH7PZ45DnvU4erHI145GgorBmp/f
    HkhH9zlDr/uBey5UcDwshZMK/cMYnNcVQET7uzKR2aO4Gw/rzvoAvSXWHWzDYJbMd66l
    a2eQ8hOaMSMREA/90xnNIf6uVOgnAz9oIt0uA51pFMTzQBg+kaaI0SOBwUuR5ISptqcD
    4rJ/mihoy4uMpp6F28RBwJw+mStrYU/sNvq6DwkOIwUwbKdIa4fqqpaHOdMZPjaar2NZ
    /xsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1783544652;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=uNZt4boGDfu478+WIMDn9z9zXl+uGBpTgPXTSWQdNC0=;
    b=yVFoj0cXtx75eI6P+Oxh0WopSvMnT6dpku0cjHjNhZjBeiVqD9qfrLvhP6Q3VpsPIB
    AKzRD8D5rAoepdJuE1Bw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGWUpI6wfUjZWOuvfZPDhjfo3o0tv9XjkArh/V4="
Received: from p200300c587147773f0f0e3c76ec87fb3.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d388268L4BxNp
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Jul 2026 23:04:11 +0200 (CEST)
Message-ID: <2160d030b5a6414335c84cb89632384866d94e1a.camel@iokpp.de>
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
Date: Wed, 08 Jul 2026 23:04:10 +0200
In-Reply-To: <20260708124934.764281-1-lgs201920130244@gmail.com>
References: <20260708124934.764281-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-08 at 20:49 +0800, Guangshuo Li wrote:
> UFS RTC support schedules ufs_rtc_update_work to periodically update the
> device RTC. The work can issue query commands and access the UFS host
> controller.
>=20
> __ufshcd_wl_suspend() cancels ufs_rtc_update_work in the common suspend
> path before calling the vendor suspend callback. However, the
> active-active path, where both the device power mode and link state stay
> active, jumps directly to vops_suspend after flushing exception handling
> work. That jump bypasses the RTC work cancellation.
>=20
> If the RTC work runs while the vendor suspend callback is gating or
> otherwise changing hardware state, it can access the controller during
> suspend and trigger an SError.
>=20
> Cancel the RTC work in the active-active path before jumping to
> vops_suspend, matching the common suspend path.
>=20
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")


this fix tag is wrong, should be:
Fixes: b0bd84c39289 ("scsi: ufs: core: Fix SError in ufshcd_rtc_work() duri=
ng
UFS suspend")

since 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support") placed the canc=
el
after the vops_suspend: label (after the POST_CHANGE vops call), so the act=
ive-
active goto vops_suspend path did cancel the work. then b0bd84c39289 ("scsi=
:
ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend", moved the c=
ancel
up above the PRE_CHANGE vops call to close a race in the common path. That =
move
is what removed cancellation from the active-active path. So the correct ta=
g is
Fixes: b0bd84c39289, not 6bf999e0eb41.

> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b5..9d5571a7aec2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a,
> enum ufs_pm_op pm_op)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0req=
_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_disable_auto_bkops(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0flush_work(&hba->eeh_work);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0cancel_delayed_work_sync(&hba->ufs_rtc_update_work);

RTC updates stop permanently after the first active-active suspend. you nee=
d to
add resume:



diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 376a314189e4..06f253b08b65 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10339,6 +10339,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,=
 enum
ufs_pm_op pm_op)
                        req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
                ufshcd_disable_auto_bkops(hba);
                flush_work(&hba->eeh_work);
+               cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
                goto vops_suspend;
        }
=20
@@ -10548,10 +10549,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
,
enum ufs_pm_op pm_op)
                if (ret)
                        goto set_old_link_state;
                ufshcd_set_timestamp_attr(hba);
-               schedule_delayed_work(&hba->ufs_rtc_update_work,
-                                   =20
msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
        }
=20
+       schedule_delayed_work(&hba->ufs_rtc_update_work,
+                             msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS))=
;
+
        if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
                ufshcd_enable_auto_bkops(hba);
        else

Kind regards,
Bean



> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto vops_suspend;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0

