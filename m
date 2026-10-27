Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793125095;
	b=KfUJjPwbZx9DaQNyBFwcsPqdBmjE0vNGWWl8ZpTuxeBUEnLtTGlRL8vIFEEfrvu2rjhX
	 mFIaA+GXzAVso3fO70/S62SR29VoFTkL75hfSixFEi+UbI0wmx0EnkFwXKzPbaJPuOTxt
	 manNEGYaPgnHjIMFfdgjOLD02zEt2qSGZJ5wGGEYy7LU/cYD6tcQ9L37ebBR9CIWt0RF0
	 QzKQrXbDcB+e1i6eDKrWwEIVxB8uQYLjn4O21I+vdP3xa3yAVC6uLB7iwrgJ8i+59R750
	 kX7696R0EjeHeetw/yjK4stsXeu2/uBtL5zTK+pkSypXWl4RJU2UcPhq99b0EIeryQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1OGP3vAf2N6yBHBFjlNU3/YbFZwF9jv1NKjFlU67lBQ=;
	b=soQ45BTuocnEdXtyTlVflSBSaIeWdkwsj7pW0VZGwBqpdxMHIuPuYZWUKdQL3mgQrKIe
	 QQhlUJt5a6xgp4pWoiHe3D7KmKb8Ird4hJhmoiOi2jRuXMHVsLa5Jzb7DU8eTrYc9h7qw
	 3PbAXikfPDMwoyImf2SZtp/XhO98QWP7OeWzeWLHenHdN9T8fu5DDfDfh5MxZw106skUZ
	 1gedRx/z19NUFGkU1F5wVY0TtVZS9XZsOhLAAoeTUjq13HvLJ9kp+E+JAM267SfMzZneE
	 vhlMON2ThTYA8ohyxYghqoi5C/KQJczG0DI+RQMhrMDhB9sJhAKgZVsVZG+2U0xZ2Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSZmF1+I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05D7606A320;
	Tue, 27 Oct 2026 18:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSZmF1+I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA711F01825;
	Tue, 27 Oct 2026 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793125094;
	bh=1OGP3vAf2N6yBHBFjlNU3/YbFZwF9jv1NKjFlU67lBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YSZmF1+I/9k26v77gyfEvT+NI1GLOfFFiKzTX66mVkenCf7m5rsfVu2pvz4Od5175
	 jY9+OILnQGz2fs09iMzUO7R2fgqX4Fa/LFrrJy/zBNsS+qBhK8SmooG9X81IBg6zko
	 zkAKjHMsACJ2C8yRhBImyKp9E+MK97lCoW2q6G/sgkgbJtb3ccZNG1GjlAuMsSYBEv
	 ChK3+Y53UWJdhhSsGdmZlA4m5pWgFXpCRtOKGbDD5iUd7d0YcxtT/MFk/8pELTuy/Z
	 9jdH0NW0nE8HVET25jUo7F9YoF9dvZq/kPRaqarr1T8gkTpnQ2t7PFEUqGP/vb1Do+
	 Q1W6iX83Ucn5w==
Message-ID: <sashiko-outbox-187009@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: target: iscsi: fix hanging WRITE_PENDING
 commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Bogdanov" <d.bogdanov@yadro.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261027180123.13163-3-d.bogdanov@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
 <20261027180123.13163-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 18:18:12 +0000
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
- [High] scsi: target: iscsi: double completion in iscsit_release_commands_=
from_conn()
--

commit 31a87057639fce26dc0f2f4bbcd6ddacf96b85a5
Author: Dmitry Bogdanov <d.bogdanov@yadro.com>

scsi: target: iscsi: fix hanging WRITE_PENDING commands

This commit removes early CMD_T_ABORTED checks in the iSCSI Data-Out and
command execution paths so that aborted WRITE commands in WRITE_PENDING sta=
te
are passed to the target core once all Data-Out PDUs have been received.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 62ada3a52210e..03d618cd76721 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1518,23 +1518,6 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *con=
n, void *buf,
>  			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
>  				iscsit_stop_dataout_timer(cmd);
> =20
> -			return iscsit_dump_data_payload(conn, payload_length, 1);
> -		}
> -	} else {
> -		/*
> -		 * For the normal solicited data path:
> -		 *
> -		 * Check for a delayed TASK_ABORTED status and dump any
> -		 * incoming data out payload if one exists.  Also, when the
> -		 * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
> -		 * data out sequence, we decrement outstanding_r2ts.  Once
> -		 * outstanding_r2ts reaches zero, go ahead and send the delayed
> -		 * TASK_ABORTED status.
> -		 */
> -		if (se_cmd->transport_state & CMD_T_ABORTED) {
> -			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> -			    --cmd->outstanding_r2ts < 1)
> -				iscsit_stop_dataout_timer(cmd);

[Severity: High]
Could passing an aborted WRITE_PENDING command to target_execute_cmd() cause
a double abort completion and use-after-free if the connection closes after=
ward
in iscsit_release_commands_from_conn()?

With this check removed in __iscsit_check_dataout_hdr(), an aborted WRITE
command in TRANSPORT_WRITE_PENDING state receives its remaining Data-Out PD=
Us
and calls target_execute_cmd() in iscsit_check_dataout_payload() (or in
iscsit_execute_cmd() for out-of-order CmdSNs):

drivers/target/iscsi/iscsi_target.c:iscsit_check_dataout_payload() {
	...
		iscsit_stop_dataout_timer(cmd);
		if (ooo_cmdsn)
			return 0;
		target_execute_cmd(&cmd->se_cmd);
		return 0;
	...
}

In target_execute_cmd(), target_cmd_interrupted() is called before
cmd->t_state is updated to TRANSPORT_PROCESSING:

drivers/target/target_core_transport.c:target_execute_cmd() {
	if (target_cmd_interrupted(cmd))
		return;

	spin_lock_irq(&cmd->t_state_lock);
	cmd->t_state =3D TRANSPORT_PROCESSING;
	cmd->transport_state |=3D CMD_T_ACTIVE | CMD_T_SENT;
	spin_unlock_irq(&cmd->t_state_lock);
	...
}

Because CMD_T_ABORTED is set, target_cmd_interrupted() queues
target_abort_work on target_completion_wq and returns true without changing
cmd->t_state:

drivers/target/target_core_transport.c:target_cmd_interrupted() {
	...
	if (cmd->transport_state & CMD_T_ABORTED) {
		if (cmd->transport_complete_callback)
			cmd->transport_complete_callback(cmd, false, &post_ret);
		INIT_WORK(&cmd->work, target_abort_work);
		queue_work(target_completion_wq, &cmd->work);
		return true;
	}
	...
}

As a result, cmd->se_cmd.t_state remains TRANSPORT_WRITE_PENDING. When
CMD_T_TAS is set (for example, when aborted by a LUN_RESET on another sessi=
on
with emulate_tas enabled), target_handle_abort() queues SAM_STAT_TASK_ABORT=
ED
status and drops one cmd_kref reference via
transport_cmd_check_stop_to_fabric(), leaving the command on
conn->conn_cmd_list in TRANSPORT_WRITE_PENDING state until ExpStatSN
acknowledges the status (or, when CMD_T_TAS is not set, until
target_abort_work runs iscsit_aborted_task()).

If the connection closes while the command is still on conn->conn_cmd_list,
iscsit_release_commands_from_conn() checks for TRANSPORT_WRITE_PENDING:

drivers/target/iscsi/iscsi_target.c:iscsit_release_commands_from_conn() {
	...
		if (cmd->se_cmd.t_state =3D=3D TRANSPORT_WRITE_PENDING) {
			/*
			 * We never submitted the cmd to LIO core, so we have
			 * to tell LIO to perform the completion process.
			 */
			spin_unlock_irq(&se_cmd->t_state_lock);
			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
			continue;
		}
	...
}

Wouldn't this call target_complete_cmd() -> target_cmd_interrupted() a seco=
nd
time on the same command, re-initializing and re-queueing cmd->work for
target_abort_work while iscsit_release_commands_from_conn() also frees the
command via iscsit_free_cmd(), leading to workqueue corruption, cmd_kref
underflow, and use-after-free of struct iscsit_cmd?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027180123.1316=
3-1-d.bogdanov@yadro.com?part=3D2
