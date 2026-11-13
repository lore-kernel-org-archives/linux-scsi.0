Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564336;
	b=NHDH6eR70x2WLwsXHkSExTq7gpqPgUomP6vNRKJWU3tz4ePX4UxePH7KfnYyRqnr15sZ
	 YjRK761BUnJ+Ijy2vI0ZL/IDpS+WRZoLKIGnkaerMpTc2iB2m32JwCibwQYKc3sHqfaZ2
	 6PhXm+gs/ikPJVciODQ6s7PUj/BaR5H6AGIw2ykmgQgQbvoeA72O9UI4MuhQRQ1tloOo4
	 og6WhQ7jdhqDPqDz5tV9h3r5ju/MrW9VvcwhGaCz9SUZ5sZYF6rEl0zWZ5HpSVanEn69V
	 hlqg8x8OBsuZFpfZ7iaQ+uC/3uazd66pvqnUiXIshfALalmoNy4kFTv+zHSbuRYtLfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	b=VVTzlqnmFpUTcXA6DRlp4fDrzUMOt2xxf0ZAdxEaVuYwzf+oMSpzEnl4z0Cu8aWTnlDS
	 TYuXpVWpfNC30hVJpHsTZumEaN7loSMNw4qk1dUFNfi7/+5C0qq4lmKGKlk6MqcEqHeEi
	 9YRGfQ2I7nSpEM5LPHIVyZGj0PSeTdO5PDQ+tugApH+GEwa5sbXDu0yrx0GNISdnNiYST
	 bAWo0PHRGB7UH+Sl8uQ5E0WcKpONjEgLP0v84UMGZyML7VyOezgLkRue9suCUnFKCLyto
	 0qg3Ry8vI7aXF7z/ZuTw7gxcbcnx2vQbcEV3WYpQoUCowEIkXbzJmidWQVIULXhVzMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nN3frtS1;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BE8606A8A3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4BE8606A8A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nN3frtS1
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c45551fa84eso187355966b.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564334; x=1795169134; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=nN3frtS1dXU5gnwmqfzT8+bhaiQQmGH+o8SykyblXrC3qld0kuEs+6HEGC2rkpdv/S
         sQV16XdsqqZb3GM8OFjrvrple+atxGtcqxLFVKkGZ0Zd80qUKx/EPhy8mDGrZkmovYLQ
         gPE45P700sVxzONMsyf76aaH6Xk5KYIuezCkWASzF5DvGkP1gh+ZRYmtrnwRu9+hQOqa
         BqpjziGjGsV2LfHal3A39L3aaFb8qdjtC8kgwx4O/4F9AvhElCVGweiPQgw5f+yTyeo/
         j+w9LUu3B6WOr6fOKhMnpx/PfseHq+Dks7TfznRnFDL7kPCQ+qTR2Sh8LdlE9KHj9gsV
         IzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564334; x=1795169134;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=jQXTYvf7FKnkMWndppvaiJgVK9CuZuUmexuy5HL2cTXwXzI/UUh30Zvp3o/mkUxl4k
         2qPojFsSbXdU82yyCWQ51EQB3WWNtcbyo6v0fLrKl+gVVdK2zUEQW8tsW7EUzpJZIkBa
         LKFulLCH2TNF5iRCtfDtjx9bs8tuby9wHMvPQ62utbAwOdv2iCkiEnNYdz8n8tUQrZLa
         pIOYWD7tQFatlq+TintimDxIBOwkdN5tyRH92hvz+1QtGMYjh9AYOoNypCv4yw7qKZi1
         xoe4vbBcsNyVL9a4uGtSz3y1Ktoc7Jo6QtehPvbRKdH9/OfiBrd81MWt1G2wAv7+rZO9
         4ORQ==
X-Forwarded-Encrypted: i=1; AL+hErHK4/U8aQo0Luf1q6lax5EJHiArf+q3/VFjaCtCQLtRMUznon7rGv5KQlr6DQTq7+ahJwiX5bfyMx6a@vger.kernel.org
X-Gm-Message-State: APuU4Z9mg2WGaUpcnGov5+n0UZY0jZ6wZpwO2Vf9zhHwdqReZPRANUYs
	dSXrbYHJSJawN9JggMZfPtBiWWou+Jtyjmz3iDmNcYCmyK0aVzAmzWNvusUHijWO/m1iu4lIqMP
	WBCcwhoz6i78=
X-Gm-Gg: AYBFou2e8Hr27/A2bFnUT7nYaIt9vhBQUVl0brGkAbDY7s5LOGz+jxBarQ1OCKWwls+
	aHcyx8WzjOj0wtJfXQYBvjiMxHKAkSZ0uuIZkW2upna98Cvv/LqsITn278DCjqmr4760xLEtxhb
	ha6a2etV1G/T4MIqiOe22X1u0DjxtDZknEGzdwjnx//9NzKFqp1l9ypxgs6+R33PSOjw00DqT3F
	Ps10YKWbqcXCuT+AnkGt1JcvKYX+vZ/FIjh2RiVsm5wNb/ZYs1p4gCha53SR+pxqwwdtTY0vrID
	UnH88le6fGzUxYWja6Khm1xFt9uc8gC+X4+x3mjzZ5/TklIwK+i5DnUmWF0ETc9Bw+hnDy4CPzR
	ejUv40bK+M29eUvr8+0rVHA8ixMGkBkY7BhxKRWLw/RkcDSAN4M7cwiV8fV5oRUVsgqzKAYS37L
	YYeCcARw+bLRaVlXweTS8Pf0mLfu2OZ8NRzvnbmAO5+yaH++HfznqL39FZlwUoPnGxqDFPogF3V
	wtdwFiccr2a0fvcTWc+IYcODh58apmJ6MYj+McBroknMwk1ReF01Qmdx4tWBDjBXJlI8MYStiIp
	pFP+G41oNpoc8a5gBaV6vFDcp1RDhKrc+7TNmQtHzrILd39mmVa0NVfqE/p22qEtFeD4Ys2nNSm
	LOyhnw0w1
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}
