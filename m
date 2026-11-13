Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564363;
	b=uOZ+MtO3++SUNywx9grnvmggLHaMwjT65JcLTvmingxlFPLa3Ys3kHLfbVYlTVbWwmma
	 cQgCMq7fC32YkR7rffiQh9UZnMHA2Ib43Oqy0he7KGnynW4WNeRjO68uUsPzAuSr64rwY
	 g4GByCmgHxTN6yZWXQnoPfJUaZhhmqf8VS8e/58af/rvYFqobnokXsoOHBQkIzNKj2uBi
	 Up94sbN3MLYJ62nEc/iumVttdsFrIZT50DK9hwmx2qOjcIrMqqi+IQL7fWeUaCvnWfXQo
	 nrBKWlM372KPu6CadDHR1K5bkMcV3kRr66KB3IJUx3VA8yGl9EcbbMQ7NNsTBUJHEMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
	b=bCdTn/uEyM5ehRupmFcbjDOeJZN90hW0ijn5hQC8OI/ym3zE/60Y7EiWL4CBrheMpuZL
	 q2ivxCd6g2hTVKO82oyXsCNoeL97YMkG1bQUDoRqcXc6X2/ElEPZygI3/CJtEwsR/VkHP
	 0EAqlagtq7KA/xdyO291SwqqIZvlBL2IhgjaGCMMnLz1pOowGEPsIQCO89FtZbeSiI+pu
	 molR1p0EtNKACROI4WvhWCzmSsa+8+yfddEhJRjjUoSYmKXuNAduvzWeb3uuUYFaa4wJp
	 nhcNvc68X4xRLeuEGmUn6usiG+4FJHs4ppnRNDNchCLSkfbQmGe/7VIJcOHXd9MpmJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cjEYfKb2;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91F606B10C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC91F606B10C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cjEYfKb2
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d473cfff6so128735566b.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564361; x=1795169161; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=cjEYfKb2ti/xguKoQF5XePY0eNOezud7K33Duf47S0g3JkHBuObkd06WZKSsE2j4TE
         DEwnxkXlTao4933EWT51qAqcKFQZzBDYUWq7IdS+RrJUrXD2u7QTXDm9Wr29l+nlsY2h
         ba2aoEFnt/fnBZ4TqG8AlHBTx7MlaAOM8MSBIpLqFecTqJgM42mukp171NeFhmx0Zx4N
         EfXY8c4e2NVT5eQpV/Fv1f87MHIzBgzN889RZpIYFKMs83t0n9Q8bpafRw7OfeQ9pMp+
         KOGhNvmnj7I3xZktgYLxquasfZAW0tMnNpo/9hpnK424qA58Vs+J+ftPxNsRzOLYAEav
         G1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564361; x=1795169161;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=Wt3W5JConcxBdRRJPtSYJqoWYemiIQbqF5yHkAOm0AntA/kqyQOpYuyD+mb/lbyL8G
         CtlVdzb+EoiTUQTOV9etfLggwZgdj/qAFC4TNItAf0ubME9VKgW2INtslbS/nw1UlLug
         95/r0vI0mjDNnN68dvjaPfGKjmdmDuod6eGLKgjCJB6fgdJ3wrWgkbqhEBb7Xfxi6tUE
         jqh/aywSYeHvs4siRJLxD4P8Smed1t4O1zHaA48K8sR7vXTZOll2CZ3L2+sMnlMMPHKb
         lCoLIdUXRduwbPsmWrR545z6Hg+bq1NmJoweujsSMuQsN5IgWfdweokIdMXbM2zjE3cV
         WtUA==
X-Forwarded-Encrypted: i=1; AL+hErGboB868xsKqb9myd68kOX2QmJK/0/fW9kFc2N/kbL7mCi69eWg+Pab/joJ7ERySMlUI84tA0wtDC4/@vger.kernel.org
X-Gm-Message-State: APuU4Z9kidCwYGfdsVsrZz4vY0pteK6Cpe1xzMJbdK+/EkiMNfIqRbKm
	rT36D13VjpdIOKP4lgoRBQrvUyAHHXN9asg53yu6mB2H//I/QBbJZcbFZYXL/cjLeP5C
X-Gm-Gg: AYBFou2vL4S86oscQng20aEmoz6cL32RCxjC4Ibs3MW+42pnybp3YjyUeflyIsXp547
	16P4QA0Ab0RpB3Xp51KAG2IfN7ZSLbwcqPIZzi0mlCTpAjN+2bWVmFB4Q041hYQdU1Pln+YWRXo
	MXRKrIrafD4fxuLgY1RsHOLMK2A8bsBDbZBeqVAwDxFYUgNBtFfznz5ioY4iczFxQMH2km4luQk
	RdHt15gMREXV+FH1wByTu1e9CW/RaCl1tozKJeQeMcpSAo8RZxzdw4Wi8BJueSLCfG4s2z2SejG
	GCkD6oH1RchuumpQnaKlaE33GqJb8qU4AVBs37ijri5hY9cnSzSWXNAK3KBp957IAH6nr06CNAW
	EvFt8ZHcjPladGe7C7GQvhUgAJUEyT/qcCbrnKrIzvqLnVmtegkjMAiI3VUqcSuInVAwsevL/Pl
	o/VbzP1IneJuYZ+4HhWDSUfM/TTRMYkKvDrmkYcrVHRHmlnkCATC6bmdcTi9d1W6w0kOhLNjOSI
	gs4a/PIDDh72tKktOFYcxf0cszgxe/ykLrp3xyIHY3eiBMjl3u3hRfHgmAmc9V1e3w42jki2snv
	IoHdXMFPpZEMVFph0jUUsukyKw8YHQZiLnCH30kmlmYS0TJtzXPpIIzO8t/go/Y=
X-Received: by 2002:a17:906:ef07:b0:c4d:5820:325a with SMTP id a640c23a62f3a-c50963dc627mr169588066b.39.1794564361325;
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b8651bsm73693366b.78.2026.11.13.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Message-ID: <e8b71a2778d7d7797d433e7bac1a37ee64aaa30c.camel@amutable.com>
Subject: Re: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
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
> Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
> that can be mapped are the ring buffers and __rb_map_vma() refuses
> VM_EXEC already.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/tracefs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 5020365ca704..e04febd868eb 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/namei.h>
> @@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D TRACEFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &tracefs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
