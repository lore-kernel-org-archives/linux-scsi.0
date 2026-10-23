Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720901;
	b=2MmxbmNe8MHf71P3w/YXwqLG45U4DvkoHMNzjzxBnXupLZEfWwUIBiYnArRATnLACvIZ
	 a/YPkJFRv0MNll/u0K1BawMEXTyvMzqQv/6HkG6JQ3JFMLRBTKQidFr7AOLPsjQNkedGx
	 Fi8tlXqBc1KVmVMNlW26j6qu9fi2kSJPGElkbNDP8FpULXaeO07vzFXi8K57JS4HLNxCj
	 9Dm3WPExCWYcmprey5AhNdfHlt4q/yMPeLNyHtPsy6xv5Hmp4YWGSw0W3nUJxIIHpRhQT
	 azSZjevrz2EPap1dk1MGwuzy5pLlC2CCaasbB+zgz1jZMaKqhEffSVVnUT+62Wdeq3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720901;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kDq6nBHxAMj+4/8EvAu02PFRsyPzgle+8WOEaZceAsU=;
	b=yxiW94D8JhmpNCEhVA2HG/GnrEk6xxEOo8cGQplOMKU+jU8ngqtlkeMws65UvuwLwCbJ
	 JldLsZ5F5pqZLtnTMwKu9zCs8CDzvTh+JEns6rxW8vGqtPE2qNOxl3nh6pyAC0AoCU5kk
	 STpIbOmgh1TkcScHRrwPCljpfNxctaU3EDXMC5tylLG5/DOE9rfQ5BPTSI+X/PFNG871Z
	 9LUORdWbnB4dafPaWeJTFK34Ll5tmLjQ6uP58vCRs1828s9B+PTRaxoKnAuEc5G04l2Zz
	 XPjySvhEBNqikFabVJTFh9DJDoIiwqluiOZzdyHiu5Qnht8CAlKZ82+yoNKi7wktPwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Flvi9Pvr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F78606A319;
	Fri, 23 Oct 2026 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Flvi9Pvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448AA1F01825;
	Fri, 23 Oct 2026 02:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792720901;
	bh=kDq6nBHxAMj+4/8EvAu02PFRsyPzgle+8WOEaZceAsU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Flvi9Pvry6SP8GYW+eCF++tqTK5JCZMwpn0HcygWWddjZ789qX/hw8ivDysbCXgGn
	 8HdfU/6Pw4OEaJQmhDC+Al6ERW+4liWfTzoubzfNliOmLojMnSqGpYWp2MwWFNvW1a
	 K1q7c7ZlCJNDenVp3raiF9w65ulj8uFoIpRcsQzwS3TEGX8T0Ojl0DvjngygBZnwHt
	 cT5dlStqTMbw26W81B60ODVomNxT+x0B02+9o8B47D7L1zH0x/9xCQfkeD8OZLd7rv
	 JI47pmXNreDDDIDvtr/lxMW9j/SxOhzFSoCdr8fwVWJcniNsycAis7fcZe4kD5jvIV
	 zpGSdpQ9j0EGA==
Message-ID: <sashiko-outbox-182202@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] usb: uas: wait for pending commands before unbinding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayi Li" <lijiayi@kylinos.cn>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261023013931.388916-1-lijiayi@kylinos.cn>
References: <20261023013931.388916-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 02:01:40 +0000
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
- [Medium] usb: uas: stalled wait and false timeout error in uas_pre_discon=
nect()
--

commit 4c54d6873e1e380dddee1542eeac75bb8256858a
Author: Jiayi Li <lijiayi@kylinos.cn>

usb: uas: wait for pending commands before unbinding

This commit enables soft_unbind on the uas driver and adds
uas_pre_disconnect() to block SCSI requests and wait for pending URBs and
commands to finish before unbinding the interface.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..300ab637be70b 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c

[ ... ]

> @@ -1211,16 +1212,54 @@ static int uas_reset_resume(struct usb_interface =
*intf)
>  	return 0;
>  }
> =20
> +static void uas_pre_disconnect(struct usb_interface *intf)
> +{
> +	struct Scsi_Host *shost =3D usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo =3D (struct uas_dev_info *)shost->hostdata;
> +	unsigned long start_time;
> +
> +	start_time =3D jiffies;
> +	for (;;) {
> +		if (READ_ONCE(devinfo->udev->state) =3D=3D USB_STATE_NOTATTACHED)
> +			return;
> +
> +		flush_work(&devinfo->work);
> +
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000))
> +			break;
> +
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500))
> +			break;
> +
> +		if (time_after(jiffies, start_time + 5 * HZ))
> +			break;
> +		if (uas_cmnd_list_empty(devinfo))
> +			return;
> +
> +		msleep(20);
> +	}
> +
> +	shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
> +}

[Severity: Medium]
Can uas_pre_disconnect() stall for 5 seconds or emit a false timeout error =
in
the following cases?

First, in uas_pre_disconnect(), time_after(jiffies, start_time + 5 * HZ) is
checked before uas_cmnd_list_empty(devinfo). If the waits on sense_urbs and
data_urbs both succeed (for example, 4.7s waiting on sense_urbs followed by
0.4s waiting on data_urbs, or a scheduling delay), can total elapsed time
exceed 5 * HZ and cause the loop to break out and log a timeout error even
when all commands have completed and uas_cmnd_list_empty(devinfo) is true?

Second, because uas_driver sets soft_unbind =3D 1, usb_unbind_interface() h=
olds
the interface lock (and callers such as usb_set_configuration() or
usb_reset_device() also hold the device lock) when calling
uas_disconnect() -> uas_pre_disconnect() without disabling interface
endpoints. If the device is physically unplugged while uas_pre_disconnect()
is sleeping in usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000),
usb_disconnect() sets udev->state =3D USB_STATE_NOTATTACHED and calls
usb_disable_device(), which blocks on the device or interface lock before
reaching usb_disable_device_endpoints():

drivers/usb/core/message.c:usb_disable_device() {
	...
			remove_intf_ep_devs(interface);
			device_del(&interface->dev);
		}
	...
	usb_disable_device_endpoints(dev, skip_ep0);
}

Since pending sense_urbs are not unlinked by USB core until uas_disconnect()
returns, won't usb_wait_anchor_empty_timeout() wait the full 5000 ms, break
out of the loop, and log a timeout error without rechecking whether
devinfo->udev->state became USB_STATE_NOTATTACHED?

Third, if a status URB completes with a non-zero status, uas_stat_cmplt()
frees the URB without clearing COMMAND_INFLIGHT or devinfo->cmnd[idx]:

drivers/usb/storage/uas.c:uas_stat_cmplt() {
	...
	if (status) {
		if (status !=3D -ENOENT && status !=3D -ECONNRESET && status !=3D -ESHUTD=
OWN)
			dev_err(&urb->dev->dev, "stat urb: status %d\n", status);
		goto bail;
	}
	...
bail:
	usb_free_urb(urb);
}

Once sense_urbs and data_urbs are empty and devinfo->work is flushed, no
further status URB will complete for that command until uas_zap_pending() r=
uns
after uas_pre_disconnect(). Wouldn't uas_cmnd_list_empty(devinfo) remain fa=
lse
and cause uas_pre_disconnect() to spin in msleep(20) for the full 5 seconds
before logging a timeout error?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023013931.3889=
16-1-lijiayi@kylinos.cn?part=3D1
