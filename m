Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904006;
	b=jZXD+0CxTn79oBk/7q+w2V51HGtEb5A8tniEIJtSzyJUUBy1SAjGHPxwDVatQODBReaG
	 1Cpu0nHmPt+kAIfOmFqF2SalzUfD2OISBJO5JzaMxLnzpcgHYLYxAa7oB1kfRr6SkLn+y
	 Nf+rEPAuGYYYablxZfoPPrmdpvCUpu5MkQIsJp/n+QfIOJtBVdUknNI3lGazE/+J+iwxQ
	 JuAhlJMSWaxTR5x3YdwYSvuFcn37m20k0hjHttcK5d65cjeXgZfC0NCC5GqdhWhtP++eL
	 t/ySTqQxGOkI+HIScIt8tpoNN96coCYBRheoMNyTsnHcVL5P5MfWn9aMz7oqWCjCMTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	b=bKo+c/x+HMHZaCrT6s8Rl4cyEBGSklYCJjf+Ys93c7TIetUvfqaNGfFTLfpMbJUbxTGz
	 OHc6ARTnrzUHet10geWsZThD000gpiajvL7RxeSqdxFu5eNoEcv2Vdmsbq3tbY0MyUaVV
	 J5GTuf0OQvX5xcuzAMDWZ7OYhwYCkZPrEUF00zDzRwkMBtP6u0xV/yV7zknjXjpzTGU2Y
	 BToOc9CLlBK3d2O43bQdpUBh1IGW802tdKqDH219GJgj8DdGBrvbV/hvodnZLAXqrT0Ji
	 Bx2vofF9TsJkU9Am7BpCo7n0RlVRIS9y2bkOmSsQfeC1b87YshZPfAgETAsYo4EjusA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDC9606A336
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FDC9606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a358881793so374289f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=Bh3COd7ZzI6TmZdb32Fg462zWvuh7WQNnrUpXucHXcpV5t+t8gMfKKxOWwhkcHBcNt
         zIJKpUT9Ten8K9xmb0ZHj3p/ljeyNVefWtOpjWCo7Igmb/P1wzmYs63YOxLg7f+WXmDC
         wf3ao9cg3f1DrvZE/oBKoQiWFPBKSPnWk+jCT2CGoQgxeoDuJREjXd8oRMM0GizRyDLq
         q7c8W4Fdq61I08pJrjWNPm+S1jXNjmZ2MpEutx4SYZ/JoE6iRzvUZ/uRuGO7TyWDBzw1
         OlncqX8aSwrA8zDhY0Cn+N6eWM3qFfFk2ULf9A0Yk8lhKFDJjJXQbcxKbI+h6RZ2p0E1
         0Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=AgFlN7UH0UalnJ7ILp00jP5GOcx8kt+cqT1abRceZY9aM61BssvJ3VwCi+nGP+rZBS
         iFQfRX5fkQB4hc/zfoiCHg4gXXA0uWjXwIoeYi/jsnzjd/u9ynZXnfc/HR3E9ZMP0zPe
         aLWg/srWhmt8xzGlQK+D+18nPQKnTTRsJGMV9znKdALFtjnWZWmwKyIXA/CAUv21FNL5
         C7lPrzYWnXXwAmqNV33pBOLPrro2lGxaSiqJKbAQjYyiGHbx/YMT3LFVTAhF/IQ+qKRx
         ueoc9s0SFSB912hf8Q/YYDOva6PxCq/0vrtyK5hwsUta8IvGagfUrxb0iW64+pZ9mHMB
         7K+Q==
X-Forwarded-Encrypted: i=1; AL+hErEAiEdlS9Zy54V2zTJAU3RnrPjNK0OlnX5XSuKjBz6MTc0aOs6HGcsPFV8eZPo8OJ5cKmnrYhXSXe44@vger.kernel.org
X-Gm-Message-State: APuU4Z/q2J0ekbulzhtsgqQ6LR6sY2u/k3zixPhvdiprO9UYHTdYIIyq
	84uyfydoMCpkzgJiNAzkGywkRoF76YgWwsHry44vosl4i616SEKBAkE3qJKuuRd2I9zD
X-Gm-Gg: AZFdTZeFF+F7QgW3O5vsJ9pIg48gBQO16kXVPaEQi57dX86vnzLo9lf88GLela3sl/G
	5Mlz+0lFfGGGuiSQsinfiXqkSHK+8ziZp6ZNuCEZ1FViSvqt3//y71vFyko6eLFAc4yz+1JQ8bQ
	Yz2WKzf5TxfWSdbCWsS0Klja9J8dVR1OoFoqMprCxnUGS6NrPn5GxJhIdfwz2fhMFmE7OVtqJ2/
	x5sccMqZbDOQco9fc5wUOQr2wwO+yNIiGFRiEDQgvZJ/Tz4Qb/G33UgdSbiF7L+KsFgOH/HlenF
	UwBtdkIXYeHOg4ANZIs5IoL9BeubMOHCnIl2VtegjDAWQOIi+rK9nJLKTurC1wNNoS0rgri1OzK
	104E69g7/Ejmba60W50TNu4QWq/p0FFhTwuN540Sm5pJzCDyw+0qKwoNN3nFlKFQEkOW9OAWEht
	oKSBHnZOWFvprliHdYxTr9Hk/f7K9Gf8++BREONqHPUkPjnpgUdkNJxxMfWXcsuoBjzFYTKuv7s
	ovZhX8vPTLecMNiXQX0u9ldXyv3XIbHVuC5XvlijCDk9lTNMLG/exMyhZ83xCNhp6jphGIgXwHI
	2Yk8wYblJBVDMiyKDO+ugygkAeCkhNaPkDMUoQsN5sQgEW53rkzSfLTpkGVL8D3loCtcM6NogKP
	qiUvohoj4/EADn5etSbc3EDyE1uiORYM2W6o6jndMY80eafWMGFabJSXo
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
