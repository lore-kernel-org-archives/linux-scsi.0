Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564705;
	b=sXgygdAkjPAteog9ExDvW1iHiDm+uMdo23PyONpLcsNicZDQiNHVRU10YPPadTKdSACp
	 JSMCc5RAd0sRuW6ZOBKOsMcmurFHWUxabUlEROkogajCBEODVjHpsI0R/tm5v/HHqZInO
	 lq+jtlWnNribbcrnBXtImM0OmO+uGhuFSoGrfc4Zzzs7zGgvfDMuZJcRikj+UfuI5KrUs
	 0Qa/jX3W1ehuWTYWkrR4TEO8xLavkIJ6yEdPkbR6v6TIezesT/AdNQBnMN/U0YZ4XGlaT
	 iJPgEr15HTQPBX4B7yLW6RuQGRfyqgfY2FG3VPqlXAfkMs6vXF0h96OOL58UHqQzXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
	b=bO5ZD5V0uKKS7hArFCD+0wL7wwxw2EmYAudDWPAU6nphVyj/ujmXQ3WtJVr+oND6+BiL
	 1QqyiuT4ELwavpQD7dk/VfaTeb7y44IEQT5HdxOETwB2X90zwoIcNaa1Zz1SToMW04tTY
	 RVp1Hv8HJtXmg8LWxgTyHgd0qadgGUZsbQxi5Q2IUbctTMNprATT9gFvx8uRtR8s4gFHi
	 ML8uS5SDwXQ/39RxBCacdyTgt0/+D9MxgValnI4pMp154vvSrEmxnnobEHjXoG10l/OgX
	 P0SYM8hiasL3SnGwicrGJKe/PKU06AUyfZsWxsBDsRSW0IHsO0R5J5aU5W7OlZQBOcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BADxd+iU;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F6606A883
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 922F6606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BADxd+iU
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-497614c95f0so327657f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564703; x=1795169503; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=BADxd+iUI5Bylfm9xHmZjb4pgHg0fbyWkyp8vNCt747iYknkt4pGGRNYLQ78EH/z4x
         Vbi/Jq3+E8iOs58TJRk6WPlWSpFf2OpeZbjgHeXjXzKeHm9XnJ+eEvU2VLt6liCBRq7I
         79Td6VY4SiSTAXWOIivpd5ztVkC+DBAB/J4OfHn49+YeU7s/KQ9yNfnwb8sPZOTKoGu0
         Zirp8LScbJznGaQAXzatlGuiy/pBfqScnET/jGobuhYjlwMbyAqyeVJ7smTe1nJkO+dB
         h89eeA8CIS4pNdPKyjqDo55n+EKX5qBSzrC2C/95dZzzzQLBvHRJ+46c+P8Bzg/7r93a
         +u0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564703; x=1795169503;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=xbOT43UgjECk+sqjmV9e9Mat5HGEDgp1QYcaXcsroUSEIiOEzjX6vTKlot3/nxZW5a
         Sux4N2EsoNBrroWN7coHG4zhp9koQs/w5VrGocQ4s6aFfXsGo+p0ANIj+cIiXP4OG/tL
         l3KGi/mYZAoWiAN8EvKsdJ+hJmj5ZUufYf9X15yj5g0/yutkCzzbNTXnkyb1wWAt6ts+
         aCOxTB/oZtVTv84k6nS8lGYsDh7YwJPvHoRFpO9tbC3/u+H0jy8yLqp1cBnLWcHV5cB4
         G/cu/83ENDiIA2UUXd3P1rJVSeP1oZV2vFhYzmiC0J3EUYYkn/5boYzkOWJT6CcSJMOq
         RI8w==
X-Forwarded-Encrypted: i=1; AL+hErFJzl3MZUdMW1c68LEPs+wSI/+bHsRaWh4DjkDCrr/f0ohBID4OuE3ha58oaY/TI5Num45bRJJqfJyF@vger.kernel.org
X-Gm-Message-State: APuU4Z8g/B8rHvJ1iluEun7jeo6dWpjBGi9JheJFkfsCydT69BqIvbMU
	HUG/JZSVn+59gg7P77RH2tIVLMHxviOY9MfLX0vk36BoHt4V5MLhF7cqzXgaidliGV5z
X-Gm-Gg: AYBFou3Q7NVDjiU6obYp8DwnjOaLdDbRgXgkwePCmbKUnggH+XG0XfZKDdNMg8Z4LtB
	5/aCe6VR1ddsIJiHHqYg2+kFYqEEl3M5l9Wr91i9V6GO0qvKQiTc8K+GppR6+lMd3AS5VR7DDcW
	HX+WOpadWLV4C3Hw3enTN7KpKGEDyGZr4FXDvq55F0MczuJluCG90ybPOJHAANROLohK6Gs7ai5
	aOo1tyurKVAVUDSUQT4roNhx7xBfGs9JoDxgXPoBENmq805DIZcS7ZqhlRZ4lu2r+DhZmP50iVq
	ktalTDHBXB4/F8XAiZkUA93egPa5Hhd5FvPCbEUXnHSCwwucJI5dz8ZntIjfwqEQ1d9VSSo2BYR
	uJxtmr6ZbHi3uEAf+RvbG3Zri49A/2BllZejrDu38zVLHxNY0xLfIIXtT3cMKdYYkPNTAFZt8ZS
	aFSNOqUa9W1petaPCaZoBu60dA5d3iUtgqs8F+yNrf4TGMoMnvokub+/KiPFDfms0N6HEwu6TWG
	rfbstFiQU3bM0Jvn+bndNErPUHhobpPQbRcSFkKQ+7gShZuFTcWuo7i8y1C1JRqxiVRUzpqvnYn
	hcXviDMao7h2R+h6mpyWcrRUWtUpWJB/q7isO8fV+GvsQBgKdRItmaYOnMG9C74=
X-Received: by 2002:a05:6000:2501:b0:488:88ec:59c3 with SMTP id ffacd0b85a97d-49c73259cc3mr5012611f8f.14.1794564703010;
        Fri, 13 Nov 2026 02:11:43 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm4931434f8f.11.2026.11.13.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:11:42 -0800 (PST)
Message-ID: <ff6d2a8c8623f5476d5c352dac1ad98ab3da303c.camel@amutable.com>
Subject: Re: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
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
Date: Fri, 13 Nov 2026 11:11:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
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
> Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
> refuses PROT_EXEC mappings but the status and policy files are only
> ever mapped for reading.
>=20
> But selinuxfs needs device nodes. The kernel replaces file
> descriptors
> with /sys/fs/selinux/null on exec via dentry_open() which doesn't
> care
> about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
> path as /dev/null doesn't exist yet at that point. So clear
> SB_I_NODEV
> again in sel_fill_super().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
   I.=20
> ---
> =C2=A0security/selinux/selinuxfs.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/security/selinux/selinuxfs.c
> b/security/selinux/selinuxfs.c
> index 310e19efff1d..d7ae853b6d68 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/vmalloc.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/hex.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/mutex.h>
> @@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0 /* last one */ {"", NULL, 0}
> =C2=A0 };
> =C2=A0
> + /* Android init opens the null device below by path. */
> + sb->s_iflags &=3D ~SB_I_NODEV;
> +
> =C2=A0 ret =3D selinux_fs_info_create(sb);
> =C2=A0 if (ret)
> =C2=A0 goto err;
> @@ -1955,6 +1959,7 @@ static const struct fs_context_operations
> sel_context_ops =3D {
> =C2=A0
> =C2=A0static int sel_init_fs_context(struct fs_context *fc)
> =C2=A0{
> + fc_init_pseudo(fc);
> =C2=A0 fc->ops =3D &sel_context_ops;
> =C2=A0 return 0;
> =C2=A0}
