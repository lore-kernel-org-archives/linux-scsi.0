Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794734702;
	b=ZijFjPz2DeYlsZLqu4UD9RII+/1Ygw4DjM2PWDVYVaD25oVq4MNjLTTnEfRND5FmgmI7
	 iCpT6FJM7+KVEQjTCRtsDTaxVhAjMM0WfOydXtsWVvdiovGEKnUkHLTelMqmeI6WHy9km
	 xxQVVYFN/6pRuAdCyAItWfYh9XTp1zRBHIFy5IFaZLl/8R6gZ00tzs+/MuurQgs1efVds
	 lJ/BKWsC7COYjNy5Oo50Xc0oV9ZMbeLjxfr7P7BFaTexmNE2gTPu+hcK2vr9p9iLrWiLZ
	 5ThJA0kzdrhWvx0qeFpkglzWumPELwO2LTBbr8DIyjG4UxuDzf3nkG0wB6e01RAqmmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794734702;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eJEyaJ4so1FD1gojUO6ZsyW4LAejAddOKIF/BXRtMqg=;
	b=EcNc2FAqPemTufKixtvepMLpAJBeAR8c/MIYPaMGf7UCqFPFTqSke3gKO7aEO5ca6Vz5
	 BukF02LyAEegRz5KXMdoX5nVu6HUVrYCmbmI8IMxAMhqZ8V0cS6PmN1MAaptYhB68QFNB
	 XZxQck2sZ6LgUkfhG2u/csI7h3CFzB7ubrCzgnBjsKQqfIU2MbXkQzpgDkXTCBduviLsq
	 EQx1tGhFo0JgqEEEbheB3RXmr8P0sBZvcQg0wl+9y8YSA/GCM3SQPcWfr/dfaIYBur72H
	 e6Rz+/IRyUeL5xbS+Ly3XFGnSM35rB8UbbdH4IYnjRceq8Rp6MQ67jf/tBSlpefTUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANtsvDae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C04606A331;
	Sun, 15 Nov 2026 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANtsvDae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0471F000C4;
	Sun, 15 Nov 2026 09:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794734702;
	bh=eJEyaJ4so1FD1gojUO6ZsyW4LAejAddOKIF/BXRtMqg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ANtsvDaeLxyx44lTY5tTbn4vuNYnEduPeRnT6aL1KuLM8pqsEjRGmeoSnKbcvUKho
	 Tyn2XCX+M3q19+O1ti0BGtMNO33MP7sQaisyHCDzBnPyjA/mi7S/JnbdMIiBoqN+BN
	 hJgu6ee9I81LF+1FqhCc1D6/UNn1XxJNgpnsqzxX7hysFClIIpTIoQ6eImAB9n4ila
	 oFQbm82St7TllXMCdPdS9nL9n+cxU1DUk9HDL4PEA6+tn1uLo4kknq+Vuk1/9WA6sZ
	 hkr6CGsPbW9/alMO+G9r86z+fKRw41la3jHrouFgm2VzkReVkpM2q5tYho2wMW3BJ1
	 WafuBDfwNpCUQ==
Message-ID: <sashiko-outbox-215362@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] scsi: target: iscsi: don't attach a connection to a
 closing session
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daniel Wade" <danjwade95@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <3ae0ce68449390d9e3893e5328367c4db3818f96.1794732723.git.danjwade95@gmail.com>
References: <cover.1794732723.git.danjwade95@gmail.com>
 <3ae0ce68449390d9e3893e5328367c4db3818f96.1794732723.git.danjwade95@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 09:25:01 +0000
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
- [High] scsi: target: iscsi: incomplete teardown check in
  iscsi_post_login_handler()
- [Medium] scsi: target: iscsi: premature LOGGED_IN state in
  iscsi_post_login_handler()
--

commit fbb74f9a87b2184ab2a30c73faf991dfc1060e88
Author: Daniel Wade <danjwade95@gmail.com>

scsi: target: iscsi: don't attach a connection to a closing session

This commit sets sess->session_close under sess->conn_lock when the last
connection closes in the ERL=3D0 fallback path and re-checks
sess->session_close in iscsi_post_login_handler() before attaching a
non-leading connection to the session.

> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/i=
scsi/iscsi_target_login.c
> index f4df551817116..de0cd95aff017 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -660,6 +660,33 @@ void iscsit_stop_kthreads(struct iscsit_conn *conn)
>  	spin_unlock(&iscsit_global->ts_bitmap_lock);
>  }
> =20
> +/*
> + * Drop a connection whose kthreads are already running but that must no=
t enter
> + * full feature phase.  conn->sess must not be touched once this returns.
> + */
> +static void iscsi_post_login_fail_conn(struct iscsit_conn *conn)
> +{
> +	/*
> +	 * iscsi_target_tx_thread() only leaves cleanup to this context while
> +	 * conn_state is TARG_CONN_STATE_IN_LOGIN; otherwise it would reach
> +	 * iscsit_close_connection() and walk the session being refused.
> +	 */
> +	conn->conn_state =3D TARG_CONN_STATE_IN_LOGIN;
> +	iscsit_stop_kthreads(conn);
> +	iscsit_dec_conn_usage_count(conn);
> +
> +	if (conn->sock) {
> +		sock_release(conn->sock);
> +		conn->sock =3D NULL;
> +	}
> +	if (conn->conn_transport->iscsit_wait_conn)
> +		conn->conn_transport->iscsit_wait_conn(conn);
> +	if (conn->conn_transport->iscsit_free_conn)
> +		conn->conn_transport->iscsit_free_conn(conn);
> +
> +	iscsit_free_conn(conn);
> +}

[Severity: Medium]
Can setting conn->conn_state =3D TARG_CONN_STATE_LOGGED_IN at the start of
iscsi_post_login_handler() and only resetting it back to
TARG_CONN_STATE_IN_LOGIN here deadlock with conn->tx_thread?

iscsi_post_login_handler() increments conn->conn_usage_count and sets
conn->conn_state =3D TARG_CONN_STATE_LOGGED_IN before taking sess->conn_lock
to check sess->session_close:

drivers/target/iscsi/iscsi_target_login.c:iscsi_post_login_handler() {
	iscsit_inc_conn_usage_count(conn);

	iscsit_collect_login_stats(conn, ISCSI_STATUS_CLS_SUCCESS,
			ISCSI_LOGIN_STATUS_ACCEPT);

	pr_debug("Moving to TARG_CONN_STATE_LOGGED_IN.\n");
	conn->conn_state =3D TARG_CONN_STATE_LOGGED_IN;

	iscsi_set_connection_parameters(conn->conn_ops, conn->param_list);
	/*
	 * SCSI Initiator -> SCSI Target Port Mapping
	 */
	if (!zero_tsih) {
		iscsi_set_session_parameters(sess->sess_ops,
				conn->param_list, 0);
}

If an asynchronous transport disconnect sends SIGINT to conn->tx_thread
during that window (for example via isert_disconnected_handler() ->
iscsit_cause_connection_reinstatement()), tx_thread sees conn_state !=3D
TARG_CONN_STATE_IN_LOGIN and enters iscsit_close_connection() on the
unattached connection:

CPU0 (login worker)               CPU1 (conn->tx_thread)
iscsi_post_login_handler()
  iscsit_inc_conn_usage_count()
  conn->conn_state =3D
    TARG_CONN_STATE_LOGGED_IN
                                  iscsi_target_tx_thread()
                                    if (conn_state !=3D
                                        TARG_CONN_STATE_IN_LOGIN)
                                      iscsit_take_action_...()
                                        iscsit_close_connection()
                                          iscsit_check_conn_usage_count()
                                            wait_for_completion()
  iscsi_post_login_fail_conn()
    conn->conn_state =3D
      TARG_CONN_STATE_IN_LOGIN
    iscsit_stop_kthreads()
      kthread_stop(tx_thread)  <-- deadlocks waiting for tx_thread
    iscsit_dec_conn_usage_count()

In addition, iscsi_set_session_parameters() mutates sess->sess_ops and
iscsit_collect_login_stats() records an accepted login before the session
is checked under sess->conn_lock.  Checking whether the session is closing
before transitioning conn->conn_state or mutating session state would
avoid this window.

>  void iscsi_post_login_handler(
>  	struct iscsi_np *np,
>  	struct iscsit_conn *conn,
> @@ -690,6 +717,20 @@ void iscsi_post_login_handler(
>  		conn->param_list =3D NULL;
> =20
>  		spin_lock_bh(&sess->conn_lock);
> +		/*
> +		 * The skip filter in iscsi_login_non_zero_tsih_s2() sampled this
> +		 * before the negotiation.  Re-test under the lock that serialises
> +		 * against the ->nconn test in iscsit_close_connection().
> +		 */
> +		if (atomic_read(&sess->session_close)) {
> +			spin_unlock_bh(&sess->conn_lock);
> +			pr_err("iSCSI session is closing, failing login on CID: %u\n",
> +			       conn->cid);
> +			iscsi_post_login_fail_conn(conn);
> +			/* Last access to @sess: this lets close_session() free it. */
> +			iscsit_dec_session_usage_count(sess);
> +			return;
> +		}
>  		atomic_set(&sess->session_continuation, 0);
>  		if (sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
>  			pr_debug("Moving to"

[Severity: High]
Does checking only sess->session_close here still allow a non-leading
connection to attach to a session that is already tearing down?

iscsi_login_non_zero_tsih_s2() skips sessions that have any of
session_fall_back_to_erl0, session_logout, session_close or
ISCSI_TF_EXPIRED set, but iscsi_post_login_handler() only re-checks
session_close, and iscsit_close_connection() only sets session_close when
sess->nconn reaches 0 in the ERL=3D0 fallback branch.

For example, if a session has one active connection (conn1) when conn2
passes iscsi_login_non_zero_tsih_s2(), sess->session_state is
TARG_SESS_STATE_LOGGED_IN, so sess->session_continuation remains 0 while
conn2 negotiates holding session_usage_count.  If conn1 then closes via a
connection logout (or ERL=3D2 failure) and the Time2Retain timer expires,
iscsit_handle_time2retain_timeout() sets ISCSI_TF_EXPIRED and calls
iscsit_close_session(sess, false) without setting sess->session_close:

CPU0 (conn1 / timer)              CPU1 (conn2 login)
iscsit_close_connection(conn1)
  sess->session_state =3D
    TARG_SESS_STATE_FAILED
  iscsit_start_time2retain_...()
<softirq>
  iscsit_handle_time2retain_...()
    sess->time2retain_timer_flags |=3D
      ISCSI_TF_EXPIRED
    iscsit_close_session(sess, false)
                                  iscsi_post_login_handler(conn2)
                                    spin_lock_bh(&sess->conn_lock)
                                    atomic_read(&sess->session_close) =3D=
=3D 0
                                    list_add_tail(&conn2->conn_list, ...)
                                    atomic_inc(&sess->nconn)
                                    spin_unlock_bh(&sess->conn_lock)
      if (atomic_read(&sess->nconn))
        BUG()  <-- kernel panic (or kfree(sess) if past the nconn check)

Similarly, in a multi-connection session (nconn =3D=3D 2) falling back to
ERL=3D0, when the first connection closes it sets session_fall_back_to_erl0
and session_stop_active under sess->conn_lock without setting
session_close, and calls iscsit_stop_session().  If conn2 attaches in
iscsi_post_login_handler() before the second connection takes
sess->conn_lock in iscsit_close_connection(), the second connection
decrements nconn from 2 to 1, sees session_stop_active is already 1 and
returns early:

drivers/target/iscsi/iscsi_target.c:iscsit_close_connection() {
	if (atomic_read(&sess->nconn)) {
		if (!atomic_read(&sess->session_reinstatement) &&
		    !atomic_read(&sess->session_fall_back_to_erl0)) {
			spin_unlock_bh(&sess->conn_lock);
			return 0;
		}
		if (!atomic_read(&sess->session_stop_active)) {
			atomic_set(&sess->session_stop_active, 1);
			spin_unlock_bh(&sess->conn_lock);
			iscsit_stop_session(sess, 0, 0);
			return 0;
		}
		spin_unlock_bh(&sess->conn_lock);
		return 0;
	}
}

That leaves conn2 stranded on a session with session_fall_back_to_erl0
set, which iscsit_release_sessions_for_tpg() and lio_tpg_close_session()
both skip during TPG teardown.  A CLOSESESSION logout also sets
sess->session_logout under sess->conn_lock in iscsit_logout_closesession()
before sess->session_close is set in
iscsit_logout_post_handler_closesession().

Re-checking the full teardown condition (session_close,
session_fall_back_to_erl0, session_logout, and ISCSI_TF_EXPIRED under
se_tpg->session_lock) in iscsi_post_login_handler() would close these
windows as well.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794732723.gi=
t.danjwade95@gmail.com?part=3D2
