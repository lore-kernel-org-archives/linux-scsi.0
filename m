Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793020122;
	b=g2UU47SBi0+ewnqnyfPemvaEXg48OokJK1cgM/1Mx41FNoFoag1TrQ/Zta7DIpzIjD6o
	 9NJVktSc0NewYKFmHR/pPcRfB439jjj20P5okgCIJEmMSN/JZrg6GvtWU6C4TIeB4gOrs
	 BO5GyC1z8rckmMPW7YKSE1ogkdUDhtnk06yCVgZMNOsMMZn7we8pL8ua1p8Ds6tQWTSUa
	 unHgHQ1VygsL1Mgy9miEx63L+d762CJKsUyC033ziI7MJ52R5ne6wE6NWSzmgbU8j5lbR
	 NoQBSotFw2RmQl5bpNqc8cIM00hNNPnLP2qH398gu5yu4quC3MlDs/uTsDVrBwXwSrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793020122;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UuiYySxQYmj3Ur1PieLILZ76iVoaVKL3nIliKM1Pv+4=;
	b=Jd19KDLuHvfFJD1J7WD5PEUJWVCmLs2/cjsS4UQfYVpILlkCqAqiVGrsnyHdvefy2CHS
	 rxuzBsDsMIsezfXotmZnWI2zH0BWKjn+icQHSMXggtuHk4Cy7E00FL8osgd8polK9+VDT
	 yWpkTMXz6sBsRec3lPdzKvqQJ/HceIp9vJsxoNcOxy4997GdcKHEn202j1cgqh95W+XY4
	 X+ZalyLWDHzazdysvk15Qp5E8FDOd2y3luf/5HocL/s8MBbeuxGqWxk82ypFJqYf6631O
	 RwWGR0zd+JgvFw6IGYsPS8nbMeIqNrD5k/A9oFBUw6EgY9PBBK5F3Dz0K4YvBse0Drw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R0w59fDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAC1606A31A;
	Mon, 26 Oct 2026 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R0w59fDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAB41F01825;
	Mon, 26 Oct 2026 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020122;
	bh=UuiYySxQYmj3Ur1PieLILZ76iVoaVKL3nIliKM1Pv+4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R0w59fDb94IJzFZecyssyaXNY5dfpdjv4YKmgKOeTo8fgH7WBqjMvGQAMMSKwbJbc
	 cgUnPuH3uoBW8ePSeqYzEpIWD7dq8tC54d2CJuE2RRH4b30rERtUsdwd/HmTO2N9/D
	 LvBv9z62PMRftqyiN6qy3wlbdDS0xRb7Y18fXcdmcFyzrjtpU3IR2ExHQvOaZWTOMY
	 J7yJrlPwj47/yYD2BV6HqJ60qCt4CNQVvWVIRqh8w0ghfG+mVGglc7cLPCtID9Kkaz
	 Xu2eNRJHfUW5r8u/oNktk+YmbU0SosYRH0L2btUvkvc3S2Zi0Yyh38xxhRd5GJnOtV
	 T0fXuMxCM65OA==
Message-ID: <sashiko-outbox-185270@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] scsi: target: iscsi: Claim the completion on the
 DataOut submit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261026124344.745124-5-loberman@redhat.com>
References: <20261026124344.745124-1-loberman@redhat.com>
 <20261026124344.745124-5-loberman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:08:41 +0000
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
- [High] scsi: target: iscsi: CMD_T_ABORTED race in iscsit_check_dataout_pa=
yload()
--

commit 106a0e34d325c477082712ef599ef2736992fc34
Author: Laurence Oberman <loberman@redhat.com>

scsi: target: iscsi: Claim the completion on the DataOut submit path

This commit checks for CMD_T_ABORTED in iscsit_check_dataout_payload() befo=
re
submitting the command to target_execute_cmd(), completing already-aborted
commands via iscsit_complete_aborted_cmd() so that completion_claimed is set
and connection teardown does not complete the command a second time.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 83184de284825..e6113a549e053 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1699,6 +1699,16 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cm=
d, struct iscsi_data *hdr,
>  		iscsit_stop_dataout_timer(cmd);
>  		if (ooo_cmdsn)
>  			return 0;
> +		/*
> +		 * target_execute_cmd() tests CMD_T_ABORTED before it touches
> +		 * t_state, so for an aborted command it would queue
> +		 * target_abort_work and return with the command still in
> +		 * TRANSPORT_WRITE_PENDING and the completion unclaimed.
> +		 */
> +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> +			iscsit_complete_aborted_cmd(cmd);
> +			return 0;
> +		}
>  		target_execute_cmd(&cmd->se_cmd);

[Severity: High]
Can CMD_T_ABORTED still be set after the check in
iscsit_check_dataout_payload() but before target_execute_cmd() updates
t_state, leaving the completion unclaimed?

If CMD_T_ABORTED is not yet set at this check, iscsit_check_dataout_payload=
()
calls target_execute_cmd() with cmd->completion_claimed still false and
cmd->se_cmd.t_state still in TRANSPORT_WRITE_PENDING.

A concurrent task management request (such as ABORT_TASK via
core_tmr_abort_task() or LUN_RESET via core_tmr_drain_state_list()) calling
__target_check_io_state() can then set CMD_T_ABORTED before
target_execute_cmd() calls target_cmd_interrupted():

drivers/target/target_core_tmr.c:__target_check_io_state()
    spin_lock_irqsave(&se_cmd->t_state_lock, flags);
    ...
    se_cmd->transport_state |=3D CMD_T_ABORTED;

When target_execute_cmd() runs, it calls target_cmd_interrupted() before
taking t_state_lock to transition t_state to TRANSPORT_PROCESSING:

drivers/target/target_core_transport.c:target_execute_cmd()
    if (target_cmd_interrupted(cmd))
        return;

    spin_lock_irq(&cmd->t_state_lock);
    cmd->t_state =3D TRANSPORT_PROCESSING;
    cmd->transport_state |=3D CMD_T_ACTIVE | CMD_T_SENT;
    spin_unlock_irq(&cmd->t_state_lock);

Because target_cmd_interrupted() sees CMD_T_ABORTED, it queues
target_abort_work on target_completion_wq and returns true, so
target_execute_cmd() returns with t_state still in TRANSPORT_WRITE_PENDING
and completion_claimed still false.

If the connection then drops, iscsit_release_commands_from_conn() sees
TRANSPORT_WRITE_PENDING and claims the completion:

drivers/target/iscsi/iscsi_target.c:iscsit_release_commands_from_conn()
    if (cmd->se_cmd.t_state =3D=3D TRANSPORT_WRITE_PENDING) {
        bool claimed =3D iscsit_claim_completion_locked(cmd);

        spin_unlock_irq(&se_cmd->t_state_lock);
        if (claimed)
            target_complete_cmd(&cmd->se_cmd,
                                SAM_STAT_TASK_ABORTED);
        continue;
    }

Wouldn't that call target_complete_cmd() and re-queue cmd->se_cmd.work while
target_abort_work is already queued or running?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026124344.7451=
24-1-loberman@redhat.com?part=3D4
