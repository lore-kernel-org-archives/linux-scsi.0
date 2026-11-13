Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564657;
	b=0wyIGVq4BSluklyd5vcE8/EIiHpO6Jl96W6ciP8gqtbmXf3K5WWWl+FRT7zrjl2IBiZC
	 jxb01E6GL23/0evS/219pfYAl/a4gRZBC8eMGUBfhHsI1uTtucEmse5CeAm7CQT7mPaEd
	 3XQ77bzrXlwf8C/s9FAbfMolgI0jGaocnde1nWl3gswhV2PNPAwADDTqZSL6SW4uljr6M
	 z/zLsjamqcIcoJzXuW/yGqZlVH74CpaZi2ZwdGD67qZ+lk4n1165M7oGw1Ah3iFq+xtpi
	 Emms/0NYOLiaAGy7bDuwKXuxi09Spe7gBzJkOR+ml+E8oJI0V2Rbwq5KD5DVCjvlIag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	b=KSHuPaIMU3Np5T6KFhDxw0M+hhjeqKHmimGYbRDESjuwc6IoWUKfRjmyWXIGgsL1ahXr
	 OGcgrW58XbxSctCO9CpXG5aBWURWSznG94gkb3g26Af26bfEZhvV9pDSqDTq14G+Qs+nZ
	 zJeVAnFKAGg4JPMJ56DbBYM5ot0qUFCknQ3OLyjUogMQeG7r+NUmC/VE3fm60VwS7xa8i
	 4vp+H2DLkatJjU70kKzI/h4TRXp9rUxZodgcE8Z9CIelAYXQo+q65VlfuiIFbBg4o9XXa
	 JsQYawdpvkHcJ2gXgqs1v4zuZZNpDxcMe1zFfkgqeX2qx7S/x0R0lLy9FQSSfv+UBIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62A606A33B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B62A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-490d59c3edaso395273f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=afSYRRYW0Lzg1RjNF5a8Z8fp4FTD8+wBAkqEEgX+uXVLN6iB/1Oe+S3s3pjBsHkfPy
         t+OYs+BeBV0n1jEyBb10NVx3dBSZolIBqoZV0sAqk1NmAyPkc8BtADcPrCcEDzdTW4+p
         zgkm0FzjpTOQt7I53MJB0zmRNwJ5JPK+9oiFhFL/qPiFq6x22bgZ8fSq9Se2ho9ikF+q
         rg0gx4TedCmdQu2h6zCkoXcFHWmQ+ZQsRVeKTv2sVCXhncyHGZ2k8DCVvoh7926dtvhd
         5w+l12l3Dd1UCqA4z70s6tomNhqNtGqcJuf3lRDB60cxVt/wNhZpOgzeegjchzcaCyfn
         tojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=CC2wL4YL7EsNPSMPtD2WMQqGXfiXrRK0a8uIp/Q3YMlQ2ktx4HU1k6gdTkB/ogMqYa
         sW1v+AlA6UYTVLIZxUTbWkEnvGO2KAi/70sVGsIcxV4LUKG435oZoMovbx3AtYlzyjLn
         lQhrdY9oftyO1vQX1lcusZ+jDbwevaue3ItawNjfkuWAPCl4BJ6iLzQoLXrPe6Neih2R
         OjMQnfsDitPk0SPkSkcUeLqbPfcHfr8asvs5HCuaioidUoxMXAD+R0eRM59hy969NFsS
         aTjYuIQo45PKBPjqrrQB7G8F5li6dzGXNokHzoY0Gf30vA39A9oeZRHhbd47TL/C+mfx
         bJrw==
X-Forwarded-Encrypted: i=1; AL+hErGavi23Qk7NB/c2FTjbJiFwsLF8WSZ9vDBjdd98q4aRoVmaP9Jy03js2zNISneE6Qgd7ezyH/xesuzi@vger.kernel.org
X-Gm-Message-State: APuU4Z8nfSVKDLRlEJrDIETtBnZAHYOgEOd9p58ALLnhP95od/slU7Db
	d0MB1N/yM04NeXtgFHC9kgt45ee+osUuByCJ1tlaE4rI4ue/8fI996mFUytvSr9i2Eog
X-Gm-Gg: AYBFou1POJqwAg/1kVoCTgRXyJxMwYSMVX0NAd80Fe+vs1qHxTBNnpemdKuq04d25Cj
	SpaWUUvqkFeknOaUn+RKn54ZiXiaUj+af/w34Ofz+hQwo120/3qJPmlh7FZMNLy8VkaI3B4Gb+V
	DNGS2s5dyx2O7Ur2ztT+mSTeoux78FS6GTDi2fl5dIKDzyy60askwdflyS+CLkN94g2l2OdJ5Q1
	+njOKNUtOmRfrxD8B3eFh2P5LYg0RB1hYhiY228LuPyebxHOyTgjoTonGR5X6EemU/yOssUnl7D
	rt9SuNfDE3+F2N7mHvyo2Ofrrqfo+yD9Wu4b9wMl0WP8jCHFlBJwk3eSYhehFBQgPAjwtL7eKHV
	5lZgQKEGjCzbcuvJtrhfP8r6nD9j6Ozo0z7RM38mGzgaEiUSGBytFKM7farKzOJu1Y335tC8BbV
	3j/m5bjhXIT3E32u/0VVaU7KwJqLEAX9PQjbLCDhA99WUucyo6fJTGr9qUwbMR7wP/SOR8uTgRn
	8nfiUqEFqd5tAwanRoo3f3H1Rlv/3q2FDDkc5plmqAVFaDPVivT+xOOXMh/sYSJcaI1WITf5vdX
	WfYZOYkmyQvtgPdOOJO35cXL5EknX0rXMuZrS3pRyo2Iqo5uJiPoA+hxBLY3ld8=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
