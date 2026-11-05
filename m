Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906999;
	b=lHOLVfZCB7D65PZkgx8qdHau17NN2njtd3a40USRoP0ux6/BeefjxZ4uo80bmCPFWmlU
	 LWIXQ0uKOWe6qxQ2yXvCoqjhpboq84+4wBfAEfOVOAFJ94k9zAvkd5PD96PRa5zwfBEbr
	 +xrpdvwZBZndYAARV8MUZCEbsKsHOhsw9w242hd+VH22WQvDLvmDbHC3bklINkfqGa9py
	 PJgkz/0GtL6nyCm9m3p3rscqcQfnn5TNZY569lil6pUKNx4VC9fsTTYPinPuPs48zBm5G
	 9C9XuecSXh6rZwhP3ly4m4+xmGl2BrLdau7kNM6nXJpEeclQMKmNa2rTjrC3qZCZxKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906999;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Mq2TZRho3g/6dJEkd3aM2nJWP3IUjUSQ0d76Sv96NJo=;
	b=s6AFSHI2087qD4uO9J3BalYOfaYW6SI1N3L1xL8Ncb2bp8jZtpCcwan/rCeLiocywfHY
	 Hjnlns+UCHB25q0Z/n4FmBd4hdbM3MpRmzdwauZuaY0i3VK2RCwzeFRvUKjkvC7PcgAxw
	 SZz2SgyaPRwZ5MBL/VvX6jCiefZw/rcmHLMn8SWw2oCdKFg1SpSdEVBW1NpRknQnmuJUl
	 LwjkOjfOfXn1KPbOH852GkYTl6VNvOZHiQ5dBLX9htFFJ9jG+bOUsSEAKYmPcrC+hPu4k
	 JSQ7LRwiZQ9bxhikWNiT6/8aoJY/ijHmoDjiv11V553XUMdAKEjUbGLHWixVZDl/bhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjJEPh8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C2606D81F;
	Thu,  5 Nov 2026 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjJEPh8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBACC1F000C1;
	Thu,  5 Nov 2026 19:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906994;
	bh=Mq2TZRho3g/6dJEkd3aM2nJWP3IUjUSQ0d76Sv96NJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WjJEPh8pDtseuVUQk4qwZA9aci3gac063ZokyebNlvHp2beWZHvvSUeYQeiXMVXvr
	 gorR7o8d0SaoLeOi9bKNyUy3h6vHu09hw27HReSQrpP5tbdq5gCz3B6gixX9La77ez
	 A3GDPdSDz2e83FWBMhFysd0uKqafdxTW2wlSO3wrIC47SZJJWU00KVW3tU8R/XZoDc
	 l2HWNRW/SEC3nlzdu96mPwurJuhISd5di7F3WA+6g/riaXNTCLrXNXhDRDwZUn89Ok
	 0Dcu6L25OUIAO131EMpgW4+6XspNy4+EDu3YAgYrAOfY0ko3kC83F2cPBr48QIfDJY
	 xKWD9ZPaIbjkw==
Message-ID: <sashiko-outbox-199895@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 32/51] proc: resume readdir after the last
 name it returned
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-32-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-32-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:51 +0000
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
- [High] proc: proc_readdir_de() returns 1 at EOF, breaking old_readdir()
--

commit 6510b1c4f87c45306294a13ba8447b50990db356
Author: Christian Brauner <brauner@kernel.org>

proc: resume readdir after the last name it returned

This commit records the name of the last emitted directory entry in a
cursor stored in file->private_data so that subsequent readdir calls can
resume after that entry by name rather than by numeric index. It also
continues after an entry's name if the entry is removed while being
emitted, and returns 1 when no entries remain at the start of
proc_readdir_de().

> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 9e59796349e15..588999058e66d 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c

[ ... ]

> @@ -290,23 +346,26 @@ struct dentry *proc_lookup(struct inode *dir, struc=
t dentry *dentry,
>  int proc_readdir_de(struct file *file, struct dir_context *ctx,
>  		    struct proc_dir_entry *de)
>  {
> +	struct proc_dir_cursor *cursor =3D file->private_data;
> +	struct proc_dir_entry *dir =3D de;
>  	int i;
> =20
>  	if (!dir_emit_dots(file, ctx))
>  		return 0;
> =20
> -	i =3D ctx->pos - 2;
>  	read_lock(&proc_subdir_lock);
> -	de =3D pde_subdir_first(de);
> -	for (;;) {
> -		if (!de) {
> -			read_unlock(&proc_subdir_lock);
> -			return 0;
> -		}
> -		if (!i)
> -			break;
> -		de =3D pde_subdir_next(de);
> -		i--;
> +	if (cursor && cursor->pos =3D=3D ctx->pos) {
> +		/* Resume after the last entry emitted, wherever it is now. */
> +		de =3D pde_subdir_after(dir, cursor->name, cursor->len);
> +	} else {
> +		/* Moved by a seek, count from the start like always. */
> +		de =3D pde_subdir_first(dir);
> +		for (i =3D ctx->pos - 2; de && i; i--)
> +			de =3D pde_subdir_next(de);
> +	}
> +	if (!de) {
> +		read_unlock(&proc_subdir_lock);
> +		return 1;
>  	}

[Severity: High]
Does returning 1 here when !de cause old_readdir() and compat_old_readdir()
to return 1 instead of 0 at end-of-directory on non-root /proc directories?

While proc_root_readdir() checks for a positive return value from
proc_readdir_de() to advance to the PID entries, proc_readdir() (for
proc_dir_operations) and proc_tgid_net_readdir() (for proc_net_operations)
return the result of proc_readdir_de() directly as their .iterate_shared
return value:

fs/proc/generic.c:proc_readdir() {
	...
	return proc_readdir_de(file, ctx, PDE(inode));
}

fs/proc/proc_net.c:proc_tgid_net_readdir() {
	...
	ret =3D proc_readdir_de(file, ctx, net->proc_net);
	put_net(net);
	return ret;
}

Previously, proc_readdir_de() only returned 1 after completing the do-while
loop (where dir_emit() had succeeded at least once and set buf.result =3D 1
in fillonedir()), and returned 0 when !de at the start of the call.

In fs/readdir.c, old_readdir() and compat_old_readdir() do:

	error =3D iterate_dir(fd_file(f), &buf.ctx);
	if (buf.result)
		error =3D buf.result;

	return error;

When old_readdir() or compat_old_readdir() is called at EOF (ctx->pos >=3D 2
and !de), dir_emit_dots() returns true without invoking ctx->actor, so
buf.result remains 0 and iterate_dir() returns 1 from proc_readdir_de().
Wouldn't old_readdir() and compat_old_readdir() then return 1 to userspace
without writing to the dirent buffer or advancing file->f_pos, causing
callers to read uninitialized or stale dirent memory in an infinite loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D32
