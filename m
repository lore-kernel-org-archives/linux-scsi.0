Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794825060;
	b=y9WDPYMVtEHkxtKmvj7khizjKU2C8HChKDkG+o3GL/5+LkviENP0pIXuVW5tsN2bjIQL
	 StqTrFMAP7TiCtGYMXQbQ93aC+reQ0UelZzXuO5Z0t3SzvpOAEqzpHYloRRWkpeihBsF7
	 2SRA75z07r0LtkCeQISYkymf0028tffdDxBcNDv/Qg2XQzHyokTCMcCMG1587DA99W5QI
	 xyR3QaYS5u1M+H4Upq5wEuDco21DhZbU9/6onUl+DILslNDlWH2+/VdaVQreVuthxuRgx
	 1R4QYyt3Q8fiTNemNfWT3HEYtufiXkWebK5Jjd1xgFJp8zxPvzkqpP2rAanDEy7zcFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825060;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hFxx3gDaH6OWqSq1KtCp0wy+9fGsSzjcn1OQvJWi0zQ=;
	b=3Xr1/w154oHeRtZhXxCC/d0cqDvz/FvnrI9lRXS+f6cIvSdKp6g/6Fd9GxoRoZjCC6bx
	 BUK6C5S95X1cml1B0uBTf9W6ekdONT81r7XXTDZPqD/g0dks1l24D1P+s2A360V2xHVDU
	 SRS62LPD6aUs2DQXbiqPawa86FBJe0T/ikkzSVIaxWTAcQ+ZEmFELSOGFebPRb7aqdXMa
	 HA7AVuAb5v/yvWXZ2mevVk+vRlntAUfUJm5DwrSHTTxJCpQSPzrQ/1VcWda9cEGevvuJA
	 LBDFiu5uJmjGSugcH0K/RB/Bjehec3YoZkz3Si4Gzo1PnJb5DCK/0Lgi9hPsp3GoRdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9ODOZNn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2446606A323;
	Mon, 16 Nov 2026 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U9ODOZNn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8ED1F000C5;
	Mon, 16 Nov 2026 10:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825059;
	bh=hFxx3gDaH6OWqSq1KtCp0wy+9fGsSzjcn1OQvJWi0zQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9ODOZNnAaedDCu6vACne+lwsl51B65JxE8KTUPgK1ou80J00Ru8I0uIPZOne0sfo
	 LwatkvxbEv2ZOxn22qkO/tUbZxpftH8o+O7MdcBQSyrY4dY21AXGQExHWyFTWLIuxC
	 d2AXzs8IIP6DMW+pBzVZikgeYzmLiLZ72yO8gj8NwkjQMSvQrxZw3l/K/kGvNzaumr
	 0eyQnMituHl3mIDECYkeK9HlhcEIHDYK1X8Cqt2N3xD/F9lUzo2Og2i8T/PNKrjd72
	 MFDqtT5X4jLC6V6rw8tqUpslYK6Vg4y/1ZnsVucvDJthZtTiz7HgqWeYQ26E8MzvvZ
	 b0xCcZtlZ25WA==
Message-ID: <sashiko-outbox-216740@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] IB/isert: finish a Reject the target core allocated
 itself
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 10:30:59 +0000
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
- [High] IB/isert: late or missing isert_cmd init for target-allocated
  commands
--

commit 7a5bd9118f37880c28b788536bd93564bfb3692e
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

IB/isert: finish a Reject the target core allocated itself

This commit updates isert_post_recv() to ignore commands without a receive
descriptor and initializes isert_cmd->conn and isert_cmd->iscsit_cmd in
isert_put_reject() for reject commands allocated by iscsit_add_reject().

> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband=
/ulp/isert/ib_isert.c
> index efa8d7b7844c9..81164881dcc24 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -758,7 +758,8 @@ isert_post_recv(struct isert_conn *isert_conn, struct=
 iser_rx_desc *rx_desc)
>  	struct ib_recv_wr rx_wr;
>  	int ret;
> =20
> -	if (!rx_desc->in_use) {
> +	/* A command iscsit_add_reject() allocated has no descriptor. */
> +	if (!rx_desc || !rx_desc->in_use) {
>  		/*
>  		 * if the descriptor is not in-use we already reposted it
>  		 * for recv, so just silently return
> @@ -1958,6 +1959,9 @@ isert_put_reject(struct iscsit_cmd *cmd, struct isc=
sit_conn *conn)
>  	struct iscsi_reject *hdr =3D
>  		(struct iscsi_reject *)&isert_cmd->tx_desc.iscsi_header;
> =20
> +	isert_cmd->conn =3D isert_conn;
> +	isert_cmd->iscsit_cmd =3D cmd;
> +
>  	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
>  	iscsit_build_reject(cmd, conn, hdr);
>  	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);

[Severity: High]
Can a target-allocated command still reach isert_put_cmd() or
isert_send_done() with NULL isert_cmd->conn and isert_cmd->iscsit_cmd?

iscsit_add_reject() links the zeroed command (with targ_xfer_tag =3D=3D 0) =
onto
conn->conn_cmd_list before queuing it to the response queue.  If the
initiator sends an immediate NOP-Out with itt =3D=3D 0xffffffff and ttt =3D=
=3D 0,
iscsit_process_nop_out() matches the reject command on conn->conn_cmd_list
and queues it with ISTATE_REMOVE on the immediate queue:

drivers/target/iscsi/iscsi_target.c:iscsit_process_nop_out() {
	...
	if (hdr->ttt !=3D cpu_to_be32(0xFFFFFFFF)) {
		cmd_p =3D iscsit_find_cmd_from_ttt(conn, be32_to_cpu(hdr->ttt));
		if (!cmd_p)
			return -EINVAL;

		iscsit_stop_nopin_response_timer(conn);

		cmd_p->i_state =3D ISTATE_REMOVE;
		iscsit_add_cmd_to_immediate_queue(cmd_p, conn, cmd_p->i_state);

		iscsit_start_nopin_timer(conn);
		return 0;
	}
	...
}

Because iscsi_target_tx_thread() drains the immediate queue before the
response queue, isert_immediate_queue() calls isert_put_cmd() before
isert_put_reject() has populated isert_cmd->conn and isert_cmd->iscsit_cmd,
causing a NULL pointer dereference (or freeing the command while it remains
queued on conn->response_queue_list).

In addition, both iscsit_process_nop_out() above and
iscsit_na_nopin_timeout() start nopin_timer without checking for
ISCSI_INFINIBAND.  When that timer fires, iscsit_add_nopin() allocates an
unsolicited NOP-In via iscsit_allocate_cmd() and queues it to
isert_immediate_queue() -> isert_put_nopin().  Now that isert_post_recv()
accepts a NULL rx_desc, isert_put_nopin() posts the send work request
without setting isert_cmd->conn or isert_cmd->iscsit_cmd, and
isert_send_done() dereferences a NULL isert_cmd->iscsit_cmd on completion.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116101108.1650=
132-1-yhlee@isslab.korea.ac.kr?part=3D1
