Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907333;
	b=sCK3nKT0Ey8gk6lvehcZtvYKy1VGBwajlQJVorCknVbuYgiBeom4EeofDn5xAEml959F
	 Bobd+KOuwQYE1K8n4KgVr5YDsog8ZA05elcbf9VdAa36yBvZa+1v5Sh1/n+XJ7or6lztu
	 8MV9m5a7CoB2wKbcC6dWGEy208fYGA2vcxkbtFOhGGvYctQQ8veV8Bz1OdjM5y7S7uS5a
	 xCU6QZ3P2QJUJ5sBG27a26E1aw4aTcCf1BLmRPiWfgf/XSbV56oH98NRiZjWcrH6gRYHv
	 GNUF9nfwswZWgsKNnxB7bbhZtfxtyVha3k9qQ/Ve5RqU51WkaweWObA7x90Ilm6WQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907333;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QnupmpJjcDSUenY+8iHhV2pDdP26FR+grPEd9BKN+Wg=;
	b=q0CFr9e3yjrR+hBl85q4vz+VGFuIeCmjctU+w5NWWjyjcBCvqCwcKMMYM3mRVb0rgi4H
	 4JTejoHR1PRriwdUmHH1w/LFgFSqqQJPqNWnHC9NuDL+zyOKRLUlqVTSCnmNPHVOqShpF
	 0ajDoT9griB1NG/rYbhLej9YEEdStS6QuSntYg6JjqmMxfmbkZ5pOn+FIhc1YHDPqP8TK
	 cwiaqY5nWgYujr9Kb6gzThGXKEqlxiauCEAgJ573KbCMVJ1pnipgnT423IIOLcKnzjYe6
	 AWYjlh4BRqprH4OnPc0u9ZgvNyBgKi8OJT7PvDFKtgiY3rFdLO29md8lYbYV8nBYDWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=icO3rWLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080AF6077B4F;
	Thu,  5 Nov 2026 19:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=icO3rWLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E09C1F008A1;
	Thu,  5 Nov 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907331;
	bh=QnupmpJjcDSUenY+8iHhV2pDdP26FR+grPEd9BKN+Wg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=icO3rWLw6nKGObCQJgYMxAh2P6PTRzIdDeuA404d8zGUUVnEp22awIUt/ONskepjG
	 FQyNYgueaW+0iYJhp0FqJ+XOW2y+yurI0uUuh+dfsOclM2Nh3qdwIC3ytuTEQmNhzr
	 MTetr7AbbAQJrQhhBXugv5fx//leXY88njWHb3TZ3743y/bVbrU4sQkjQK81piouKz
	 MGYh6ZeJ6sFNsrOgjNWWNWno+Xud511eRRatEpGCbh1xHAr4ri1vGAQGPMtUR0YyMD
	 sstDXtwDG9/n6Jsu5U178yWJP4hODLvoqYoWfkpM7RkF01wue3ewhl7sYNSjaz7bA6
	 sSwHZw/oTnT7A==
Message-ID: <sashiko-outbox-199938@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 08/23] proc: let procfs own the seq_file of
 proc_create_seq() and friends
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
In-Reply-To: <20261104-work-procfs-core-v2-8-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-8-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:29 +0000
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
- [Low] proc: unused-but-set variable p in seq_open_net() when CONFIG_NET_N=
S=3Dn
--

commit 4dea51dab83a49a4131e34ad5f96bc9822052389
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs own the seq_file of proc_create_seq() and friends

This commit updates proc_create_seq_private(), proc_create_single_data(), a=
nd
their network namespace variants so that procfs owns the seq_file directly =
via
PROC_ENTRY_proc_seq_ops and PROC_ENTRY_proc_show. For the network namespace
variants, ->proc_open() and ->proc_release() are simplified to only manage =
the
network namespace reference.

> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index df5484813d5dd..9973f846c4674 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -37,13 +37,13 @@ static struct net *get_proc_net(const struct inode *i=
node)
>  	return maybe_get_net(PDE_NET(PDE(inode)));
>  }
> =20
> +/* procfs opened the seq_file and allocated its state, see pde_seq_start=
() */
>  static int seq_open_net(struct inode *inode, struct file *file)
>  {
> -	unsigned int state_size =3D PDE(inode)->state_size;
> -	struct seq_net_private *p;
> +	struct seq_net_private *p =3D ((struct seq_file *)file->private_data)->=
private;
>  	struct net *net;
> =20
> -	WARN_ON_ONCE(state_size < sizeof(*p));
> +	WARN_ON_ONCE(PDE(inode)->state_size < sizeof(*p));
> =20
>  	if (file->f_mode & FMODE_WRITE && !PDE(inode)->write)
>  		return -EACCES;
> @@ -51,12 +51,6 @@ static int seq_open_net(struct inode *inode, struct fi=
le *file)
>  	net =3D get_proc_net(inode);
>  	if (!net)
>  		return -ENXIO;
> -
> -	p =3D __seq_open_private(file, PDE(inode)->seq_ops, state_size);
> -	if (!p) {
> -		put_net(net);
> -		return -ENOMEM;
> -	}
>  #ifdef CONFIG_NET_NS
>  	p->net =3D net;
>  	netns_tracker_alloc(net, &p->ns_tracker, GFP_KERNEL);

[Severity: Low]
When CONFIG_NET_NS is disabled, does initializing p unconditionally in
seq_open_net() trigger a -Wunused-but-set-variable warning?

Previously, p was assigned via __seq_open_private() and checked with if (!p)
outside the #ifdef CONFIG_NET_NS block. With that check removed, the only
remaining reference outside #ifdef CONFIG_NET_NS is sizeof(*p) in
WARN_ON_ONCE(), which is an unevaluated context and does not read the value=
 of
p.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D8
