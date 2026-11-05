Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908698;
	b=C/S2IS8f93iGDzJpsuOwOOF3JrcNjY3s+ktiigixRUKHV7XT3JDum2WuBjyZ2F2NnD8B
	 U4QuEYtwixTImktkmDp5+0k6y6VB8P729SMAAnLrAV5q4/TEHoSL9SVhlpc57Sa0TwMC5
	 1JVCvRINRkBCF16eLbXoxaFfOunfl6lWdP7q1DiIpmeF/cUA4EOTHsrCfo+V4wWebegL8
	 i8Vlaem6/7/MaRrXMIDRJqMBO1L4+2qcm46DZhgpyb5xL+su6KjcB7oY5NBzeW6vFqKBL
	 ssclA0HhQu2B8+d2HLuedU9lDth01Y99fC0Hv9u7MW2sbs9JFOlXVGrG8w27kCAXxkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908698;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Di4Zv2+bgkX+HhZmCpdKbhvfGlZoAaFGwpTTtNZDf1w=;
	b=i5tzjQcgsuqMsSCQTJHoFpbqLoNVVO74kdGqgDtWP8l4sHNpGkcNVRKtU44uz9qgdsks
	 vWah2q0RtiHy+cPTIAkkABT8FxSuPgdZNzz1UGVBa4ZxqXb/VbzkIr8lV3T+FWpf59gis
	 uUSlNz8UbVBB2j4xjj81OaLcHiI914spWBwDRbhrVLZqAEYhRUxQN5KmxLBrPdYxb66u3
	 D4s5Kr0WdtJ3N7kNo7uY7/J2tu617I3Qh/N2O5ott1xCJnCSOBmf1cntMcZLEyFJ6t+y4
	 hTOQrWEbdqG1GusB6tHlo/hO/GuSuFV2WgeqFyZ4DqQr0tYW5AXdcFtFpkibWVC05Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PS7EuTM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6997606A6D9;
	Thu,  5 Nov 2026 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PS7EuTM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4B01F008A2;
	Thu,  5 Nov 2026 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908697;
	bh=Di4Zv2+bgkX+HhZmCpdKbhvfGlZoAaFGwpTTtNZDf1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PS7EuTM4dqldTrwdAR0onQbkCjogqgjpUy8oBN5Oi/jsHPd1HPHlgSGbxScX7TULM
	 hRB6vR+pRSsaVGMqkA0T2yAO/9EP8dfTHiI3smO+XSdOQTs0WaU0CSspRWwNIygWmH
	 xxyaJ/jl5nVv4oGCeueAnyoM+i/SNOz1yePgzX6SBUyU7ID4QMKKDqnCau9Fzxv22l
	 9yUUQnAUlAQfxJYnkuFIsPSnTWbDHjOSLzPYjAQnKTCY8vnyzOnX2r4MnJUC80Xsxq
	 9G6Oxyszcx5C+PQB+DFxzoyTPD+CIGBL43AvNqSOHfSpIHjw0LBt6ISDjfycxH6Ryo
	 K9q3hUiMFf+cA==
Message-ID: <sashiko-outbox-200057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 23/30] dyndbg: let procfs copy in writes to
 /proc/dynamic_debug/control
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-fs-v2-23-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-23-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:14 +0000
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
- [Low] dyndbg: split declaration and assignment of __free() in ddebug_proc=
_write()
--

commit 1bfaabab91de2989a4d10ae03eef349ab77809d6
Author: Christian Brauner <brauner@kernel.org>

dyndbg: let procfs copy in writes to /proc/dynamic_debug/control

This commit factors the query execution logic out of ddebug_proc_write() in=
to
ddebug_proc_write_buf() and switches proc_fops to use .proc_write_buf and
.proc_write_size so procfs copies in the user buffer before pinning the ent=
ry.

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 64a2112908725..1d6012c9eb41f 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -1002,11 +1002,28 @@ __setup("dyndbg=3D", dyndbg_setup);

[ ... ]

>  static ssize_t ddebug_proc_write(struct file *file, const char __user *u=
buf,
>  				  size_t len, loff_t *offp)
>  {
> -	char *tmpbuf;
> -	int ret;
> +	char *tmpbuf __free(kfree) =3D NULL;
> =20
>  	if (len =3D=3D 0)
>  		return 0;
> @@ -1017,15 +1034,7 @@ static ssize_t ddebug_proc_write(struct file *file=
, const char __user *ubuf,
>  	tmpbuf =3D memdup_user_nul(ubuf, len);
>  	if (IS_ERR(tmpbuf))
>  		return PTR_ERR(tmpbuf);
> -	v2pr_info("read %zu bytes from userspace\n", len);
> -
> -	ret =3D ddebug_exec_queries(tmpbuf, NULL);
> -	kfree(tmpbuf);
> -	if (ret < 0)
> -		return ret;
> -
> -	*offp +=3D len;
> -	return len;
> +	return ddebug_proc_write_buf(file, tmpbuf, len, offp);
>  }

[Severity: Low]
In ddebug_proc_write(), tmpbuf is declared with __free(kfree) =3D NULL at t=
he
top of the function before the early length checks and then assigned later =
via
memdup_user_nul().

Per the cleanup.h guidelines, could tmpbuf be defined and initialized in a
single statement at the allocation site instead:

	char *tmpbuf __free(kfree) =3D memdup_user_nul(ubuf, len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D23
