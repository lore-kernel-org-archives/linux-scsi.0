Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904595;
	b=3pbxpKZW7KrIaOYJ4zMzLZvi49IDrXg2cIUHpBwfF5mX14Ii37vsLMF/4XIi+NL2o/+e
	 0d0yWmLvcCnzd+YKb2RKYB5IHur1aD8qCYxD8sgEyox8P2XBKeZbo/eO8wE8/1SPaiJDs
	 wzpifeGoi3TKB/3gegGpvmyQHUEpuOj0zqyNWjD/CdhwFw9Y43Gk592OpLE8VdnFl9GCI
	 BB/dIfIfmXcC1boZI0qn6c6mw6PII+boMywx+9RuGhUABWMip/ACeBHmL6D6fE/bKi4AQ
	 100TWYDXIzBN65rNpdQZ0CaWoFHXpd3n+TchxkweZs6c19k4pzrduwvlwuA/GqF7rZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
	b=r8ti0CQqUe6VMIRnzTsGeTutvVJxBh8TI6Qm2c97rnxEQ4U2qXFxxVyuVPbabtcKA40R
	 85a5QL0YdbKzZ48vVqmSWXAbiem06K/JvTPFC8B8co703FqNscFdx2S6J5CnuPXc8d5kT
	 i/8mVcn1iq//WOSY0WzcoIk3W9tz/KOcf7urmO5jlSV0DZ+zPD22zSDmbqIfLnU/eTObL
	 55mzcJpUV3vY1P2GvPeoXVPcGFYfuVN7tTUlIE+3DaGijB+lMdMYUmgOoBf7aCqHYuUIe
	 Yi1zw+ha2psaBx/fABYnT24d+xG7j7Zp22cTIrlWioSRptMC83ey05NL+MFqQZTNPbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1307606A898
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1307606A898
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b467581b98so39088905e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904592; x=1795509392; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=VB84C1shjSG034pSk2oK3egXlQwWjuu3VjrdbAKPawk/Twv4Yif6yhPlbROFWtMgPQ
         3tz2NQZOgPBk3fq0QRZC/paJXFCSb8aJt/mhh+A0iXMTZvR4a2C4xo37cxqDT+bS5wyK
         cFfqQ64HX4H+WtOYlqmaNWk53bLD4rVzH3Dam/22N7EldMgTIeT60YiznWNjIzN+eEJD
         Zc6kl9xoD3REW2KAU35dfm9/7zuNgWUL6hteTTxoqyJmYKiacM/NYuvwNSKHsMwzezat
         1L4qftGlpMPZouPAaee8sA2dATEpRVvU+RzrgkUS2mvSj/+KFRi5Npjbd19v9tUdsF88
         Zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904592; x=1795509392;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=xMTEgHykEklxH94h25Tdxw6XmTc3Q8Z0dw1yBdHu9f8CVkH5XPC5yLl6eu0tOg8a49
         wNt4ncwA+o7KnOhjAlMpWHGoMNgfsKGkM68FWWCOhf6M3H64odV23DbupfX/tcPKiCaf
         wX90uwLlBWjOO+cfkJ/trmZrWfob2kPieM+PwTPiwE2YIw/FfR9fQemkEFAjdIoM9pEc
         3rr0lEWT8K9EepyEki65+MJCmiIBmgWyqT7qzKkleX/1WQtvf4yKYQ+euyFQvQsX6PbO
         faXtrjfKLde6MKFOv8U8F/65mwx8Gt0NfjPGYtqgyIAc8VaOT61sg3VLhxBjIax7Qu45
         55jw==
X-Forwarded-Encrypted: i=1; AL+hErEghHMlaIkxK0+m2f2xqrmftTg2Yg2papoae/c++dKJktbupQQJk1Q/8GltCnogw4OQk2W4TcXzsb7m@vger.kernel.org
X-Gm-Message-State: APuU4Z8cx1wBvpVdYnKRNj98pzJVvO0LyKfAPRVVLbif4zJOGpwne//t
	GX4XCsnPKe94TzLNLQ2h2nN/OPbA1xY037uWLmy6abreLZmD8dYU9i4LIvic7jsoPFmo
X-Gm-Gg: AYBFou2r4x6MZzlSEMCCPjos89E+9+97Lqb4Wu9/arQN+kvAuKEuuSnGiUhdZMp6AFd
	qsZ7P44rR7UhYh8UC2tHjceO8mMWxmUnWwMtCRTIBWG2L8jTUukB4ufmY54rcpiiDzMUWjzO1ym
	1slp1nvtVW6hhtMmBZYePYPwN/2VPx55iSxnzKfBTbH7yU7YBs3D8JDIQVRmLm5Y47ORK7yEWml
	tS6a4oVK1Fh3U7d/BEf1uR42jXbOKikYen0S/w+mV9xvM5c+k/aFCXwG8RqfHC5mzqTo1eW/ndC
	LNreukjd26OH/ZgTG4+AKri96h87vmV8n2l1CMEbj3ntzfB86bcYmN3bU7pSjI1bUYgoufER5V5
	WWSLgjZtcE1HDJ7s+CZuC0PI8et0w6rn714JJ1PHjKWWg+CZtB1fy6EthrNA4v9CfT2fSBABKp/
	sjo9iLAeqtYUsDTWX0QZqk+0gXxdRGRjgwsI6cpF9ztyBmoqG2J9/qjDh0J+8TaxjlwiSCGnxOr
	AYhSTxAjVwZSaVPE9KnD+tODaGY69z7a5RCHDNwUEkvK7WiaFEs5T1OdOtDxr3k1/Dz4ergSX3Q
	2tBiM+ohEKz2LLJMKEPXZOzD+lL8LEb6JH+x4/5zCZ4Op0enaEDb7S51S160VTSFnOWFfpGinds
	C9o1ukcvoZgKN3fU+DVJtSt/7sT7uUx1Wq3CmYzplVMDmhmoGwpom38ld
X-Received: by 2002:a05:600c:1f90:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4bb55ab281bmr266345525e9.21.1794904592167;
        Tue, 17 Nov 2026 00:36:32 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm52548565e9.12.2026.11.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:36:31 -0800 (PST)
Message-ID: <411502f9a4f940c223b2b88d7e19fafdce63172e.camel@amutable.com>
Subject: Re: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:36:30 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
> device nodes.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0arch/s390/hypfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 559b011e68800..8662169de477a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/vfs.h>
> @@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	sbi->gid =3D current_gid();
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sbi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &hypfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
