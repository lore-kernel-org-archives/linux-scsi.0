Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564378;
	b=2sfDIcVUiJTr+foNStvRoR4cm9qIr2lJ7WxeCWFVJI8bL1cs0D6TDwGQkZJ9rtPgTjBi
	 /R5QBmyN6d/wMiyXL+bXZ9sdEjyc/y/XRObbTLbfyyLsNzJLJyYPwcgX1fJazPyBg9A2y
	 ENr+M9S7dYH360Np+vgewsSkvYaITLRWpfbvVjWV0nhvmfD7S2gVozkXUaMmx4bFQLXWH
	 HZuXZ3XPo3uwgVj14wm8iYNM0Pp7Xp3Bmja6B7jqrs5VvyGAImZEIJgE22UkS+fGP5HVl
	 Z/TljEsvg1ulyHebS2NZczZpSnb4aeZtrP7heMdyUbt7JEMEGiAwV5ZyjyUlaC8hsqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
	b=Ax5cxo2yRfMaCiTwowL7zBdHGT00abFzUfzVehgdI+d3gFydVb+pd8ambc6l+74TjSOT
	 5K5QAEuzNYdxkj3zJK4JQlXonDlfOlSNePUUUihvGAXMlf4D+4sF9uJXPP71ksyGWSmxK
	 T6ugFsGeZMeExbDM+up/jNL9YTLmzP4mTwPj5syU1thELAsmErzeBXXWmpWlPZGkkU81n
	 +sW6S73jAIQw3awRcRtUSnmcFj+Pk6CXsif0YXzBlKIkHLPELD8T6fay0TmSmpXNPYneH
	 5ZhbDzKtsmekmzLUtEhUG2YXlrPwYANKA2C2ofm+kZe93k35nYePyTw5KmHK9X7RiHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WDdVkHgl;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76AA606A89C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B76AA606A89C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WDdVkHgl
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b6e8b6d424so1596905a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564376; x=1795169176; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=WDdVkHgloKbBDmiudlEZ3ZWe+zg0BVZ0Jxwgdy+X6nc8ZJ9FIVi7F/SYJVqBRxNf3G
         3Gnq29xgDZdSKYiYaDVmU8W0xCuGm4Eu82rb/A8U6D5iLEOgHTmlDog4vSfdCU82B9rm
         qMGycG7Kl4j8h61zt+kqUkohzwqy0DPARMdjq2hKw51hdb6jylA1cwqwSD8nreSBsEB9
         DkDXk5ueYK99P4pH+jY8EwMoZnNW6BehoecLG+1JSq6wWJXsZMYgAdKGybKKFJkxuO0p
         O8Ri4u2My3QdIqEe8fwKAquZP0382+IuLTCd4KpBNa7znuGAHwPb5rxafjOggGTtG7Td
         r9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564376; x=1795169176;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=jdDe2p9BJhYWgBzOfaR5Fni++v/2YNX7lGDkJWpZ1jDRD+pOJwuxLcHpk+G+HOBAAu
         GJzBUhG5UL8ka9xIN3rmlQtfFF0TgdUgxg5qrk9QmreTgr096EXleAT7cO1LS1EWSa41
         SZ1hWmoP8D4rT/a5N/L+VyS0YaMmFOcPVTtdpF2pUUzx4SKpwBuLZNm7ZXs9/HIKiBXx
         Z6hFyzF6Q+4pDje2K0hI+F/c8jDg5JUpQjZU6PHhIAgBm18+J2fNM9dQ3h6Q3AwpKYrL
         NM5u9aZ/BNqamOk2H8+c7Exw3lLffhHcWcj/7Qsc3K0QXBFVcXlQsPgykBTN6+DQ2C6K
         Q8OQ==
X-Forwarded-Encrypted: i=1; AL+hErHPk/PVazg0TCrLDWPJZfIOq3T36wt0KB1laW8V6R9AImIZ0Lp3TeCK9xbXrZeA3elgAtYwO9oSKpl8@vger.kernel.org
X-Gm-Message-State: APuU4Z9KYBRNGR4pEUe6j89V4qdhw/s+Sig0lQc5M/F5wxOn36ppp3UD
	g753UPoJ6hval/OWxN2ROkVUZb/PKmMNg7P+KHBWx779sIx7jRbNJRE8+ebGiHipHBsd
X-Gm-Gg: AYBFou291iC+fEDUHiYk2W6hLS58qrI7O1mxWXVCXxpJbjAhSSenQDjBl6JCLvGbIgb
	mmw3g1reO12fVtgD/zSiHJTRamWPA+6d2wf6L/3UoDK4A432ln78ASyQ79JAy25hdvTncG3g0by
	aSGTuxTUWlYPRkAT7is6jEytiFujd65A8YcmvSKZvToadDZ5KiYcQX0UXORJJsTTmljZ9ElWcCe
	12mp3gKT1X0vw7TMeqCJ/X8NdKcb49w/VhrYbmAWK3wdTR8GZocllSJzEv/otVV40GSAV4s2RSy
	Z+gzkYYx25iiZQKanHCxYeHqkjwPbF9YzpNEF10hXsUXjeUw2C0pgtlO5RsH4XHrS94QtJY2GL0
	pEOTeaf1qu0yMpLpMkDaW+DKf4O4GGvXbdzmd4KHS0D2YYIYwawzCAWbxaydmb/a+NR+VcFVhnT
	nM5yL1O5sODIHp67e620b72uiK7lYNZZgdh2VAtQIlxjjmiNvShwu57i8qR94Ol7erf5IKY9vs0
	oORdS3E9XzuWOhgP3RdI6MYYmZK+KO2Q/YzzI3CbP1CmOpf2JyNO0mwR0SvD38Jj9BUw7GJd77a
	OlTMKwYsayCerYvTRvDk7a9YO1fIwdbs2OjPLzLDTYnFo1mgcVc8ecm2+4U0WgY=
X-Received: by 2002:a05:6402:280d:b0:6b6:4dcd:967e with SMTP id 4fb4d7f45d1cf-6b7c0bbc394mr1685420a12.20.1794564376161;
        Fri, 13 Nov 2026 02:06:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm706711a12.4.2026.11.13.02.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:15 -0800 (PST)
Message-ID: <4dfa19dd41ec1a202182284d9617926a259288a7.camel@amutable.com>
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:06:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/configfs/mount.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations
> configfs_context_ops =3D {
> =C2=A0
> =C2=A0static int configfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &configfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
