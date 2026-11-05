Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906930;
	b=dM3Ob315+huGezSffZQusx2JRpZ0VB6D68IQ9usQaoZNTR/pgovcR1R3rxFO0b/3At8n
	 FFoUIlX12qLHQjOvs+n7fg5qRpIBhK4xtPrCnTxhu6FBvy27vtriDKCPc+/dsu6k5acVr
	 yPAYA1YlLJg9uRuReDTdFohJekuqLnT9b/m6LK7DRUayZAzoVqwfwo8bhbYq1Upec4BbV
	 ptwRMdjQiInB8MWQ3oCoIKvYk92UA3hQukMeI3XcyhuQUG4IBuCJRDlljkDgnVqtrpO77
	 ijtu+m7bZXB8zL1mFNv4Eqf4J3x9ng7Zq1m67HA6rNpNFcBriNa3Y4qs/fuVUsr+xlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906930;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t5ltLRfeO7A4ze3tr9EcZS3s3I93T55/6iRGXRatBcI=;
	b=PtXNdly4ke+9IphNrzx4KpktNqAQlX+JMHpCeRgDUPF5C5bC7zpa/9E6L8Dv6Nfm0+y8
	 tSx5UCZlwvbaCK5qFjhVCCwByClP3Qh3BFrXUrpCCCtpFX7MTTUSxhPzf0s6iG5JGlyTP
	 qxhzFXH278YH4PU+WDAtvlQ52AxARp5ZgVIASxIWQR+bm5ksAHSchGZNa/P1/QJmePcx1
	 9gPmxBgXY6kGwo2BSDAhaHqgJ8nYV84j5u1Uc5qiZE2z9001kLKEm6MrcfAbMTSNc6nwT
	 EXEhMeInHHihMX85IhycQpFWzWtCm3QJn/7TIGN2JFX8g8c8K+D5vCgv2O1RxjIJOeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N8czzOm3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E84E606A33E;
	Thu,  5 Nov 2026 19:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N8czzOm3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F791F00919;
	Thu,  5 Nov 2026 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906929;
	bh=t5ltLRfeO7A4ze3tr9EcZS3s3I93T55/6iRGXRatBcI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N8czzOm3uss/Nev41wWI2HCgtA/JJ30J5ZI/5HvqHyryejYB/vPH/hBylXVkVGrv6
	 OielTQZZJsAgzXMX0XY5+ywbGo0mmqbyFRwY2koxZomesAs/TJ9/gk+vP/71ryRjrz
	 T4vkNotZqPxmBNAvJ14HURgj7iVi6JGCZi7FoFu5UsPJYhvBEXafmV8KZulQt0TLUa
	 bnhBhsrybsI04J6qaEoTmohzhtxxwuJRWFtL3gmSrI+vhB1bjBR5l4UtjzfZC6c0lO
	 DCD02LTUhjPPRIlhUjpD4vyOQAhRmKBCDZpyL6ta2I03KLDunRpmQHSavStcgYROjy
	 RlifknHgKJUtA==
Message-ID: <sashiko-outbox-199864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo
 under the codetag module lock
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:47 +0000
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
- [Low] alloc_tag: unused function shutdown_mem_profiling_async() when !CON=
FIG_MODULES
--

commit ec0095b3ecdd2d01651f48bc80cc81d976e06106
Author: Christian Brauner <brauner@kernel.org>

alloc_tag: don't remove /proc/allocinfo under the codetag module lock

This commit defers removing /proc/allocinfo to a work item when
reserve_module_tags() fails, avoiding a deadlock between remove_proc_entry()
waiting on active procfs readers and allocinfo_start() waiting on the codet=
ag
module lock.

> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 82e2c3448dcf2..7d7ad67049537 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c

[ ... ]

> @@ -604,6 +605,26 @@ static void shutdown_mem_profiling(bool remove_file)
>  	mem_profiling_support =3D false;
>  }
> =20
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
> +/*
> + * A module's tags are reserved with the codetag module lock held for
> + * writing, and a reader of /proc/allocinfo takes that lock with the ent=
ry
> + * pinned. Removing the entry there would wait for that reader for good,=
 so
> + * let a work item do it.
> + */
> +static void shutdown_mem_profiling_async(void)
> +{
> +	if (!mem_profiling_support)
> +		return;
> +	shutdown_mem_profiling(false);
> +	schedule_work(&remove_allocinfo_work);
> +}

[Severity: Low]
All callers of shutdown_mem_profiling_async() are in reserve_module_tags(),
which is inside the #ifdef CONFIG_MODULES block further down in
mm/alloc_tag.c.

When building with CONFIG_MEM_ALLOC_PROFILING=3Dy and CONFIG_MODULES=3Dn, w=
ill
defining remove_allocinfo_file(), remove_allocinfo_work, and
shutdown_mem_profiling_async() outside #ifdef CONFIG_MODULES trigger an
unused-function compiler warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D1
