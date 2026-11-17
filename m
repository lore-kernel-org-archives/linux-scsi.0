Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904514;
	b=c62B0zMLrmCo/s6w49mswvu/YRllBf6G4joNto1XfA1+fUPAoxVxHGtWbnMCtE7l1K0f
	 D8O4sM1tq5hBQ3NONanRv+voZ06U0cLFdaGZGxwN5td/Ut2gHBjIBx3gJSHP45zi5ccet
	 HiyFvDH58YXqZ2C18mEumHVTAP1w9F1IEpAsvMr5eKuSVoFj5ZYCOpLELfs/oYK9g/thF
	 bVaf5Dws1OrQqrvMicXWQc40IO0vu7OvJN6ipAcs8Vddejr9ua7GyhMacYtaFDcKICxge
	 L/kRNMEHK59LFqnvDGJDYsOvquImDtDm0yF/2+aMHAeV2JMpmYYcvzW2pmSsyqdMQZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
	b=4fZ+lLOKzW3PSRvIR/YaePzdfMME+1tL+oHbJxI/y3HPmrqnBL2EZMZIJtHmDC8v5Ulv
	 /8gOLbyexECJg4YSaRsYBY8yMj1tcQdl1/YXeHW4fKK8Pm3PVnqNTv+bKojzBnKTG4qfN
	 kC0ZxFLJM1aDtQcFovMa+xU/3raZLNq2N5N9vUzpfQEWEnnz7Pq1CNJp0hyUP3to03izR
	 +hX8Jlj1qENLVn7SkY4i+n+VPlWvXGt0LGsjObaS6irS6W3D+wzgqI3uxgPjNApVNUIRa
	 cgJkxkJY4+LVQqBXbi8KeYXa0ZcGFdPFEhq68EPPPzN1ILuU9wyURpsd9gaDD48FffA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865DA606A88B
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 865DA606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4919a880834so2252940f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904510; x=1795509310; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=asHWLUHh9Osx9c7ISjHVvBK+jrwM+bEKiKQ5ZLUG8jHeL8cbDrdmay7aq+azwtlrvN
         q7YkHw224WJQO7TnM1AyMygFYXrlY29jKpq3C9XROr0oTqsA+UK4p+WS5GMy+xx9DTRb
         nuDA+OEO8+ykjkDq/RDjAwEfWgenycj+snq2KkG6mulygb6NKchr6plM71+t8W0/+aGL
         LigMC+giRqQ92TsunABClmE52NWQSdRqhQeez7lH76lemvGh63Ic8nud3Qte/9KpQmbQ
         YrdviXjfG5hlS64KIE7Iq0kMRVYmtZMNK2hkMRb6Cz1tihRk5N+J71aJKPK+K5E0SOED
         KbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904510; x=1795509310;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=gDZEJm6ytGqihj+HujK7uDVH9Yj2w2ZqXD4YjE+vt444HOHt23U3fAOy+3eRR2paCw
         IGNHuT8H0phyjxBXElADi085hmtKJNmwv9j/qOfHszjbRbfM9HEZwQ35vl6MFtLEmDcW
         y/1uuhHnl+nOvXXGv/YpsGoUSbIujp50/RwU6Hb0Ea4gXIy+nciXKsQ2O0lMkPJ2vZgx
         OpVrHpQ2SP4Y9i3DJeWBeuZpLZFfvIdlKmNBtOvxC5RyOH5EMSmBuGtup6qvRn2VvTwl
         O1VdSjpTD6djRdvvP5b+1ebAU/fsbziIFaOWPozFAlaM8vVmRS+dOV6z2pHn9emSM5Ux
         shJA==
X-Forwarded-Encrypted: i=1; AL+hErFpe8A9ucvGuUf3tny6xWdUp3j06pZ9b+QqXfYwl0QBxDJ4iicOhaBO3ay3xUX31jNvTdnK2o2FVDPH@vger.kernel.org
X-Gm-Message-State: APuU4Z+gvPNQZZ1uWSVenu1QSk5V+YBXkw8XA1G4jZy7XcU/HBXgLRJl
	xR9+w+YMq2pmcsw641RZZ52JWLU8CQaC8Q909kCy8ZjnJewNpt2aCdFh9lCjWgmnM1wa
X-Gm-Gg: AZFdTZer3qV2n/q1NbFQAv9gW47G7p2y0d8R8Zhd0v3V2k68hoL4nNm1ljh1ZAhx/xo
	v05aSs552/XeftAVgSgKyOxpOB4dTDR6gDw5xypEEckQEG0fyHB36XFznMQxAi9Pe3ZALlOnZqk
	w+a6G2NCVuktTS3VaoH1hMPZV6MeRYjUe9AL0dAJlGNk8yIu/ImiRmONp1dorlCz8GRM+9Nx6tD
	Erzf55qvBvQTRKdL4DagtSL+sciA9L+0aHsQM4w4VoOilr7/9vXljpt0tcJNl/Ddsc5daEee+cb
	GV7i5QJH01W1id1y6+b2R3C8lmn10akfyTpnwpsR3ZuxNxkhwo9N3dU3WI+YxfcAK1ek8TioA+0
	q/ssgkAhc5eLdBUAOXISDYFqSDsIlFPKEFIA0dpMtTjiXoaKVrWF0ExP4t2JG7t4MjeCxyw5ZwX
	QqTQEdHtXg0gdOSy+aVt8To+XdzjFJHTpENegu+OVNcFOO7Bs34srkws5JM6uXtVj3B40tIlW09
	7nBau9FLZlLhptPzbOofk9iTPGwDUEFuoJA6BpXrt4BrqzxGNk9ziVjbR8y19ZTiKe5a0KdPn2e
	MXGbOlrRmxDmgPFurIbFh3Uz0F/Em2fk/T7BbYhF9YYUjNLr2wsimhymwCqH4l68sSnsinA/JZu
	59jek665b3lHX+/KQKB3bIbjrEKL0WyfPeQseoHs1LfPRltA7y1xMl/JU
X-Received: by 2002:adf:e193:0:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-49c728c6e6amr26569239f8f.43.1794904509932;
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm26338505f8f.36.2026.11.17.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Message-ID: <b0ec2cd8f9b7a6a2e4a54c6df2fa897bce068cbd.camel@amutable.com>
Subject: Re: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:35:07 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/ocfs2/dlmfs/dlmfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3bf..1789ec96dc130 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/types.h>
> =C2=A0#include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations
> dlmfs_context_ops =3D {
> =C2=A0
> =C2=A0static int dlmfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &dlmfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
