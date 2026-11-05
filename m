Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907353;
	b=yEpFvzB2fAC80BExuTyQiPVieeL0dBUb/HHuHJh9WzwWJS80GuXzBlmlXedQSGLlyB91
	 M2+c3mjxQeP2zWLkK5A+/+NLcAN6v+BEtUABZIAlBQpWBW/ArdaFin8gxdK0zk7KLPgF8
	 38Bs4GlVfimyJbJ8ssb7sGspOpaETspW3UIckdPNp8VBFj7yTCrxvMB1m/Ne4kHZpLR6E
	 qf85CKBopQN6olBXaENJ3elN7KVDXF5NioEPzxDzqF2sXr2p3OX/HdM3APZO3aCkr3C1+
	 Oc2GCQxXWhBUxwVuIZb3vcglk6Y1/6FQIE3dSfBu7MS4dpFk3EXOA6T+rif+lrgT2hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907353;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eiSLs4tpW5+ooQETfUAsv7SD2u+8vxBZSNTA/E9JPSA=;
	b=jOc0J9vnIU1voHfOBvssWczFLxvdj8mDG+IeGXOafQ3E/u0R4OSfxZbbtXoJ3RGlZO/i
	 9coeOLtCCDWTBlPyBcAhHCeMqEJcPtwTGJyQrO3R35hwi1NS2Sr7JjJlGdzGmoPVMsJ+5
	 eZPzEeEBWWg74R4M7gRoR8DL0mLCY4yutEA4pmp68P5FnqAeE6XBkNhf7SqB5nnQee4lR
	 SiP+M7TD686Ipz+Uyi7u/iBn2pas7D0PzExUsjRq+/tHH3dctiCyUE6z9+9nwy8vshRU6
	 Ftromdw1p86U3DPYONTkxAL+ZcCFJhwmm8h6ayCzDn+a2991m2v6OR2ECBLA6uesj/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRVwl1Yw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E9A606C884;
	Thu,  5 Nov 2026 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRVwl1Yw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24731F008A1;
	Thu,  5 Nov 2026 19:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907352;
	bh=eiSLs4tpW5+ooQETfUAsv7SD2u+8vxBZSNTA/E9JPSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRVwl1Ywon7MS2C+OemnpnnRZyhhY3OqsfkA0hDxdTc+rduK6mkVEdlJDGNIGqSYy
	 a1NLTQZZqowxlMpgmKyOfh8BBgOzgFAHydYWKlFfry5yNMxiI/UD8ldqZYx8WMm7ez
	 QNVP0ICID7Qj8TKSjz1zNuhOdyu+/wENB2Pe+KXsAcn/SDnE1f4VadXGr2TU1yn/I4
	 kSqEUN6UAmPa8USnYhqhq+djAtPsBeI0nhvEXQeRMsO17pEiCgKx17axw4dL2BiiBh
	 F88Gi+dRDEKECFbv6g4fiHem3PZPjp3QB2HUifdGFOqWgr8pWyiCoUmeRakhBgXvWb
	 R9lZgeMwuUEfw==
Message-ID: <sashiko-outbox-199948@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 18/23] proc: let procfs copy ioctl arguments
 in and out
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
In-Reply-To: <20261104-work-procfs-core-v2-18-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-18-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:50 +0000
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
- [Low] proc: __free() variable buf declared at top of pde_ioctl_buf()
--

commit 56830294f9ddc9f5679014810e7198455a39f42c
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy ioctl arguments in and out

This commit adds support for ->proc_ioctl_buf() and ->proc_ioctl_args in
struct proc_ops so that procfs can copy ioctl arguments from and to
userspace without holding the proc_dir_entry pinned across user copies.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index caa47933c233d..717cbaad65df2 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c

[ ... ]

> @@ -548,11 +549,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, s=
truct file *file, unsigned in
>  	return -ENOTTY;
>  }
> =20

[ ... ]

> +static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
> +			  unsigned int cmd, void __user *uarg, unsigned long arg)
> +{
> +	void *buf __free(kvfree) =3D NULL;
> +	struct proc_ioctl_arg a;
> +	size_t size;
> +	long rv;
> +
> +	if (!pde_ioctl_arg(pde, cmd, &a))
> +		return -ENOTTY;
> +	size =3D max(a.in, a.out);
> +	if (size) {
> +		buf =3D kvzalloc(size, GFP_KERNEL);

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in
pde_ioctl_buf() in fs/proc/inode.c, buf is declared with
__free(kvfree) =3D NULL at the top of the function and assigned later when
size is non-zero.

Since the cleanup API convention prefers defining and initializing __free()
variables in a single statement rather than initializing them to NULL at
the top of the function and assigning them later, could buf be defined and
initialized once size is known (for example via size ? kvzalloc(size,
GFP_KERNEL) : NULL)?

[1] https://lore.kernel.org/r/sashiko-outbox-195542@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D18
