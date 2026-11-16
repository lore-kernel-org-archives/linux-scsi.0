Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789692;
	b=E41mKBD11b+jDqqHe+lni38vpb/mToBhDORkHjiNQ73RcZd56aYN9EvO4amzIGlTNHCh
	 FikdRNdHUZl1yzTOSoJxiFavrr0POMVXyYtTqZxsflUQHNgRYj3+ORqQh+eBxKVuLnf/7
	 vWhs5Il3g+2iCPWIfegtdn4FSaYDN2CiTXEFH6wHgmycw1zTmtDEB6KKA4mlvAsORXWz5
	 cGoP7fmB7YzqDv9OeVgPyL/7hu2NGfKpCuRksFr5ScV6aB+G7QX0VRj37bM6QlQkstoKZ
	 g2o+LOcS3PVWK23opfFNEj36wW45lYjbeqMFroiqhu+bqJvh3zkEYaem3ABYlpOSjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789692;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pvlRcMLoQYHhz4XMzUXfZDpX2OjVZIoGxVhY7JcCHKE=;
	b=aCz12yC7rO41BPuLxylMMlPyzjXR8+74TfmuQk3diTul77Imk7Co/4WiD4nZUsrcyx8v
	 5sc4hFcpSnt/AYEppPOfovW7OhBedRHtq9Q8JXcHELTIkU1cVw3AWTT+RTsNgCXiPVZo4
	 79V4c6ilTebS8RvTfcVSM/2ZOXaEqoAmgTjbPqb43Vs0XyQXVdlUGJGlDR1d/EhNMWhem
	 6FzTE7eOVPKEDi4vlyCYNNunQKtAw+aHMdqLX+PrxqYkeWH23F2Y4EKKzzT4tRgNYzPVq
	 5RoGDJg37xyyZwvxsKstQGuZ3trY4H7pSnSvj7w1tSTYKRKcjl+wWMyGjNdifIKks7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgSTmJ3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC4606A881;
	Mon, 16 Nov 2026 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgSTmJ3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63F31F000C4;
	Mon, 16 Nov 2026 00:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789692;
	bh=pvlRcMLoQYHhz4XMzUXfZDpX2OjVZIoGxVhY7JcCHKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mgSTmJ3Xo4uOQIssth0IJAtDkjLmUSYKUSYYHdDAbqiSzmuYQtU2dI8kB7J9k25Kv
	 XJlZaC/04UZ8lNbApL90t09Cy4PnkPEQcSihGrYgKJxTh37LfycLE14qqpJCI2xeOD
	 2pFhbEm7yHB8WAtpiu2cS+vEPvo5NhfXuFdTjNwlrJf27nIqT7+bwC3CTI2CF+2PfM
	 9xM/jym7saQgvifgoPFVqEDDiwXkE1f18fOhWU2OfohTpr4UO0RKM3coBGMK/lDp4m
	 /Z8OOubvW51VW+2N07pmur7M/4gMe5aDt6JqUKLNbpVvdF7vcpgi/L3DEMUfhSYl53
	 8H49sAxYlKz5g==
Message-ID: <sashiko-outbox-215964@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 10/18] scsi: target: uring: Time out commands the
 server does not complete
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-10-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-10-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:41:31 +0000
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
- [Medium] scsi: target: uring: schedule_delayed_work() race in
  tcmur_timeout_work()
- [Medium] scsi: target: uring: UAF race scheduling timeout_work in
  tcmur_queue_cmd()
- [Low] scsi: target: uring: 32-bit overflow in cmd_timeout * HZ in
  tcmur_queue_cmd()
- [Low] scsi: target: uring: unlocked deadline calculation in
  tcmur_queue_cmd()
--

commit 2624a7f3c24be9a1330c0e703d8b3102658c07d2
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Time out commands the server does not complete

This commit adds a configurable command timeout (cmd_time_out, 30 seconds
by default) and a delayed work item to fail pending or in-flight commands
that the userspace server does not complete in time.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 2978dd08c99cf..0f83bdc55e06a 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c
[ ... ]
> @@ -190,6 +196,8 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, s=
truct tcmur_cmd *tcmd)
>  	struct tcmur_io *io;
> =20
>  	refcount_set(&tcmd->ref, 1);
> +	if (udev->cmd_timeout)
> +		tcmd->deadline =3D jiffies + udev->cmd_timeout * HZ;

[Severity: Low]
Can udev->cmd_timeout * HZ overflow 32 bits here and in the
schedule_delayed_work() call below?

tcmur_set_configfs_dev_params() accepts any non-negative int for
cmd_time_out without an upper bound, and both udev->cmd_timeout and HZ are
32-bit integers.  A value above UINT_MAX / HZ wraps in 32-bit unsigned
arithmetic before being widened to unsigned long (and on 32-bit
architectures a value above LONG_MAX / HZ wraps time_after()), causing
commands to time out prematurely or immediately.

> =20
>  	spin_lock(&q->lock);
>  	io =3D list_first_entry_or_null(&q->idle, struct tcmur_io, node);
> @@ -205,6 +213,9 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, s=
truct tcmur_cmd *tcmd)
> =20
>  	if (ucmd)
>  		io_uring_cmd_complete_in_task(ucmd, tcmur_fetch_tw_cb);
> +	if (udev->cmd_timeout)
> +		schedule_delayed_work(&udev->timeout_work,
> +				      udev->cmd_timeout * HZ);
>  }

[Severity: Medium]
Can scheduling udev->timeout_work after dropping q->lock race with
command completion and device teardown, causing a use-after-free on udev?

Once q->lock is released, the server can complete tcmd immediately on
another CPU, dropping the last LUN and device references while this thread
is preempted:

CPU0                              CPU1
tcmur_queue_cmd()
  spin_lock(&q->lock)
  tcmur_io_start(q, io, tcmd)
  spin_unlock(&q->lock)
                                  tcmur_commit()
                                    tcmur_cmd_end(tcmd, ...)
                                      ...
                                        target_complete_cmd()
                                  tcmur_destroy_device()
                                    cancel_delayed_work_sync(
                                      &udev->timeout_work)
                                  tcmur_free_device()
                                    ...
                                      kfree(udev)
  if (udev->cmd_timeout)
    schedule_delayed_work(
      &udev->timeout_work, ...)  <-- use-after-free / re-armed after cancel

Scheduling udev->timeout_work while holding q->lock avoids this race.

[ ... ]

> @@ -244,6 +255,58 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd=
 *se_cmd,
>  			    se_cmd->data_length, sgl, sgl_nents);
>  }
> =20
> +static void tcmur_timeout_work(struct work_struct *work)
> +{
> +	struct tcmur_dev *udev =3D container_of(work, struct tcmur_dev,
> +					      timeout_work.work);
> +	unsigned long now =3D jiffies, next =3D 0;
> +	struct tcmur_cmd *tcmd, *tmp;
> +	struct tcmur_queue *q;
> +	struct tcmur_io *io;
> +	bool rearm =3D false;
> +	LIST_HEAD(expired);
> +	unsigned int i, j;
> +
> +	for (i =3D 0; i < udev->nr_queues; i++) {
> +		q =3D &udev->queues[i];
> +
> +		spin_lock(&q->lock);
> +		list_for_each_entry_safe(tcmd, tmp, &q->pending, node) {
> +			if (time_after(tcmd->deadline, now)) {
> +				if (!rearm || time_before(tcmd->deadline, next))
> +					next =3D tcmd->deadline;
> +				rearm =3D true;
> +				break;
> +			}
> +			list_move_tail(&tcmd->node, &expired);
> +		}

[Severity: Low]
Does breaking on the first non-expired command in q->pending skip expired
commands queued behind it?

In tcmur_queue_cmd(), tcmd->deadline is computed before acquiring q->lock.
If one CPU computes an earlier deadline and is delayed before taking
q->lock while another CPU computes a later deadline and appends to
q->pending first, q->pending is no longer ordered by deadline and
tcmur_timeout_work() stops at the later deadline until it expires.

> +		for (j =3D 0; j < udev->queue_depth; j++) {
> +			io =3D &q->ios[j];
> +			tcmd =3D io->cmd;
> +			if (!tcmd)
> +				continue;
> +			if (time_after(tcmd->deadline, now)) {
> +				if (!rearm || time_before(tcmd->deadline, next))
> +					next =3D tcmd->deadline;
> +				rearm =3D true;
> +				continue;
> +			}
> +			/* Leave the tag to the server until it commits it */
> +			io->cmd =3D NULL;
> +			list_add_tail(&tcmd->node, &expired);
> +		}
> +		spin_unlock(&q->lock);
> +	}
> +
> +	if (!list_empty(&expired))
> +		pr_warn_ratelimited("tcmur%d: command timed out\n",
> +				    udev->dev_id);
> +	tcmur_end_cmds(&expired, SAM_STAT_CHECK_CONDITION);
> +
> +	if (rearm)
> +		schedule_delayed_work(&udev->timeout_work, next - now);
> +}

[Severity: Medium]
Can a concurrent tcmur_queue_cmd() cause this schedule_delayed_work() call
to be ignored, delaying expiration of the oldest command by an extra
cmd_timeout period?

CPU0 (kworker)                    CPU1
tcmur_timeout_work()
  /* sees command due at next */
  rearm =3D true
                                  tcmur_queue_cmd()
                                    schedule_delayed_work(
                                      &udev->timeout_work,
                                      udev->cmd_timeout * HZ)
  schedule_delayed_work(
    &udev->timeout_work,
    next - now)  <-- ignored (already pending for cmd_timeout * HZ)

Because WORK_STRUCT_PENDING_BIT is cleared when tcmur_timeout_work()
starts, CPU1's schedule_delayed_work() arms the timer for the full
cmd_timeout * HZ, and CPU0's schedule_delayed_work() returns false without
shortening the timer to next - now.  Using mod_delayed_work() when
rearming would update the timer to the earlier deadline.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D10
