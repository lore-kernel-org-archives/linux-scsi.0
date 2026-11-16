Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789906;
	b=2mrvIzYvcPIFdxaFMOQiS6kbaXoPU47WcgkKCzsfBmZPnGT6zHyE31dYMxujTLa/YzwY
	 MszJpaT5JaEZhLBBKyt6yjkRFhQc80j62XlOkzU+Ji/0olo6H4uQQWZ4Yl6Kc7WOvF+w+
	 DsoyvWvu7nZszAaVr4/Ibsw0nNR8270S/6o8NJjmcuryRai4kdtw/s5J9syWQYSXjC+uo
	 3zVoNlJ309wgxPTl4cM8c9DVkG6AftUk+iIakGr3ffg8S+yexmhG65GbXNSL7z1XC7aH1
	 UrEaoHQBnL94UCEBJTgVyNkFwq3hPP2YhRkBc8+xJ2DWM+uH+Xm8xbX3LwnSKQaGq7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789906;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J9mTwLbDzSmc946KbmaTG1WaVGbczmdyHljlmL/y8rE=;
	b=BQcI3tQK5GAc+2H4OCv6eUaJyYkItFkGnSbikEG9GwNoyA/nLt6RFJQHvzH2D35zDrF8
	 TyHdEuL2NYge/kw1W5pVjNjF315pCAyX2ZZlEG51nT12T5BnB4mMs/t919SYXT98dQvbk
	 FtaCeBDu+fRtyb59OC6mnlCU9p5r4wJa9IBxaSWsdVZlA+y11c8KyOIgouIbO7dV/zEfv
	 be2XSC2GJguBypckEp8rcB2BvaAYeAagQ72H+XW7e7ri/TSZO3Kg5laeV/mfb/RwjJCAL
	 lsZulhhOcxWkuWZmzUzWBP9n0rA78KS7p40GQ8RXtCvLTTb6ruVR1tcCUNo0X1PYwRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzQph2XE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5882606A323;
	Mon, 16 Nov 2026 00:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzQph2XE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C51F000C6;
	Mon, 16 Nov 2026 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789905;
	bh=J9mTwLbDzSmc946KbmaTG1WaVGbczmdyHljlmL/y8rE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lzQph2XE1nLJ8FFwuFe0JIeYO7UXPqZ/u1zZ59EKPEI1IUYWvyKOPC2S/xGjuYkbg
	 ajT4aYS4sSscBEyp+LwAzuAc5ux+5zVg+Jo0qKkJ+7+4Qf3I8eOVC0BFWw/moMn89F
	 XPbrHr2eaGVG1Bl07dQTtpeJF64vxvaeJk85sEI1mE/68O6haD+easp543BYuN9Wy4
	 W0QFkiy2vFakUSvgwvj7NJEgrfrSMZHn4EwhWtMBFRXePUjbNgZYMWsK3s0W94b1qw
	 ah+YuWJf2zTu8BHcsObdLlRykYFG7DjsEinYfTHkh4ysQeCL90Dm8Afc/grAZ9+WwQ
	 lVifbylevbKOg==
Message-ID: <sashiko-outbox-215968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 13/18] scsi: target: uring: Implement UNMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-13-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-13-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:45:04 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: target: uring: submission workqueue stall and TMR hang in
  tcmur_execute_unmap()
--

commit a69183b9652241c1e0d7dcfe7c2618562f084113
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Implement UNMAP

This commit adds UNMAP support to target_core_uring by introducing
TCMUR_OP_UNMAP and synchronously waiting for each unmap range to complete
in tcmur_execute_unmap().

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index f39bf7bf36d0f..366c5e9820956 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c

[ ... ]

> @@ -268,6 +275,36 @@ static sense_reason_t tcmur_execute_sync_cache(struc=
t se_cmd *se_cmd)
>  			    se_cmd->data_length, NULL, 0);
>  }
> =20
> +static sense_reason_t tcmur_execute_unmap(struct se_cmd *se_cmd, sector_=
t lba,
> +					  sector_t nolb)
> +{
> +	u32 block_size =3D se_cmd->se_dev->dev_attrib.block_size;
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	struct tcmur_cmd tcmd =3D {
> +		.se_cmd		=3D se_cmd,
> +		.done		=3D &done,
> +		.desc.op	=3D TCMUR_OP_UNMAP,
> +		.desc.offset	=3D lba * block_size,
> +		.desc.len	=3D nolb * block_size,
> +	};
> +
> +	/* Wait here, as the core completes the command after all ranges */
> +	tcmur_queue_cmd(TCMUR_DEV(se_cmd->se_dev), &tcmd);
> +	wait_for_completion(&done);

[Severity: High]
Can waiting on done here stall the submission workqueue and hang task
management?

On fabrics using TARGET_QUEUE_SUBMIT (such as vhost-scsi or tcm_loop),
target_execute_cmd() runs inside target_queued_submit_work() on
dev->queues[i].sq.work.  Sleeping in wait_for_completion(&done) blocks
further commands on that queue until the server completes the unmap.

If no idle tag is available, tcmur_queue_cmd() places tcmd on q->pending.
When an ABORT_TASK or LUN_RESET arrives, core_tmr_abort_task() and
core_tmr_drain_state_list() flush sq.work before calling
dev->transport->tmr_notify() (tcmur_tmr_notify()):

sq.work                           tmr_wq
target_queued_submit_work()
  ...
    tcmur_execute_unmap()
      tcmur_queue_cmd()
      wait_for_completion(&done)
                                  core_tmr_abort_task()
                                    flush_work(&dev->queues[i].sq.work)
                                      <-- waits for sq.work
                                    ...
                                    dev->transport->tmr_notify()

Because flush_work() waits for tcmur_execute_unmap() to return,
tcmur_tmr_notify() never runs to remove tcmd from q->pending and complete
done, stalling task management until cmd_timeout expires (or forever when
cmd_time_out is 0).

Even when target_execute_cmd() runs outside sq.work, if a TMR aborts
se_cmd before tcmur_queue_cmd() queues tcmd on q->pending,
tcmur_tmr_notify() has already run and removed se_cmd from state_list, so
tcmd is never aborted and target_put_cmd_and_wait() hangs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D13
