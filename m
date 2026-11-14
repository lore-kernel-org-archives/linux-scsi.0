Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794628410;
	b=vn87Oift6aw8JUQ998yXo8jgy+Me126+aX1JqP3OWF2BGrLAeqPxFwgFXFWnemxd3JK7
	 V9uQw6bHh0AgwI8CJhIlkBARULD32ouWjx777cPEpLs893AIO9+EsppxvWbw5/ae+GdFp
	 QjQ3V+JOWyzxteGEzEOODGHhM5M185ffRmnBVIbsNq6QucsN/2KgqlQArgc8iJvvPQHgX
	 BwFQ7GT0mHRb0tKuceoXs6tZGGz1kG53dBKSwbPUfkfM92RYbbMmTSVK46PEwwXzhl8Bv
	 cq+eN8ElmwPZZ9rJgMQwCo+AKIxAceeaCdr+ScGjl4WLapsfL7R7JU9Eyv77vtMfvcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794628410;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fs7o6/g2Q1PhZl3WxIoIu5qFnHLTxHLTgIPvqU/p6vQ=;
	b=uwQ9CLOEfzRI6C+Y/p94cO1HY/IEemwMi0y5wJebuFFcVu310+8OxLjihb846ygKp08S
	 +5hDiZCOY84ehPurHNnvxTIYu+BV4QcQwDmQTNnOcEcggTDza40B4ZaEgQRX+av7YnOkI
	 TWo6hh0lWsxYb9Cft1nxzb/76cHaqFYnSHbzA03vaONIT6yAvov2qNNxCwrbT1ohuN3ip
	 fKYkD17qGckeF5Tfkz4hUI1yGyX6qUrNjnNHFuoOYewWj+lZu1PXoEpHhpkBMvPqAMmav
	 hOLQm3XUVPB1aYEdBYpkUDTbRm140ipJY9wxIwlPP8BJ5rlAZqJegqVxfR6acJ6zmXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVgV5vKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F5D606A32E
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 03:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XVgV5vKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298951F000C4;
	Sat, 14 Nov 2026 03:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794628410;
	bh=Fs7o6/g2Q1PhZl3WxIoIu5qFnHLTxHLTgIPvqU/p6vQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XVgV5vKJ0HdYk940VJ2k9SxBzTdVpoIsPvg7Ot9EUObcdOdzvUDnpKbZnl2h40Pig
	 so0sR+0qtfMZFfz+B96AjqnrRX9Gvy19ygIhMIJ3fPIVEQs0a40hJna24qJuHyeu1J
	 TCB5XCiC+WntxdO9NXL9IqHS7afgPN94sEFlOgU1skQcxqbeD0gE3dHWXYLa9KZR+A
	 rYDsjGiV59bwB/KF0pMH9P1zmhHwvlovha1xB322D0cEpWM/w4jFW7bvDrvFdxZL1v
	 6oGsJ9UcQvP9qGsqx15C1wS6frFKk536l8avCipvj/m3/jAaBMxL5+8nYfgrh23UEu
	 QGbFkORzd74Xw==
Message-ID: <sashiko-outbox-214130@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/4] scsi: arcmsr: wrap the type B completion index
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261114033810.549787-4-yhlee@isslab.korea.ac.kr>
References: <20261114033810.549787-1-yhlee@isslab.korea.ac.kr>
 <20261114033810.549787-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 03:53:29 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: arcmsr: Fixes trailer cites 1c57e86d75cf instead of
  1a4f550a09f8
--

commit bdb98590f8437552875503e5c3790a14bf604318
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

> scsi: arcmsr: wrap the type B completion index before using it
>
> struct MessageUnit_B lives in the dma_alloc_coherent() area shared with
> the adapter, and holds the completion ring next to the index into it:
>
>         uint32_t        done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
>         uint32_t        postq_index;
>         uint32_t        doneq_index;
>
> arcmsr_hbaB_postqueue_isr() takes doneq_index from there and subscripts
> done_qbuffer[] with it, and only afterwards reduces it:
>
>         index =3D reg->doneq_index;
>         while ((flag_ccb =3D reg->done_qbuffer[index]) !=3D 0) {
>                 ...
>                 reg->done_qbuffer[index] =3D 0;
>                 index++;
>                 index %=3D ARCMSR_MAX_HBB_POSTQUEUE;
>                 reg->doneq_index =3D index;
>         }
>
> So the first iteration uses the value as it was found, unmasked.  An
> index beyond ARCMSR_MAX_HBB_POSTQUEUE (264) reads past done_qbuffer[]
> and, should the word it finds be non-zero, stores a zero there as well.
> arcmsr_hbaB_polling_ccbdone() has the same ordering.
>
> Reduce the index where it is read instead, which leaves the rest of the
> loop unchanged.
>
> Measured with a KASAN build.  struct MessageUnit_B is 2176 bytes with
> done_qbuffer at offset 1056, so a reported index of 600 reads 3456 bytes
> in:
>
>   BUG: KASAN: slab-out-of-bounds in arcmsr_hbaB_postqueue_isr+0x1f5/0x270=
 [arcmsr]
>   Read of size 4 at addr ffff88800c08cd80 by task init/1
>   ...
>    which belongs to the cache kmalloc-4k of size 4096
>   The buggy address is located 1280 bytes to the right of
>
> Fixes: 1c57e86d75cf ("[SCSI] arcmsr: initial driver, version 1.20.00.13")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[Severity: Low]
1c57e86d75cf ("[SCSI] arcmsr: initial driver, version 1.20.00.13") only
supported Type A adapters.  Type B adapter support, struct MessageUnit_B,
and the unmasked reg->doneq_index reads in arcmsr_hbaB_postqueue_isr() and
arcmsr_hbaB_polling_ccbdone() (originally named arcmsr_hbb_postqueue_isr()
and arcmsr_polling_hbb_ccbdone()) were introduced later.  Should the Fixes:
tag be:

  Fixes: 1a4f550a09f8 ("[SCSI] arcmsr: 1.20.00.15: add SATA RAID plus other=
 fixes")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114033810.5497=
87-1-yhlee@isslab.korea.ac.kr?part=3D3
