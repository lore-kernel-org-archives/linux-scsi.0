Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904090;
	b=fxnUeWY1FRgG8NNMlowCJWz/R7PYOpCpUvO0FLZx0OklFKjX/zLm8gQF+4hmv++JPC3V
	 yWXgvXzGWEQTpcpvdWItA+AnSl4B3YcP7LEqwTmz6ONWFSS2e6NdBNBTRpCfDrXWox8iv
	 4ahJLmPdms40g65RYNWOuowiRaN/yCR8iON0fOoYhHq6DbWxQXaRv39JcQuZPi3XpzQJN
	 YqkAXF9ATJxmNq/xBFzrwkVoiOD7d3qI+qc1kzmS2kjNOZ6JFOvuKWTaZBfwdYrUsruFV
	 6Nl1zh3aM3KULKJ6mlBkBvZ+4fz6rKO1S8G1RhxZZ8auv2P4Sn7hvFHuYDZwVnifcew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	b=Z9smunCGrJFM4Qp0xBsIlq6TCkVT/XrLJBdAfPGNFFVT3xT0AwlCHi+JmDt3cDuY9Xj5
	 kBi1C6JI797yW2b0hjAeVMmzgwUyQ2ZZXZv1sEjZU7RZBYdR4ofr332ugwuH2e0kK1Z3Y
	 260YB9tKcTHBUGIbNDg/z/SqBjKnfjmyt9pILWN5fR/tqEplUYnC/qOQthaOibkcttIrc
	 8rG7N+Q7hfu99e+n9PPJKv5S1dPeR00iibHRuANf0IJXjjTFiegR1FU/n3bNHj18fdtor
	 6u8IzRPeKzH6roY8vSN/GUWYeVOYVSKpP6b/1gZiBQj4ou1zzMuN9a0CGg4rCVs9TDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12502606A89A
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12502606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso26232785e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=G5kPAzk6YKyHaocuCdT5IFslrUJH5/ldhNVhV6xYWUthrOIppv7Y8kBtZdevqAkpzI
         BDRFsu2jrF+YCozPia7EV1j3KLeZC6Lnc8BgBdPYFaePytvbOESC0m4eRkryqhoEbPxE
         WM5n2Fa2IGRg+WkSIkgfyoTemIrDdEbfzZV+2Eacmamzzj+t+HuCPRqV+GPswkKxuMa/
         2fm9UdrHUV6v7jtlgmqycAcrxGUcSbURHcUFMMj9LS/XjgTFJtp8hDDDARovdS596Fjm
         xwkar34XXNuYsLWY+RNo1AZ45FE/L69efZRvwjPbSAF3CGRgr3AaMHZz6Kf/cz8pCVs/
         RhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=Zk4l6CKTcnpKVwV3DJHPbEqwCPZ89teI6i9VzenpT1SgKhAd/BsGxY42FRRWF9fnEb
         xUwg0hjR5Sz7pp5/x3ZewaG0YMIDHu14hKSjSw+9TTM3X2RKkCK2lqoy73bCmWdlYk+U
         PKN0Db6hZXOkggO+og+WWupgh+tbSs4aISvaNyYKpMjoZe9jNPbDO5SixCRmo0A53ZiB
         YiQkeagzkw9rvlQOPRujzdnCidggtq+toHzzNWhD47sjyNKt4aLt+TPtmXAm6c+dfxmp
         +P/vXeajagKSCkZCEwCx+s3ebrr/QBZS/4t4fgOTV3FNnNKSNE0VT/44VavE/4ahQtTl
         OjOw==
X-Forwarded-Encrypted: i=1; AL+hErE7jJpIMiACP81hgScWJt60gbZd/2YPF21UZI0FHoYTVE/4cBgiEUC1NICVmKg485pK6In7lOQFfyuB@vger.kernel.org
X-Gm-Message-State: APuU4Z+qIbflz3aGTGsvnPZ7F8niy61fsL+kQHqMB2DmJgL5J+Pez95g
	V9wUtIcvShKPsHbIr6rOx/y5Xw0I4Gh+Ye4nlwnTsvKdt6OvcBm5M/WW0y3sPQYJ69P9
X-Gm-Gg: AYBFou2XyeGRDSEr2X9JOfdXXGObVL1XXQZIRJJiiUL4lyI0xZ2E1ZM/CW8Yoj1d4m4
	lQCeiKFoeU3tPYQmXotedYI3WrB25C/PxRcNvbtJlwU/+bDEqgdyPhPPmVQFGcDkCvX7T26u2PY
	IqYJe4ulFuaY9G2zRJHRlEcuzBZmkSMgsyRPoFRbvDCAXcLoBtYVGfvovjV4KADyWTcU9Q1lp+L
	BCIFleDoFB4lL0pHZpCMF2tQ+2+c+kgDvLDeB5I/2k1SmNIRGZSHwVsasZqDrHKHXoVoCgOxEBe
	73C90dbxY/kuQnujUzCgF8I3H3s8v2HrNlOBUqYfNsUf1OHKoIw6bTwQ07ih20+TGf7UjeJcFEZ
	Y02KM4P2icq/OkwMdG88LgEDm/op+IcpNJSdNc/hOmBu7opxJ2lvn52Xfybu2ZyPbI2sSy+Bqbq
	nop1IuDRs9ctPT0XWCc5JqESlMT3kePIVtb/nFGJTXtdVG0FrDdtXU280sjgpEPfy87YW/tZa3L
	PAMcpvbicZIsGvDtHTX481AsV5HtKKxeuXuUNhX+QZ4E3x+URMtHM3RWZc8PT7hrdjZwA/7OOw1
	vZl/7oRFU3J8IGAwKanHeLnZWKn+7qkWnge8Z+fB9yxWfryX3Z0LQ3VbNtkJkePdHZSXxvEbB0K
	A5ozejPVx9Ya2vcfqAAIttVJXL0tJ5agrEOLlwznxqNNbxY9EjiIoqQ5Z
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
