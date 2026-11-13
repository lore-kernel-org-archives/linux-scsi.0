Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564338;
	b=vekTUUPL8SwCGH+Lh54EY0KUfglUYU7TxpjfkAdZMhWvKn6Ay37efhxF8B6P5HUTfwiR
	 VWDwolkIR2EkB+uMTuiNsPdRQ0CbsYZAOtO7SQy8a2sD6y3h1dD0Ui7TrEjRlcFdVwBEV
	 CON/clLcw+HUeSs6+YAQMSZSt4VTdLdvG/VcfE2zdkk6wSLbvRx+jOOGJSsKoQlrGLj5w
	 TjM6vOgT4nBI5pUDjoJY4o7i077Y2J6rbfT8j1wLqMvf0kh+6GcGGl00ojg3WVjwU7tax
	 J3pBqVTPitdJFHSNQgseGs96k1nyCa8sDV0FukD/NWiI+S7DASGM2rT3cHVu77Tfr7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
	b=b1nomTUkD2FZwRp1P7b8H8fBs27GSIpGr5G7P8AS5G5U4AC5HUeEM5Hylz6gBASRf4xc
	 2zw9bciIgcQPqzWYVJOK8m3gSKdlStCOsbOVGnJg/SK81kyU3MnLL4a1fjFyCFi5ltuQI
	 Zu1zTcC8vUouZURvZOPAQFrRkNf77u2yDFW/4Z/mGtVi/PY3HWUvBN/CD7RmFRksFShuZ
	 0qaarTf1bjNSXbokbmZMslPMduJN/0hqh/U+VOWfRBJlataWaveD+/UzPZbEqocol2V0Y
	 IxgXhEDA5ny4ie3ngikgYLVr14Z1RE2fB4eysMu2M6mFGOuAhi/Ie7QzfXAMh8UjsdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="BcN8/JZ3";
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F2D606B13E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3F2D606B13E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BcN8/JZ3
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4322d310e7so190391866b.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564336; x=1795169136; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=BcN8/JZ3o8G8RngOszXG3JTNOcmRF7Y5HhcgHfEFuj8bd59D6/ZB+k5Qh/rpeFRCcR
         ddACGgLLZgU5b3f6uROOjMlLzNHxLpnDWTvmFTIG7dNNkaJHDW07G6TO1gom3Rvc3G6a
         phj31A4a6/nEoCYWD8i1KXLteYhy5qLcfDwMY03tf9yOOPsaa+sC0St/LDVgowIEHsk0
         tZO/CMI2RrlSiK2F32OSWBbCdipxonxIIN0DBtho56nDsRF+fFDKa92VHmnJVt2oHACg
         qH7hz+1dQBsoiVIgFoQGohYiLAIIKP/PCGAm0hHsixZQutOWB167lk9DbkeNw+vQ2Hrh
         L2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564336; x=1795169136;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=kxiSdmy3DMenVTJF/vb/Amlx8VS2nuauXOZjk27fABCnWjI9g/kFACOh+gNNnfZ5FQ
         Qc6JlL/DTIflrnwoJE0cSxrMkRsXHOSL5ASKPKaenyelkluK5gO1ni4G34OfvG8EeaFh
         egsIFZf+Qft2fE+oZgOTKoZbJEzdyJDq0OnOu6CDsa0o79svbguAuzAlI/4K5vkkt584
         eXMH2O1V16Ln637C0mxT88fMIAtaTnZaJHIXH+mHEawOpbbsn0J9h12sKLsEOPwbX+sI
         bcKcoDKEtSeTSj7OAQVolc4UmK6ncOfJEkE+giRQ225FRGLG3CL6zq6Ke/P0q077O9Kq
         ykRQ==
X-Forwarded-Encrypted: i=1; AL+hErG7FBqdMp9JDxU40hb0yX98iWwHvQKGzl+781UHE0DAF5GO3Axz9YSla1rCQY3BVgnbfdqL3ICrbe5l@vger.kernel.org
X-Gm-Message-State: APuU4Z/5r241ZWq2UqNAjLAOMEw7z44KQQ8XYn+qt7uRMRwP2aNfY9Kh
	521LeUJ3q9qt0PdVt87TXYo5yvePeh9NtxRkutoO/0Wfgpo2NZ/PQT0hUU/uKSwtpX5X
X-Gm-Gg: AYBFou11p0dwhSmYqkmqMr62fDFSFDMamZxcYjDJTPomUUYENuGc2l2wZLrUHnv+0Kl
	dQOux6hZzOlcS4qUVIiSIXtPx9MdS6iLxgK2nmjF2VO6TH1VF+iexl5inoD/CD02vi0IA3ITaIx
	neJaUIy/OWUHqAvDLwTXgsnL4vpGWB6qG6B66/0lfsnj8XV6IUT0o5Fn73HLYmn6oxjruutxH/3
	Ar1GbGeHxwreQiP40iROnYUl/2rix/+8ezgMM+O3E5S4JymRmYtxYHcg7gWrIsj6tW41mbtaFN1
	UvaNVDMIfmCyCbve2yvjjisy9HY+zt8A9XRNFF/UKFLpOl6tb/i1KoMijF3To6mT4T0yNGWTvsO
	7nG9YArIBObUqY9SzXTM5w1ztPy0ds9C6TrSvXDmzNbFYjIy9s7aeIiKPjKwh0+sfslGeQvHdRM
	tUWSWdRXz/ATbcyijk1kip82KkX+H3Z44Z0GlzRihl+3sHb21XN1KiUuOK71uOCCafXnLjUEe1c
	7aeOjLKZvcELxQOMalpYesVE69ceI2uJSW/rB5+3pv1ALfLKTlsHiF56SXZMHplwsvqEYByqytD
	wskCi7p+lxAw/uMb1tLNxH1EuwAD793lQfs/fZSlwJpon8A1N9QrQermtenOU+U=
X-Received: by 2002:a17:907:94cb:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c5096389759mr162937766b.41.1794564336347;
        Fri, 13 Nov 2026 02:05:36 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5b93csm75365566b.5.2026.11.13.02.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:35 -0800 (PST)
Message-ID: <8f532a01f6cc2eb73582864343e25be4ec990919.camel@amutable.com>
Subject: Re: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:34 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
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
> Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
> can be mapped, kcov, relay channels and powernv's memtrace, map data.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/debugfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index b4915551ad31..f163f0bc5703 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D DEBUGFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &debugfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
