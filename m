Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564237;
	b=QXaV/NlhN6xLM1kemje78fBxB3erhGJiHksv6fVR3QQEPQU4pqNQyxwoEWPkSIawScOd
	 w98ff/AAeL0CF6y2xkhsrf5Ixflrh2T/dk1AcIuRWheQhIfBlFJ9FRaPBTAABWS6zYm7W
	 isGILk7aZPPBwrtmykU47NkoB6NrvpacM74lBJaO42yNA3PV8t9IWQ8xzPNGReG6Qk4ih
	 a7NK3iWUlT4kQ7w1K0vGKnl2noG0hwKj873aOH2r4rPSuQwbNwrxoxxab1+mVue5R8+By
	 DjgrBhIGA8U7/oVG3893VKCVvGwN9nhFdoN4EwlX7taC+H2QhDT9Kfc3nNyA0GLSHyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	b=ZHn1bg71+AbrW2AWwA1EC3ovSub86OjG4sOw4urgB2igfsgctKX41qwnyQcFkSYH5sjx
	 bbkJlJJuc7JXvrNPv+CkZnu47B2QrmJPRwPxyEB/9VOUxOgfX/c3wIvvSh/xC9LpXCT6i
	 TEtfmPwCG7tW0CoV6a2nGgSiYXaPbNMe0sOUo2Fg1MqmiXJlr7x/trfdaucQH8N9diSWO
	 95OGlsREpkPr/61BKTxU87fL05RlEU+b/4ruxMooAVsL5CL5O1a3rbU/5803PbhfyEH93
	 l/0VQk+Zqicq8j6X39sjF3CfqjTvkD3HAvGrRuWotCB//H6xCUbTRpXJy6Yb2QqgSDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C56606A88B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2C56606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b56c428212so1145029a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=HmOhZp1aysVRSGcApaAZDLI81xyeSldeu7ePLUPKkH54FsFfnK+QDVFY4+VQQZDD5I
         H2HloBZm5LZmO+0yz1W9rfEhaL+YICMUwpLNmuFaGXNfAv5LYB2fsAN36refSeHGX9fO
         cryYVQ+kM2KCw8u+OcP3112ltvgpCHGvfl9d9GfdLtqmNcwNDmKz3KTPAT46qO03zj8M
         uuWZNkUaGTWe7Ooua9eiEAKQiiHx3qf0rn/l3lNWMOa2sfege5hzg+R5XNTSj8AN0bpY
         dCBAZCrR4vjcQdomnF2hzC3FA98LaruL1WYTiCQ1DC9kzlEXZqoLyeQdM7U6VrMRD1VV
         Lr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=wyhjjLNiXi07UzXss1InsvtLxlNCvggl1YoSTJNX4UbtW96J+LVA8xf3vyqD6hJl1c
         ICknBbpBkn8Jqu2J39OLqW86ntZymW3azX/0BH5JUJQc1ZDdmhfPirT0wSYKqj3cZjXm
         th3m7cLLQb0+csgyliMzBOuc4w8AQxutwqi8W1+20h7q/U+nJZ25MIu/ZY/D50K9KaC2
         Omeb9mmbCt0FtBRNGlsPn28qfVQqPIUByKHeCIhxy2XOSC/rHvWakMJ+qPqmQfTguMqH
         HFjne2RBap2aBBGktMSHy68nFYRxprScFRkSN1cDM8V+ljptuGxOXv68LUwv9Xzu1Wp5
         Du8Q==
X-Forwarded-Encrypted: i=1; AL+hErE8GWNJzeazxw8T2C5UE43cXSBh6HP2oR09N9gWfWJXp+5TsH60TxHGBahSwRFrkCfeIelR1p/fnAoq@vger.kernel.org
X-Gm-Message-State: APuU4Z/V8zDLDbmYpgWMuinOzSnsldACZo2/HUn6xH67orBy+j+CRrcB
	ALu87SxXpgcJflSnXzkuhYVBunG6B5MOHoDYRpW1+nzCF+XksPKnKK5LZ/OlILMiCVdr
X-Gm-Gg: AYBFou37DVQH0clcOgSsmWamZY17xzxsQYe4Nd3cTehioFIIIk9BGnkeIEqQIbA3ODa
	nBHgmIsZcgXzboi5ZntDAwn6y/k7EsF558MurZatJLrJ9Jb9+DZiSnv75CljeJTXU5Crm73MONq
	vockDPeQWLadnP7TMPCPfeBkhAE1uxvTTC3bNn1PqnGg99sK1S37OMZzKSo+3Fg7Mvq2mem70ne
	V3H6T/2NlXxwiUcmfYCeSCHrsHCJgUGNpWpWvmckqIBAULC9NJ6Yi1HSGxmgyorXWxmnVDtuz1M
	hH5WAbSk8n4LzYsEXsmYgQxpfpStb0CSHRKqYm/9nRlAU1UN07sWnJpleyVj5cyR9KMfV8XGIaJ
	wnnnqlGW1BfmF4AGiq3+aq3cuDskoNWaeR43ndmkJJZweaYwG9vTtRoCzEfKHHbM4lPgxByxkFP
	IY1KmFb9JPqQ2Uj0kuaS7lUMKaWLaSoLcdMJhcgPz4FfoEBa8xoUuZFCDpLGxnCTcYdYhAElyxT
	Ou1nQpbBxS8QtEqfPJ7O5fPcG1hfQXeAxUi8mB0I8THlhDmH4Y2YAoEzQRfFvY9Jjy6dTyR8Gyp
	CaX5eYeIoalytIQXJScWw1x3HsvT1eVuivuQY5bD2n85R3hPu8vn8yp0cOmGHOQ=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
