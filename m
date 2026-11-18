Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998310;
	b=PApL6sftQKwdmbhNS8VXNafY1rmWIQ0SQKMOgb7YouVEPPzHzCYufHFaCe9mIdllvoz0
	 W1jogDh1vZG71aCJigcHcA8Go5IVtZZdVYHspEDzQJ5EBjtW335EPzZ1NLN4Z39ncZgfC
	 PjpXKvk6rp0gcmnnlebuXcTtk3UNcPKho9Md9Lz33c/XEY8BfnuNGm1g4IRhIYRxmMXUm
	 a0K6TQhJ9padwklwQnMeMPyVCVsPufPDMPuLGMHURgKCTO8DKh7rBcl1hYFsb3agUF/y7
	 qUdiLde/rSpU1JkSCFmgdsWFzktZ+hvsERAGEOPKXv8s7Htq7WUn90JsY0mTVfjxZ4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998310;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Of1osJO34tnQCsuiW/mm+Hj1OBNOLnPlasPXI8pUGNE=;
	b=UgQv/oBElQUIcI29XM4kDYV99PMR0dj478jAwdqVS51w4keMGinHJXuGWEzBTw6NEpQO
	 7hRKKcIA8rh2irTms1o2WRc0VxqZ8CliovSIyrszo8Eltq1Cdd5IzR1HfjFJFiy758rnV
	 2NtgzVKB+Ove9NhRQyKE1dwdYMa+r9dwcLu4sxYgUOyE8zaEUCOGor2JSe19jYl0HrWLN
	 UaJSmIGg9eKhum4Eoafm0gBnH2f8YfYz9G/29/KWh8R5IQcKzpQy0s/CWtU/vqnjD8GvI
	 rDEzOAYpuIyVzvdZ/7Mzm5ncWX/cnha5ZwQ/DruvN7gCgRA+asf80Ky/gemMR0NSXsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2uL5ihe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5B3606A330
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2uL5ihe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A161F000C4;
	Wed, 18 Nov 2026 10:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998310;
	bh=Of1osJO34tnQCsuiW/mm+Hj1OBNOLnPlasPXI8pUGNE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=n2uL5iher7kYqhnS2Zf5M7wO37A+VuxvjIbg7SOPgOqfjdRnMf860OGMbyGns4UIN
	 tZH1X2aiMcD+WgJApjDD7Xkd8YAXXzmCuEk39knGQw0pM5eubetysxqWtqAwkzq82Z
	 5lDJ61U2kcJ6JntjmJzMSL2lT5NzNwRGpXJ5FycpqTeGCvV/2ZAfvxNT66xS7mrA+k
	 tJY4XghvvdbnxsoxaiBs5bPUvd0OqgEeOkGA9/dyDfvd/B+pU2smh7b/MgywvCXw1C
	 fY/eLEaa/eCbs5zPZimmFn5K3yUdKQLE/hA6QCdNQt7aZGzkp/8mxV7jYSrt7PUSf8
	 kAuqt1N0jeT1Q==
Message-ID: <sashiko-outbox-220721@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/37] scsi: mpt3sas: Restrict ioc_dump debugfs and
 replace raw ioc dump with text
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:38:29 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for ioc_dump debugfs fix
- [Low] scsi: mpt3sas: inaccurate leak fix claim in
  _debugfs_iocdump_release()
--

commit 820d81c18cf70e4f505e1114ea0578843ea87567
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Restrict ioc_dump debugfs and replace raw ioc dump with te=
xt
>
> The ioc_dump debugfs file previously exposed raw MPT3SAS_ADAPTER bytes,
> leaking kernel addresses, and was world-readable.
>
> Create the file with mode 0400 instead of 0444, replace the raw dump
> with a small human-readable text summary of key adapter properties, and
> fix the memory leak in the release path.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes the raw adapter structure exposure and world-readable
debugfs permissions introduced in 2b01b293f359 ("scsi: mpt3sas: Capture IOC
data for debugging purposes"), should the commit message include:

  Fixes: 2b01b293f359 ("scsi: mpt3sas: Capture IOC data for debugging purpo=
ses")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sa=
s/mpt3sas_debugfs.c
> index 183391f6b8d19..432e120ac81db 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> @@ -49,22 +49,62 @@ _debugfs_iocdump_read(struct file *filp, char __user =
*ubuf, size_t cnt,
>  	return simple_read_from_buffer(ubuf, cnt, ppos, debug->buf, debug->len);
>  }
> =20
> +/* Buffer size for the text dump */
> +#define MPT3SAS_IOCDUMP_BUF_SZ 1024
> +
>  /*
> - * _debugfs_iocdump_open :	open the ioc_dump debugfs attribute file
> + * _debugfs_iocdump_open: open the ioc_dump debugfs attribute file.
> + * Populates the debugfs buffer with a summary of key adapter properties.
>   */
>  static int
>  _debugfs_iocdump_open(struct inode *inode, struct file *file)
>  {
>  	struct MPT3SAS_ADAPTER *ioc =3D inode->i_private;
>  	struct mpt3sas_debugfs_buffer *debug;
> +	char *buf;
> +	size_t len =3D 0;
> =20
>  	debug =3D kzalloc_obj(struct mpt3sas_debugfs_buffer);
>  	if (!debug)
>  		return -ENOMEM;
> =20
> -	debug->buf =3D (void *)ioc;
> -	debug->len =3D sizeof(struct MPT3SAS_ADAPTER);
> +	buf =3D kzalloc(MPT3SAS_IOCDUMP_BUF_SZ, GFP_KERNEL);
> +	if (!buf) {
> +		kfree(debug);
> +		return -ENOMEM;
> +	}

[ ... ]

> +	debug->buf =3D buf;
> +	debug->len =3D len;
>  	file->private_data =3D debug;
> +
>  	return 0;
>  }
> =20
> @@ -82,6 +122,7 @@ _debugfs_iocdump_release(struct inode *inode, struct f=
ile *file)
>  		return 0;
> =20
>  	file->private_data =3D NULL;
> +	kfree(debug->buf);
>  	kfree(debug);
>  	return 0;
>  }

[Severity: Low]
Is the commit message accurate when it says this fixes a memory leak in the
release path?

Previously _debugfs_iocdump_open() set debug->buf =3D (void *)ioc and only
allocated struct mpt3sas_debugfs_buffer, which _debugfs_iocdump_release()
freed with kfree(debug).  kfree(debug->buf) frees the text buffer newly
allocated by this patch in _debugfs_iocdump_open() rather than fixing an
existing leak.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D31
