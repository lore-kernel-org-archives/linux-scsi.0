Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8C22083;
	Thu, 30 May 2024 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098501; cv=none; b=bxjtyBFMK0ZKnxCjJWUmmGEOeQGgB/nlp12obzdski7Kdpu+O9xjXRvpZ4W2cJfs+L2R+/zFkZ/ODTFi/m0OGUANUbWnokNHuP7+TAQaaKnfT3ZqAzm3gvwyRBuTEIdjUCRPnoB8N2cLwoWwKjOpO+wnB2uds21Bo4MV9e58vA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098501; c=relaxed/simple;
	bh=ZtUUQX2Y9TvdpZmxYV4+XoKIEuYCr5J5XRNdtBXbG/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YznfILYszqjll7ouD2fVARgKmPOWIao9K4gNf4Y20OE3lwRW+eFXVB04hivi1GHD4VUZbKr8XUvT7+iNmjixX1a48z5IAQpQXjoZLeYShR4YKDUEn/FgJhaoL2tZkpF+pepa3FNrLbq58Oz8BAqAxYW8DyfKn09HIRt3gRmLdKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bznaX4Tu; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bznaX4Tu"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-24c9f297524so686848fac.0;
        Thu, 30 May 2024 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717098498; x=1717703298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=41y1G1yWB6PRjXPqqWESihB4DpKvKPtS6LjA52lk1aM=;
        b=bznaX4TuIr6eO+B9w2tatJT5GGzCiU/K7sY0k5Rm5yX4+k2iAglobFqL1yAW/HbdUy
         aVBGCKfanj//nzRgITXaWLu6s+M3Toy4CIhG8anTl2c+pITwTmByVDTS4PKmXHc6R/Ek
         fIB6xEbZ2vXhUp7KxE9KtZU0ezmzA1/ghQqPuER9cDYH6u+X3Zw9LEzRQ1cY8mjfzuZx
         p2ntSZDotGIS5bx/f8+Ec78qBWAV9Kt1o9S1AQYfMfWGMctaI4j9/FWsBy0FWBhCrizS
         hKXeWbML732+//bxlk4+Z44rcprIbw/CIE7MVDPp8dDRhcHCTkiJOieD4vtUIvxnZhWf
         vOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098498; x=1717703298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41y1G1yWB6PRjXPqqWESihB4DpKvKPtS6LjA52lk1aM=;
        b=o2hmObQGTPqfPGdZYsQP0d9rm3Cuneqf7MWfZJ2Y4V6Fq62Dc581dLoFiPdelKpwLk
         Mxkiz4llJ7ruAy67oM0KcuIFRDPrjXiALIIi0/8y5fU/LaqRG66wBpbw3muM1+t0S/j0
         QLWOjo2DC9C6ZY7EfyVZya9opRutpIrN+yvYVVPPdIAwNncfPVuA8iwytUPsfRasB8bd
         hhdRQ78DVm/rm8Ey1ftYJgckysZ0cHBGUUYlWNZ12wTiLFff4qWuAzWRZM4Tkzhqhkgu
         XL5SCAkmOBuk7LXt0Sk5fSu6bugMPJZLmipleS367/ySSfyDwH4xo6WMWP5EBZZ5Xo50
         NEjA==
X-Forwarded-Encrypted: i=1; AJvYcCU/bQr09QNz7e89WJA71yeio3XdUpoWV5cCZlUB8USLx0LAEn1Jq81BFfva27EGPz91l8hhCMsB8/CCyj11jM+dtOnsUm+QYvqE/Z1kmsDzt6GEbivpyq5tI1+bejmA87tYrK0DENad0lUUcBF2ZQOo1/B2FC6IKGOfcxnBzoU+/NB63A==
X-Gm-Message-State: AOJu0Yx4A2ZjQlz4K8ewATMokstyVmuvO1Ad+vYVRboU4a3YxsT2Fw51
	c3OKv6yMBt1ainCI0kRz/jBxmV1zDhzWn77SB7OGR1UXTpEp2NoiM1ppjtrstjkzy3O03sReK35
	mhaBJP6xt219pDt1SzYgAfT1RIl6sODihye4=
X-Google-Smtp-Source: AGHT+IGxcLZtvGZ8VsT8cGFEuW/elxJjHWgoM8RDpdS5UpADe97i5sefwnR8gwVFsz1jHFTWagn8cx64x4raaIJwd/s=
X-Received: by 2002:a05:6870:b492:b0:250:6f7c:495 with SMTP id
 586e51a60fabf-2506f7c0a24mr2683166fac.9.1717098498330; Thu, 30 May 2024
 12:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529050507.1392041-1-hch@lst.de> <20240529050507.1392041-3-hch@lst.de>
In-Reply-To: <20240529050507.1392041-3-hch@lst.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 30 May 2024 21:48:06 +0200
Message-ID: <CAOi1vP-F0FO4WTnrEt7FC-uu2C8NTbejvJQQGdZqT475c2G1jA@mail.gmail.com>
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for max_sectors
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

On Wed, May 29, 2024 at 7:05=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
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
> Note that rd picks a different value for the optimal I/O size vs the
> user max_sectors value, so this is a bit of a behavior change that
> could use careful review from people familiar with rbd.

Hi Christoph,

For rbd, this change effectively lowers max_sectors from 4M to 64K or
less and that is definitely not desirable.  From previous interactions
with users we want max_sectors to match max_hw_sectors -- this has come
up a quite a few times over the years.  Some people just aren't aware
of the soft cap and the fact that it's adjustable and get frustrated
over the time poured into debugging their iostat numbers for workloads
that can send object (set) size I/Os.

Looking at the git history, we lowered io_opt from objset_bytes to
opts->alloc_size in commit [1], but I guess io_opt was lowered just
along for the ride.  What that commit was concerned with is really
discard_granularity and to a smaller extent io_min.

How much difference does io_opt make in the real world?  If what rbd
does stands in the way of a tree-wide cleanup, I would much rather bump
io_opt back to objset_bytes (i.e. what max_user_sectors is currently
set to).

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D16d80c54ad42c573a897ae7bcf5a9816be54e6fe

Thanks,

                Ilya
