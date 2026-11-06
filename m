Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793985930;
	b=2UiVBDuNfaarEWuzAa3F9EFmHiVQYtrjSOMORMte0J9f59TWG2s9oklNySBu0rxUg14E
	 ztZ/1VwYxIvL3i3AbzFH1+ulNfkpZCrx7C3OZkP8vOHweBvu+Ed6GC7/GAx9kNt2EWBV9
	 HDtL9fmy0XiI44Ui/br1BabkLi5u81aCJQTzn9l/0jI5OoUMrDDr9N2GaHJOMYdS3uiii
	 dX7gmyMGjdSqRZlNY7cxiKL5yJEvkc0xp5dcLdZOq23X5LJVIRewIedFX8i2BWAI4ixm/
	 y2nF0ROvg09poB18fDv5LKKu0fDIDmDbK7jvyNDUxQ0KMs45+p0fYZWwis8ggioMGGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985930;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
	b=Xl1BAAb8IVeKVCw7OMs0y8yzv1Goqpg5SaNQApGdMmVoGRxl14nb3BshlLhj5VZl8Ft3
	 MFhEAoD8HKrfhD3Lq5tUtXDgiYBHY/INf5PHXA1v/yoCrQBvMZIXfGirK2N1mFKQUIDbJ
	 cT00xn1Iip0lP7LorFa3Uz1AI8213QmdUHnDSLY45n6iJ244b7YQm9X1eqAVsEqqE8MO8
	 NourHm6NY7oo8zCGW0ldSSIE/P00E5t+mlzVHODD5UgsiT4Nihkm8Hgcv3c28TP/UIEgr
	 VltszBjJn+iV8sM7mHuzUTqwOaA72o7tCbeMPEEdmYWGQ3MDWzhHKg2lyDGCQzVm/tQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="ewlCk/lT";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376B606A32E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 17:25:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5376B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ewlCk/lT
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so1365e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Nov 2026 09:25:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793985929; cv=none;
        d=google.com; s=arc-20260327;
        b=CfHt19f1tmfIsVjX28XeJMdLOLWXuWQ8loqTBXbtN6JhrD5dq8vQRlWYhIW66/klWG
         Ui4T+o7qnqbYZbqw9iTFUWeKL7V7TN/h6UkuL/XJKqew2qcNVseh/el4xLSWy68Is57z
         f6b2dUC0tQaCfdd1KJjRuavddennlH+cmX4HqHtn0uLsqTEkW9ldwz2bxNv9ryS0xE6K
         BkauyTfZEDS9srNtDHhprOqU6OAfs9FtPgllYkoW0702jdPM/jEdcYa0xa8YUyozIAiX
         W6XAmKrWRULiaekjmUozIg8Jo4c80/m+oroGL8VOVlgHse8zghibCBv+J23rY1bGplrF
         nERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        fh=LrJ3+hXLm4tK3NmNkHn8nLwsLsq726SwCgCFa6ijDWM=;
        b=PKVwajmWU2bbRdSWarJ4Td1spV/PBnJtzuVVTo6DUWT5z9hOA+nxAmXvl8nsTS2kd+
         yHks/HwVInYFQHarnM9MbKDc8lPGh/SL8La203kY9fYP3b2kGCf3Dh7qAx2eD9dJ3Vqy
         ykvCK48Bc2l1cG5quadXVpcUQZ5eBHagWlpoL9ST69uHRNH/5Bv8HyGvTiczzpT7zMXI
         +zA7BSGhQ8N/ut1+l1vIsoS4Nb/jNXY9wynYtDaekNDX97kAWmAlEHHU93Gyk275wOqT
         7F5EnlFgnWpSBLb2pIWlhWg/cNJzXf4r+ce5+nEyMXCSuWTV7wXUlhas6iYy78vpfH63
         Q1Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793985929; x=1794590729; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        b=ewlCk/lTPeKUbMBQjEFxdvXeSJcIPNy2WZqd3RMZR0f4utguz18d1I/25cveVMzzFo
         RT7lseKNhSlQDjNcDMIS/DhwPwUeEMuf3p3QA2SuaR2YWynu3cJ86aMi1V+rohgW/ueU
         wdYBRPMGl9NpfqRBybmsYTfqpJAAsq2YUA3wBescnBCrmLOck2h5FL8JtaVfjtntUhMa
         atBGAqnYj6CPAyn1iWAem1TaZV6cbQ3Ry89bYsb3Y3ddSg87IS5+y0t3k5n/93i7MVsR
         kOjiJQAHUQ9kOMLGGhlfbBtqgDPKlex2gLuJNJ4aUDDAFXSR7PLhJYKjThP1OZfQlk1U
         nw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985929; x=1794590729;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fUrJNblI2O1hZNjcXmW6nSh+tuR5hYmiGJK5WvnJCM8=;
        b=dZJwxXO7mItLmhcKsNoLldT9FJlAe9IKsnkuNwR+L7F3XDWL4L9MvmkwhD6TtguiqZ
         l1RXd05aaa/PoxAs8a6b1AdAIuQVil1+vIPtrFJ/H8Gbp5a3FMCZBjEk6pixPacBIeLW
         a61SAwbgwUcTugcdmC0q1LNlVfuNqEwJoAO9ycSfFMpZG01+Geb0MGCf17ZesohoTHg3
         MYUaq6NFr3cuPLoIP9CIXgFPNDzESr70W/Ky0AaNEm61/jZq6ckqsDL25iAznNznmRCz
         46v7TcHfy2DGlK5S8df3FJAfsvoJLQtCMyh7ki+KCiYoGzPHSl2JBdVnxXz7pHBd9Cnh
         sfTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzeRrT1xbEAHE5gyHG2gepB9JxHufNWURo4cUt1TqbBFp3bZko5KoKW+ALPAKeqQStdCmJw7jXC3c5Z@vger.kernel.org
X-Gm-Message-State: APuU4Z95X+yHpjzRaRBOkqR5RRRQDKe9FvgNqNwQ34qUoTsXbPxHlf7J
	BWAn/7YtRwWJ1bE1feAARcGCYZqQrgiWMjrOjbQp18NO5O5FEYtaJcwqOwd58ZYIQVodXYYQEgb
	tX6Hk3LZ5x4rMLPkCZLvO+dX5zO+whQfDPmix4CM7
X-Gm-Gg: AYBFou1CvtI6cRsS175H1P+7plOpYsLvuzw1TDcYX28jafw6RhDiHWdBr42q4kauvKb
	bcE+HhgYWhzKpgN4vgieecVkvL9dTd7Z/g0dXsiL9z6YKXL4SsY2EFv0ShBb8QnrQw00LUCerDj
	RkvEwmmn6jWIcic3PkUFDwII5HPOxOAjtu5PiMxffNLhssk6m4LIepqds4GeGmDAJn0RewwU8Xv
	mRzTC1Z995sw5hWg/KwVlFTslw55nJKJnMqYtxsUwiGmtIcEeJtbAACMQJwirNTs0tATsN8y5xM
	iPjOceysKBLj4IsvsFpz63QdIe/r2j4RUyXGnr/DgBkpL89+kK94sZUy9LSBWXb1DvJiVLpxTbQ
	BBB9q2u/sCBzqAn3OgVMt9jLOqKbF6feLHf/iE3HHwcg3Dzur1e8QXg9fkKxRpP2XEEj8cGYrQJ
	6m7hBKTvw4HsAHplG+Pd1jrIcf/RdTueC/wvZqQLINHlJO
X-Received: by 2002:a05:600d:644f:20b0:4a2:a8c:22ae with SMTP id
 5b1f17b1804b1-4b78a315689mr14125e9.12.1793985928307; Fri, 06 Nov 2026
 09:25:28 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106131829.3228926-1-cui.tao@linux.dev> <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
In-Reply-To: <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 6 Nov 2026 09:25:16 -0800
X-Gm-Features: AclHuK_zmhBLd-fBLwMoqE-7QVB_DAT0nisVVyTe7VWHd67XlQDn1ECR61povKo
Message-ID: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, dgilbert@interlog.com, 
	mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com, 
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com, 
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com, 
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, 
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org, 
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org, 
	phasta@kernel.org, joro@8bytes.org, will@kernel.org, 
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, 
	mason@kernel.org, aesteve@redhat.com, harry@kernel.org, vbabka@suse.cz, 
	cuitao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 5:23=E2=80=AFAM Christian K=C3=B6nig <christian.koen=
ig@amd.com> wrote:
>
> On 11/6/26 14:18, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> >
> > udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
> > data pages keep the accounting of the memfd they were instantiated in,
> > but the bookkeeping around them does not: the page pointer array and
> > the pinned_folios array, both sized by the buffer page count, plus the
> > transient folios array sized by the memfd folio count, are plain
> > GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> > memory, and size_limit_mb defaults to INT_MAX.
> >
> > Charge the three kvmalloc allocations so the creator pays for the
> > metadata it induces.  The system heap in the same subsystem already
> > accounts its buffer allocation;

Only if the mem_accounting param is set to true. We (Android)
currently depend on it being disabled because system heap buffers
don't have a single owner for their entire lifetime (ownership often
changes immediately after they are allocated), and the kernel doesn't
have the ability to switch who is charged for the buffer memory quite
yet. Albert is working hard on it at the moment.

Could you update the message to note the mem_accounting param pls?

> > the data pages here stay with the
> > memfd.

memfd / udmabuf is a little special because it uses shmem for the
backing store, which is already tracked by memcg under all conditions
(except hugetlb). We don't currently use udmabuf, so the lack of memcg
charge transfer for udmabuf is not an issue. But once we get charge
transfer working for the system heap it'd be good to follow up with
udmabuf.

> T.J. needs to take a look here, but I fear that this might break uAPI.

Thanks for looping me in Christian. The buffer allocations cost
gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
so I don't expect charging them to break anyone. Leaving them
uncharged is an accounting gap though, since someone could spam many
udmabufs from the same memfd and only pay for the memfd pages once. So
this change is ok with me.

> A lot of the DMA-buf resources are intentionally not charged against memc=
g.
>
> Regards,
> Christian.
>
> >
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>

With the commit message updated to mention the mem_accounting param:
Reviewed-by: T.J. Mercier <tjmercier@google.com>
