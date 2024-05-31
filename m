Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502A32C19E;
	Fri, 31 May 2024 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146674; cv=none; b=q2TmUiZtaZfk61zuOzoYIvpZkY7uPXrZL85qGTuYX3RKs02GG2b1Z9KJXzMSZvtIYL4km7uMbpTEc/VMIOseJhUcGtr1X6VYlEd3zEbWZjicZQspyFPCHX6Jkhmh0uDYPuZ7Tj6Fnnk7kR4xrcMA7V6OAuiqOBMuNO2h+lsLE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146674; c=relaxed/simple;
	bh=DARciJPeOOeqtGUr2Sj/lgTITqsZ35LsQ+3IdLrImNc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjasEab9CzpfaQOtkicnOXDyhOcJfaK57LR56YK8kpB8oCU711dYH/Ou4Zq//skBVxb9Ul6qMoXBd1TO8v+apS9f9SER1ESiRyILub1oA6i+lTgCdgIvqOPNwB9xQ8fuV5Wh0IjIKN8VF4y0wUUPdGQ73nrF1uK7RLdRYGMoAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IcwHSBJ2; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IcwHSBJ2"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6f855b2499cso1117766a34.1;
        Fri, 31 May 2024 02:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717146672; x=1717751472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHySJ52Pl0hABImbEf8CzUryCpcO6Vzdug5aWyPJAWM=;
        b=IcwHSBJ2tQLjT3+m0fwFCchEn5a4Re1zoSQ9AvXEzZEmWz7g8D+cHT65bOUMRNWQzD
         UZ8NH+wchdkveI8YmUY+7ogFq1yQ8cXALnxISbwIJUOp1nNuB2pn1jcTN+XwQhy8NuE8
         s5uvCXUs6sgbpuA4CLL3dM/Z6BXE6v+tTHIsKyCyvd9FFp8ge98bYlI1b4u2zawKtXVp
         wDKumiv9lKGJGPJ/8uPt4TQwBBn3cfXZpgKKMJqxUUZgO/k1tDq5RNWdBds9YOzEoCiv
         S+8EOIxKfBzkq78WUZHzYsgIlhxD6YyBxgTAgnovy6sl+1DHNF5pxVogr77NmB3yvy9Z
         EDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717146672; x=1717751472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JHySJ52Pl0hABImbEf8CzUryCpcO6Vzdug5aWyPJAWM=;
        b=T7mumCb92cD+RsMEUVT0BZBNOYOyH23sLUfEdy9ob90KJDZg4UYk+42WOEs4YOTbMD
         rVXr+OaXj8DN5oXCDhnmdfDwJJ5d9+t1FN32aKCR1Qps47gn5l7ef9kqXNLL5W8nPI5/
         vvvbAnHhxSfqL29oUdYeO4EtEr3BoG15C24yZm4FftNx/cPOHzSm7xhKscWou5o325k5
         8n/+tj8gOeVLgnicoS3nVlg3HToQJdOJWnQEw+gMJDyMyYQzgaT31+W1jc/kHy3RTfkE
         6Eei33hDkr8+H+7Ww7yKeFiq++f+Rnz6xd+DyljKi+zjlTRIsXpE61ANDKLOabwSr3+e
         4S5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLd4cDY3+YpssCmfz4EgzGbRvvlt0XYNS+W5Ort8ing8qTyCbDL4IDPMLguurqm04gnrpv2wpiIvvcPlr+RzZBjDS0d4E0ZsVSpikhGXpb8G3U+ayLoX33k2rjHCDHAvmwRgfvV+UEok5gfE4rUZUQFboNLs44JI6QfNApvy5OqN8Uag==
X-Gm-Message-State: AOJu0Yz5QfvkcmCmZDiLzwRqFt02TSMqQGu6LRhurGkdExoCUq/1qctg
	gfwZ47LEJbaC8PJWcgAVnRk5EsxYR1A1KiCYPs1VRxsHirZbeqqzUfa+ehMcs+dw8xEM9o6xvgn
	OT5qdOmQ46Fgpw6wQwV5kS3Hl7RI=
X-Google-Smtp-Source: AGHT+IGvsAs1mcJwvgWnNqWcEhu7b6x8mgHTIAZ0GzBV17r0EcNcgsUewUXES03iA8vPcRMr9oo8aonYpNodLH6h808=
X-Received: by 2002:a05:6871:339a:b0:250:75cd:34f2 with SMTP id
 586e51a60fabf-2508b99ababmr1494585fac.22.1717146672346; Fri, 31 May 2024
 02:11:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240531074837.1648501-1-hch@lst.de> <20240531074837.1648501-5-hch@lst.de>
In-Reply-To: <20240531074837.1648501-5-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 31 May 2024 11:11:00 +0200
Message-ID: <CAOi1vP-+j-RHLmnDLpsZREnYb_f7QGGhRC9YOgctsFNuE7yM3Q@mail.gmail.com>
Subject: Re: [PATCH 04/14] block: take io_opt and io_min into account for max_sectors
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Josef Bacik <josef@toxicpanda.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	nbd@other.debian.org, ceph-devel@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, 
	Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 9:48=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> The soft max_sectors limit is normally capped by the hardware limits and
> an arbitrary upper limit enforced by the kernel, but can be modified by
> the user.  A few drivers want to increase this limit (nbd, rbd) or
> adjust it up or down based on hardware capabilities (sd).
>
> Change blk_validate_limits to default max_sectors to the optimal I/O
> size, or upgrade it to the preferred minimal I/O size if that is
> larger than the kernel default if no optimal I/O size is provided based
> on the logic in the SD driver.
>
> This keeps the existing kernel default for drivers that do not provide
> an io_opt or very big io_min value, but picks a much more useful
> default for those who provide these hints, and allows to remove the
> hacks to set the user max_sectors limit in nbd, rbd and sd.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/blk-settings.c |  7 +++++++
>  drivers/block/nbd.c  |  2 +-

For rbd

>  drivers/block/rbd.c  |  1 -

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
