Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565073;
	b=zFAHYJM559mU1Ih5FTj2vMCCMHOYBHlRNnAArm+n5LrCAuhmIKpNT6ZFOHsvmmWUSTTc
	 lMRzG9KzEMsGNkK/oIQ750bCmg30mYyr9+6KpcLvEyTMlPvaD4fI01UYQP43I3dIwcjw8
	 pkS3wT1PgJ+5NPG/Dm2eL1qwA4m5UGIZVtHASxp2jZVHwxj5XxjsKlRYauA7ZfyAKbmBT
	 L6Cf58VoQWO/ryWXbbUG7AIorJ+mFZF6/ybS5YYO89B9I9+YgSA1izvf6HhvnHl8Go7x3
	 U+NJfkj0cQK7Gr61Mu/kzBw8h2J5Ap9F4r0tc9nXIIl9tgCYpPmd/eJGJWkt5TM4DBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	b=UyG7tyA8gXYVADkO0A5/Ik65hvKhmznh426mKQGOm9lzTxad+zAvxX/ywNJYMqa8vKtk
	 ulboRkLC31YmDDWXVWkMtOiVETIC0XD1ETwg9Nq60NEkk/a7bUZEKjH1dZr5AXbBsfJJh
	 kDNaHzXBFHO4ANvE93i8hLFS3sHqQxYMdZLdIIlprLJvjh9imydW7i/R8c9aGKL+AltOL
	 VY9ICCV81NV3Wr5d70hrma7fPrUrSxokU/4k2UK55uMHOQgYiV5Y+YUq6LzKAXY/dbLLj
	 zCLI5Upkp5+IqJjBz3UXA+Oo+aptHZvpjp62WgnKNVaUjNyPkvv7aUZ1XE4hlQN9Xdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4BF606A887
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E4BF606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10701235e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=hEEG7fG6RzQkOoGSL66zkn+hWpy0b8TxpW+CxGFBwGxbhLfdgmFqwESmbjaY7MScGa
         1TTEC4ZDzMo/nTmQbATUq4OC5CVK8FiegRjrCOceUr+V68t+3IyOPEhrmauT/typpuMH
         7BtZ7bLX9twnpc3pST7EzNdPnkg3BFhqHXhYG5RTwPNXEKUOMAEYxir+CLBCGEbp4xnq
         ot2tG8XA7sYEn5cZCga4RcL6w3I4tCQX2A1rGgTmCQohN7lvb4NCOhavzOt0i7fRXz7K
         0fiOYrUI/s1Mo3f+qCL5v2ciULr5WU1WUhy3OFmgCMCM2mU4bZM+JgAT1J65gELN03wt
         2Tdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=eTlpTcribZ02fkcSeml8IfWpKKSIo0RMIaIbiZ33NC+hkPV22noKoaS7As/EL9JEr3
         SaAQ9dmQYVfqSepOa0cpWW05DhRfEIR/+C7h7PkdIQ2fLpmH2NazHBVrgOI2qu6XfPAX
         YTJX6WSN5AhmG185170LvdxIquLtUgyvwoo09uB6B+pfXgyuFm05B2p5a3NHmnn1K5OR
         oyiaLrbQzZ+Q3A+GIf+Zk7Bq3wZRcCMGXD+k1GpltLkNtFBf8E59gDqSxrEGek857bKg
         Ih2eNFt2dO5QB8ewWAQhCJOI+L2JJ8sxnweruLilhWEoIjLDMevcNLhgNtx8Ef67Wo0K
         RxTQ==
X-Forwarded-Encrypted: i=1; AL+hErG7GCj+Zt/pryyQAEPJkQbBu4cL+l4uGyh1edVpvDgIYRQ/Lb253nLsQjM2W1fDVKnp7d4SWgjMFaEn@vger.kernel.org
X-Gm-Message-State: APuU4Z8+4Yg5nvua+wADviCIb1xs2Uxv+lt3RFAAWRTae/zXwvCWOnDv
	3gdj5NQC0UP538XNOfVfFBmT0UnTNKoR6y5+NJYtxtW9BfDhQzWpsY5FpbsRxJ2jaj8w
X-Gm-Gg: AYBFou3uS4FkVP65GGIrzAK1L9jV11moXMQO4mhWmNRlbZq7+Dq5VNubgtVbjYzm0I8
	TfTbXYCoHjKx1pfCPTqPn5rROAK+OVCwUZo/QivT/g4EVykkKAVxSDC1yMx9kw6KwBNNvE/TyzA
	Vh6roHkhlfsMqHZphCITHbFsyzGkrmwxtWqW2wfSTBSxOzNKY43jczG7VnaRHKR2vOhR3734kge
	DuAShn8oLXB281HBdrM+KG9bmoW1khIKVmXyZ+iHIjAlQaJW9JaWa+cppNOeiS0h7qWVNl+fwTC
	2dW+bbLUoSTIZMmwJUKyvGOCGad/hLkUNkDmPGHlMOd5gFMR2+3mWrlGa/TX9GcjNzEZORop8I8
	akr06UxeCLxy2t+Ye+1pFNI0Ry9BCNk7ox8UegQW85w+ICoy1xiOIvJKBDIpHj9SFw0xVwmbZbc
	68k4ql7x2w9WOxC8//Ide/SgcHvsT/kx5fHUu2+UNRcX/awdoP4J02IyX/FYFlhdzily1txhGeQ
	LNuFW35Xsu8TMxeDLc5bGo+ZUWspd5khUB+dpQn44cJsyTuWd851IhynYaaphoFdc5JW3+YR/WL
	AvF1q9hQOBDolNApKIR2eyMH97c5WZOtV3Qy9Y+BM/EFxEvePvVGvS/o16DiqyQ=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
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
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)
