Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904110;
	b=gWONklPa/O4+9ewv/nxrAUBBMdYvuTzl08NQBikL5ZeSfC5SCfhFnNObnSAdI0vcMOfj
	 p7OgMdATSWd3djd15pAOgW73HmcExgK00PSgj/GPQmZoAbsN+McsYJUCUbsxrFBAh0UG/
	 G3TAZqMnn/jZNJadxJp089dTmkU3vFRu62Si+IGAZu9p30ifhYPlipjd3N6m2YnhhqgTm
	 wFFsP0NwhHbLQh/OgQE8BPBedBK3uLiftAnGPHJ86iaZKDeNZGmLOBabcq4xZoxHX/sAB
	 sqqI4Iitk7//lcDaRoInsDyV/cym9P+HqL5rfry3EQGVY0atXSK7iIPDh19Wm5CH6qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
	b=TO/1hZNojttx1qZbQZiGoQX0e1FYl+Y61yo9nWmxRvF9IQRYnGws3rlUuasgDvEJ2mRX
	 jVrCIwm5+p8mmzLMHS0HeXMeypnssqvmjGK366HLxMGa1xV3j3h8/jm77hrWz/OaAS97O
	 pVs2/u5ELLGx/CJnoUL9IlWwCrvGb2egd+pZzVP89HjwWmpn3bu7IkP2gfdq/MXbtp1Yv
	 6iwk9Sm32T4Ol7viyW/QfsK47W+u5Asna3FK98A/6KkbcOhNThkSgU/QdbHXcOAtckbKO
	 WmD8Wh7R/IyYUYXXfOhSOuUNG2XAjp0DEOIpgpDJaSJ8VqP3EfWrax45T9c1YNdPzJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="lDHE/E60";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70460A2605
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF70460A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lDHE/E60
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso36239975e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904108; x=1795508908; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=lDHE/E60fAF7y/GcfWe7zssqpibfABjaDWc4DbPAbANFwY7mipSCQzk/tGna/Yk9Yp
         5M31Ja6Q4S90Eg4jWdoE2GH6TurYV9Y9Yxd6SoBGFySZlSGgcD3Nf8Ac20Morq/IEeLi
         HZNDCkpilOoqmPVEk/N5paMQG+RjNO9OhPzIDtVn6k+5pNMY8rSlnV+zGCrptyxwBw8i
         uHdMwH/Pby0zhrQLCKl2b6izfUmExSZrUoQCnWP4NFP78u9vhGGyVwUcvE3no1VAV9ln
         DDlxdlg3j7mlBLcF1wQFzdXfstbmRKgVspXMjOajtHMeg5NsSNAba7k+RMZ1HFntU+s+
         8A0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904108; x=1795508908;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=dQSh0ycVE86brfL9Qu7EahLOAaFSBV+ai87GhCJCGL7L4/JmaXUBmPaCbyKu+HGG2n
         Uv8OIJ28eLGFgxqTKfK6BCIgWhey/5YSBkPg4YcYv+5pzCBb6DFFS4dMMxtV4X2VTkp6
         O2931AGw3LVqKBd/Dfa2Rmf/n5NlH8LHSle6nV/OmjUkwyEXslF5f/Gs2VYdoFvicQdD
         mzBGVnlUJdasohBFiF5UdvnCDpBVvsfqmZPI7oFzcKhPZ44jVAuZsynZxL3dIm4+f1QW
         2vu44hUf2WtHsF2mHg44axyF9SBBWipR2T36bEWYVgbSGZFrmI+4kqeoyBm9EYCB6hSV
         5xyQ==
X-Forwarded-Encrypted: i=1; AL+hErFk6cUyHP/Zm7MVsgbjrkQHFi+ByQaQuKkD33+dCMKEw4vk4pi/vCIYSU3tzHtrf967OVwraOALKB+d@vger.kernel.org
X-Gm-Message-State: APuU4Z+jAzbrMFrP+OLiO2r9/WGYFm2FNDL9hdasD2d5UweiCr2j9eHd
	sijw15NU3Vrw8deJiNQVTLeNQbI5tY4HmhaYp1JwJti9pJA7bpDKRjZmdSmat/IebKka
X-Gm-Gg: AYBFou32AixSp+QqSUqfFBiT4olViIwTKhdQe+0e2QS01X/4DaSe5wtzx7beKBi5R0C
	ldXc4ss7q18fU7C97TBKt7VlwnCSI/lynj0lAk86nHqBRFdFLvQbQZ6DThVHYiIrNYqk2sxi+V6
	wymgTAePcIJ6xL8uCCqyXNJk/p8YfgY34UUmN++22yWKVirKTtJgYi3f/+x3fINIYmY7ChLFfgw
	m78sxZJb+tgDR6SBqxJqnQSJ2cNz5EBkZjq7ob5jl43big2QEcFcjGZjaSYdkLQC3kJQ0dAA5lp
	f1FzadXvHrxOLiJwAbq0fp2SciRcKkMUqKlGvWZ7cPgA7qw7Fu4i+OsHzjL31I6N+eHM5u7uUq0
	4sInJB0rEknKV6he4zXsBM7us53scD+OyX8g0bfeivWs1sN4glB8qvQL+sJVgCZHrc2jJvf6tvf
	71Udjl1fJH7FvcedVp6pBGqqy1vMJ3vDE0HSnYI1nQT+Ea5P4TFsRsX8qXwKNXbtz6b0Zr5zLSJ
	lDj6rKtOJJlwRc25/9Kw9xv4DEVCNPY6gPQ0nlz058XeuTlXqXDOOZ2Fj+V1R4sMtmfdlxPUkmC
	jtQ+2KkBa56fnHimM4fuV618SsX0b43oA1eZzWjnbZVO8jT4nPQ1opsqCC21fHkknWkc5i6Bb0y
	TMN6tSoq3+1eQAwulu3i2Pd1Ghd6FRBgxbjWBVyj25KJMlCSQP9Ahq9Wy
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr255399085e9.5.1794904108278;
        Tue, 17 Nov 2026 00:28:28 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78422d2dsm75197335e9.10.2026.11.17.00.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:27 -0800 (PST)
Message-ID: <afc070a816e3ae5eb3c9e2d62d4f25c59ee61df2.camel@amutable.com>
Subject: Re: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:26 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
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
> Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
> page and guest memory through privcmd, both data.
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/xen/xenfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
> index 37ea7c5c03469..aba7d038ed735 100644
> --- a/drivers/xen/xenfs/super.c
> +++ b/drivers/xen/xenfs/super.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0
> =C2=A0#include <xen/xen.h>
> @@ -80,6 +81,7 @@ static const struct fs_context_operations
> xenfs_context_ops =3D {
> =C2=A0
> =C2=A0static int xenfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &xenfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
