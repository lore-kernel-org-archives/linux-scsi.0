Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564785;
	b=CFOezJy9JzF5JmSo9ba7R+X2IEKfcU/+LR1dLou2MRWoQgHKehoMAfTSfk9ibVvwvskw
	 gfMC0QnJsR/zb+RkZfezX+5P4QVCDFInxrAxFZBGuUEbas/a2YKUUSIlGtfTHBdE7a42s
	 98u7j6qApokQJoNyVtBlkw2avupXoLqlkdXJx+SgEZ9QR5E2+jVZCQRJ0n2c6JekXabnw
	 tw9eHwaIQlcSGZtKvgeNRixPSDuolVbdaPstzHU+6KdJUZhp9zrm2YxHr1ZcBHuDGbmxr
	 MF/IGOoDtzbGnRvEXyAzJoWWeJTxRC1P1ZEJA/Rf2Jg+Z8GnzHaoyIh3yW3zm2i9eDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	b=3y53VO94lFO1okLObJpbgQXHFf0HAtsit+9z7eDIR3xVVltxiPpLSfwGt4eH8AYveQUG
	 eHWb33XEq/xrxBI9lU1Egx84WhrNnlWOrnym3MPgYxi1I6B2JgETcPCruObqEB5WgWq84
	 PwV5/6t7THYj6glZXvQpO0hciLscuup5R4K0/ll0PQkW8Vsmv5y5hPGPyuKXZ0E5iTDG8
	 MKHYlGMExyQY30NdFId6CEDyjCz8dP8c7q/5ABNfKsSdrTd7t2AswJ6ffIm6oXWzOrDQ4
	 xM4rHbUO1E4aH0DqcQcL1l7V2JVilHYpzP+cca5eg96w6QK61vq834s3HrvhrxurYMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B913606A33E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B913606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so10467145e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=qhgXZLcHEG/xp1ftPxi4Y+VtkR5xPsdZusiH6E7v1UVOpu+pQQwW0vkLZszWZiEzcA
         +BIaLUI7scE4yUL73wk7QDgrWayWPrLwdz+Upaai9wvZdfIC4mpAyM7/MboFd4cm+sgl
         6S6dsMSsgGsAMWrOW2SdAqPT3x/sY2fNDxpywpmU57N6cPKU4MQNdvXTLk3fPNzTNPjQ
         TN2vMd0rw8z+5ZJqFwtlFaNorLJKFpgZtePYZzAG9uux/UTV4iwPxrV7Aluh/WlU8Te+
         mKwCC2bzY5T7ZateqcC/h9wnCcfLq6dmSfmWCE2kpyRSPYXephvqiHzXHW2gW5l+Jqy/
         ZrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=V5ug2IIe05JVebT+JMLlyRNcjbPnZNs7UNR4ISaz498AQTaUe6r1e3OcAPi6B7sL5D
         iusMjWZTvDWxdvToxL/P91rVkTNGLaoUtR+DxQWvLjqhMy9K6keu7FnJZdqWt0ob6dYe
         XCiCZbFt7vEM0m/KbHlFQXYZ8h+Ym+9PHNLRxK2opZkkFcFmAevI+J0Beg0WBBCqVNau
         KV6a4i0M144VuSfDPlhHlViiUksxX4oOv5xAEezDBYDXS+Mhrb8Ry60wa1EWLcQBDtf+
         h9DQYbVAdWZKtE1Nvu5et5mUf3TtdzivoZOu7h0/Bg3CaWvP6ciimg9gKL+VhuZdCn23
         Z0Wg==
X-Forwarded-Encrypted: i=1; AL+hErH7gYeGuSgFO0SOc3QW1zOykM7jUngC03ESUsmnYhLa9+tCGGsNKysA46yfO8Rol/TbNF14Q3/Fv7S9@vger.kernel.org
X-Gm-Message-State: APuU4Z8fcj5Vxfx93Xj/NwQpTIc2uRYqj2V4l1Xc8O+SMYD+dbwwZCJt
	MT2Vjiv8H57TBIkP9Donjp7+0NfiEgnOI9Op+g7BrDdmmaz1D+huNRDxvswmuQbXFoGy
X-Gm-Gg: AYBFou3Bbig8Mh0dV4qKiUTsMKzyw1nPyl+z4V1qxWW+eXfl8jx+SEeGIjM5DvD6bos
	ES+fzynjmShM+rlPeorDpzUJWohXIRBiKYwFoh4x5HrYMcTIJHOOMZTZM9zGlKYTgww581EBz5P
	hhRn30d750BvnsrJSZKYRDe57Vmyhl87fwfkys5PRSGuy9UdvyWehDlwjzcpuYTJq1OETqBwMty
	8hhMr+hT7hJEHYPaLoEOQBhR0748WptLyCRdgeFpQpIM9SxFKggyCn+xfX4NLjrAtx4cKn8+rH5
	Roh6osDQGIXAFNl7nKSKCsxVYhVigbhRl5JlkUr1c8SQ+jkYVyFsxxZRfHdEnKTX2ec90s3tSvF
	CnpuEUQaBCmTAjR3j484nGb8fOYTGv2WaPBbSY0O2lmLk8hSn3mVQWskyDX55UgFHrZWx6KRoxH
	+iZw99+ItmpM4/sR4qvt4hFF69qlwmmvVe9NLMzTJKW/8OlipU/y3MHi+k/MOQYS07T9eUhtBr4
	/pFNLCrw62AUrUSJN2V4+BucBSGXO8vVk9MihW8593lhVvixPJD7FElATrY0lphVaudTYG7W06E
	1Rf5ViHRzcu4BhwgoRtAhVSomt0YE96s+EGLipdWjbr3ecMaX2C/ail8kx3zfefQ
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
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
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
