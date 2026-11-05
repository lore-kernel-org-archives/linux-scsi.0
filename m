Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907348;
	b=cO6Y2A1Fz1hdZ1ap3g2S0S5fmPUdlh2K7VmL41oiCRPZeR+C8zVX0TXkmTiGUnZ8iYna
	 XF6gc1ZHH1RLQ56ffBSshjhTBSw6adf9DycIeSJtMkBPZ4v0mpf335/eeKB4LsSHBIspL
	 M/8T4Ctvi6s0AxbFZ/WGxRaTyOgEKLy9jYTqMyYk93iSn8R4Ha3ZsxjqY0R1IakjYdk+G
	 NUvaiUQsYFX6IeBS63s6VRYEv8kAXpjuL/xuDxLxmLEHLbEnK99PkWoJaKD69x2KOXbKW
	 TpBZORLz7/u2QtYtW7e4JBHfxynNGIDq9FosC1DyQ/sHG9Aud/XNhyYEgorCYxy8qYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907348;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1MugNV8TCf3DcwhciMioHkCDdfBEvJqmJegZE7T3Anc=;
	b=InNX0+epFldCpEeGNpurNV1NXTAAgoLkEF6Wga0NjjcyHMFiCHKE9E8JTVFOHn3U4Ki/
	 qSoB6JlI49gwS1dNIZ/DgXjIUnwNPoEF1DzMWpcx7OnGQhYZxbYVHiesp+T8S4fJ3osoP
	 oaWrE40xiqxCwJtCLzHN1XujqHib3h7pzOFZ/BgQaQiuaTG5T8dG/R1HKrhUVmAz3eulM
	 pdLtpwfUULN0jJyLJlHdY3f5b4J9/3qm5P7tWsHLYJNlnwvtjPwlS0qsvq4xRZHJLXAjc
	 Tdt++riBVcqVsMiqU2jeUDmCn9bnfy8Hk0Yl6rbaHZWfl9CJnL9KSDMDLbH0mn9ZoRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxUDwRLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D60607956B;
	Thu,  5 Nov 2026 19:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxUDwRLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6371F0089E;
	Thu,  5 Nov 2026 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907348;
	bh=1MugNV8TCf3DcwhciMioHkCDdfBEvJqmJegZE7T3Anc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JxUDwRLS659AKy9L6EF/sMAUNJPV9IWLdEGgYT37J3Q3xoM9Rgl+/f5tJog9D28GT
	 YMaZHCMQxAz8Q/YhL7D2HkKgLdWMS13ODeIvOVS2cO3Xyt1UiWgXthVq8iKNCfiwYC
	 CBZKMuWNvUYO3GRSHNobx37W6/E4wT6vFZKwM2U+b9rd+Q0o+xU/Q/0vCpfhxieJT7
	 F6OAqSTAk8K2MFcN+drjgRiXeceRcYXDu/MhOHTrRoTOf/Jcy6qlsQJs6CLNabmhUG
	 q0HrKvIx+/XHSn3ssmSRL1+tCAkBs5GI7/FQwPFk1on24fvEEyzBWmsp3oEib+CbCf
	 nnIC8BG7tI46Q==
Message-ID: <sashiko-outbox-199946@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 16/23] proc: let procfs copy out reads that
 don't go through seq_file
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
In-Reply-To: <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:45 +0000
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
- [Low] proc: define and initialize __free(kvfree) variable buf in pde_read=
_buf()
--

commit 19cf278eb9fee57b90ee19764f6b076d9cab553d
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy out reads that don't go through seq_file

This commit adds ->proc_read_buf() and PROC_ENTRY_FULL_READS to proc_ops so
that non-seq_file procfs entries can fill a kernel buffer while pinned and
let procfs copy it to userspace after unpinning the entry.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index df1caa0f238df..caa47933c233d 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -377,11 +379,67 @@ static loff_t proc_reg_llseek(struct file *file, lo=
ff_t offset, int whence)
>  	return rv;
>  }
> =20
> +/*
> + * The entry fills a kernel buffer and procfs copies that to userspace a=
fter
> + * unpinning the entry. A reader that faults on its buffer then doesn't =
hold
> + * up remove_proc_entry().
> + */
> +static ssize_t pde_read_buf(struct proc_dir_entry *pde, struct kiocb *io=
cb,
> +			    struct iov_iter *iter)
> +{
> +	struct file *file =3D iocb->ki_filp;
> +	char *buf __free(kvfree) =3D NULL;
> +	ssize_t rv, done =3D 0;
> +	size_t len, count;
> +	loff_t pos;
> +
> +	if (!iov_iter_count(iter))
> +		return 0;
> +	/* neither the allocation nor the entry can honor IOCB_NOWAIT */
> +	if ((iocb->ki_flags & IOCB_NOWAIT) && !(file->f_flags & O_NONBLOCK))
> +		return -EAGAIN;
> +	len =3D min_t(size_t, iov_iter_count(iter), pde->read_size);
> +	buf =3D kvmalloc(len, GFP_KERNEL);

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in pde_read_buf()
in fs/proc/inode.c, buf is declared with __free(kvfree) =3D NULL at the top
of the function before the early returns and then assigned later at the
kvmalloc() call. Could buf be defined and initialized in a single statement
at the allocation site:

	char *buf __free(kvfree) =3D kvmalloc(len, GFP_KERNEL);

to follow the cleanup.h conventions?

[1] https://lore.kernel.org/r/sashiko-outbox-195540@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D16
