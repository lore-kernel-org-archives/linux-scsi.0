Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795788459;
	b=lxIDBbqcMmzc8KkIrnCiPlHCwxyXyGXnWiUhnccbz/ndSVG3Hq/YN132+JPjXlEmFECO
	 KdV0NoyuxBcYqzJeHmkLvCRpCK0ea0UqXdLAYR1FUUk5yl0Oz0gQJUSrewvyCMjqsKj65
	 Iky4h+zfnxWmqAkvRjn37sbr4JDSDQIC0AQN0UisISkxZct+fwMVSYu2eVlw+R9A8i3dz
	 j7nllGtVdHXtVLGVy4m040NyP2MkWO0r5+AxVxgrG+TdXy5xzMoaHjmIYm/b8lDPSRHL3
	 PPJgXEcJkPWAy48R0ZHXFz9HXQ2uQWpvqV69oU+4Zc2+sXpBjUxO8t9KxomIM+Tu2HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795788459;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GfalxYdrCNmpT0qq3k+/iT/VmgyrZXmJE8lDYdo5Ia4=;
	b=Vyyz1n+2iNIrv8cxHwowwiXTS6aUuv8jbuw8bygMsj05bMa+dsQosGvycG2j/jXBBmdb
	 bMu2KSMGYLuYUNmk29q93JzuPn3wjJNcECRKWh1SVq/OB26eGj09Bw+UBjAH3LvBMgHnd
	 2AeY5xyyQWA2wx3mYzr6kCSHg2HySSf1Emd6JZJ6/PXvhq1b6P68P7LtXZ4P2rmV/Jpip
	 hfXKB+7WS6Oo8NPUGxCZ1kcTOmBcW8VZ3Ouk3d9FkPx0ckugoXyYXyW/S6gOTxlDEN6HY
	 31kD3LTXBu+HRGoaOiQN0fqLyaTtIfGPBywKO+lZc3Alx1oLJ0VEI1rxfeW5XnnMo2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEnw+vvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C1F606A31C;
	Fri, 27 Nov 2026 14:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEnw+vvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4631F0181E;
	Fri, 27 Nov 2026 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795788458;
	bh=GfalxYdrCNmpT0qq3k+/iT/VmgyrZXmJE8lDYdo5Ia4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VEnw+vvTgoEJmMrU1GK00ohwOewwB/Zr63++3rdfwgFxoWzoNsYCdbgeZUurgI7m0
	 KBSGJDlmRBXyVt0AlaaHRrI26pqEGIq141nFLFeJKkDFXogBtwiVQCJ9JmLOH3BJh9
	 YbzSTFAcyNSlpWfd+pyv/kvIkoa64/y2SSqx8Wo6IVcyW/jcef28Pexre2BofAV98f
	 iq6ueISG5ghjT/CzUIGfEH1+H/dRt0xZzyxK10bOjP+10JGZCAaWQ73Qz22Yj1UAD7
	 IRe51WOEHFMvEQM/VtTfo+aaR3DXDacaitEn6yZRb9jH8P2VCdOyi/PQSqvjv/2OpJ
	 VPHAOMSbSYQmw==
Message-ID: <sashiko-outbox-237532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: target: iscsi: Do not let Time2Retain
 expire a session in use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rongen Wang" <security@nitrohex.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261127-b4-lio-iscsi-session-closing-v2-2-a3ac8e88cbad@nitrohex.com>
References: <20261127-b4-lio-iscsi-session-closing-v2-0-a3ac8e88cbad@nitrohex.com>
 <20261127-b4-lio-iscsi-session-closing-v2-2-a3ac8e88cbad@nitrohex.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:07:38 +0000
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
- [Medium] scsi: target: iscsi: Time2Retain timer race in
  iscsi_target_login_sess_out()
--

commit 98654cdef0969ffe654a76bd2db16a5343a38c0a
Author: Rongen Wang <security@nitrohex.com>

scsi: target: iscsi: Do not let Time2Retain expire a session in use

This commit defers Time2Retain session expiry in iscsit_time2retain_work()
when session_usage_count is non-zero, clearing ISCSI_TF_RUNNING so an
in-progress login can either stop or restart the timer when it finishes.

> diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/is=
csi/iscsi_target_erl0.c
> index 036ddc1002f6c..35e2eed11750d 100644
> --- a/drivers/target/iscsi/iscsi_target_erl0.c
> +++ b/drivers/target/iscsi/iscsi_target_erl0.c
> @@ -747,6 +747,7 @@ void iscsit_time2retain_work(struct work_struct *work)
>  						   time2retain_work);
>  	struct iscsi_portal_group *tpg =3D sess->tpg;
>  	struct se_portal_group *se_tpg =3D &tpg->tpg_se_tpg;
> +	bool in_use;
> =20
>  	spin_lock_bh(&se_tpg->session_lock);
>  	/* A stop after the timer fired takes ->time2retain_fired back. */
> @@ -761,6 +762,26 @@ void iscsit_time2retain_work(struct work_struct *wor=
k)
>  		spin_unlock_bh(&se_tpg->session_lock);
>  		return;
>  	}
> +	/*
> +	 * A login that adds a connection to this session holds a usage count
> +	 * from iscsi_login_non_zero_tsih_s2() until it completes.  It started
> +	 * before the session failed, so there was no timer for it to stop.
> +	 * Handle it like a login into a failed session: leave the session
> +	 * alone, and let the login stop the timer if it succeeds or start it
> +	 * again in iscsi_target_login_sess_out() if it fails.  Expiring the
> +	 * session now would make iscsit_close_session() find the usage count
> +	 * and give up half way, after which nothing frees the session.
> +	 */
> +	spin_lock(&sess->session_usage_lock);
> +	in_use =3D sess->session_usage_count !=3D 0;
> +	spin_unlock(&sess->session_usage_lock);
> +	if (in_use) {
> +		pr_debug("Time2Retain timer for SID: %u expired during a login, deferr=
ing\n",
> +			 sess->sid);
> +		sess->time2retain_timer_flags &=3D ~ISCSI_TF_RUNNING;
> +		spin_unlock_bh(&se_tpg->session_lock);
> +		return;
> +	}

[Severity: Medium]
Can this still leak the session when a failing login in
iscsi_target_login_sess_out() races with Time2Retain expiration?

drivers/target/iscsi/iscsi_target_login.c:iscsi_target_login_sess_out() {
    ...
	if (!zero_tsih && conn->sess) {
		spin_lock_bh(&conn->sess->conn_lock);
		if (conn->sess->session_state =3D=3D TARG_SESS_STATE_FAILED) {
			struct se_portal_group *se_tpg =3D
					&conn->tpg->tpg_se_tpg;

			atomic_set(&conn->sess->session_continuation, 0);
			spin_unlock_bh(&conn->sess->conn_lock);
			spin_lock_bh(&se_tpg->session_lock);
			iscsit_start_time2retain_handler(conn->sess);
			spin_unlock_bh(&se_tpg->session_lock);
		} else
			spin_unlock_bh(&conn->sess->conn_lock);
		iscsit_dec_session_usage_count(conn->sess);
	}
    ...
}

Because iscsi_target_login_sess_out() restarts the timer and drops
se_tpg->session_lock before it decrements session_usage_count, both sides
can defer to each other after the timer fires in softirq:

CPU0                                     CPU1 (kworker)
iscsit_handle_time2retain_timeout()
  atomic_set(&sess->time2retain_fired, 1)
  schedule_work(&sess->time2retain_work)
iscsi_target_login_sess_out()
  spin_lock_bh(&se_tpg->session_lock)
  iscsit_start_time2retain_handler(sess)
    /* ISCSI_TF_RUNNING is still set, returns early */
  spin_unlock_bh(&se_tpg->session_lock)
                                         iscsit_time2retain_work()
                                           spin_lock_bh(&se_tpg->session_lo=
ck)
                                           /* session_usage_count !=3D 0 */
                                           sess->time2retain_timer_flags &=
=3D
                                                   ~ISCSI_TF_RUNNING
                                           spin_unlock_bh(&se_tpg->session_=
lock)
                                           return;
  iscsit_dec_session_usage_count(sess)
  /* session left failed with no timer running <-- leak */

The same thing happens if iscsit_time2retain_work() runs first and clears
ISCSI_TF_RUNNING, and the timer restarted by iscsi_target_login_sess_out()
fires again (for example when DefaultTime2Retain is 0) before
iscsit_dec_session_usage_count() runs, or if the last connection fails
right after iscsi_target_login_sess_out() checks session_state and its
timer expires before session_usage_count is decremented.  In each case
the session stays in TARG_SESS_STATE_FAILED with no connections and no
active Time2Retain timer, leaking struct iscsit_session, struct se_session
and the command tag pool.

Decrementing session_usage_count before restarting the Time2Retain timer
(or while holding se_tpg->session_lock across both the decrement and
iscsit_start_time2retain_handler()) would close this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-b4-lio-isc=
si-session-closing-v2-0-a3ac8e88cbad@nitrohex.com?part=3D2
