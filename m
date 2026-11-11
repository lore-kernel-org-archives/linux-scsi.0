Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409171;
	b=jOnfSOxyh5onXHCJhScZoJLkavGU8+S5JKfcVkOOLlp2Bw8OThgGMNX4t51pPzfZVG9I
	 L8j2I7crUx7/7fxDJSDUZBbLsbQm8VY6cQEHlWl+WKak51c0nfUmdYlFeJfb/5v+pIEV5
	 tFK9GEuYMMPFL+atWQ9hwlTam95x2VNVpqDSqTRVd3hp6w3lkDGbV7wB5q+ybsjs/ZvmA
	 X/LU1fDllJCfNDb6BoZVC8a2sUcPc6DNYT/t8LpRYkFPe5yXoj3vmcvX6YXL/IqVrPpof
	 Hpo2KZaIBFQBG7pbmWcAFy852LVEmZSMhtk13WfxFW6P0dkTEJrwZTCYl5EhQHU8QLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409171;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J2NaWGJ0wvvwiWu1IEV9ZvmpEEt43mEP+GR6BSBmiBc=;
	b=SlxyV3HXj8wc5m+JJLMGEZxOKvgn+brpl2QvczjA4w9LcH8AehtLAurQ3srbsnF4wG9j
	 J6QkjMoHMSxMSY/5l9XASqrW/SD4nRMx3SkuaGhSp9PpjAzinYoLdcxi8nOjr8kzssKKQ
	 XfF2uFYrVMP9srkZ1GzpS52EY4nmaqA1BqSc1oY8T7gFI1htxLLQX3+u3a8j7dhe6LMH2
	 fMQn1UvJdN/IHy9PJI2HBqYhtcYSDzIBcpvlEeaojhE6Ppw1df6PmvdTbicBTSpfo9nyQ
	 /7r7FP0y8K/A2e3kJP2EShygX8Owt8P/FFG4bTsxNOdjjXrbodMMUo7KiTr2iYkrRgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJng3xyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F7B606A32A;
	Wed, 11 Nov 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJng3xyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC71F00A05;
	Wed, 11 Nov 2026 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794409171;
	bh=J2NaWGJ0wvvwiWu1IEV9ZvmpEEt43mEP+GR6BSBmiBc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nJng3xyO1tiZAdt5zftMGaW/g3b7hnrmhpfTWVup0mBIGiuqFxNDnGlZCI46+rlvO
	 0M3RaaMiyuYRzr4q+jKcM0k1vK+2rBXTCJGmNn0Sp7z9WyYCdQjEqmHH8/fXj8E5by
	 w4LrbQvldx7NRGxurQShgOpBxF4MaBklr7CR/loYUCBRE1IrzebSXLIcOsNy+Fr66l
	 xNcaebqZ/9nozK9XquoJFO4HZYUrvmmShgGMsRY/bvOlFEYWyEOHdwDBTlgeaff/N5
	 rE4Tf+asJqiiTwIdx0WV9TQ2OmSmoNv3F5NMW3tmidynSUB3ghT5eMx3Cn89+y1bYC
	 ziPxXep0JbwnA==
Message-ID: <sashiko-outbox-209207@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: sg: Require CAP_SYS_ADMIN for BLKTRACE
 passthrough ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tao Cui" <cui.tao@linux.dev>
Cc: linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261111145034.248717-3-cui.tao@linux.dev>
References: <20261111145034.248717-1-cui.tao@linux.dev>
 <20261111145034.248717-3-cui.tao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 14:59:30 +0000
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
- [Low] scsi: sg: duplicate BLKTRACE ioctl command check in
  sg_ioctl_common()
--

commit 245abdd71d86c36b043cbaf6080f0c6a16895527
Author: Tao Cui <cuitao@kylinos.cn>

scsi: sg: Require CAP_SYS_ADMIN for BLKTRACE passthrough ioctls

This commit requires CAP_SYS_ADMIN in sg_ioctl_common() before handling
the four blktrace passthrough ioctl commands.

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e6c01..36a1fb7343607 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -910,6 +910,13 @@ static int put_compat_request_table(struct compat_sg=
_req_info __user *o,
>  }
>  #endif
> =20
> +/* keep in sync with the commands blk_trace_ioctl() gates */
> +static bool sg_is_blktrace_cmd(unsigned int cmd)
> +{
> +	return cmd =3D=3D BLKTRACESETUP || cmd =3D=3D BLKTRACESTART ||
> +	       cmd =3D=3D BLKTRACESTOP || cmd =3D=3D BLKTRACETEARDOWN;
> +}
> +
>  static long
>  sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>  		unsigned int cmd_in, void __user *p)
> @@ -921,6 +928,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg=
_fd *sfp,
> =20
>  	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>  				   "sg_ioctl: cmd=3D0x%x\n", (int) cmd_in));
> +	if (IS_ENABLED(CONFIG_BLK_DEV_IO_TRACE) &&
> +	    sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;

[Severity: Low]
This isn't a bug, but sg_ioctl_common() already matches BLKTRACESETUP,
BLKTRACESTART, BLKTRACESTOP, and BLKTRACETEARDOWN in switch (cmd_in)
immediately below.  Checking sg_is_blktrace_cmd() before the switch
duplicates the four command constants and runs up to four extra comparisons
on every ioctl call, including the SG_IO path.  Could the capability check
be done inside the existing blktrace switch cases instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111145034.2487=
17-1-cui.tao@linux.dev?part=3D2
