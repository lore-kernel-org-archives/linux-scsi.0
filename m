Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795692164;
	b=kK6HajUHaz55dG1ek4Dy0l1EEl6i//MlwIlKia2d45ZXh78KMSYwRTUnA09OOPgOPVuZ
	 3SvCfVTcW6OIaH2XZ+aQSk/3WscboOZR3kWz+Wm6K7Yuz43afZ9BLiXYscrq4SHrRyAp6
	 GbQtk1CtLHq6XzIk57Q9sEJEcja1+Y07+nNmuCSm6CfdfhuHmqKACAX0y2eephjqDmP7Q
	 JOwIGCChWaNNtVUv2YLBg/BlHE9IMa2/t97htMfDQ6q6s/mE0Snhbap69nAxA2wPivkYZ
	 wN/YtJgIr2tCQ97qfoodxmdbkjHmLXw8XW4qUVJLjCkCcR3tym242aCw30lg1+65Y/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795692164;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z7vTkDv6XaAPOtvy9cypqAIBhmuiv/cJusJKCsaz+Vs=;
	b=xAG7cRdpXPiMbRjMeMQ2dvlW49jNh9l2GNgmeycMIAQjwPxBW+DSWRCUR8jGeNRBs7dj
	 /XlKu4HajQtMqV6MaNsE3DTeDHj/xfmocZ3jf/mdd/d48fwdfwUWncVodp+2S0PSNM2Bt
	 cmBQfHBBPC2hjYing8vDFtuTlt1dBaugTPzgbu8rv27iDjgO8kAZ46/MMUwn0M6zMH2fW
	 jQeUndhJwkC2zNcNT2hW4GH0SJ7I/Z+bVdXh6KB71+XpVK5m6zkRPAD7Gh37n9H5N14hZ
	 zLli8KIFaloh7wvYTJ2kPYSPWvNuQo6Ab0sYUplwr9DF7bRrmRfyNDazui+nmTAYbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Itfi9jk+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD9606A323
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Itfi9jk+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1DE1F000C6;
	Thu, 26 Nov 2026 11:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692164;
	bh=z7vTkDv6XaAPOtvy9cypqAIBhmuiv/cJusJKCsaz+Vs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Itfi9jk+Glji1p7Kxg02iF9yyPdUkOwLeBYqXfyey6dRN7aoL0RTOya21UDlTJ3XK
	 GoUnOiWPvtSPJq65rTOyd/hSmvt/wDnCRm32PIgwlf3gIFGSRASYxqQ6/vOOyejbEW
	 CMmeKWMPVFYkoYrnny7YfZNLWeJ9UVp9R9PsLC0mSEhDgPnjsRkVCVlXSCgYPSAZWY
	 wvv64hd+c3Auf8A8OLY1tlwyHCfC4rULFHQHADqaW1x9URY2FLmmhELblYddwXzZ2V
	 J6kCSVaJQHEi+WaGv/pd9pKTa9L91K1jLqX440/A5y9GQKFpDO/3IVi9aE5OfkOYbS
	 X2F3Mt0W8q5Hg==
Message-ID: <sashiko-outbox-235373@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: disable exception work before removing
 hwmon
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yaohan Li" <shunsheng1218@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261126111400.2828356-1-shunsheng1218@gmail.com>
References: <20261126111400.2828356-1-shunsheng1218@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 11:22:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: ufs: core: use-after-free in
  ufshcd_rpm_dev_flush_recheck_work() [1]
--

commit a1077f0758756bac493f25126be2d29218ae49d7
Author: Yaohan Li <shunsheng1218@gmail.com>

scsi: ufs: core: disable exception work before removing hwmon

This commit calls disable_work_sync(&hba->eeh_work) in ufshcd_remove()
before unregistering hwmon so that running or newly queued exception work
cannot access the freed hwmon device.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 00a7637a1487d..f2a132c27fa0e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -11024,6 +11024,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>  {
>  	if (hba->ufs_device_wlun)
>  		ufshcd_rpm_get_sync(hba);
> +	disable_work_sync(&hba->eeh_work);

[Severity: Critical]
This problem wasn't introduced by this patch, but can
ufshcd_rpm_dev_flush_recheck_work() trigger a use-after-free on hba during
ufshcd_remove() [1]?

ufshcd_rpm_get_sync() resumes the device via __ufshcd_wl_resume(), which
only calls asynchronous cancel_delayed_work() on
hba->rpm_dev_flush_recheck_work:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_resume() {
	...
	if (hba->dev_info.b_rpm_dev_flush_capable) {
		hba->dev_info.b_rpm_dev_flush_capable =3D false;
		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
	}
	...
}

Because ufshcd_remove() does not call cancel_delayed_work_sync() on
hba->rpm_dev_flush_recheck_work, an already running worker can outlive
host teardown:

CPU0                                CPU1
ufshcd_remove()
                                    ufshcd_rpm_dev_flush_recheck_work()
  ufshcd_rpm_get_sync(hba)
    __ufshcd_wl_resume()
      cancel_delayed_work(...)
  ...
  // hba is torn down and freed
                                      ufshcd_rpm_put_sync(hba)  <-- use-aft=
er-free

[1] https://sashiko.dev/#/bug/linux-6d2939f8-3e6b-4a28-a988-2094ecabbec6

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126111400.2828=
356-1-shunsheng1218@gmail.com?part=3D1
