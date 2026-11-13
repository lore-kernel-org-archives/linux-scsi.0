Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564808;
	b=rH1hwmo4vyUqzNkqhkyyfn/rTbyhL0ogKx87M4Jf0bbYg7sMH0XaIchrwPZzkYzrABwd
	 aGI0SVOK0QoOjaS159z+CzFbfOCgLXyhk4BzsA+R0hS5ByJzbsWJSsixp9ijrTcLfUqoD
	 EHl/awPPdpwABkgED01QEFPg3TDrXa+xgPEh1LlM8mk6GOBbUahY9lhVzqcr7S2OAjuHx
	 b9hIrG39h/CQAH4ZMzIKgFe4NBGj1tnZRS7seqC32++2X/7BP2RzCLOvMYPB9i/jTKQmK
	 K7KxKvP2TBktEgJiV39aKhGe2+IaZXT/4z+VzJR/J71EzHEqNqqaQe/cVb+S2S4t7Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	b=0iPoQutiyND4p+2xcZ/yHqzRr5fKbK7O1nXAS/3lwp/GEbZAHWAamXY7AwW5UOf1+nz0
	 Mwspd6eScJUsB0zdMDpTUP48RjjG5iaoZ2Y9Sr0oLl/3jSiS2H0LcaA2wzqAzhMMfSMDa
	 2Eg73RdO+xZRtn3Yz60EA8B3kPTt07FFT7biLQwoTR+DZQflPwiC3NxOOWYBTJlKLzKyO
	 KGPJKCyvst6MoyYH8hpSMBzP8wDDsJk93TXdAXWEMKOD/b2pvzO6WWAvUWY5cg8e6gxHt
	 oa8+tt6mlJkduJhbfA/xd2CqefcdT7o6qgl5V/FqD+7iIWICxjpK6J3xH6gSfEOnPwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA14C606A339
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA14C606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso10214355e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=rqBNEWhefqtER2dpEJNVPTElbe19fVdkNyIzbVbNULqUnWk9JP4TtodfrAxZg35Ufq
         +ciPTMXXDC3Fn73QdDq1nxL10hoZ0LEMTSuk+HTluWLCH3mNQBpp5ecm/W/Lr1PQghIv
         NQThaRjLVubmwKFzY9W4H2pkvpw752j1vTd8XwcKuq70wsUgwzLrChjclsxLFe4j6CXh
         P2+zI4RYwkyiSmtYnxi7mmM5Yw0kfqLENKBervoD5JNkytp6QIULxp+qmuf3k5WOFN+d
         HC6ACfaHkSpUVoBZwd9XYoAangfmrtxV8FymQjjH9iY0qoozDauX1oxEdXhYxV5zTWYW
         c/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=BmHxZjWJgbuejBYizvpU44PKvFqnDNyC/JLDEvopfFphpVZ7HmAV7QnRzOWaXBuGLh
         Vk3DFT8ntjfU+QfNdJsNoJOfzkT4yz9HWmhrWGx42AzEiJkySLsoULbFMqet2u93nhBT
         7aiAwL3angPcHLoAAo98S60UAglAeAZRHGLMZn5ER+cHKJC91FrwvQWHLjtXeDQLJ5y6
         XRy48Ku36tBEdXGNpaI5OHB2V0GkI1H2l3MXBjhRBzGALLL7i+EE1qGpcqI/FawdksEh
         vOROj4PLc6oKDeNjryIJ2SvdeE08fKlIgn8cW18eLYoAaYz2SCbBtoXtV9vMCOGEbHfg
         6lLg==
X-Forwarded-Encrypted: i=1; AL+hErEHO6v/X/fbhxKJONDTmxpZWudr70br0jOQo8enFxlitl5SF0Tj5lEsZKA/qlgAKdgKar4UdyTJkESH@vger.kernel.org
X-Gm-Message-State: APuU4Z/f6AqwK2FvC8tetfrP1gavPnjgYNFltxCal0XtL35iuaaDhtIm
	AncLLl+RCuSExlx9UuirjjLXJZFjcBQEH4hFncGTWNG21EVzQkHIOvi0WAcREw1PTWVI
X-Gm-Gg: AYBFou1dSVbebVuTqTJAglWV4fsxysmxgBu+zRnx/glf0tNZV7Cp31bnRGfc61tpdbf
	4ZZC3MGfaGdeU/X1BcnZyd9iuaPdTcZ6ra0SeFQSUG5IcllgKNYDFwLQOly9OQzGQBOJqcQSPqi
	ijw8J7jSAcwvEqetYFF2h7RDhZrL8MWNrWSqQWoynOqx/Ndr3NjWDxUttXqddcrmMLsU2zACwMr
	dJR5QHbuOsvyutN+2i4aQh4JxJ4yiOFd4cfejZUibvuvzfaT9QffD2I8twrIIFdR6SUvUVf7jXp
	gSphbN+ylaC2msmDz9ogUyx5uv2tZkFZ5H+Gsklcp1tjJP9njt4+Vud8tF+N3vx93+n1ZsKfPWV
	8A7IS/kMy328G2pelXjb79chpr13dxJPN950/kuDBX9faPdSCYdG8f32ac2UipBbcUJLuwZcSmz
	Q51W1Y5mFrWx89Zi6tOwsdkFCU2vamwtmxpjQnD2QXjQSzxxgIWLOqMwnwy6Sh0YvJAc03SrajR
	U5SahbLOfTdrnrYmhPPcajgnQjxPBVtQutQPNrbchcwZYpHbqGL52bHBuRT7HEQncozC2YV23Oy
	FBbvc+1Cg0Tfky+SI2F6s8mYyBTdLPDmFk0U/DqTk4KDaaMmO1AtGM5J59Hsuzs=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
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
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}
