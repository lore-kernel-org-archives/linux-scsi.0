Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794531266;
	b=tRCT8XawTNYy/nMVaRsEnO8LhhrHfOMEr/Ckzg/8+78wvi3Dzqe/3Tyku9YXyUXAE5/N
	 5f6Ufm+2sxVP8mkOyIn62hqNFdjtvuoIOqA8/NTXnPWtsqwL4GRsVt1hD3rOzRicioIyB
	 KX3BWosGBHeTJzmVTFVQv/4jbb8JP5ppTkVwQ1g9tRVko637CIYuMaa6IYp9ycSb4dSMK
	 LfTQnWWczObgjOdwSUFxW4hKKiE3Xk5DcleW81ZWAh6N3HiAoYmCirJA6hYi4dKLpGv7k
	 audtYCNwSsUS5y7/iDNdOGUT0AD7Uugju1egNpnjn75ZLFJ8VDk4eOQs3XyogE1HKVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794531266;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PqhPK/Jk3/DpbkTuDGFXIWB4SGkqiiRV47uDGX0EgF0=;
	b=dyxAb0KXlPu75ZsZfbCT2lHBn+58kCkp9JRxKAUhUz4FDJ2hA0qG09BjyAgkUTcEONIe
	 dn3feGfdUy+WnqieX8aAtwzxdO3cGIsKgrHSUa5da/HBy7S/K1qQeUfHEePxxY6byEDPn
	 EzgXDQbIXq7euUyqgKDn+PNHDSPfrCmXyfyBnpWMi0L+7shexOODMJnktQS+GHVt5+7fT
	 V2vHwf2bRXBjBFr3mi7TNaZ30j5rQaqtQ+wDcwcFW0VFoC4+/WDfsXI+s9pPuZpiglvqF
	 +k4QfWb1THvnq0mdaNhWdmNv6oqRuZGskiXnuZhv7NrwFR3khH5gH//aKRPXa56ABXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=koFCUEew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4068606A331;
	Fri, 13 Nov 2026 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=koFCUEew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075501F000C7;
	Fri, 13 Nov 2026 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794531266;
	bh=PqhPK/Jk3/DpbkTuDGFXIWB4SGkqiiRV47uDGX0EgF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=koFCUEew0o4VeHt00YpJ8NfN990RM0X0ACm8TBycC6KPB8yz/aQ727k7OOEOT2qzI
	 IZfeFIlVdBN1tQkhzYTAe+KH8xq6kjkmK/cNwFlZP4ON8TmUGTR6NZCew8WlxKTCSA
	 aPuTH88X+fxFKuhPkwJYt5Vr+wBW98sQOxUu6j/rPF3Sct5mUjY9/PL5qvIodcRQ6r
	 NTTO02lw7+OrW9n0wh5ZP48XwbP8qYzTHauP7WKixJgFuAElAqfB/nyS4eQGXFvs/G
	 7WIIw5wRsGRXbRawRDM2KOEVWCAryQUweXNX9mM/ygS0hVghgXYENUQ5lUHdt2cSPF
	 LPS3kyl8t2Tzw==
Message-ID: <sashiko-outbox-212009@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] usb: uas: fail command submission on fatal USB
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261113003536.3622755-3-sarthakkukreti@google.com>
References: <20261113003536.3622755-1-sarthakkukreti@google.com>
 <20261113003536.3622755-3-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 00:54:25 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] usb: uas: command hang and cmd_urb leak in
  uas_queuecommand_lck()
- [Medium] usb: uas: orphaned sense URB on error in
  uas_queuecommand_lck()
- [Low] usb: uas: missing Fixes trailer for uas_queuecommand_lck() fix
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] usb: uas: use-after-free in uas_queuecommand_lck() via
  negative qdepth [1]
--

commit d4b0bad1326a981836c51fc29f205193a0a134fb
Author: Sarthak Kukreti <sarthakkukreti@google.com>

> usb: uas: fail command submission on fatal USB errors
>=20
> uas_queuecommand_lck() only treats -ENODEV from uas_submit_urbs() as a
> fatal submission error. When a link drops or an endpoint is disabled
> while hub_wq is frozen, usb_submit_urb() can also fail with -ESHUTDOWN,
> -ENOENT, or -EHOSTUNREACH, causing uas_queuecommand_lck() to return
> SCSI_MLQUEUE_DEVICE_BUSY or queue retry work. In addition, if status URB
> submission succeeds before command URB submission fails with no inflight
> URBs, calling scsi_done() directly leaks the unsubmitted cmd_urb.
>=20
> Fail commands with DID_NO_CONNECT on -ESHUTDOWN, -ENOENT, and
> -EHOSTUNREACH in uas_queuecommand_lck(), and free unsubmitted URBs
> before calling scsi_done().
>=20
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

[Severity: Low]
Since this fixes the incomplete fatal submission error handling and URB
leak in uas_queuecommand_lck(), should it include Fixes: tags for
eb2a86ae8c54 ("USB: UAS: fix disconnect by unplugging a hub") and
cd5432c71235 ("USB: UAS: return ENODEV when submit urbs fail with device
not attached")?

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 3aadf4c88c5c2..843860687542d 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -743,11 +743,13 @@ static enum scsi_qc_status uas_queuecommand_lck(str=
uct scsi_cmnd *cmnd)
>  	 * a command that has finished is a success for the purpose
>  	 * of queueing, no matter how fatal the error
>  	 */
> -	if (err =3D=3D -ENODEV) {
> +	if (err =3D=3D -ENODEV || err =3D=3D -ESHUTDOWN || err =3D=3D -ENOENT ||
> +	    err =3D=3D -EHOSTUNREACH) {
>  		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
>  				DATA_OUT_URB_INFLIGHT))
>  			goto out;

[Severity: Medium]
Can jumping to out here leak cmdinfo->cmd_urb and hang the command when
uas_submit_urbs() fails after submitting a data URB on a streams-enabled
device?

In uas_submit_urbs(), data URBs are submitted before cmd_urb, and
SUBMIT_CMD_URB is only cleared (and COMMAND_INFLIGHT set) once cmd_urb is
submitted:

drivers/usb/storage/uas.c:uas_submit_urbs() {
	...
	if (cmdinfo->state & SUBMIT_CMD_URB) {
		usb_anchor_urb(cmdinfo->cmd_urb, &devinfo->cmd_urbs);
		err =3D usb_submit_urb(cmdinfo->cmd_urb, GFP_ATOMIC);
		if (err) {
			usb_unanchor_urb(cmdinfo->cmd_urb);
			uas_log_cmd_state(cmnd, "cmd submit err", err);
			return err;
		}
		cmdinfo->cmd_urb =3D NULL;
		cmdinfo->state &=3D ~SUBMIT_CMD_URB;
		cmdinfo->state |=3D COMMAND_INFLIGHT;
	}
	return 0;
}

When cmd_urb submission fails after DATA_IN_URB_INFLIGHT or
DATA_OUT_URB_INFLIGHT is set, jumping to out skips
uas_free_unsubmitted_urbs(cmnd) and leaves SUBMIT_CMD_URB set and
COMMAND_INFLIGHT clear.  When the in-flight data URB later completes while
devinfo->resetting is 0, uas_data_cmplt() sees SUBMIT_CMD_URB set and
returns early without calling uas_try_complete(), while uas_stat_cmplt()
skips commands without COMMAND_INFLIGHT.  The command remains stuck in
devinfo->cmnd[idx] until the SCSI error handler times out, and
uas_wait_for_pending_cmnds() in uas_suspend() times out after 5 seconds
with -ETIME.

> =20
> +		uas_free_unsubmitted_urbs(cmnd);
>  		set_host_byte(cmnd, DID_NO_CONNECT);
>  		scsi_done(cmnd);
>  		goto zombie;

[Severity: Medium]
Does completing cmnd here leave an orphaned sense URB anchored on
devinfo->sense_urbs when uas_submit_sense_urb() succeeded before a later
URB submission failed?

uas_submit_urbs() submits the sense URB first and anchors it to
devinfo->sense_urbs.  If cmd_urb (or the first data URB) then fails with
no data URB in flight, uas_free_unsubmitted_urbs() frees only cmd_urb and
the data URBs, and scsi_done() completes cmnd without unlinking the sense
URB.  If status_pipe has not been flushed while hub_wq is frozen,
usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000) in
uas_wait_for_pending_cmnds() will time out with -ETIME during suspend or
reset, and the tag can be reused while the old sense URB is still queued.

[Severity: Critical]
This problem wasn't introduced by this patch, but can a negative
devinfo->qdepth [1] cause a use-after-free in uas_queuecommand_lck()?

If usb_alloc_streams() fails during reset or resume,
uas_configure_endpoints() stores the negative error code directly in
devinfo->qdepth:

drivers/usb/storage/uas.c:uas_configure_endpoints() {
	...
	} else {
		devinfo->qdepth =3D usb_alloc_streams(devinfo->intf, eps + 1,
						    3, MAX_CMNDS, GFP_NOIO);
		if (devinfo->qdepth < 0)
			return devinfo->qdepth;
	...
}

When subsequent commands enter uas_queuecommand_lck(), the loop condition
idx < devinfo->qdepth is immediately false with idx =3D=3D 0, and the
queue-full check idx =3D=3D devinfo->qdepth is bypassed:

drivers/usb/storage/uas.c:uas_queuecommand_lck() {
	...
	for (idx =3D 0; idx < devinfo->qdepth; idx++) {
		if (!devinfo->cmnd[idx])
			break;
	}
	if (idx =3D=3D devinfo->qdepth) {
		spin_unlock_irqrestore(&devinfo->lock, flags);
		return SCSI_MLQUEUE_DEVICE_BUSY;
	}
	...
out:
	devinfo->cmnd[idx] =3D cmnd;
	...
}

Every new command then overwrites devinfo->cmnd[0] and reuses tag 1,
abandoning any in-flight command at slot 0 and causing a use-after-free
when its URBs complete; uas_sdev_configure() also passes devinfo->qdepth - 2
to scsi_change_queue_depth().

[1] https://sashiko.dev/#/bug/linux-30cdc430-800b-42d3-908f-c7a0b944e7f9

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113003536.3622=
755-1-sarthakkukreti@google.com?part=3D2
