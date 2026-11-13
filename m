Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564728;
	b=y+FWiOQKztOO1Jye/NHMVaZ6WEv8LKcTdHI+9qR4AX6fSd9891BWhSaLfBqQIxIul/96
	 /4z83YmpxoSBR90Iia3scJoU6iozFXPW72YdONeFoPXD/Um5ri6Jy0tdByqPLqYBokQzU
	 tLDRKdpS6qJ+hA1rf3FBfz3qKmjSSm57vIDFj66vQZ/wPcvuX3bK9vOzciKe82SQ06G8N
	 IqLXPxAYPaANei9eezYrEctsPnEXNp+Sq4X4Nk6jmXsqaSBlFVZ35A4HzMJM8+SkgEZKU
	 6N8PYf9OjGN5kGarS6I285dPYOwQg/qQkzKVcms7KEYR1rI/x0BkcwJM0JuUsGzSukA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	b=a0xFGlIh+kBF5QiKGzs10ZHbu3l2v0ZQ70kuO1yQ8kf7JoSear3k79hdwGXhgI/wwpqZ
	 DOGAoo5KqA3+D9VivH3/HnWGD2XXhij0rtMxgBqwjPOazob6rsYo6SIzJYDqket4F/NYc
	 aTK1Eryb3/eaj1bc0eqnob/9b2XkxuqY+YFtPndW08qu9NbZwIDYd/pNOyBJp1L01+A8R
	 y+p+nR+jPxvW0CUmTJ73pF5SDdSEsKArMcQgJHJ/z5qqhOfI3m2alybiOd4IF6aLsf+gX
	 KmvMJHU3lNkcc2nHRXVo84TIDpv+GLa6JEJUdHkYl/DJYH9eEiI5yNRtqGapMk/lqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8216606A888
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8216606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso13097915e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=JofFrwonLml2YmEXhdcViuKQhdgodt9TPfkjQoH5bRE5MuhkX9eapeBcuLoN9BMOMG
         mg62x7tr1NIo2ce3//xfxGBo2Glw1JnMwrRUE5PKg9cgXRmANAsmerUzgfn4I+APSoic
         nLUkrr6h7Ej/6ZnsBOEx8OEPXrCx3CvMaGkTszs9w9WOs3gF62hftbL3MH/tr8iwAkM5
         IEqdn+20vI39qrHT5Lu5B20ux21tBPJwfptIyU9tNUhlU5QyFDk51k8ZhbiJowoQswf0
         13eatahih0uhEB44iQMwucAarD0vNvZBAG3aTkRmepVuKD8cgol5N6Bgv+DPTP+kX4Yt
         YdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=eWA9juPvOhRRUE8yOYH5OCYoQ33hI5Tb1+iTD3g+tzgUeCZLzLYeHpA4s0tK3hPzRR
         5hw1ucIh2HWkBkcYcvmGVqkd4LXMXL3VRZKcdQjoCyXolTBz+R8NmEOzZuBVP3o53+YG
         DYufRQXqUMwu3dLfUVCxpcuuHlCz1ZVjBUF1Vqr0P8J22NJDVgGXp7qhUWi0BoHEW854
         +6R2oFfIOLTxH3oL9SCnAfZcYGRd35QkYt/a7BnDimmMgvy9nG689jtKAFO3+gOytcYl
         rMIGOMqr6g3bhzdG4IXb1Yd/zUyOupnI6gBu7sSUUbbjC3zTpvXHgUowkKrII4tnPedS
         onFw==
X-Forwarded-Encrypted: i=1; AL+hErEM5ZBalh2xM3z/g0GQrPI3JvbtGFxn7Zh/nBcjyqH3MgV824HbQTvGi4lj8DZR7hExEkF6ig8IGMNR@vger.kernel.org
X-Gm-Message-State: APuU4Z9QvalJ4iMoJA99EScAFKOMqYBSIaEZlV8R+4v/1GU3QNxJdW7N
	80hdMG1YValsuPLKHefMUH+u0Aard8uvSVVnR2KbdlL98KpFCf210pO64zYH2zfF6aEl
X-Gm-Gg: AYBFou3nzlN53x2Nb44paZcU2lXIT/U86dAfHGBNIatNmot8llM19ikayRkeGURyeRX
	0fnl8NXyFOZ3iN1URbkXwGZxn7mebgRq2binVisdMkICjQ9g4rAgdWdyAoqS53c5DE5hTgaT1Kr
	HJxtxcRGcLI5cWcs0RsYpTWuOJtBsGzl6ORc03OBvpQwGiOk+SYLFH5eZF6Ljnqo+HNYYtRVtmr
	SSOM0KZC4v6AytiX0v4REuPrQKIFt11kw8bRVnVX3UefhaN850Inzi/wDU4WXdz6R1wbCudsvvy
	E0bsAL5ASs9Wy2HqLisWWcc8Uvual+fUJjthNmfWLvmo5fUNnjvgwem1WNPC+lEP0ahqvP5M++d
	xOsLmoMIBCeL0WueesODMP3Z2I83xcbZmvxoZZ06QTQdEluHxKIAKYiy2AQzNn2FXGM/qgOUgaB
	7p0LCRskX0GtNUGp6JLzrdzuspbKJK6f74zKw52z9fDS6mPd3lIdJCEw1OsqNRQOLMGcTaVdAtp
	8dXB7kaiiUFWT2o0zrVwTeDbS/Vkv1IMssFkbgJIYvg9s5CQ4MTuGonmTYcaZ6qn85nHohtxCua
	jEo8sCrViV2ssgaJQAQElV2juS9TYZKqpeKLB4OXK2hBvsXJk0wqHXgVyaTcYbmh43x/fu+tKUY
	eVSRkc1qs
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}
