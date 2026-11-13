Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573510;
	b=SSkfENvMO5oTaV7iQxbOqfdJgphpUvtpvKvf/2eiZm+I3UV66kWH6E9t+TTFYgvvL/Y3
	 oSXAPYNLuZODiel7ow2wVgc4pcZFhe5fjIyM64Ir3vGUU0eYZUjEKpzRCYCB/YeodP/No
	 9FkCWyxOJQWUdi01qPcB+PjvjEVlYK+mrEGuCfgMMDOa54tOT8LylkxBdbve6i22xOoHx
	 WPGSG4f55RYHYwxgQ4KZQI4BPiuS8IuGVgJ8V9+E/p4Cd77hyhh47dSes8VnNxma+er4e
	 fTuiBrxx7DhdeZHr9eGbIvYY39o4neTCuSaV2dYYXzVqKUnKHwkXjrRnW4v3Glhh7IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	b=cUK40NqPRyZJA3vg4g1cAxDntk1LV4t6m5K26fYFp4E09Idca+TaXrqLEQxzxYP4dr08
	 v63Bv27JWvJH/qvJzv5B7UMQ6qIxsG3FtUw4mmitk9GC5i/5M1ATnGdTMZ8WG7y+3ZCsy
	 sdX5126XeRmFrfxA95SRrHDIQ5GUZ+tG0MRy5cMmsyygCf+wpfS5W4hXMslRltWEkTBcY
	 lhKEiNGBoD3/+Xq7lKP52gi8IMlMnfTXCkOnfPozftj9C0ruL+uR5ehAV283Bv9O76sU6
	 rPHH/FwK/3FJIYAwcjHGmma5ccb3UwgBT03zGPmTX4smD3/06GOJXXshscFdn5+fkZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B5606A337
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB0B5606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so3649065e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 04:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=Bz2+TnPIApHKvsf08kyiSuJZ5AWViHONwTwuNXVAuo2u8JGXjKnEoxSd3hG/r/h3b1
         tdsUEBtaZSOWfU3+mD3LjyqvBKt9Vc6RBsvkZZTD05u5eCDGhnWto1Wbu/C0r64DVVdd
         h2TGnt6meedDH7Iwjf2Hw2JxWOY8jwAvEAcAC10FURsf5jjp4p/KJzFYjzuPwuYFNKea
         Iij0h8HoPs5opXKf2XwMBJpd5hsYSV0+BHP/DvKdCCgwNFtbeIFAwqDf2ag0NBOCbqs2
         OXWiZmXbdGCixyOlqQBMgrkFkrhg1VmbSdmvvBdeQ4Vz+QMvhYl+k9AO6FJ5UW1pg6b2
         DVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=0414N1CvrMM5rWw0S0P4TxeYcfN9PHwCc6M60DHWwb1WRC3QED0xPoDxz1Fn5aWWEL
         azF7OaJ9Zn0voANTl5MD/0Z1mxZDzVbbyj0SjGAuMPBfqbpCywvZfcCLpFx3S44rfg66
         h3ey9qbL1jlQvErP/WU+cjYEC8gRHQyNzmNZnEtbk1/meyei8+47oU8vNjR/Rj3yavgf
         +P0DQTPUq0wQsUUX4vi/7XI8Tp0si74tZ3Ask56ypjgSKCETdz6btBeZIPySzobOPzMk
         eTlWrRfe0vJEU6vBCYYxkZAikuJBqVTxCZpfuiOVenT2SeqnEFvAvZH08tOjy7jv3twA
         A+aA==
X-Forwarded-Encrypted: i=1; AL+hErF9hUJNagDzmNjGnLEuE+cUeulezDFVKf++0Cd1HmcDpQdZfEBPIZc2+vQURk5LdIsBRL1/zCF/WWhP@vger.kernel.org
X-Gm-Message-State: APuU4Z+X610lSKRnf1eJqdjXIkSXb2aw11DEYEZn1TegjZQnE2hOi57n
	lfQh9ukm35Gqt/IexPxAsUzucUYJa/bC33reE0ejax1hrkCt7ZTYqSirIFBWWEVzsfl2
X-Gm-Gg: AYBFou0vEQ+fb/2jqoaBWKNp3cVddzS3Pl1JFcUvNKS9kEvhgWmDFJ3XVwJn3KXe95o
	ijEPsa3ybihypAV0694oS7lL9vGI6r9yTzdh7JjTn/Ed/KXEsYQ4b4HjhG+RDFKLVw9VOtfH0A0
	nfIBw2LK6sfAZ4bI6WF1QkX2VLPKqr+CM9mtiMmp2AmHwSF4hQu1FeuMrIGfzNluiFvbU6S9YPV
	JQr1J5b8Xe/pPTjZhqOfdgQa0HNjAJZNUppRwUUSbQ6AbJ5RGY2IJMkzDtx2kV8Ztny4M0jL1Uk
	nYWEF3ps7Ema6DITyiTGhVXpIQGZXeCr1tzSiSuhhQpfvz6Hrnj8Dd+R6JtIQ5plN5fOhWvEsBf
	qeazYLS71tMlTh6q0wqJRY2/Atyw2W3mNd3Vl7mmrsMEr2mBa25MMXxMqXqLQJklv8hRSTAXzN5
	CQcq4SrcZi/Q8lIC5ZcDVbirQ+yNka1Wxjb7ZOMSZHBnl6Pvi7exzd3TM3xGhdlvp1gWg9t40yt
	QtlW0K8muk88XVyOXKHASR8ZJ2kJh3Oxj2AC1UqflUETNgFSMqwCCYmC6SP70hWl5tx55qgJUlz
	yPTFnYjRlkSUQ5ddR9hTLEL3VLhEWx4vz62pV94X2hfzEqxg2jH6E+T9YBU2Hp4=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
