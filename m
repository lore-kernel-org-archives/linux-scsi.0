Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782091;
	b=tY00WRGixeDZkHtkYzLo/FRB1d6zFLU/4mpa4zRT3lLCoQ9Belbs3d7ibRpWV6ByfIz5
	 OAWyIjI8U6dnS1eD9W3znVPMheOGJtNmPtiNrtYa0pE+xjAF5HlNFB2bgj+uC+737PoZX
	 U+pzYT5wRGmFP/UB+3dp5kYX+BRsRafjZqUIi9fjGt86xdRgAWUTLrtAD5vxYOjmFiy7a
	 wMjci+ot+yN/Kwh7Azsr7HWW/KkSUByn8eGbTI5PSpijalH111Cc6Z5QZiv5kho9x+auQ
	 YQRKuYWlc9M5ng1Cg+JsO9JjoL3HCqE4G7Nj4tJ63FIcqNa/6AhqOaLk/MBchgT4gLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6JEr/hDsRw0PBfGsXwlFIqB3D+iO7P5XK/6DpMYHYnM=;
	b=iUp29OBim5RMXHWa8CvcmY1HWJXBB+2PJxMiNs4+fdZCv2lD/EyIpQLWkOO8PvwlN7V2
	 APJVPJfL7xvbivp4bMe/rNyrf7jnMnLAGtzKOraLcfZ9KjvrNdokxuriwP/MxDqWtM0q2
	 JqnxIQnBe+ditaeLRfzsGn00voWgdp9VIHAqcMLs8tfVUC5wTG7ZFOlD9chjIhlNP+C++
	 1r6skPryJMAWbD24b9J6QjYUeLJgZOb6jPSKpO/DbSe389pUCQ6plJtr0UKda4XgiozpJ
	 y8z6Ccz41Y6JVEXam8RpoxmLyA7PQtGNcsEPNt397acOAZr1SxzoFpeB2136gl6TEPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+Lu7oMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C748606A337;
	Fri, 27 Nov 2026 12:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+Lu7oMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B801F0092A;
	Fri, 27 Nov 2026 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782090;
	bh=6JEr/hDsRw0PBfGsXwlFIqB3D+iO7P5XK/6DpMYHYnM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C+Lu7oMGXXISVXi++YSqDyH4GqcpPp9l+dAySyA/61VA5KuSypm0tUeoALvHGsB46
	 YrYbWgQjoIfYfAPoTfmLtXFCcGAIailcDuS8Ci3fug3budJfU34rU0m7Opplx9aZoJ
	 eNV6vpksuBN3kFKdIgi3RRnojKbj6cGBA99vqI1revnU1xcyAlkDbcQjd7rbF9vss/
	 KWx0JGEETbjHh5l8t3Dqo6a82F6+MN+BhNi56eykErPZq3YzeYZ6BU1JKSdUA2UdDr
	 87DCsBLxTWhyV6o3z7EM9OE+yj/Zr2ItMFII+BfkrNkVMwsjWMFCJSnNAlkKir/VJo
	 N6kfHoATlHxLQ==
Message-ID: <sashiko-outbox-237357@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Refuse to add a connection to a
 session being closed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rongen Wang" <security@nitrohex.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261127-b4-lio-iscsi-session-closing-v1-1-cdf2bbbef87a@nitrohex.com>
References: <20261127-b4-lio-iscsi-session-closing-v1-1-cdf2bbbef87a@nitrohex.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 12:21:30 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] scsi: target: iscsi: missing Time2Retain check in
  iscsi_post_login_handler()
- [Medium] scsi: target: iscsi: premature param cleanup in
  iscsi_post_login_handler()
--

commit 9055d1b28301fad93aa7addf4bcf0bf18f5835d0
Author: Rongen Wang <security@nitrohex.com>

scsi: target: iscsi: Refuse to add a connection to a session being closed

This commit checks under sess->conn_lock in iscsi_post_login_handler()
whether a session is shutting down before attaching a new non-zero TSIH
connection, and stops the connection's kthreads if the login is refused.

> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/i=
scsi/iscsi_target_login.c
> index fda04eb15d3a2..717628000472f 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c

[ ... ]

> @@ -674,6 +699,32 @@ void iscsi_post_login_handler(
>  		conn->param_list =3D NULL;
> =20
>  		spin_lock_bh(&sess->conn_lock);
> +		/*
> +		 * The session was located from ISID+TSIH when the first Login
> +		 * Request arrived, and since then only the session usage count
> +		 * kept it alive.  If its last connection went away in the
> +		 * meantime, iscsit_close_connection() has already committed to
> +		 * iscsit_close_session(), which frees the session as soon as
> +		 * the usage count is dropped.  Do not attach a new connection
> +		 * to a session that is being shut down.  iscsit_close_connection()
> +		 * makes that decision under sess->conn_lock as well.
> +		 */
> +		if (atomic_read(&sess->session_fall_back_to_erl0) ||
> +		    atomic_read(&sess->session_logout) ||
> +		    atomic_read(&sess->session_close)) {

[Severity: High]
Can a pending non-zero TSIH login still attach to a session that is closing
due to Time2Retain expiry?

When a non-zero TSIH login starts while another connection is still logged =
in
on the session, iscsi_login_non_zero_tsih_s2() sees sess->session_state !=3D
TARG_SESS_STATE_FAILED and leaves sess->session_continuation at 0 while
holding a session usage count.  If the active connection then closes via a
CLOSE_CONNECTION logout (or fails at ErrorRecoveryLevel=3D2),
iscsit_close_connection() does not set session_fall_back_to_erl0,
session_logout, or session_close; instead it moves the session to
TARG_SESS_STATE_FAILED and starts the Time2Retain timer.

When that timer expires, iscsit_time2retain_work() sets ISCSI_TF_EXPIRED un=
der
se_tpg->session_lock (without taking sess->conn_lock) and calls
iscsit_close_session(sess, false):

CPU0 (login worker)               CPU1 (iscsit_time2retain_work)
iscsi_login_non_zero_tsih_s2()
  iscsit_inc_session_usage_count()
  /* session_continuation =3D=3D 0 */
...
/* last active conn closes, Time2Retain starts and expires */
                                  spin_lock_bh(&se_tpg->session_lock)
                                  sess->time2retain_timer_flags |=3D
                                    ISCSI_TF_EXPIRED
                                  spin_unlock_bh(&se_tpg->session_lock)
                                  iscsit_close_session(sess, false)
iscsi_post_login_handler()
  spin_lock_bh(&sess->conn_lock)
  /* fall_back_to_erl0, logout,
   * and close are all 0 */
  list_add_tail(&conn->conn_list,
                &sess->sess_conn_list)
  atomic_inc(&sess->nconn)
  spin_unlock_bh(&sess->conn_lock)
                                    if (atomic_read(&sess->nconn))
                                      BUG();

Depending on the interleaving with iscsit_close_session(sess, false),
iscsit_close_session() either hits BUG() on atomic_read(&sess->nconn), frees
sess after iscsi_post_login_handler() drops session_usage_count (causing the
same use-after-free in iscsit_get_rx_pdu()), or finishes First-stage teardo=
wn
(transport_deregister_session_configfs() and setting session_reinstatement =
=3D
1), sees session_usage_count > 0 in iscsit_check_session_usage_count(sess,
false), and resets session_logout back to 0, allowing the new connection to
attach to a half-closed session that can never be freed.

> +			spin_unlock_bh(&sess->conn_lock);
> +			pr_err("iSCSI session SID %u is shutting down, refusing to add CID %u=
\n",
> +			       sess->sid, conn->cid);
> +			iscsit_dec_conn_usage_count(conn);
> +			return -1;
> +		}

[Severity: Medium]
Does returning -1 here after iscsi_set_session_parameters() and
iscsi_release_param_list() corrupt sess->sess_ops and the failure statistics
in iscsi_target_login_sess_out()?

At the start of the !zero_tsih branch, before taking sess->conn_lock,
iscsi_post_login_handler() modifies sess->sess_ops and frees and clears
conn->param_list.  When this check refuses the login, the caller invokes
iscsi_target_login_sess_out(conn, zero_tsih, true) ->
iscsit_collect_login_stats(), which finds conn->param_list =3D=3D NULL and
overwrites ls->last_intr_fail_name with "Unknown".  Moving
iscsi_set_session_parameters() and iscsi_release_param_list() after the
shutdown check avoids mutating sess->sess_ops on a dying session and lets
iscsi_target_login_sess_out() record the initiator name and free
conn->param_list.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-b4-lio-isc=
si-session-closing-v1-1-cdf2bbbef87a@nitrohex.com?part=3D1
