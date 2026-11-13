Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564919;
	b=Fc/bYTXvFvNhVuWn42y+70K5q5wSs3c1aPGmnMXhdKrzy47PxTWIlPfx124Z3zX+UeR7
	 GSTP3onS/DGDzJr94TPJuhQ1N7sGlXh6H02F+pVNdJpb14JvtnenAvB/4It8unNsVTH+g
	 52urtyw8/bJqomRShomWVUur9Gw0n/u+yrJQVvPdgBivUt0upwBQtgwvwzXaPBsU8k4Mc
	 evh1hX3xdECl7P81Nx0ib2PL8c8XLA9iN0KwHpjXm9arpv4243FTO/krpM8UHvcYAGOeA
	 46CnO6pS/kPkgJfw1xyNWmqjEdu5qBnWa1ey8hHDBSkxonJXLGsZJRF1Gr580hsFKww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564919;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
	b=K1BPcyYhlmqzRPIU9Lk+xZuy4ZN4QPfWjxN8W5Kx5vMJAbhdkqCcJrMLd2pJzNnBrYut
	 t9FZJc27rcmrSHwlFqMCOVLZK/3g/MN6t2ROfR/VvbeFmwJmmXHZ7FqXDvQ68dK5Ocn1z
	 mwzpu0MHXt4mjltLHPwUzAm9pvRUcy2g0jpXn38tElIhiunj82i2czzCaW0O2nKfuGagL
	 Ma+ZYuu1KOT8AV6FDChx7isbC9Hl7x5V2Vn067UV73Xs9HngsHQ1mvv0M4Is0d1mHWQYM
	 GBTFlIRvmQaNOCiAw8U4mfz9IWd34BpY6sxEJLyxn5GDqdAYvoI48xCrtxwKOwtTWoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28C0606B134
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A28C0606B134
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so5374085e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564917; x=1795169717; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=XokUN4uhZ5cnIDNPS9kLjfaPp8ZSmyDY7nHz3ffF9uftFGQzzc0NaUd0CPxl6tmm/G
         EB2bqVZrrrQULKzHfxmMlarOF7+NP4G1EuGLp1x7hwkFzcf5DKQIlYH5+zTWTg0qLXK8
         Q27+pu7matN83z4kFimCCYFY9EtcVBpSYh+f+WbPWczzC82gi2dU1+IxENiNgIvD4ssI
         1POQJndyP8zOY9I/drEtHc8Rir/wcokVwFCL8xkdsULqRcKqvw/m2pftg5e6OYSufYMA
         FPm06vn59Z5lYx4UA2FpKr0UjB0BBdejlJLIE+RKFWt9/d0/clXrD3SuYpmwDbHdW+74
         JQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564917; x=1795169717;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=EFqXx3EEQDbTa3Lh15Ztdrpr7IZgMuw8ks8uem0vZhzBdRNuAx6/tCyP4A32Mcq4P6
         s5B7nTZWEKe6LKDhVLqggFV1GtE7wCRjVF7MZ9GfXp/AoRUm4CpQAez2yZbgrLl58mri
         R93FzvEkeZ2ezGiS0LBrWTZ3dUQ7R9pgATe0UQcYNthJM5IWdAqyf2AriX5DlOjua3s/
         5mUFSY1U1jeuQduGEF7d69crlsWCmJMrWUo35XL9FqFN9etw8q+AJzRoeiQoP7lPA1hL
         tFKceJFgKU0e55MHIvPBjs+J/R66VvAt3TTpEPD37pDferPkxYePKX2FSLRornRlHX0D
         iKrQ==
X-Forwarded-Encrypted: i=1; AL+hErFbzZ5h9/ARnYmmZq+yHPdb6N/Vgjnr5H+MIDrvFe4UY1hDrHkTIV/FnkNTZEsTVbybJ6+RZ1NfPRVP@vger.kernel.org
X-Gm-Message-State: APuU4Z9qr6gQuMja7bn4RI2RXutvrLsYQ0UkOFPRhxWOLPDNsQhoijcI
	GiKvRDXjkHPWK01pRJmvha2y6khYOb+cYz+snESa7d3LpMW+X8VqRVpkN0PC1wnZhUf3
X-Gm-Gg: AYBFou0OQxb3LqguN+oOIR9s4d/5o9JjCM9hsNS/tw8wYeSIecB5fVBU4amtF2umyCL
	I4bpSMzjA3vhnD2yApfxBu+3eQYOw16oP69G5XJumipLqhlgKHSKOF+6DkfHu+rPHKZDJhTvVGy
	cCP85+ogUjl4GauaH/77yDLozBpaVX8vhkbDu3sH2ozH1nkpfm6nMkxA9zIgBKBezE87NtZ0Fzj
	Yaof7jGicbaw/ejVMjt5w7s0FaoAPWyw1c1gy+k48lbxoDBzU0K+UnFy1NvZ4/k+fp2MmMOS5qr
	jlNtRbCylq55Sm6nnGx/qR6a3OR1eumamysGnSMhR7IIlDHbRuju9eiciIiaNMcJH+aRmsLugvh
	F7O4zvKgR+BRsolQMrthdT68AJQ2Qv22W6puskh10USeH7bu2ix36c4YTLN4JC2uK/GKwRSnk0C
	Dnlvin2h1hXAFXgMT3+mKcMy6qNFx4qgLmy5QDvba1JBFucI1v00B7xAUL5YfvBsylJDRGVKnqd
	NQ3hgXK/3PX1hDJOfENK+Bfb0eto5tOuRbFmYiQeiXH2amln+BW54cJQ4ltVQduGO7to0IFG1ao
	OgiEXZIrDhQcXzPaWvNqM6cvtErqEt8OLNeZR8OQoDbfIiEYsFbD+BOlb+Lkv5c=
X-Received: by 2002:a05:600c:4f84:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4bb5599ade1mr43492835e9.0.1794564916955;
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm31982365e9.0.2026.11.13.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Message-ID: <e2edfa06d185acd86b46945622b6eb6dff97b307.camel@amutable.com>
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:15:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo
> filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
>=20
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0include/linux/fs.h | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and
> must not be
> + * used as storage. Look through stacking filesystems at the inode
> that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode =3D d_real_inode(file-
> >f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags &
> SB_I_PSEUDO);
> +}
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);
