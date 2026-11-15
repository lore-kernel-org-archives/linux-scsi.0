Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794740365;
	b=iHeuxtRI/VMaHK2JinsJ7z6ei1/5lc8Ytzzts8J2dJbRHBaRJCFsCv4EyJEgiIrLFj8i
	 oVpWYlCgKGmN8IeYUTEY9eONa4nVG1YhaUJjDUgJnY8zfopZOLOeRVvkWJJFtAduylUAJ
	 CP5UXldjQe+Yv+BdqmGF6D0AlIa9lp4HvrarozNHZ60FAcJpKlZQmmqZ46zMQw2UlVRc7
	 e+7V19/srKY2R1GRkCd7O0qU35iTEYwZYR6FoICDaDUF0f4CgfegpkBze7J/j40jw7ysK
	 HLsGAp3k+Vmnifb+cSThGANZ4r2WJ+6kuxJc29sHW40wPbe/TmAe+/0UGpCa7OmX4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794740365;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vnMs5C/7Cd7Ng4umrmXPnRjthSwxlCZILIhiKLaE73I=;
	b=GggAKshvUtnSBqhUw3T6sTg841yzNBDEx7BgDAZ63MRINBPlxVosaBNTBN8mCB8BZJZW
	 N/1VqJvVvLsS8PgVhSbGddy82yqi8ec0GoiDOSjI/bPeIVywxOUdJq/6nPE6tnqHC3jvx
	 IM3dCyIx66f331TM5jdXCSPzIYaCp/cycLwMPswiRZ3BB5g+u+hPIBNaAsSZmddjZfBQ3
	 IcBZjkQxoQHw6xqfyd+J+qJlIKk3z9xwbg4/DeKO+XSOtgBlX7ME+cxIV02KBTVRjabLR
	 h97B82yC+hH3lAGishza9ftD/7nwTYbh2Q6kVD5mXNMrwN/psF6+B6Y3ONWpFK3YAUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqksMTn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909AA606A31A;
	Sun, 15 Nov 2026 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OqksMTn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEABC1F000C5;
	Sun, 15 Nov 2026 10:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794740365;
	bh=vnMs5C/7Cd7Ng4umrmXPnRjthSwxlCZILIhiKLaE73I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OqksMTn0u0lys2OYtDM8IBowEJOH9uiS2JwsgplA+jN5namzKQkHliuEF06lM/Dw5
	 H6Nj8TN8Eqfk/zbIKbWZZGvU5yBJXNkipYiXRzwyeM7uOAHWu2XCu/iL4u0CKOu1Mb
	 t51e2BdXw+RNbZeZNh8QPCwv7uR3DiS4/TbNMcWgDOcaiaErwjVAW4ygvgI8dcJ7Gf
	 nt93npIfGwEiLHiTxuOA0mg6IjNFZ0v8RA060huYgdAnlfbl2NKKQA2ouHnjK/hZ9Y
	 bvT2iKTPXeca+WNrR7CK7s1bH5vvQPhQEYfG0eOcxxe3PUxeHlmdLnlk+SYlecNmyP
	 4K04jK3cmEcDA==
Message-ID: <sashiko-outbox-215433@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: target: iscsi: don't attach a connection
 to a closing session
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daniel Wade" <danjwade95@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <35c3a401f78f153f5f36cec7072c83da11902664.1794739041.git.danjwade95@gmail.com>
References: <cover.1794739041.git.danjwade95@gmail.com>
 <35c3a401f78f153f5f36cec7072c83da11902664.1794739041.git.danjwade95@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 10:59:24 +0000
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
- [Medium] scsi: target: iscsi: session leak when login fails on
  ISCSI_TF_EXPIRED
--

commit 2ec69a848adc6f1dace5f53e352fe2730d42d6f2
Author: Daniel Wade <danjwade95@gmail.com>

scsi: target: iscsi: don't attach a connection to a closing session

This commit prevents a non-leading iSCSI login from attaching a connection
to a session that began closing while the login was negotiating.

> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/i=
scsi/iscsi_target_login.c
> index f4df551817116..556ae5d2d501b 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c

[ ... ]

> @@ -689,7 +713,28 @@ void iscsi_post_login_handler(
>  		iscsi_release_param_list(conn->param_list);
>  		conn->param_list =3D NULL;
> =20
> +		spin_lock_bh(&se_tpg->session_lock);
>  		spin_lock_bh(&sess->conn_lock);
> +		/*
> +		 * iscsi_login_non_zero_tsih_s2() sampled these before the
> +		 * negotiation and never looked again.  Re-test all of them under
> +		 * the lock that serialises against the ->nconn test in
> +		 * iscsit_close_connection(), and before this connection reaches
> +		 * sess_conn_list or TARG_CONN_STATE_LOGGED_IN.
> +		 */
> +		if (atomic_read(&sess->session_close) ||
> +		    atomic_read(&sess->session_fall_back_to_erl0) ||
> +		    atomic_read(&sess->session_logout) ||
> +		    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
> +			spin_unlock_bh(&sess->conn_lock);
> +			spin_unlock_bh(&se_tpg->session_lock);
> +			pr_err("iSCSI session is closing, failing login on CID: %u\n",
> +			       conn->cid);
> +			iscsi_post_login_fail_conn(conn);
> +			/* Last access to @sess: this lets close_session() free it. */
> +			iscsit_dec_session_usage_count(sess);
> +			return;
> +		}

[Severity: Medium]
Does this leak sess when the login is refused because ISCSI_TF_EXPIRED is
set?

When the Time2Retain timer expires while the negotiating login holds
sess->session_usage_count, iscsit_handle_time2retain_timeout() sets
ISCSI_TF_EXPIRED without clearing ISCSI_TF_RUNNING and calls
iscsit_close_session(sess, false) in timer context.  Because can_sleep is
false, iscsit_check_session_usage_count() does not wait for the login to
drop its reference:

drivers/target/iscsi/iscsi_target.c:iscsit_close_session() {
    ...
	if (iscsit_check_session_usage_count(sess, can_sleep)) {
		atomic_set(&sess->session_logout, 0);
		iscsit_start_time2retain_handler(sess);
		return 0;
	}
    ...
}

iscsit_start_time2retain_handler() then returns early without re-arming
the timer because ISCSI_TF_RUNNING is still set
(iscsit_stop_time2retain_timer() bails out when ISCSI_TF_EXPIRED is set),
and sess->session_reinstatement also remains set.  When
iscsi_post_login_handler() later sees ISCSI_TF_EXPIRED and drops
sess->session_usage_count, iscsit_close_session() has already returned and
nothing ever closes or frees sess.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794739041.gi=
t.danjwade95@gmail.com?part=3D2
