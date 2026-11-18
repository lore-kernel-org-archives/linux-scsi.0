Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037356;
	b=hC32is/NKyTrJQo1vIvqRsMv3zEhTdQZHKZgNaOZ6brNto0OLfPNJCO28LeZbcta17Id
	 vJGGAqN7EN4Bod0sWpHusc2RNuE3Bfl7l3oEBsgzol5TZD8LnzgIy2iU+UitTgWkVIBGE
	 dHndaykhjbzCSJ6L5uyeBlDS8Ix1P+kcTJTKSBOappTVJUJM5T65tSZFGM0u28atLN7Pz
	 7fdh9nxKWbUUhOa2Pgyr8DRuaEFA4Bf+AHDYxmzKOkNw3TkqNnlwym3TGixDb1S5uWQDj
	 77iH54wihetRq+t9VcCDN7oMzQcAu4nl05USuhzHh4fNwjugpubz0j7/KAglfdvV+pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037356;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C3QlfZ+wK6lyf08+qEikLrmLhlgppq+P5MHxH0U5RZk=;
	b=n8vIUdWPprXsx/87Twn/DKbFaDKdfQAf0YMOLM+gXBB/kvcUVaHITSRcflwmEVgOxeVB
	 GewoyNPh+SwogwUUtYwHxS1+G8Kt4UAbRUmbH6GMnIYm62KOFS42x/7Cyb6gXx2MaPqMJ
	 o7agA7ByGGSu54/tCeiRAJXg5u3sPVlEtFKSj8DcDGBXrF1q6e6HVNTsAMOAjpsES/VLQ
	 ZLLAGbRbltbdb2GHWlfG+tj0nMUj/tWU1Y5NQe1mDd5cGoRLtBUzzRtaklutbCDO8NtPg
	 b/OkTbL52flpUW/P4QOCt7JET9GJ368o+aPYWGLSeCY/FF3jvwEcXmtO2MLTtTLfYFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7O+ZVcp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B3606A32C;
	Wed, 18 Nov 2026 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7O+ZVcp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7E51F000C5;
	Wed, 18 Nov 2026 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037356;
	bh=C3QlfZ+wK6lyf08+qEikLrmLhlgppq+P5MHxH0U5RZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F7O+ZVcpmI9iu4q6m73SUnLlUP3NfDFnG6TJII5WnCwlbsdHYGLDY35+Fgt3viUHs
	 n9uyQiCK0Aj4nfetbTf6c+JI3/5RW/ll0GdBZwM0FVApu5qPJCbHdIPxxReEwY1MdE
	 rrz+ZKxlFjI+0jE33OYIddRQ5a0Oj8Ox+qVYGvjN5QlOwyzIh8WL7iuRen1WUGyO47
	 b4ZgHLAu7B09GL5gcGQSXmb0Hb9yjGxT2spX624lydhm89v8lnUMS8HpF+vZzFmx3H
	 QyUp/unRT2S2aEm8y/J6T2ifwWJ3qmnC59xdnwtXQilaNtMi9Ps9dKm4ORuy4iHsxC
	 yZsTBGo+8b3hQ==
Message-ID: <sashiko-outbox-221994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] scsi: target: iscsi: retire an unsolicited
 NOP-In only once
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261118211503.2526705-2-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
 <20261118211503.2526705-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:29:15 +0000
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
- [High] scsi: target: iscsi: race on unsent NOP-In in
  iscsit_take_nopin_from_ttt()
--

commit 079f94c5aa78a5118ce1f2b2658476b66fcf7998
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: iscsi: retire an unsolicited NOP-In only once

This commit introduces iscsit_take_nopin_from_ttt() to match unsolicited
NOP-In commands by opcode and TTT under conn->cmd_lock and clear their tag
so a NOP-In cannot be queued for removal more than once.

Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaugh@=
catern.com/

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 124ff269b8e75..b0dd3e84e68e0 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1783,6 +1783,33 @@ int iscsit_setup_nop_out(struct iscsit_conn *conn,=
 struct iscsit_cmd *cmd,
>  }
>  EXPORT_SYMBOL(iscsit_setup_nop_out);
> =20
> +/*
> + * Take the NOP-In under cmd_lock, which the tx thread holds when it unl=
inks
> + * and frees the command, and clear its tag so only the first answer get=
s it.
> + */
> +static struct iscsit_cmd *iscsit_take_nopin_from_ttt(struct iscsit_conn =
*conn,
> +						     u32 targ_xfer_tag)
> +{
> +	struct iscsit_cmd *cmd;
> +
> +	spin_lock_bh(&conn->cmd_lock);
> +	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
> +		if (cmd->iscsi_opcode !=3D ISCSI_OP_NOOP_IN ||
> +		    cmd->targ_xfer_tag !=3D targ_xfer_tag)
> +			continue;
> +
> +		cmd->targ_xfer_tag =3D 0xFFFFFFFF;
> +		cmd->i_state =3D ISTATE_REMOVE;
> +		spin_unlock_bh(&conn->cmd_lock);
> +		return cmd;
> +	}

[Severity: High]
Can iscsit_take_nopin_from_ttt() claim an unsolicited NOP-In before
iscsit_add_nopin() has queued it or before the TX thread has built and
sent it?

session_get_next_ttt() assigns sequential TTTs, and iscsit_add_nopin()
drops conn->cmd_lock after adding cmd to conn->conn_cmd_list, before
starting nopin_response_timer and queuing ISTATE_SEND_NOPIN_WANT_RESPONSE:

<softirq>                              rx_thread / tx_thread
iscsit_handle_nopin_timeout()
  iscsit_add_nopin()
    spin_lock_bh(&conn->cmd_lock)
    list_add_tail(..., &conn->conn_cmd_list)
    spin_unlock_bh(&conn->cmd_lock)
                                       iscsit_process_nop_out()
                                         iscsit_take_nopin_from_ttt()
                                           cmd->targ_xfer_tag =3D 0xFFFFFFFF
                                         iscsit_stop_nopin_response_timer()
                                         iscsit_add_cmd_to_immediate_queue(
                                           ..., ISTATE_REMOVE)
    iscsit_start_nopin_response_timer()
    iscsit_add_cmd_to_immediate_queue(
      ..., ISTATE_SEND_NOPIN_WANT_RESPONSE)
                                       iscsit_immediate_queue()
                                         case ISTATE_REMOVE:
                                           iscsit_free_cmd(cmd, false)
                                         case ISTATE_SEND_NOPIN_WANT_RESPON=
SE:
                                           iscsit_send_unsolicited_nopin(cm=
d)
                                             <-- use-after-free

Because iscsit_free_cmd(cmd, false) does not purge remaining immediate
queue entries for cmd, the subsequent ISTATE_SEND_NOPIN_WANT_RESPONSE
entry runs on a freed (and potentially reallocated) command slot while
leaving nopin_response_timer running.

Even when ISTATE_SEND_NOPIN_WANT_RESPONSE is queued before the NOP-Out is
processed, if iscsit_take_nopin_from_ttt() runs before the TX thread
executes iscsit_build_nopin_rsp(), overwriting cmd->targ_xfer_tag with
0xFFFFFFFF causes the outgoing unsolicited NOP-In PDU to be transmitted
with hdr->ttt set to 0xFFFFFFFF.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118211503.2526=
705-1-yhlee@isslab.korea.ac.kr?part=3D1
