Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759498;
	b=HOM3UnU1et6Qh39UGPwp7TNGgJDtoIrC59mABUx+nD9Nk30/us7RonqCsPHSrjkwSC0C
	 x87ETWW6tvOeuJxjsr5hJPbfnsxQVZqmm7VYvDSASxl75W6vI++yUPGZdzQPSpvuqwZCj
	 jyn1GdKgDu/ae2C5n6Oxd9sqn79sNFrCjCu73DM0KfyuDUbJLM/qGqLO/cC3vF4MJcgsx
	 etpYlbMbcTBBuViMTalQnql8hn+YQF/rC/joOQ+uwxPFxLQSG+ro53/tGe7IEg6avI9MV
	 +eYvF1rBP7zmjYFRuDtc0i22Zmxv1wrLDjYRpiCYtNx0GCndzzlD3vPswq/s2gzndhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759498;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8rZ2YzNVQiRnwRcikROPeCGl6R5x5zb65FtvNtgrm/0=;
	b=RTGRlngG9WFMrKiYGAUIO/RLHnVxbqEx5AJx6hDjbKxXtUPY/R7uh/GaeVZhh5EvKZUV
	 sWJt/cpldBu0/z1lZPytq6aT+P2g3QIdHt9E/sVpDbitK/jJyMRQ00JfNvWcbXJ2sbLPd
	 q8WCZV2K4jgxmv/lMkxmAJGBq73LJL+wYzYIWlP+LPLexhNBSLQ1+N+MFxAXGQVWQuLpw
	 muCHmvpzmSzrFRJUo4ZBl5f5oQYngB79aYmiYIorTMe35QBAzamEOVuUNcHz1srZV8u/8
	 gpmCL9lnMfl4alipW+7gsAaCUivBlWsDPiUpd9TdoR7xfjX6jGyYfK7JUmTg3KBLSgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBh18cbn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C049F606A326;
	Wed,  4 Nov 2026 02:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QBh18cbn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A421F000C1;
	Wed,  4 Nov 2026 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759497;
	bh=8rZ2YzNVQiRnwRcikROPeCGl6R5x5zb65FtvNtgrm/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QBh18cbnaMkic88QlVT24I4y4DeB4a5v/NFF6UY0v1f7nEDT3dc4ffV4CZ9XRU0Ea
	 TMBWqjeKK+kO4PcWYYtprIMiZLELW6krtbzFnrXTNhLRs8gHuwuNCmAYGkBVhaCnmJ
	 7AgFKoyl7tqVSKHPOHsmbIL9QLd8uBcWzm7yj7I3l5lpM0yGm6sQgwlyQIjdc/HFDO
	 dxEA6Bbb8Mfe3d/jP9eYM3VEcTmScbU+rcZUC3M/HnOM/n0s6Dmdy9BxK0QampTdMS
	 ZVFPW4qbNAOEzLl+4Evd5JEjzp+khU8oAT9vYFfg0OI+J/YPGPD0IjXfUjIi7Tb6if
	 UHuF/TI76BfbA==
Message-ID: <sashiko-outbox-196478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: cxgbit: drop the cnp reference when the close
 reply never comes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261104021448.1468404-1-vulab@iscas.ac.cn>
References: <20261104021448.1468404-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:31:36 +0000
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
- [Critical] scsi: cxgbit: double cxgbit_put_cnp() and UAF in __cxgbit_free=
_cdev_np()
--

commit 6bb8ef7c81c63dadb738bb34808599917602fb9c
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: cxgbit: drop the cnp reference when the close reply never comes

This commit attempts to fix a reference leak on struct cxgbit_np in
__cxgbit_free_cdev_np() when cxgbit_wait_for_reply() returns an error before
a firmware reply arrives, using completion_done() to check whether
cxgbit_close_listsrv_rpl() already handled the reply and dropped the
reference.

> diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/isc=
si/cxgbit/cxgbit_cm.c
> index 146705845fa3e..91787bca3ff10 100644
> --- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
> +++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
> @@ -558,6 +558,15 @@ __cxgbit_free_cdev_np(struct cxgbit_device *cdev, st=
ruct cxgbit_np *cnp)
> =20
>  	cxgb4_free_stid(cdev->lldi.tids, stid,
>  			cnp->com.local_addr.ss_family);
> +
> +	/*
> +	 * A reply carrying an error status also returns -EIO, but that reply
> +	 * has already dropped the reference taken above.  Only a wait that
> +	 * bailed out before any reply arrived still holds it.
> +	 */
> +	if (ret && !completion_done(&cnp->com.wr_wait.completion))
> +		cxgbit_put_cnp(cnp);

[Severity: Critical]
Does completion_done() work as expected here after
wait_for_completion_timeout() has returned?

When CPL_CLOSE_LISTSRV_RPL arrives with a non-zero status,
cxgbit_close_listsrv_rpl() wakes the waiter and unconditionally drops the
reference taken by __cxgbit_free_cdev_np():

drivers/target/iscsi/cxgbit/cxgbit_cm.c:cxgbit_close_listsrv_rpl() {
	...
	cxgbit_wake_up(&cnp->com.wr_wait, __func__, rpl->status);
	cxgbit_put_cnp(cnp);
}

Inside cxgbit_wake_up(), wr_waitp->ret is set to -EIO and complete()
(rather than complete_all()) increments completion.done from 0 to 1:

drivers/target/iscsi/cxgbit/cxgbit_cm.c:cxgbit_wake_up() {
	if (ret =3D=3D CPL_ERR_NONE)
		wr_waitp->ret =3D 0;
	else
		wr_waitp->ret =3D -EIO;
	...
	complete(&wr_waitp->completion);
}

When wait_for_completion_timeout() in cxgbit_wait_for_reply() wakes up,
do_wait_for_common() consumes that completion by decrementing completion.do=
ne
back to 0 before returning -EIO. Because completion.done is 0 again,
completion_done(&cnp->com.wr_wait.completion) always returns false on this
path.

Wouldn't __cxgbit_free_cdev_np() then call cxgbit_put_cnp(cnp) a second tim=
e,
dropping the caller's reference and freeing cnp before cxgbit_free_np()
accesses cnp->np_accept_lock, drains cnp->np_accept_list, and calls
cxgbit_put_cnp(cnp) again?

Also, if CDEV_STATE_UP is cleared while the CPL_CLOSE_LISTSRV_REQ is already
in flight, cxgbit_wait_for_reply() returns -EIO immediately without waiting.
If cxgbit_close_listsrv_rpl() on another CPU looks up cnp via lookup_stid()
just before cxgb4_free_stid() clears the stid entry, can
__cxgbit_free_cdev_np() observe !completion_done() before
cxgbit_close_listsrv_rpl() reaches complete(), causing both paths to call
cxgbit_put_cnp(cnp) and triggering a use-after-free in
cxgbit_close_listsrv_rpl() and cxgbit_free_np()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104021448.1468=
404-1-vulab@iscas.ac.cn?part=3D1
