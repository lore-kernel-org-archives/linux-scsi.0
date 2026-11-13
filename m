Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564190;
	b=FXUO+SsIeYLMUpmG6BfQ4F+rJ4brEIJhIh3wGTdC2cKFyfQjPoFX+Kp8y1VIiKcJtDib
	 fdmk+wQioET9J3SMomkbDcR1qXtlmhxbXrDEU7baKjPh9QEYY7N0y4mWiKCAMMlOoX2l/
	 f4fyUEOZfN+gZlmcDOrkHGrJ0YRTjXO205uuCwauXGJjJFa8my9MGEyYAQcWm2LXy9GHA
	 rmOSGYfcXH7fKeX5e9944OpBGApxpftc2zfmRHr4R4n28PyVt8slUkLuVrGQ1c1zZ9C5D
	 WR1548gz8XIBNBaIz+3j0iublPKthVdQvT0Ntv9WZye4XJ70US65mi9VKNGyMHcow1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	b=v06Yy/0oZ+0vGNYJ5EPli7ZK193P21vKHt6N0KPmfLliZcB+idN1ivSGaCwId9LOQmNQ
	 0l1EzxGzE/O66lerPKD4CCugw2RdhlBXFo+FvxQeQS3UArSfM+hg0H09Bv4T3omoZwFUQ
	 krNulDsJL4iUma0RTacYQ6op9lmbRoYDVHa3fnyr4Idwb5AzLpyOx/iZOgZ9DcPSJv1vf
	 x6hogePzbM0U7cLBVPtx62lSSxQqFSS+jn32/eMNx3Tq/8cLP3NwhPPA039Z0WDk6Js4f
	 K+SArBrxlAUBFDk0TYGmGV7gerjUvxMN0/Nmkyd2vc21Mv9sqaUY5VaagIeytGU0DSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B2606A8BF
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA8B2606A8BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4d581da0aaso117516766b.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=PwLaWWEZlovk3BcnO0ZG64105bcHT1OuSddm6BbnvIqxbrPzt9auj7esmk6BNbh6fX
         VcVz0Fb5EO25ZFbwJkkdsGMVKdakOQPzqU2f6LPhtUiDBhEZmXH+cAuxyn5j0/PSwsaT
         RO2aU2TU8aCmd84MLoXz7vnHjZWZq5qT0/Sc6gtTAg3UhyfQddRWFsH5ep7YUVPW4oOS
         ZJYdPFjeA/srAxsT7bXr7CLtpXwYO3HrhRePJ9C+1IlKmxOGPfhyvFsMUb4DHUYdYyHA
         n68GAxpj0xAii+OfqqKyb+8UpP8WFZF+WeKZ9rpWrZ/4EfgHnKqz0J1mnDjnDglQmq1u
         ISGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=NrbGt2Rghwd7jy7UUJ5+EJs3dhrkzq9RVk7Yc+cfeTmLoAum3/hSBj3BZFu7jleKhb
         57Xhb4zFEscN5azsV/ea+6bYUKlNJnyylH/URAv1Vql+PRJ4dFB+mBgkqJUMEtjEYbYd
         bHc09lcK9bCMcR41wsZdtaCm7lgNRiP9mXOEfxVZzdcb1R37Q7EB7XiUT9aL0ReeV3hK
         KcVvFy1MXx3/MVaa00gqrCg+NClVQf8B+OurYCbSrOV3P1djXI2+3meaLs70Y5fOH5xj
         4H4BiNfpsflkOy8mvoDcWSrZSjEd9rNwOs2rDWANtcfqptPtDWcPVUjb7no/u5rXjgTu
         7T6w==
X-Forwarded-Encrypted: i=1; AL+hErFyOJhmlbDMQoYB+uU7oWBXM5aYgHP6WMonzf3y1yqyyRFg4n+ZWx4fCT5wOqHg8ucI0C5jKJUphn20@vger.kernel.org
X-Gm-Message-State: APuU4Z8usuXO2h/PbbQuk6gTS7+SN8LcfgYNrH5rs5yETWdsOHg1ttbr
	feoAjfO0c0uePst5j/RdHv86MOercStytb5U8ApfV1d8mRtKJWaN9H/hcFn/T+rNlb3i
X-Gm-Gg: AYBFou0SSMBm9DrPS5T6Bg4YlYH/lR7Y6tY9LhP3sHw5msEWBNNltRM4um9BTXmYcPZ
	ZmlgVK1NQunoPJpXSiawM1AFkCYq3secLILYFsFaFUOJBElYbJbaa8qJBA8vApbP/rX4QVxaR5j
	3uMhPA7Y9mSR/Jr4DtOJyPzUd0tO4Gv5Ssycfxzw3N1BfZBPyjRk7qSqZ9Q96Px5rlcQ+zvKK2r
	vqMtO57JvF1kGbZC2bVK+YFsspzSRS6K5B++r6KXY8V9j17H/QoLoVLbT8n/ENr2NNyhUnHbgVv
	teZUl7+5+2nol6paN4uXtSHfdqW8I584QZ/TOD+U4Ul951GtrXOCZT7jxfM31b+NLvd0DFIiy3n
	NJ5ba+Uy1Sm3yI3ZiHVoA6y7xxVu0Ll2XkNkhmlYZFRUI08jebHZ7Utyc7X2e8MAZoxia0syHY6
	16+jaHaogwvLq3qc/ffs8+55J0ITXEYNgMwK10VGB+nuyNNXrsn8ztKOigrCB0xtaG+YyC8wyxI
	OJVKP5wfHhPhbv65ykV/DgKP7IQNLdsG8xXwq8cr1tjxrYYTE7135ydQQHTuXAR+e+0UGGojOmX
	EkCd2Ox339rA8ITBsTCUtRunAmUo7w3w30ofuWMVCVU126Xc
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}
