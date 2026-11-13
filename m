Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564824;
	b=tXevlaInB1dowe69DJO/xbeTZHoe9AWvIW6IcRLhXND1nzxa+nqnK9psdvHytvj5SvIk
	 C847ajNhhj440t3vP7Mdx8kAzdgZUZ9A24zI4ykE3P48nW1AvahSNaW/cGoq01LBlC4Ss
	 OINN0CKorhFYntQwqkCKhSbDXLEeBwZ55lPDziZlgDwZNKNY1c4ZiGQmFcpSKUaZWHUR5
	 fMNEyxauacwyZpPdbDI/kr87I1g6SSa5/jGRAYQ+JF+Kh0Ztq9MA45ikNeq4OGYzezxbi
	 3NAn7PW9UApD1gR/ARm70AAfSLgHOTC+DTs3Jf86cq1GKDeQpDy6F0oqxEgL4nJR3sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	b=GFarsExDViDeOOflJboWbwVUoU/3C9QG8ftoISVeQzE3p54j4yt8svJZ7MIbHTuDthHj
	 piszY/JHeTCnIY7xGz8dKxT9X0SADNaRgLylGC/dh478Z69HAdc3haIAyQppv0r9ZhSDg
	 ooO6l4dT8D0yHmTSYLKAeJ72g+qocpE+5sA5XxDv35tSB+2kZh/QofmRY++REJMiWYwIs
	 p7ld6gnIfyAsuY7TsoT1tYGg4tI6E35KvKr8TV0LNyJFrYI1AWOlUSNHF2hPivUjGwgAX
	 A8tH5hqYc/eUhMzxBUSfI4ODIO6Ad1Hrd0HYX7n9gEaD6vl6NEH4Cy4sloYgxF38IdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E697C606A89A
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E697C606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b757029223so1116386a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564822; x=1795169622; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=tBSDp3uSBFgypsbtBQgsadIQZQK7UWodMC4WHZVi1N1ipHHYu6WywVfCa4AZ6QIaRM
         wIcOajhLTVFUJp4yf9/N65gePrg5n4K0AYKI0yA+7KNwnMoUY/irx0jTqY91Kx7jR9xZ
         Pm03fPe9TdsIWGPKhcU7A4Ssshd7c8Dhe1zzS2a/pwsZLiwc6FmAy6ptf2LWGhArJX18
         uzRhPjO9k+hyhG0ceM77HGUPCflD5+7VnbyODCgVUFUm1PdMwYT1gZdGgKWe2z5NHlJg
         Ao5qYJPp+rBAoBURzi6iHuHACVVyoOXqBDLcaaEy2+qVTTu+93IkZN11FbEDMtWMDX2T
         mB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564822; x=1795169622;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=W4qHwtIcdWuLhH50p1dSQEvVNsoTg1cI+lUj3gcGUjSBlITXtV8zDbjYHE+zK2LgJJ
         kyfNQ2akEYbJI5qFFDfLdlZnMUJ+TrBd7n6kd3uShHbf1W+xJupAI/q1d36+WzOKMiik
         ovAyek7OBFrDEOBdZc6SHbom1At8lacv9xi0YwJs9VRVrfm0rNTUME0BdLwiSqlbYLBn
         qY2EW7KZjx6Apb18XbF8x3J9qmFAEOeCLrgWDocSu2SnYKs/2WhknvoYLhiBsYYPPfyM
         VRexvSH3kUGrj/9y6Am+dP0FTQ5kT+ZkA1sfeOCWoWQaXPxK8v94XNl/lz9DqojQNuIa
         7QMg==
X-Forwarded-Encrypted: i=1; AL+hErEnBDerUwWg4AvdWMtqFcYhyu4/lgvg83GCrqx1tY0LP7F1+p3gqOH7Rvh3lZxuuap+1erkZvWHYCTV@vger.kernel.org
X-Gm-Message-State: APuU4Z807tJJiSl1ya6YOn4QT5Blvni3lfFUwCIDXJ2EILKcpcqRvHst
	d02JUCtwqvoQhMrXI0tpYcUGbxROg/zW7RcY45uUroZJxvue//D7HkavhDTQBrp7Tct1
X-Gm-Gg: AYBFou1xPekxaf8AyFsxBGIFBHwYLhuoS22Ed3HkXWQzLGay5ZEuonCP3+UMQtfbRhX
	B84SWJld82hxqSWOxFd9/XNLT18E4il27wl5rseX6mOroSvXK2dXu2ytpP+mmc/MQKLzemPfvVA
	2fOehs6K5RrzTHR53zf+7kY+US6p8YMGBIdsbGY9/NfR9iFHo8FSL302cQdehVIRhkjLr80phGY
	iUr9gkLGiSB7BMpqDkIHoiBcS90pvRdgMBUGZ6scf7qAOyxs0x1t+kJisiEuSa7qDILWar7kYd/
	fWve3mWcioIeqV1DiHy9E6dEIzNhdXkGG2Adq75itpPC2JdkVtUvM6XYh75jWS1+j4UHYJzCyxk
	iRXfLXtSFV3tnIXYd3JRbW98W8Gil+8F7Na990A83xocaQMFM58aFWeFKWiavIZ1PfAfzVZ/cpf
	yifMwDUoGfwxfrkBTbZ6jNBRSpJL94qLqMZy3tZ/u1L6V8kU/A9FEtYuel3WL4yHt0L713t6QVT
	FofDbB06nmnYHGw8GxRd+TvLP/tevkMiqK/fCa6TNcCse/L2Hf4+2mcQVrtQsfAHmCCNjzbcLf6
	j3u/8MAVwv0XaB+n2mPULr7NgD+dqLgnZJ9V4JumFAyLYJGJB2HSBTNv916NEV+olUTxjvAwT5/
	8FZ5cWv3P
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
