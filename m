Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904345;
	b=C7WdGSpMz5BsEYpMhzhjNVpJvj6TFo/dA3KPD5XBrRmSjTittZjwOnTo2cdTlf89Q7iN
	 g99gv83ej33EeO31AUoRB+jirQKkjxBTG8JOEMiXaKwbZYWG5I3RCZZLqPm9nHRHgZA2W
	 eUx5iBhhLVGntPQrexSlfaKmGGlzgYyVCtjF2m8GmO3y+hsEivcFKsj4L0r+UkkwdCDAF
	 yxPlSjiT6OxtKEAFZ4jcxfaEboSYIGSC1+thrOcG/mtb0+WNjbOzFvLEPSU0uAZtM1Wp0
	 GAhUc0REsltiDSsmjChp3QqU/suUDN4DVbk1rYyzW+ZJOhC/XXX5J+N6/G0pUI8a3tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	b=zZ/Ujf6WVcl8GT2GsnS18dZW03H6vnGuiufvzEUe8XHrqCLUZ5apw+ATtPuv9TerxgKf
	 B5RWhZYdvC8q9kBOiseVV8W0NV7lbvmGKNXOjrARbzX3kOAZ8IgAqYdU4CknVQdEmc7R8
	 ZyfheughfQbMd/8I+mJRptRIt+wFR6Nyyuco62/AY0cfar5YTxb2PnG7P91/LsZjKTZwj
	 rk/Z9u96CD8sbY5KhYfrXCLb52qGLmfHjDL2SK8MSMlVUHAR4CA+UHUODegAN1jPSrX/o
	 vtyYuHod5DJOJepZuxRegQyxPFcLTAk1HpW1xHJqURjGCeFdYVW5zML/5rAoUlNuGoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD73F606A890
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD73F606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso178004f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=EFPX8Vuf7iz+NzEUQG+pPgjK/MbrESqv3n9ATmra3Zopp4tpstszPHFfE2sR6EI1XH
         /MuIqTxoWkMXSLrvcYnqUGQvNVGY6YndEf7Smwels/t/G0PiJAqa5YTB3/XSR2c5vF/4
         5S685rADCuM7kD+KTHsn5xD0Bbvj+kfNJN7h3Eeu6Tgpz77cxc6E5ixV5T0A3r/KAOuP
         +pclbSVYUTOzYQ2RRiRVVs4C5Z7y/NhXCRc6Of4Q0fL8jD/Em4FfidsaQN0h6TdkChBo
         DufH5bn8tmF4fp27j4WWCE7M7sjar8yCORXmuz1wFPQxfWworU2xHCWyEC/YN83R4E+t
         3i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=V8TT1tvu6G5VPTlJlAbyTTHguTcbqEODBsgMqEM7fOGufEgx9wYwt77ZAVk53Jc8G/
         ydvIKxohn2nR8BGlKAvwHEQ6gKXUWeOoCxLdC2rHEHK9qLO5l22YmXxBqn7r8GLJtLca
         /xJx4wEo1/DrRf72RA9ZmbRdagb4mkFUwdH0Qcn9phVw0yFZ/02znwuIsyYudHCzfOYm
         nFPdDeHEcq3MydJmMOOhVlheUuLwOjbv+wkP/e6Xzs6cQNiyASCgY5spdiSTBU/KhAFT
         ZiluVDLzbKckOWKoosExJA6dQjQZoEvUcK1FJTjQDBQfRLqjse+tqxSHzOmP7XL5GLBm
         JdYA==
X-Forwarded-Encrypted: i=1; AL+hErEbcpvRk0uV5864MrtPWtsyKMZP6PAHyiqTxcG9xIcm65xCMJmPXXdHcXkROoZpkHP/GM8BkYVgy10m@vger.kernel.org
X-Gm-Message-State: APuU4Z8l5Hqd7780FPxPkbklgb8bYWC/pnW36U1A065ItDSDfuvHyZ4g
	N940493NUZ4kEeEdr0CDBrApStwkJZRHBMyM1QBymscdwBODpuflRDq3Rr021fT5XoiQ
X-Gm-Gg: AZFdTZfGLIlJROpf/oMY7Gj+1WX41gUx7myJi8aIoNfwVrnhu8Z5G3+djiZLlUd1bWu
	Q43OmzpT9CchtX+knY7K0vDWfc9Jv2LYmzz2eMhYNi4mwbkyNkaFCLsaPRceRFNX4FDXygso9Pr
	xm1Bt88hnuU47ADYQU6lxHjm8YBl2gMz5q/0yYjK6ZkbWHNjHO4n39Bq2O2YpJIopQD1Z0O5F92
	hBh6ekLmX5nY6+YlNuhU3wyC4pcA8MZ/QYdw6eKfVD69t2TcCwa2A8vYk8EwPl10eLMjOHe3GF1
	nedcVPJl/u38esdZKcVbHTkYbfqSGErzwkgyba0HaajbmjIIjVsU4tEaeU5jfNgBG26lhV3OE00
	YEWULYjIXftmJb4ZwogYQIEJQTPb44WJtx+1Jr5SMuvJI23qbd1ihejutPP9JgAW5hPTDC3CrTo
	sRgXZsKmaRXE0Wo4f3IC8gTy8OoOvJxttJkhyHG/0RmnXS/CfUFrdfnhmxMhu4MCFmKgJD88TcA
	dM+yqitqutijMJGYMbEv4x0pvV4Ka/H/6OxzX1YoJ27NCXK8bY5M4VjLc8tDE1YPI6yj83pi/qK
	mGhA/FtnCQERlJ5pOtwCCydXk/9WR43gGCqjpvzbApinoN8VEsxOhNVYgTLKVtoChZARxnnlVhj
	j7fZsE2p64ZGwawFTlSqLAjVXjozPhMRckBmAj6zch0lgFQgQ+bB+s9fi
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
