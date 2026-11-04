Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802883;
	b=TW72iZ21R9iOJ1tmDa0s55fa9f673SBoSPM4AvUGuuHaAqDB3vbLsOUzRC/3UGRu2Dtk
	 ScwBVRVL4yUY5+QfIuwl/a3BQ7wJ9m9/si92T8jBBrl+2bjSFqH35kDUbl/AQ1QuSPjLh
	 DmdIGUAKaRddFUnDjfQrd9T0OXB0uVuWlQnStU/dv6K/RrF6iwBCEhrMl79ZwuBKABvFf
	 Arfq9hwneIisPLEBXC0ZdaqGMM6qxWOARrvl/D4n4QvcCqbZ3ytelYHPiqmzVLFScnMJY
	 lxJvmpy/qfoojCwMU1usVA8V/p5Kna/sfHqdPX873T7Tu3PuZVijp9ELT0nkNddbodQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802883;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=miceYdDB+7PLPC/J0qgYQmDdAc3qF6Ff3jq4UUQkwZY=;
	b=J7ByKJmD1zE6KouK6UIwe+FfOiXcREywpPYYF9KjbsAvEWach23Joc7vlNbQaaqaCx6x
	 RTKysSUZ7RVvKPHnyrDsxX6GduehIgLkIrznoYixqVNJwQr5cQ7bX3HEcIMqT8QUostYZ
	 +hgE1LaQCFGF1zDvLZGFjjHg0B1+26JGsPm98zklegpO+gumNmob0L6xEIxyLvzGaauv8
	 TZ7Vm7z6NUz/XuhCW4Tc/t/O+HNevBMGvuyNmxLawLETHuiCdY7bqHjXrtOYbRDRL+5s8
	 VzERPY2OgRNEzftUNM1dXqmWhBaOfaPYpfEXzFbF/u192Vlg0PGJnOboLZsBk8MV8HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCQew7J4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F15606A329
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCQew7J4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B841F00A1D
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802882;
	bh=miceYdDB+7PLPC/J0qgYQmDdAc3qF6Ff3jq4UUQkwZY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZCQew7J4C0cPbpFciKAO29xWInbT/Z9mDi4MngzVubYoiE/NbzT2woeIcapJeMO1d
	 rOxhLT3GseRScwA22F7gUErzJFnWneWR8ELJ4/+aPneT3avjJDYLsymfA0og2a61Aw
	 Td+crMWeYN2V0NTkV/ksXQvBalTAv6ZQDIpc32Z7ZlILQ7DaeMklE5gyS51OD4Ffqv
	 y9ubd4J1tRS6KMYaJyiqAp1Nqd9tnk5Ly2DkSshSP5pAirdKjminDIUmG61Qar+l0w
	 olOrzA9NoVYOWDFEIRj32Zj7BhbgBwa6xveznllTlS8//zKtVwUNIXIkBjzvW439Hr
	 8pm9c2skhrRpg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bfc346401aso558009e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Nov 2026 06:34:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzR2m9RaGxLZSlFFQ1+XrFxiarU2NGMmr5fgYNYn9tIZXKHe25qXqmIyDVsKxKNBdeO63rs2k7DSWW9@vger.kernel.org
X-Gm-Message-State: APuU4Z+X8NYcR07CDhGXMOjofwY77cRkqZGzinCCG2YFHmKIVNM4YCgx
	mWYWnDMhCwKZPp8D/5Z7V/got3vgbXSt2yLtXTofZad2W482o5Hc7ue8kpd6zfIevYY+VE67+qy
	3dKa4FFy1er40GkGLTdBpz7qZ/+JpCNY=
X-Received: by 2002:ac2:4c4e:0:b0:5be:605c:fca2 with SMTP id
 2adb3069b0e04-5bfd954bf17mr5907232e87.4.1793802880980; Wed, 04 Nov 2026
 06:34:40 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104112744.1630864-1-stanleyjhu@google.com>
In-Reply-To: <20261104112744.1630864-1-stanleyjhu@google.com>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Wed, 4 Nov 2026 15:34:28 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gWGVXeN9nq=cUe=ufeX5jC3oWpdms-2Eus13dFNxqxAw@mail.gmail.com>
X-Gm-Features: AclHuK8_mlawzHb7grWA4pMsKYYbWB0rPIQSUSQOlRdZy4jfzqgdM01VFchXEqs
Message-ID: <CAJZ5v0gWGVXeN9nq=cUe=ufeX5jC3oWpdms-2Eus13dFNxqxAw@mail.gmail.com>
Subject: Re: [PATCH v2] block: Keep RPM_ACTIVE in blk_pre_runtime_resume()
 when already active
To: Stanley Jhu <stanleyjhu@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>, 
	Brian Norris <briannorris@chromium.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-block@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 12:27=E2=80=AFPM Stanley Jhu <stanleyjhu@google.com>=
 wrote:
>
> Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
> suspend callback failures"), a failed runtime resume leaves
> dev->power.runtime_error at 0 with runtime_status set to RPM_SUSPENDED,
> so later runtime resume requests run sdev_runtime_resume() again:
>
> 1. A runtime suspend increments q->pm_only from 0 to 1 and sets
>    q->rpm_status to RPM_SUSPENDED.
> 2. The first runtime resume fails in the driver callback, and
>    blk_post_runtime_resume() sets q->rpm_status to RPM_ACTIVE and calls
>    blk_clear_pm_only(), decrementing q->pm_only from 1 to 0 so recovery
>    commands can enter the queue (intended since
>    commit 6e1fcab00a23 ("scsi: block: pm: Always set request queue
>    runtime active in blk_post_runtime_resume()")).
> 3. A retried runtime resume calls blk_pre_runtime_resume(), which
>    overwrites q->rpm_status from RPM_ACTIVE to RPM_RESUMING, so
>    blk_post_runtime_resume() sees old_status !=3D RPM_ACTIVE and calls
>    blk_clear_pm_only() a second time without a matching
>    blk_set_pm_only().
> 4. q->pm_only underflows from 0 to -1 (triggering WARN_ON_ONCE in
>    blk_clear_pm_only()), blocking non-PM requests in blk_queue_enter()
>    and __bio_queue_enter() while the device is RPM_ACTIVE, and the next
>    runtime suspend increments q->pm_only from -1 to 0, letting non-PM
>    requests dispatch while RPM_SUSPENDED. This hits the UFS device
>    well-known LUN by default and SCSI disks with
>    manage_runtime_start_stop enabled (ATA and FireWire sbp2 defaults).
>
> Transition q->rpm_status to RPM_RESUMING in blk_pre_runtime_resume()
> only when it is RPM_SUSPENDED, and call blk_clear_pm_only() in
> blk_post_runtime_resume() only when old_status is RPM_RESUMING, pairing
> each clear with a completed runtime suspend.
>
> Tested on QEMU ARM64 UFS in SDB and MCQ modes by injecting
> runtime-resume START STOP UNIT failures on the UFS device well-known
> LUN, confirming zero pm_only underflows and balanced runtime PM cycles.
>
> Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend call=
back failures")
> Cc: stable@vger.kernel.org # v7.3+
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

LGTM

Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
> Differences from v1:
> - Move SUSPENDED -> RESUMING explicitly in blk_pre_runtime_resume() and
>   clear pm_only only for RPM_RESUMING in blk_post_runtime_resume()
> - Describe the QEMU UFS test coverage in the commit message
> - Link to v1: https://lore.kernel.org/r/20261029040001.2100001-1-stanleyj=
hu@google.com
>
>  block/blk-pm.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/block/blk-pm.c b/block/blk-pm.c
> index 8d3e052f91da..34cc7c5ca04e 100644
> --- a/block/blk-pm.c
> +++ b/block/blk-pm.c
> @@ -142,7 +142,8 @@ EXPORT_SYMBOL(blk_post_runtime_suspend);
>   *
>   * Description:
>   *    Update the queue's runtime status to RESUMING in preparation for t=
he
> - *    runtime resume of the device.
> + *    runtime resume of the device if the queue is runtime suspended, or=
 keep
> + *    RPM_ACTIVE if a previous failed runtime resume already reactivated=
 it.
>   *
>   *    This function should be called near the start of the device's
>   *    runtime_resume callback.
> @@ -153,7 +154,9 @@ void blk_pre_runtime_resume(struct request_queue *q)
>                 return;
>
>         spin_lock_irq(&q->queue_lock);
> -       q->rpm_status =3D RPM_RESUMING;
> +       /* Keep RPM_ACTIVE if a prior failed resume reactivated the queue=
. */
> +       if (q->rpm_status =3D=3D RPM_SUSPENDED)
> +               q->rpm_status =3D RPM_RESUMING;
>         spin_unlock_irq(&q->queue_lock);
>  }
>  EXPORT_SYMBOL(blk_pre_runtime_resume);
> @@ -168,8 +171,8 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
>   *    driver or error handler will need to communicate with the device.
>   *
>   *    This function should be called near the end of the device's
> - *    runtime_resume callback to correct queue runtime PM status and re-=
enable
> - *    peeking requests from the queue.
> + *    runtime_resume callback to mark the queue runtime active and clear
> + *    pm_only if the queue was resuming.
>   */
>  void blk_post_runtime_resume(struct request_queue *q)
>  {
> @@ -185,7 +188,7 @@ void blk_post_runtime_resume(struct request_queue *q)
>         pm_request_autosuspend(q->dev);
>         spin_unlock_irq(&q->queue_lock);
>
> -       if (old_status !=3D RPM_ACTIVE)
> +       if (old_status =3D=3D RPM_RESUMING)
>                 blk_clear_pm_only(q);
>  }
>  EXPORT_SYMBOL(blk_post_runtime_resume);
> --
> 2.56.0.385.gac671c819a-goog
>
