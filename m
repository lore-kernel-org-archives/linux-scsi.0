Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794531733;
	b=ivBSXJm52cbJ1EprMPeQraQg2TzmzQROZkuTaZgeuEfNZJfF3d5ZwaooK/vBpfOoNGiH
	 R1zIwJbAfH8jriXuOPTzx42ETVVj72SiAHyCnYDZL0TqGxIGSoFLEfoyXaY04sK0qQ/aK
	 UcyLiWp7WlzwVTdM4SPhcy4CHV049KXogTjOtRxp3l8s3IwEZe2ccwma6cTR1M9GEESJU
	 jjxn7jUjO+XjGtqdrMcRigz5KS5+JSMkeZ4NZ0hoAC3E8BQqhVbyxrD9vy50JlYyYpVSW
	 CYHf3NZ0ehUkh0XO3BEaKDAEgQDkGxE7xJPhqhMnbVnJRUwC8xz1QCDDveQb6j9uq/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794531733;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6FXsKmLiFW0Ld3CWWRI8xwHKnNy/2GUJEVqJy3XvepI=;
	b=VSqKUitXLlKin7HLd13yNWhPJ2zY+9tICAA81IlcLy28RsWJ6olWKdffM8h5qfF4UDNp
	 9PCwMwy2xdLS5LiNaYITCo/njAfpV7Ie5TT0C649bKXujqb4OAt9eE3OjTjaVO4AcgyhO
	 i9gVdoeaORjlo+EKzk6c04eFWo2E2PwxQcO4soEZkQMXjg3btgBw8o0W40iaXIRW8t54i
	 sWtIlqaoZ9CYgnZbbdh8RWknoOq3CFBaor2g2R0Mt/szA4VMgmcPkBcdUdyRh5gqjoPkg
	 rJJ+0ahy64fHR6vFno3iDAD03Xwd0mvPI0nOgGpDk5izNVUpB+zvg3nCtKZAcCtWZSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0t7KcBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A208606A327;
	Fri, 13 Nov 2026 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0t7KcBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1711F000C4;
	Fri, 13 Nov 2026 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794531733;
	bh=6FXsKmLiFW0Ld3CWWRI8xwHKnNy/2GUJEVqJy3XvepI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k0t7KcBZVYUfxJbeFtyWoRwO/CImu6TDNRjA+jpS1q35gKFBxVtXU1e4W63kisExf
	 aR/8MzRONPFdkN3bbAJiDZR44T+YioW9rrv7OQdpYLbCK2apLckNzjqLUfRpptvN6n
	 2+6x/cZIksx07jE6h9xt98Fa+gOms99ZslbuoHmbV5xh3K4eYbYm2/WUY8oZnNekVD
	 UQzSqJJ/c2LhJP+D92fLOXeJw0RLhDoHKUvw21P8c7fXjXj/bM9dwrnWDH4s5vcW6c
	 5nIR6JxFIDbs61ndXBLIKypb8FShDfGCXzQfeL+yTX9SonHZ9vYpHuuiNglxa2fdX0
	 +Y30n8gUJGh9w==
Message-ID: <sashiko-outbox-212028@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] usb: uas: complete inflight commands on status URB
 error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261113003536.3622755-2-sarthakkukreti@google.com>
References: <20261113003536.3622755-1-sarthakkukreti@google.com>
 <20261113003536.3622755-2-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 01:02:12 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] usb: uas: uas_stat_cmplt() orphans status URBs in
  devinfo->sense_urbs
- [Medium] usb: uas: uas_stat_cmplt() sets DID_NO_CONNECT on
  non-disconnect errors
- [Medium] usb: uas: uas_stat_cmplt() skips commands without
  COMMAND_INFLIGHT
- [Medium] usb: uas: uas_stat_cmplt() drops lock mid-loop and aborts new
  commands
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] usb: uas: unvalidated IU length causes false success in
  uas_sense() [1]
--

commit feee884d21c2440f5410ec8ac6400834915e4ef7
Author: Sarthak Kukreti <sarthakkukreti@google.com>

usb: uas: complete inflight commands on status URB error

This commit completes inflight SCSI commands with DID_NO_CONNECT and unlinks
their data URBs when a status URB fails with a non-unlink error in
uas_stat_cmplt(), while preserving existing non-DID_OK host status bytes in
uas_data_cmplt().

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..3aadf4c88c5c2 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -310,9 +310,49 @@ static void uas_stat_cmplt(struct urb *urb)
>  	bool success;
> =20
>  	if (status) {
> -		if (status !=3D -ENOENT && status !=3D -ECONNRESET && status !=3D -ESH=
UTDOWN)
> +		if (status =3D=3D -ENOENT || status =3D=3D -ECONNRESET)
> +			goto bail;
> +		if (status !=3D -ESHUTDOWN)
>  			dev_err(&urb->dev->dev, "stat urb: status %d\n", status);
> -		goto bail;
> +
> +		spin_lock_irqsave(&devinfo->lock, flags);
> +		if (devinfo->resetting)
> +			goto out;
> +
> +		for (idx =3D 0; idx < devinfo->qdepth; idx++) {
> +			cmnd =3D devinfo->cmnd[idx];
> +			if (!cmnd)
> +				continue;
> +			cmdinfo =3D scsi_cmd_priv(cmnd);
> +			if (!(cmdinfo->state & COMMAND_INFLIGHT))
> +				continue;

[Severity: Medium]
Does skipping commands without COMMAND_INFLIGHT leave partially submitted
commands in devinfo->cmnd[] hung?

In uas_submit_urbs(), uas_submit_sense_urb() submits the status URB and
clears SUBMIT_STATUS_URB before the data and command URBs are submitted.
If a data URB is submitted and cmd_urb submission then fails with -ENODEV,
uas_queuecommand_lck() records cmnd in devinfo->cmnd[idx] with
SUBMIT_CMD_URB still set and COMMAND_INFLIGHT unset:

drivers/usb/storage/uas.c:uas_queuecommand_lck() {
	...
	if (err =3D=3D -ENODEV) {
		if (cmdinfo->state & (COMMAND_INFLIGHT | DATA_IN_URB_INFLIGHT |
				DATA_OUT_URB_INFLIGHT))
			goto out;
	...
out:
	devinfo->cmnd[idx] =3D cmnd;
}

When that command's status URB fails here, uas_stat_cmplt() skips it
because COMMAND_INFLIGHT is not set, and when its data URB finishes in
uas_data_cmplt(), the SUBMIT_CMD_URB check also skips uas_try_complete(),
leaving the command pending until the SCSI timeout fires.  Similarly, if
uas_submit_urbs() queued the command to devinfo->work after submitting the
status URB, skipping it here consumes the status URB before uas_do_work()
submits cmd_urb, and if an inflight command has IS_IN_WORK_LIST set, not
clearing IS_IN_WORK_LIST before dropping devinfo->lock below allows
uas_do_work() to resubmit URBs for the command being aborted.

> +
> +			if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
> +				data_in_urb =3D usb_get_urb(cmdinfo->data_in_urb);
> +			if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
> +				data_out_urb =3D usb_get_urb(cmdinfo->data_out_urb);
> +			cmdinfo->state &=3D ~COMMAND_INFLIGHT;
> +			set_host_byte(cmnd, DID_NO_CONNECT);

[Severity: Medium]
Should non-disconnect status URB errors set DID_ERROR instead of
DID_NO_CONNECT?

This branch runs for any status URB error other than -ENOENT and
-ECONNRESET, including endpoint stalls (-EPIPE) and transient USB transfer
errors (-EPROTO, -EILSEQ, -ETIME) on a still-connected device.
Because scsi_decide_disposition() treats DID_NO_CONNECT as an immediate
non-retryable failure without invoking SCSI error recovery, all inflight
block I/O fails immediately with -EIO, a stalled status endpoint is never
reset, and sd_sync_cache() (which ignores DID_NO_CONNECT) silently reports
a failed SYNCHRONIZE_CACHE as successful.

> +			uas_try_complete(cmnd, __func__);

[Severity: High]
When multiple commands are in flight and one status URB fails, does
completing every command in devinfo->cmnd[] without unlinking
devinfo->sense_urbs orphan the remaining commands' status URBs?

Each submitted command allocates its own status URB anchored in
devinfo->sense_urbs (bound to stream_id =3D cmdinfo->uas_tag when USB 3.0
streams are enabled).  When one status URB fails, this loop clears
devinfo->cmnd[idx] and calls scsi_done() for all other inflight commands
while their status URBs remain active in the HCD.

Those still-anchored status URBs cause uas_wait_for_pending_cmnds() in
uas_suspend() and uas_pre_reset() to time out waiting on
devinfo->sense_urbs after 5 seconds.  In addition, if another SCSI command
is queued before the orphaned status URB finishes, it reuses the freed
tag slot in devinfo->cmnd[idx]:

CPU0                                  CPU1
uas_stat_cmplt(urb_A)
  /* fails with -EPROTO */
  /* completes cmnd_B at idx =3D 1 */
  devinfo->cmnd[1] =3D NULL
  scsi_done(cmnd_B)
                                      uas_queuecommand_lck(cmnd_C)
                                        /* reuses idx =3D 1, submits urb_C =
*/
                                        devinfo->cmnd[1] =3D cmnd_C
uas_stat_cmplt(urb_B)
  /* orphaned status URB for idx =3D 1 */
  uas_try_complete(cmnd_C)            <-- completes cmnd_C prematurely

> +
> +			if (data_in_urb || data_out_urb) {
> +				spin_unlock_irqrestore(&devinfo->lock, flags);
> +				if (data_in_urb) {
> +					usb_unlink_urb(data_in_urb);
> +					usb_put_urb(data_in_urb);
> +					data_in_urb =3D NULL;
> +				}
> +				if (data_out_urb) {
> +					usb_unlink_urb(data_out_urb);
> +					usb_put_urb(data_out_urb);
> +					data_out_urb =3D NULL;
> +				}
> +				spin_lock_irqsave(&devinfo->lock, flags);
> +				if (devinfo->resetting)
> +					break;
> +			}
> +		}
> +		goto out;
>  	}
> =20
>  	idx =3D be16_to_cpup(&iu->tag) - 1;

[Severity: Medium]
Can dropping devinfo->lock inside the loop cause later iterations to abort
newly queued commands?

When a command at slot idx has a data URB in flight, uas_stat_cmplt()
drops devinfo->lock to call usb_unlink_urb() and then continues scanning
higher indices:

CPU0                                  CPU1
uas_stat_cmplt()
  /* idx =3D 0 has data_in_urb */
  spin_unlock_irqrestore(&devinfo->lock)
  usb_unlink_urb(data_in_urb)
                                      uas_queuecommand_lck()
                                        /* places new cmd at idx =3D 1 */
                                        devinfo->cmnd[1] =3D new_cmnd
  spin_lock_irqsave(&devinfo->lock)
  /* loop advances to idx =3D 1 */
  set_host_byte(new_cmnd, DID_NO_CONNECT)
  uas_try_complete(new_cmnd, ...)     <-- aborts newly queued command

[Severity: Critical]
This problem wasn't introduced by this patch, but can a truncated status
IU in uas_stat_cmplt() cause uas_sense() to report a failed command as
SAM_STAT_GOOD [1]?

When status is 0, uas_stat_cmplt() dispatches IU_ID_STATUS to uas_sense()
without checking urb->actual_length:

drivers/usb/storage/uas.c:uas_sense() {
	struct sense_iu *sense_iu =3D urb->transfer_buffer;
	struct scsi_device *sdev =3D cmnd->device;

	if (urb->actual_length > 16) {
		...
	}

	cmnd->result =3D sense_iu->status;
}

Because the status URB transfer buffer is allocated with kzalloc(), a
short packet of 4 to 6 bytes has a valid iu_id and tag while
sense_iu->status at offset 6 remains zero (SAM_STAT_GOOD), completing the
command as successful and silently corrupting read or write I/O.

[1] https://sashiko.dev/#/bug/linux-78c5dae0-c194-40ff-a554-3a4de1859b86

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113003536.3622=
755-1-sarthakkukreti@google.com?part=3D1
