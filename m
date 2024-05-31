Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9E2136665;
	Fri, 31 May 2024 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146543; cv=none; b=lwWFp99O4C4mdUpdiqirudSdjOv8b0W4axhI/4bSlvc4TCjmlEGud5v1SqcF3mj+tgOTd2zQwvo3pQ8JmTL6kCn3SGeok4LNRMjJnW0V85c0C5xpaAle1tOe6zYMXpu/OncEwuz0P79AibDVHJmkhi4trTYu08g2l3of/lORw/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146543; c=relaxed/simple;
	bh=RaqLSGhEQS90V4eEbZdob1K4qW3TlvwlWvbaxZRpEQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eVlWvqi02hSMKiw3FDPYYLk+eyD0Q1tJvyBExzll2eRl3hVxaLK2M+N3hqRKY4Z8VUqfUIS7j97KVjPS5uEG7xiP2e8wVqntJBIzQ+Zq4n6xQtluj+Z7JnP0s6zU4GJpyXldH2tRtm77JwL/kLo1z/w3UPcrDKSwZpsc1IeSe2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9QA3diQ; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9QA3diQ"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-250932883daso121892fac.1;
        Fri, 31 May 2024 02:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717146540; x=1717751340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7TiTdx/nEWXXgHHbHN78B+YsjlKDnX0w9LWVG0G2x4=;
        b=O9QA3diQm8eIW22G24J2ERzxYnaeh2Nt7gzkskXIQYUodqr8JkQKgPySEoDKEU8N0p
         Fcxc6vGYtrGE7Q9fQ7gPcBooEWd0b/H5NryuaZEwE5XDt9RTgFDkLDORLjgWIkYnAQy6
         YJBEbUOIx3uCBNVzm7S5HlQtVpBJ2fCRTLIJhx/iEDsYFEEBpY1qcxXJT5LZcE4/piIz
         JrcqTQSpg1fLE4J+q2UNHY59G+J2jy6906ut7fdVfXbMxlG8087tpOMGohCdQe8LWd1p
         3zqUb+uCHOKEOhvwdSRNy6p0kcPeI7rDwvIzE2agswmrNCIfiozWiZlWvU5de31/93Te
         PLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717146540; x=1717751340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7TiTdx/nEWXXgHHbHN78B+YsjlKDnX0w9LWVG0G2x4=;
        b=qAAA2CMxGRCNDNR52gPWpQuIvX8YN4uX2sKSvQ+kl52L7F59aBKm9p/HXnRsTmdApW
         iUi2P9zvNY/yhZfSuqkbhORzNQl479+1EM5E7IhlqgOicNn5/dXf77wQWZyzNZzipoJn
         YSc6GyjHjIPzwVkuQf3vWUBbpHgW7cwRdKALl0DmMc0u/XWhfmllWgRU1kLwyveccmUo
         7RJonfaDEJa4/neNA1aGra00Vh/Yji2V7ks4rDPtLOVVm9jemTvqs9ggX0w54pfzqkdU
         rhVVNs8llVMyLzSsonGrqUnTmXZ7cEmLpzgA+uB9kvEohLZdSUbABIJc9ejjjoN7Ehv+
         nEdg==
X-Forwarded-Encrypted: i=1; AJvYcCX+SUMBT1xrVkQ+wr7RssyAfGUbCwjaSIA/RhwAcT+D4qkIYyAbN2akA3nA2rEy6iZbk6gcpkU5MbFWo6+NN+O8GXyaBNlMme1Vy7XL8XaeUo38JHr9LAd0xgye7BK6xUrE6xEH4U5YCUKPqzj9iOaY41PykCsoh7YyLiaiyWDiRk27GQ==
X-Gm-Message-State: AOJu0Yx2EuRmJjdwB2J5Yzchml2mG6MP6mVvVZVCHOgbadOG5bAvYITD
	DzdBnieLUenMyZ/aftuI2oqYbsgNY3Q6i8feRxdt93YGwwc7FVyXID5Qp5oCgKVTiJCHzYTSt0E
	e8tN8P9UlhnxSU3EM3ZAkoJvZPfM=
X-Google-Smtp-Source: AGHT+IHoKiJiwn0RUfGlBR1LOXIQjJEAP/TieA174CPldpRPuDqgZrspO+vxp9UsllxKnQz9RUjusbGg9aknaFlS5Ec=
X-Received: by 2002:a05:6870:9346:b0:250:6422:86a with SMTP id
 586e51a60fabf-25065b70997mr1985845fac.10.1717146540364; Fri, 31 May 2024
 02:09:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240531074837.1648501-1-hch@lst.de> <20240531074837.1648501-4-hch@lst.de>
In-Reply-To: <20240531074837.1648501-4-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 31 May 2024 11:08:48 +0200
Message-ID: <CAOi1vP_mY-a7aiWod-eVz8xuhGz4mHBBoZZgr2FoxS5wVUym3w@mail.gmail.com>
Subject: Re: [PATCH 03/14] rbd: increase io_opt again
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Josef Bacik <josef@toxicpanda.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	nbd@other.debian.org, ceph-devel@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 9:48=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Commit 16d80c54ad42 ("rbd: set io_min, io_opt and discard_granularity to
> alloc_size") lowered the io_opt size for rbd from objset_bytes which is
> 4MB for typical setup to alloc_size which is typically 64KB.
>
> The commit mostly talks about discard behavior and does mention io_min
> in passing.  Reducing io_opt means reducing the readahead size, which
> seems counter-intuitive given that rbd currently abuses the user
> max_sectors setting to actually increase the I/O size.  Switch back
> to the old setting to allow larger reads (the readahead size despite it's
> name actually limits the size of any buffered read) and to prepare
> for using io_opt in the max_sectors calculation and getting drivers out
> of the business of overriding the max_user_sectors value.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 26ff5cd2bf0abc..46dc487ccc17eb 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4955,8 +4955,8 @@ static int rbd_init_disk(struct rbd_device *rbd_dev=
)
>         struct queue_limits lim =3D {
>                 .max_hw_sectors         =3D objset_bytes >> SECTOR_SHIFT,
>                 .max_user_sectors       =3D objset_bytes >> SECTOR_SHIFT,
> +               .io_opt                 =3D objset_bytes,
>                 .io_min                 =3D rbd_dev->opts->alloc_size,
> -               .io_opt                 =3D rbd_dev->opts->alloc_size,
>                 .max_segments           =3D USHRT_MAX,
>                 .max_segment_size       =3D UINT_MAX,
>         };
> --
> 2.43.0
>

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
