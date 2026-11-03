Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718099;
	b=YpIV9DPMIuPyHcjwGM1udC+7w6hcqZ9DZrCUHnCcZyWw3MR/OhXCoSGSHwdlT8BxmeDw
	 LaR+1+Jyz57viHTtPGwaU21RGPuR08AHgXM20Z/wkwN1ibc3EzW07y2+GCMOjQaRAPIIi
	 PsnRVmbltsLLNs4RXiwCfrswNmLCk2p368GaqZKdY9IkokTyafSu+CB3IK3cTXiTZk68e
	 8aZ8hZ1SMyRpt3/ZB2bc27cJVVe3FuTTsNF/D0dAwpZljrvIuf6HaJ+abqsCjDvsRGpw7
	 xeQiFaQQ/t6LY7v+ewAs+/E6rIDhl8xVuuYZyBC7QX9LeVvKstogc/2WLYlEg6cN1rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718099;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H4Y/D8MHsuJxIcgQs16JMa9LVQhoWAXgdYCn9GW8dZE=;
	b=dF9n0jiQ0pARZ0a8pWXyvHoJp4aeATDT0ZMqspbCZB1Evg2sjGHKkakHlMrmudtAtFpO
	 OYAGYUxlgZsmstpGPNwqae9+a8VvtB6CHjTCwJq85dbCUoX6ilRIOA8WWO1So69ZPpC/0
	 o86rhH8U+Dyc+Mzz5nCXE9K8MkimX2ArAeuPDRPWpmnkViHWR0l0SpiJtlAsgC2kpD+we
	 sKp65LNCvmTfoySb1TGl+Brq2MZqMvrSgQvxL998Fp4wwfjesx5vEVqjUrHBN7DbWOGfa
	 yKVxapLURPO/XKwYRGUsOhEbYJ6uc3sEIw5GrYU4j5M/CRRACC3bfhSMVZ/KTM4VKfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPOrW1sZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA68E60A6F71;
	Tue,  3 Nov 2026 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iPOrW1sZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664741F0093A;
	Tue,  3 Nov 2026 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718098;
	bh=H4Y/D8MHsuJxIcgQs16JMa9LVQhoWAXgdYCn9GW8dZE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iPOrW1sZYpx/JoZZqS9qV1GcjvdBuAyBkHMbgeIvuF9N8xnYtd/uAH/lu/jAlLzKf
	 Nq5vM4zhxl93ARwt5IDAUvoCbIWrHeNs/6trXeNMyLqwoaSZliHN1Lmdtd6F1TrRM+
	 E8t3nn11OR2O0yTsAAjfZ0JhJXAcI/KIsNGJZleh6tn4/huZCrKzH0zz2IUXdKnzkK
	 6W9TGbxhz+i9CE9TQ8pBES4DkH/dBUxXGqSsH1jdznxKqWRCNHZxYwypnamo4/Cqy5
	 fIsF/ocsyOzXijxNmThFmUaDNsK0S2Y+yjWibAtCyfn78+Zol7hiv1kIJFamvcET5T
	 yE9Ruio9sbg7Q==
Message-ID: <sashiko-outbox-195542@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 15/16] proc: let procfs copy ioctl arguments in and
 out
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
In-Reply-To: <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-15-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:36 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] proc: unguarded zero-length user copies in pde_ioctl_buf()
- [Low] proc: split declaration and initialization of __free() variable in =
pde_ioctl_buf()
--

commit 468d1faef733a0559be5a05e125e1ce20ec69e4e
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy ioctl arguments in and out

This commit introduces ->proc_ioctl_buf() and ->proc_ioctl_args to allow
procfs to copy ioctl arguments from and to userspace outside of pinning the
proc_dir_entry, preventing page faults during user copies from blocking
remove_proc_entry().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 3f29a1663d266..7e4ca5751abb5 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -571,11 +572,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, s=
truct file *file, unsigned in
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
This isn't a bug, but in pde_ioctl_buf() in fs/proc/inode.c, buf is declared
with __free(kvfree) =3D NULL at the top of the function and assigned later =
when
size is non-zero. Per the cleanup.h guidelines, could buf be defined and
initialized in a single statement once size is known (for example,
void *buf __free(kvfree) =3D size ? kvzalloc(size, GFP_KERNEL) : NULL;)?

> +		if (!buf)
> +			return -ENOMEM;
> +		if (copy_from_user(buf, uarg, a.in))
> +			return -EFAULT;
> +	}
> +
> +	if (!pde_pin(pde))
> +		return -ENOTTY;
> +	rv =3D pde->proc_ops->proc_ioctl_buf(file, cmd, buf ?: (void *)arg);
> +	pde_unpin(pde);
> +	if (rv >=3D 0 && copy_to_user(uarg, buf, a.out))
> +		return -EFAULT;

[Severity: Medium]
Should copy_from_user() and copy_to_user() in pde_ioctl_buf() in
fs/proc/inode.c be guarded by checking a.in and a.out respectively?

Because a.in and a.out are runtime values loaded from
proc_ops->proc_ioctl_args, check_copy_size() and _inline_copy_from_user() /
_inline_copy_to_user() do not short-circuit when the length is 0 and still
invoke raw_copy_from_user() / raw_copy_to_user().

When a command has a.out =3D=3D 0 (such as an _IOW or _IO command) and user=
space
passes arg =3D=3D 0, calling copy_to_user(NULL, buf, 0) fails with -EFAULT =
on
C-SKY after ->proc_ioctl_buf() has already succeeded, because C-SKY checks =
the
destination pointer for NULL before checking whether the length is 0:

arch/csky/lib/usercopy.c:raw_copy_to_user() {
	...
	"0:     cmpnei  %1, 0           \n"
	"       bf      8f              \n"
	...
}

On UML, calling copy_from_user() with a.in =3D=3D 0 or copy_to_user() with
a.out =3D=3D 0 still enters buffer_op() -> do_op_one_page() -> maybe_map() =
->
handle_page_fault() on uarg before checking if remain =3D=3D 0:

arch/um/kernel/skas/uaccess.c:buffer_op() {
	...
	size =3D min(PAGE_ALIGN(addr) - addr, (unsigned long) len);
	remain =3D len;

	n =3D do_op_one_page(addr, size, is_write, op, arg);
	if (n !=3D 0)
		return (n < 0 ? remain : 0);
	...
}

Additionally, when both a.in =3D=3D 0 and a.out =3D=3D 0, size is 0 and buf=
 remains
NULL, so copy_to_user(uarg, NULL, 0) passes a NULL source pointer into
raw_copy_to_user() (and memcpy() on CONFIG_UACCESS_MEMCPY or UML builds).

Would it make sense to check if (a.in && copy_from_user(buf, uarg, a.in)) a=
nd
if (rv >=3D 0 && a.out && copy_to_user(uarg, buf, a.out))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D15
