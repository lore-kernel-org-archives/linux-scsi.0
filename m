Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003622;
	b=Dz+cSNrxlqhbIkc5EpvdClRIxkmokw8G8pNGctDs3veBAQMHuIwo3P9veaSOP9jl/shm
	 xSSjzPuJgz2mhW7XEGDxZ+yh4Kyvo1ItUOr2HfWqW8Gt8XkB3Px1X6QW6vy235HAAOg69
	 DWG+xbVf5154wCdEkgnzVbwssFERdeGlzQ9b9u0gHnj71T/oHhouZd04005yygjKkK+wi
	 CpJLFt4THP0UtliHYxBNWLj6CxcsmuWlMxa42jRf6fDaCY2JYoEbgvUMhQZqiDD+wlBum
	 fOnrPyK4+LlMTSvbGBZ1/5bElRl6XLUzgqxfJa//Osw+jP+otE0Y822knHuiOxsHQAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003622;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=op6c/74qV6YVj9jP0RugP3C+9ct57ykA6Wnx8wCw/qs=;
	b=r4rmCucFjjkL3KrW8kchnRN//t/8MnzrtuGDAodsvAP4TkL55HwyVjX+ApQ8yAlP1lo6
	 Zl3LLe9NeLNsxlOcliaK2D2f0D05fsrAlhea30aGCSul/TTJLUb3gUGFAbZS7+oSzUews
	 xNheQs1ZC91GZLxhK8a7ydK5I2WZxNKlF9mPIqPK5No/HOcKi0fFk8wZMotegREPbd+4S
	 /V0F81SPTf8imanXyv2Bwt1aT3H2SjqP3P2c46OS5/SdUTWRvgjcmotz12R4zCPWcBTrX
	 a77e6ENDrRnJRhYHaXc2a7FOoS0kBbts8ICAYEH9JjCDZ8Hk/xc4mZOmEUdgbV3gXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RftNcetH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34FD606A32A;
	Wed, 18 Nov 2026 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RftNcetH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3695F1F000C4;
	Wed, 18 Nov 2026 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003621;
	bh=op6c/74qV6YVj9jP0RugP3C+9ct57ykA6Wnx8wCw/qs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RftNcetH3A+fPv0BUL7O+KDHgH9RIhcfrEQFJJ2en48zQKClpR5DBogW2AHttphzD
	 2qIFw2innEYwl8kQxi8TCJm7/Rt20KBk1uLeAPg85wN1rqsqZ1xR5qVoMGhozznQx1
	 T41D3Hl7BlLWJtoMnCqxDrOV8boJQ7j12SuBBsEnqrrxkMLmU6/s8Sc1ldKOsCbWu5
	 3yMIeFhGEoE9LVmXJgI3pU3qBcikPgkXdnlrQibO5EicpMkaKrCMmsVKiGHlSgfY9A
	 NaaLti7U5ogteQONSc46xjP6L7lLjSlYgnHfeiSylMb1roUnjk+URjXC637ULeF/ax
	 1e2maT3KYomKg==
Message-ID: <sashiko-outbox-220874@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] scsi: target: iscsi: match a NOP-In by opcode as
 well as by tag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261118113905.2361969-2-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
 <20261118113905.2361969-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 12:07:00 +0000
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
- [Critical] scsi: target: iscsi: double free of NOP-In in
  iscsit_process_nop_out()
--

commit 4b724f8430caaec9358e8c9a8789de674c7d8d78
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: iscsi: match a NOP-In by opcode as well as by tag

This commit updates iscsit_find_cmd_from_ttt() to match commands by both
iSCSI opcode and Target Transfer Tag so that NOP-Out and Data ACK SNACK
handlers only match the command type they expect.

Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaugh@=
catern.com/

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 124ff269b8e75..2762a60ec3b33 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1821,7 +1821,8 @@ int iscsit_process_nop_out(struct iscsit_conn *conn=
, struct iscsit_cmd *cmd,
>  	 * This was a response to a unsolicited NOPIN ping.
>  	 */
>  	if (hdr->ttt !=3D cpu_to_be32(0xFFFFFFFF)) {
> -		cmd_p =3D iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
> +		cmd_p =3D iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt),
> +						 ISCSI_OP_NOOP_IN);
>  		if (!cmd_p)
>  			return -EINVAL;

[Severity: Critical]
Can back-to-back NOP-Out PDUs carrying a NOP-In's TTT still double free
cmd_p?

An unsolicited NOP-In queued by iscsit_add_nopin() sits on
conn->conn_cmd_list with no se_cmd, and iscsit_find_cmd_from_ttt() returns
it without removing it from conn->conn_cmd_list or invalidating its
targ_xfer_tag under conn->cmd_lock:

rx thread                         tx thread
iscsit_process_nop_out()
  cmd_p =3D iscsit_find_cmd_from_ttt(...)
  cmd_p->i_state =3D ISTATE_REMOVE
  iscsit_add_cmd_to_immediate_queue(cmd_p, ...)
iscsit_process_nop_out()
  cmd_p =3D iscsit_find_cmd_from_ttt(...)
  cmd_p->i_state =3D ISTATE_REMOVE
  iscsit_add_cmd_to_immediate_queue(cmd_p, ...)
                                  iscsit_immediate_queue()
                                    list_del_init(&cmd->i_conn_node)
                                    iscsit_free_cmd(cmd, false)
                                  iscsit_immediate_queue()
                                    list_del_init(&cmd->i_conn_node)
                                    iscsit_free_cmd(cmd, false)
                                      <-- double free

Because conn->conn_cmd_list is only updated when the tx thread runs
iscsit_immediate_queue(), sending two NOP-Out responses with the NOP-In's
TTT in one write queues the same ISCSI_OP_NOOP_IN command with
ISTATE_REMOVE twice, causing iscsit_release_cmd() to double free the
command and its session tag (or corrupt a newly allocated command if the
tag was reused in between).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118113905.2361=
969-1-yhlee@isslab.korea.ac.kr?part=3D1
