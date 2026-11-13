Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564206;
	b=p4UF00n39YkMszo9FCoTX6wfaMV+V1nlgZu2ziXfqkL0JVkyMHvjllTmlHRHN2GFMpzJ
	 +CEiEMhyh7vKwwkSsBg44XCHynGllSkNgUtEA31PSL4Oq53w3xIQy5ioe9Mbx42LMoNiC
	 ZQaGcE7kMlhYjk4IgRDL57q61riNX8c4gXmh5EVlcRbpLxoZbEBbyrSmH+vTcjw6fUrDM
	 UNB4qi0Th0zFo3Nl2pPK44/oEtJXMDcgkQjJM72Tvqb4wiW9IZ3EkkDLvALocfwkQ6ioK
	 XI3Vr6hZA8aUKa33gDtWQHXWCoIZHXYd16QMTFoYnSp/4ao3LoyzQ7sWUg6h57mDwJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
	b=4yiAURbSOo8M2LfPIy2TOT9WKeKS/V5yObpCzMlSBbl5qbXcuRVIDFDug5S8r6WDUaof
	 MYxufqRwaOPGGJ3ioN3Mv4qYfpOrjtFbUvHf7pkajeBQPWeLJXHcXA06r5L7jH+2ErzIA
	 n3TF2M610A8f+GFZGGTeZOr1Av6fdNO3tAaoRl3dC490UtG1Ao5r+Uir+kNamDFsx123m
	 jFe+g5U+oEjja28NJXs5ktZ8pK16bNCmJ86czGi5YItodWjRpUXoD3hy8nosawHKtAlZL
	 wIvbgvFnmRD9+Ne48a5VwvheBTgXs8682Cjmx0EFXUQ5C/0DXB7BiC3Etd+Kd4B0qKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gwzE4vcd;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4B360A260D
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE4B360A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gwzE4vcd
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b570ff3dfdso980498a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564204; x=1795169004; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=gwzE4vcdu75novdCBouGsk6add5G1MbU4rjoUAUKLfhHjN16JXpL3TW62te0KeNQ4h
         CFkYIh/ZmfunLC+OqOwxPpTEErLMClrM1fcYGPQemfzJ8eoNcG0IRaMTNTZVl4uFMmTY
         NY1KgETdjv8quXYbE0ixE9wDZSzgcrDYvO5KUD1dPMwQkdJqOZ2wE5l6rVs/yjm1Qi5n
         44DBR0sdjAGKBFCF4ajO9UcYXSr02RfqiQv/3Y8VdogG9ka76OpTkDSlKx1J0txrvJw5
         RvPlb1UdQfd5RzPQ+F4LJqddQeogWrPEdkR1aa5XunF4ZwrUyeTcEOKG0iN98ugSQ46P
         5SDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564204; x=1795169004;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=bOLumizuKzVMjyD3/AdfEyIk0dKTQ4SL88arNvTu9yMyajUCjzc8fgb9Xi0me9rmJZ
         YcB1QY+xbLEouGZWPbduJzJCORK54K445oWE4upoRsKE8a9Mo5j08ksARjDhc4onakXA
         Tx+edSDGcTzRRohtXd6pKpGcTTS+QwhfFuK/w9gg6s5sgLvGIGUVaADaeMfv1tnq957b
         0HKNJxtxRw1/XzxNqlJ1ng5+PqvrA2TWoKff8Ry4tMg8wrKAN3P/DXzoiCwIHeO7pSG0
         pVa9bQgzF9U/bXd/3HBco/307QJxJixFM/UwUhV7IGHqqffx7abW8psw4KdANboXnU7e
         drWQ==
X-Forwarded-Encrypted: i=1; AL+hErHnypPbhYKUMrK8eU0UnTAg7ISA6/uZGUnobBmEmk3pFIa9Faw+Juxf2c8J2aw9XKqoAUI7nmCiQdTp@vger.kernel.org
X-Gm-Message-State: APuU4Z97NbuLus4zOQp+2KIgFUpAAB8t9OZCQwWDZGDbeJKaevtILeJ8
	3Hbt0lZL8BKXPt9xpjqljSvh7L8HRoNLqEjOQW2r4uM/8tnGqzGS7148hlEjRL95OzEA
X-Gm-Gg: AYBFou2XY50QBFxqLhJr5yqPAuiR9rd3IVFVUL3YEoYgcVBOyOY3IvFyWuvqjzKGADW
	MVKbKlOsTZ+Cn+ABg/9gTRxIN6rLXBnDTV2hESdWuIWVEvjCub0dXe9eahb0EHMbXZyxgAxowJz
	JbMr057OUJGG5d0Ck+8AFmMQ7qcRSx5EyEH5OR6OfhPoxSfTJ43T3896OQ4WqR4tsHfDDoRazK+
	wxP/RGcxTpEEXKS5BAR5PRb6GxG/gavXRm8Cw91DkNf5g7at1NoF2RZYZ+HZ3M/jQBiNyFKj7jG
	USwOhio+V3j92AqVKw2equ7OKsAZuAzm9iQiE3353ce6/ADYDY9TurPchm8dDwtwlh7yvgCPIEh
	7wFcjRkaFxWJJ5W2fTzT6SuOOn4ign9Wik436WWjXB4ivUPXzvwHOfUjrE4Wj9mxoNEkf5uDFdf
	hP2QXlQWeT1WexrOLn8DZWG841f3+hKohM3Sy9m/YV4mrtzcWB32narCebwM6b+tOAZgVSME3tX
	DcQ+W97ixLwGEXRxmIeM13YZHiDWC9f50V67e8DDwBRZg3iBoq27v5K9tExonNc8qCLbZI8mLkV
	gAmI8N1eXmpghjVDzTbNsXifpyQmObZXql+1IKFwImaFovd9KefizQ4nC6DfvcQ=
X-Received: by 2002:a05:6402:270d:b0:6b7:d479:654a with SMTP id 4fb4d7f45d1cf-6b7d47965e6mr298323a12.36.1794564203570;
        Fri, 13 Nov 2026 02:03:23 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236124esm752333a12.6.2026.11.13.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:22 -0800 (PST)
Message-ID: <e5f36cc53b733383ac1d1f1e8c03f73091595edf.camel@amutable.com>
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:20 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
> Initialize mqueue as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0ipc/mqueue.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 322c3dd98c44..8bbe32d0881f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/sysctl.h>
> =C2=A0#include <linux/poll.h>
> @@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	struct inode *inode;
> =C2=A0	struct ipc_namespace *ns =3D sb->s_fs_info;
> =C2=A0
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D MQUEUE_MAGIC;
> @@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct
> fs_context *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->ipc_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &mqueue_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
