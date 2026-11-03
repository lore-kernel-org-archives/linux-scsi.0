Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718069;
	b=dpfB8oklmoTH0RV5K0uReR6Ukg5AcHhGMGbLLI+XAts0frMuOadwrxfK7uHAdEgcQN38
	 J1Iy+G7Kg7htKzvmvuqkUPbs7mzenN4TJhq2xPbyoKb04YTXs1xRfqeOvNMQttIEemN1V
	 9mWIGscG3vU5ZeOwfCg+m8wJHUI0LHkzdQ9WYCMQMoXbRKFhaLO+Un6tPickD9pm81sEZ
	 jlSfoIXS25A+uGqW4fVHVlHC7SDHWoefUkDlsoz16XjKbsAiMtQDgZwINZVMlKYVnr50J
	 RBYhEH7j7AaQbxTTqrh8uaWa4HbIUckkz0DJzcAg4QCWpgncD5R7AUP2ehhYL+GF/tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718069;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BEajqQ35phGWaUcr3y1eTDvwsu33+Nn0Y7Ck4F/8MEY=;
	b=JsYWg+Mbx1aNUxYec+NHv0hgOO8q2Te7ZSJ50rp08ulRqtF0In4w8LUhCEvyANOaGdtn
	 Phwpv88bgnubAFGOdAlH04fF62vCBEb+gO5z7RrER2+d45C3phGwmTTMF9JtQz4DNOfVw
	 0zNlRgr9LfDZt34Jsp/bIXQfuAoIsKQz42qdKalNkexkpaccnD1WJMbxY7kuiUWqmYrvA
	 zItIqZXMGth/iio7B6aPmIZsBmmpyyyrQUhbYvg23+UQ7OycPHI/EO4BYh3/1fQaLQ47E
	 4WbV5XhejVym64IUzvrUmXj65AVaGV4IQ1qmArq8sCWtV5wGGKCx+NzUS2ZyresByjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEcq0ggu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA2F606D836;
	Tue,  3 Nov 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEcq0ggu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD2F1F000C1;
	Tue,  3 Nov 2026 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718068;
	bh=BEajqQ35phGWaUcr3y1eTDvwsu33+Nn0Y7Ck4F/8MEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VEcq0gguO6/NoWa+wL6fwqCLqkldJUUFWXaU48FgopqIQWVInov4USQPNMlWECfku
	 tjmmYgoSxJFwLb8AMyTRkOEe9RIAgKCTxUsnF6zQuC56KDIfRvxTZM6B4OGZ+0RxLb
	 mh81fLroJS4nyQyOkcaBszjAOxkYEOtX3GkPZMu84uutLjUi79KxQ0Ta6LswLb4aME
	 +9R/WJkvVhkvygnNcEPN9DxaCT6J3JtUHgSP8vKYwTs6rh6No+CNqGd39rP3s8vdpa
	 CSPispydKapyfU9yanW1YMZNTbAP3BOy5UszvDaukMX2hst4qdOs00Vyn/j4PbSImA
	 6uri+styQIxoQ==
Message-ID: <sashiko-outbox-195531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 04/16] proc: let procfs own the seq_file of seq_file
 entries
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
In-Reply-To: <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:06 +0000
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
- [High] proc: unpinned dereference of pde->seq_ops->next in pde_seq_next()
--

commit ae41131fe28a1e7fcf9c3b743e2a30697e315fe9
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs own the seq_file of seq_file entries

This commit allows procfs to own the seq_file for seq_file and single-show
entries by wrapping their seq_operations and pinning the proc_dir_entry
only around start, next, show, and stop callbacks rather than across
userspace copies in seq_read_iter().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 66a3688757dd7..8425465aae5d7 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -218,6 +218,110 @@ static void pde_unpin(struct proc_dir_entry *pde)
>  		unuse_pde(pde);
>  }
> =20

[ ... ]

> +static void pde_seq_stop_pinned(struct seq_file *m, void *v)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +
> +	if (pde_has_proc_seq_ops(pde))
> +		pde->seq_ops->stop(m, v);
> +	pde_unpin(pde);
> +}
> +
> +static void *pde_seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +	void *v;
> +
> +	if (!pde_pin(pde))
> +		return ERR_PTR(-EIO);
> +	if (!pde_has_proc_seq_ops(pde))
> +		return single_start(m, pos);
> +	v =3D pde->seq_ops->start(m, pos);
> +	if (v =3D=3D ERR_PTR(-EIO))
> +		pde_seq_stop_pinned(m, v);
> +	return v;
> +}
> +
> +static void *pde_seq_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +	loff_t old =3D *pos;
> +
> +	if (!pde_has_proc_seq_ops(pde)) {
> +		++*pos;
> +		return NULL;
> +	}
> +	v =3D pde->seq_ops->next(m, v, pos);
> +	if (v =3D=3D ERR_PTR(-EIO))
> +		pde_seq_stop_pinned(m, v);
> +	/* seq_file would blame these seq_operations, blame the entry's */
> +	if (*pos =3D=3D old) {
> +		pr_info_ratelimited("buggy .next function %ps did not update position =
index\n",
> +				    pde->seq_ops->next);
> +		++*pos;
> +	}
> +	return v;
> +}

[Severity: High]
In pde_seq_next(), if pde->seq_ops->next(m, v, pos) returns ERR_PTR(-EIO)
without advancing *pos, pde_seq_stop_pinned(m, v) is called before the
if (*pos =3D=3D old) check.

Since pde_seq_stop_pinned() calls pde_unpin(pde), which decrements
pde->in_use and can complete pde->pde_unload_completion, a concurrent
remove_proc_entry() waiting in proc_entry_rundown() can finish and allow a
module to unload or free the memory backing pde->seq_ops before
pr_info_ratelimited() dereferences pde->seq_ops->next and formats it with
%ps. In addition, pde->seq_ops->stop(m, v) in pde_seq_stop_pinned() will
observe the unincremented *pos value.

Could the if (*pos =3D=3D old) check be moved ahead of the
if (v =3D=3D ERR_PTR(-EIO)) check so that pde->seq_ops->next is only access=
ed
while the entry is still pinned and *pos is updated before ->stop() is
called?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D4
