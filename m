Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859451;
	b=H20/84vtPKPQAervUc5lsT5U1vORC9s3GpQduMoLYDvKem/AERS3tIApMHlRngZODBQE
	 52TzEtwumNVa+U4ErkHnueTnbOytu5DmboU83NOBajg7EV9MDLmfgBR4N7RWUS684LS4j
	 xIn7bFxg/sqbHsPgVo/8zZrQRGU/mff1V9v14jq44nyv8W68oQNmITqOQj4Sk2fD26cg7
	 iTIvbz3nbHZVW8rar/yqDmfr50DDV6lPJSwGfW+wUgVrLYvtGk4ytT+LzLh7snIOrcDfp
	 oIXUkNw2kaILOaSRmELPum4MdRFYqKtNWrxtXQu10LXmulHnpixRv0lNW1XtWixuung==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859451;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	b=1nD6oE7h4wkwHB7PYDkQu1ZFL0cqZLctqk8vbAw1EeSPXEmd6ASqxRwGmPZOeikaiDRd
	 sgJJxsSuqnK5EOlQvZou7NHD/YROBanw7cactglp0Vz9jAdyIecyATtOScdAo2cFkFeDX
	 En2xVkbf3vpweVHbSdGp+sLmDfy+qbecAfkd5WLkaRoDDECM5wSRt4ZgJM+2r8IzISSz1
	 GcN+p4EwggQHM0MPTxIFtaKbdLxsrrSvupNrayXXdn5iR6gfGEybpYGHfHTU0twKj/Nwv
	 BqfXm7hPoTZFERsrQqsHEBVm2XMC964rJsK49vY2A3U8/HVXDEYZj8G7425v58HNZzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E9B606A331
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 20:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32E9B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-498f5fa5103so1736444f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=K7jtkGW3ZtwRnM6upe7zeFmD3h4T/5yWlGgisutVc8aR9vkAn/kIilgqWgszkT1qJD
         8oO8KuU3co8PIUCeLiaMXYvjIB9iR1TIvT0Llg6Wp8+MdxLWJR7lBwU79iiVIgB3RmHY
         QIQ9TkgZpGzpC58JBiRlqsVUM1XT6TvE2POPN8QHAI+dylPHxSSp0ayQH0DmNF4Yt1dI
         fkXEYDR2NBiOrUD3y+0096QxYyXC3okhEfk6NlJlpvFr9GHwg+EOrMO1LVC70yZKNJvX
         MmI3OGCsVTNq8CYqGc5+G7K2bvqRnSQnR8hRjlKowEdozj76IlFvJEyv0yDz9ZP2cl4N
         ++og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=eWdCubqi67Gt8p70IlRhqaWFGwiK9Ekab29MUwCJHGc=;
        b=KpfpGW1bZo4dE6RAs5fR0QhOJqoN0MMR97SD7PwRJa+QTgCrfaqF6rT8kegs06zypP
         nHY2wD8lHS/YxKJi2VkeilSczgYIhmXe9/JVSjXmFpa6hXDqaGDPLM1TgXnMaUMP19Am
         fIl1/wl9uL1+uoua6qQ0Dcwj0r4XIgtPjs3aqkrwzk0t+e6PpInanuxkWcfDKrKDpRoH
         HDlc/Hk8yhVgSfR0RPP8lvSruCKnEQbCzn9NH/Rd7802CiplVPFOJ0m+iz63yUWkv0l+
         ZrDRpAH7Y0yMkCiR5MGPnQtpgYddelaRCCfOqttAxatYdoYPmOlxcPuH5IWokpnaOyX9
         CEJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=hnqDx80H1BHGMZ+jCw863LQE2wm4hG6wTw//ziQNWkZpZIjdyNNCtFJNcbykSvuJWZ
         RrqgQGru9l+9Rlw9NCoAO7RXSeH6CHzRwb+h6TsbT77V+vTLtC7o5AslWzWJ8+7yhciq
         sbJxN7Yoz6y6VYO91QUyEDVlXVHt5e/uzOZriYhKEljZIduQH6pNfhdOY5sHlJFueOxf
         bN/uTLfuNBjnHaTZ+WukZQS/Wa30tWyiKsfqEPmOKtkcPCgN1gGIeLsa9pfco/3ZvP3P
         koo3Bb9/+esUnHdHS2hTd5qtXE/k/xctadMJUuU/zchcL0VDKvTRNofZgdIQ6mLOou9W
         X5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=vjNo4D0lCSXJyLJTx0BzcYoUesolaqhjumhDJqUgARvp5NnKzgNe9nOHz9YEQ1xWRn
         YkebrCfDDxh2RW80JMaZDMrUXNzUmtsjyIhPQ9NX+MutIYpVb2wyQ8Wj8PXKyJ8vVdFG
         ho98S4m0ed9+kUoeKRgDHp+knjzuiK0NrXyWZKZfFL77CIY0AlllIQ8zvCiwEzRNpLaB
         qPaB/z6gyhMy7vD+sx6+K5h4zc4Q2hKDZMtqHxzUAqJK1FjCC5YeXGvIN87J2EEnYbm3
         WKFAvMcaKCA4hfTsuXB0A4Ep0jImTgSYQ3OZ4F6JXPTEDzFPEk84TRxHHgij29eNY6Km
         OQBw==
X-Forwarded-Encrypted: i=1; AL+hErFnpbWGfAAo4ad326A8JVVETSx56ec6+VmMl13BnFRF+UoIndqN/ezjnhXn4SpyExY/FBGNpttTXTgg@vger.kernel.org
X-Gm-Message-State: APuU4Z+RvfHe9sP4+3PaSvF4kz/tZ5ggRuJBHUDRbVS8JDVrw+M1h4EJ
	BAcdMzlxtHlStldW090AsmiQ/Ss7/RMTnbFRB1VOSs2rDY9YgNAWcHeRAWTmeEw0C7j4Wuzxbgu
	GsF9Hvwk2WGls2LiUyI1vOWnbWiaBr0A=
X-Gm-Gg: AZFdTZc+d6MHou1lZH9SoTV27z6zMo+r+jXJ74xQG5gkwyhi5j2DJPwM/LHeVxdJLo6
	cjwjwPFRvZTAgRsjdUyarmIPYI7bkbtyZ7kt8vRIH4XfBGcVn2vSY1NSr4tf92znc2dJ4p1Frjv
	Ms/IFtfTZHqAb9mOiZMMhmHxGneOb4m+s6qAN+mDusWoXVdoCFrIR4cCL366LcT15Ku0T3m6qs4
	suq3k99SgebV/IfzFFOkCfQ91oYaqw67IO7O6GzSBB2VwGekBE8AJqINzQ6oX2St9yyErzGzInt
	Ye30O3we5D91mGhj6MrvN8zQ77wIbotvfCWs00a7lPvYmXP9RE/OJ9lD7HQW7tJaqRLztWTf5P3
	DOBqFouPULPUARrnw2WgdzJzAW+rIyeiwS4/k16j6BoopjW6+ITi7y5a0UQvL5yNPoAVHAv5KKD
	RMwQppuEEpzGYkDUM+YtQ=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>
