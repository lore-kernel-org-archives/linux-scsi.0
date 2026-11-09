Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196011;
	b=znJcIOdsdUbyCmJm0sfdPhao4vo+86DtnaO/QlDmCZkoJuOr117x6nRBKotrGmB/PdQy
	 8+3aCsG6+1E4h59OIDGRzxeBlMe+98O78bWueeut71VZmkZpWE/dyB+Sqrm7y8WRzsAIh
	 37tPqH9lEvW5INFjOsdypQvI+Vv+l3xhGRepuyerrI0xHRrnQQsacfmwFvFYcS5lrr7GR
	 04tdTQHgHa8A9QVCMWFxNbOljAE7js11dN2Dtiomo2E9V/mq//ETfVBCVv+8/4At9ckxG
	 7U9lzVzN65HIjpErDzoHtoPH1Q9K5sA6b7oJvAsZ1JCQBJkvpC33RDFq7j08KOCp08Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196011;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BgB5QET9sg/ELwc76MYFHaGW8l1f2bvLx8aXluE4l1k=;
	b=34wjhjPB1/f9iUcbobi/wNRbHHni+4Dtzh4Z2w+VDEz/h35cs1//EqbjsON95VpLqBQO
	 qh03KPoV4ZPKbHU72rcvXAFB0qNjsqRnjvJz5n9in0uuMfkYr205qqRRubs3pDSegrUxJ
	 dpR5qec6NtAyf+KzJTAswbOwu/kVRH9QCzHpxw3viwst5wYIEgsujsPZViVtaPnWQlpjM
	 dMG/bqfsmc7T6DfCFwIkV8OCSQpAbRSy23gSVcDCKumiFEWWAFH8fjom6JmcGZQwUtblW
	 9ozzlU0mfXU5A36iumsWR/XgSaoj2YrDf/HemQvYjg0pnIxuL5g/b1YDb+TtygAQ2lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpTMxGZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F94606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpTMxGZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709A41F0089F;
	Mon,  9 Nov 2026 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196010;
	bh=BgB5QET9sg/ELwc76MYFHaGW8l1f2bvLx8aXluE4l1k=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=MpTMxGZL5f3oTYDcv5AMMRFJsRKoT2IW9HTsYyKoqQ4XYCyx7PJCnCmRh3rrRCI28
	 ztOaBfwKXWZCgvYcfB4XZiNRBHj+1XPdpCd1kkGmlJ+UXNRmgmT3bGsY5RJ3tx64Zs
	 sH41mh2wuAePSpjIbefiqFozvzs1ufJBNEgnt0c9qvx1sw94Jjg+2zUKMC5i9rns7W
	 fJETEVlzQPDr09PvqUhudE44q9phuxs3HUQhG7Wt1ZFx7EZBC8AfaZrHuTTvJi5e45
	 tKt9dqGi2rjzm64EoSbmxhX31QDXrvXBSYbOyRSc84sPAfEeRLJXppbtYELhjLa0HY
	 2HizPcZr4V4CQ==
Message-ID: <sashiko-outbox-204381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: proc: use snprintf() for the host name
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, linux-scsi@vger.kernel.org
In-Reply-To: <20261109113810258gK5WuYWQKt0HsI2ikxmHo@zte.com.cn>
References: <20261109113810258gK5WuYWQKt0HsI2ikxmHo@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 03:46:49 +0000
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
- [Medium] scsi: proc: host_no truncation in scsi_proc_host_add() and
  scsi_proc_host_rm()
--

commit 3f018a4fb0e8a43b35d69140bbb854cdcd245155
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

scsi: proc: use snprintf() for the host name

This commit replaces sprintf() with snprintf() when formatting
shost->host_no into the 10-byte name buffer in scsi_proc_host_add() and
scsi_proc_host_rm().

> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index fdc355d783da3..d1f474c287206 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -230,7 +230,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
>  	if (!e)
>  		goto err;
> =20
> -	sprintf(name,"%d", shost->host_no);
> +	snprintf(name, sizeof(name), "%d", shost->host_no);
>  	p =3D proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
>  			     &proc_scsi_ops, shost);
>  	if (!p)
> @@ -260,7 +260,7 @@ void scsi_proc_host_rm(struct Scsi_Host *shost)
>  	if (!e)
>  		return;
> =20
> -	sprintf(name,"%d", shost->host_no);
> +	snprintf(name, sizeof(name), "%d", shost->host_no);
>  	remove_proc_entry(name, e->proc_dir);
>  }
>  /**

[Severity: Medium]
Does keeping char name[10] still truncate 10-digit shost->host_no values to
9 digits?  Once shost->host_no reaches 10 digits, proc_create_data()
collides with the existing 9-digit procfs entry, and later calling
scsi_proc_host_rm() removes that active host's entry instead.

Formatting a 32-bit int with %d into a 10-byte buffer via an unchecked
snprintf() also triggers -Wformat-truncation warnings under W=3D1 builds.
Sizing name[] to at least 11 bytes and using %u for the unsigned int
shost->host_no avoids both truncation and the compiler warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109113810258gK=
5WuYWQKt0HsI2ikxmHo@zte.com.cn?part=3D1
