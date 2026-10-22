Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673297;
	b=uxSgkxEf4kOlS93uZX040T22Clm3hQhNDSgoeXxtuCyKQTSDaYo2vDEG7AiP22cADeVH
	 tQJWeBMaijbXlACs55kW1B84tJ0u2ag//uIgeTdnPRe8K+OfJ0rHKW129VFwaJBy24E4l
	 vpldHRiY2bYLf5eLERzccw/rnFUN/jUPLHjkdVuIcJqyL3Vk2kPyUWHPC/CkEVJ4RzZEO
	 CSeUtnomJ4RaXvtw323yjh2EIJj4du4qNN1jtCsDyIxFQ1t16YZYV+X32JmRdpDteYQLE
	 9Ez0st2LydbFXsFsOsrHqdyoU1UkVB/TfinEZYo8brbmlczpqTj49kedJiFFSuP4hng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673297;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5IdK+PmjkUiUuh1dD95T8XpuSiVhCAL+6eeuSPEVi9E=;
	b=YNizjN/Wk7ffGvwo7eH11IxDncxykUOjiZ7v0RRLIBtgEMk8tsiZW72nbgPmGp7NB3j9
	 6GspXjkqLPuye/EKGO5LCAaqV3pinuOKu/vPe6OGFrt7pUX6deKgcoH3hFwtJYVX8zCk4
	 hFsI2GiBoAhxyCac4q7qxwkPoT5YMA35SWU7kFJNS9PJdo5ZJ4wr4wdV19NqOE98fDl9n
	 aaQVNAqO3pqsvmaVJOzsVr8QgoAKJLRrddQgimnXVlRpCE+WwFCPr8uQxMW82UsKniGsJ
	 crAEF/jCXlzAIG43LsLhtcub6N8q8IG6L6yvvjDA0lt2TyM473TdrrXFClQgrJlqR4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPlkEpy+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29BC606A321;
	Thu, 22 Oct 2026 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPlkEpy+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3041F000C2;
	Thu, 22 Oct 2026 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792673296;
	bh=5IdK+PmjkUiUuh1dD95T8XpuSiVhCAL+6eeuSPEVi9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nPlkEpy+G2VG/qLDLna/JYx61CVoY/kPCbJczsgYyRtCzyhr1bFz5anTdjoOTwIXr
	 OLZufdm814cDn3yMv/bfMYKTmU9+L5UfhadqS3ChyFqbDbJyFonqepoNDHlOELC17j
	 P6KKBEYRdW8yFopo9SusyFJquUNZFUVMU0lrdETNfOB+HVHfX7sVcRGJW+gANzqo8J
	 IMxGVBFnm9DNcS9qJYSnltgyvwhLmhBvpCYphj+q5cQca2PBB8oyDcS+wrx7/zfv+t
	 H//4yqtoTB2Yx3SYwrZvrXR48QrpmUBoE2uYVnepmSNrfDvT/GyLlVdfU/3idEHcLa
	 Ym8mFpojzWF4A==
Message-ID: <sashiko-outbox-181504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] usb: uas: wait for pending commands before unbinding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayi Li" <lijiayi@kylinos.cn>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261022123401.319479-1-lijiayi@kylinos.cn>
References: <20261022123401.319479-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 12:48:15 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] usb: uas: pass &shost->host_lock pointer in uas_pre_disconnect()
--

commit 8e251b22758d30ff0f9e6d2743bdddf6dd61fc28
Author: Jiayi Li <lijiayi@kylinos.cn>

usb: uas: wait for pending commands before unbinding

This commit enables soft_unbind on the uas driver and introduces
uas_pre_disconnect() to block new SCSI requests and wait for pending
commands and URBs to complete before unbinding.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..4ece8f15bd170 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c

[ ... ]

> @@ -1211,16 +1212,55 @@ static int uas_reset_resume(struct usb_interface =
*intf)
>  	return 0;
>  }
> =20
> +static void uas_pre_disconnect(struct usb_interface *intf)
> +{
> +	struct Scsi_Host *shost =3D usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo =3D (struct uas_dev_info *)shost->hostdata;
> +	unsigned long flags, start_time;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	scsi_block_requests(shost);
> +	spin_unlock_irqrestore(shost->host_lock, flags);

[Severity: Low]
In uas_pre_disconnect() in drivers/usb/storage/uas.c, shost->host_lock is
passed by value to spin_lock_irqsave() and spin_unlock_irqrestore(), which
causes a build failure when CONFIG_USB_UAS is enabled.

In struct Scsi_Host (include/scsi/scsi_host.h), host_lock is an embedded
spinlock_t rather than a pointer (changed in commit e83b47309f73 ("scsi:
core: Drop Scsi_Host.default_lock")):

    struct Scsi_Host {
        ...
        spinlock_t		host_lock;

Other callers in drivers/usb/storage/uas.c, such as uas_reset_resume(), pass
&shost->host_lock:

    spin_lock_irqsave(&shost->host_lock, flags);
    scsi_report_bus_reset(shost, 0);
    spin_unlock_irqrestore(&shost->host_lock, flags);

Should uas_pre_disconnect() pass &shost->host_lock here as well?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022123401.3194=
79-1-lijiayi@kylinos.cn?part=3D1
