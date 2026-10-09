Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161EB4F3902;
	Fri,  9 Oct 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569949; cv=none; b=HEJ/xV5kkoIYE6HE0EYuAsqWnqPalKs/spzb8jUA6joIO0mV8FztFkMWVwMoBhMkgnrO/nj+y0zWLLgMZw7Qf6YyfWdWMd1FLjhy5I9PTwH3j3+eZIMGPvPTLXoM6axZm3OYuyKpAWebE8pC65XcNI/XSON4D+11e88Trbz3Ags=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569949; c=relaxed/simple;
	bh=FGR6IAJ22ppjXpr5xm080mWSWuyxnEDDo+UtB4ySOG4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pc4Uj2PxUK6HAiPjxkKv92ns8HXlSwO74pF4QgZAi/3sBZTX2ZLIyUvd+dUi3J8pACtWiOqpExCq0UBaEt9MwVq5XMZds2WleS5o64ryshttRpjPXjylgjRo+UmtcKdY110yUc+vYypa+7rNBQWP1Tsj93VUUVqoNJ6uclp9xMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nneO5/se; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nneO5/se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7BD1F000FF;
	Fri,  9 Oct 2026 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569943;
	bh=FGR6IAJ22ppjXpr5xm080mWSWuyxnEDDo+UtB4ySOG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nneO5/seF62iUijhFLoCsBQRM40H/nOYcsQEmtzn+cCnYDeEQ35uMbOtfkMvTDefL
	 IbBBEOHhiaFI2mWG5Bq0c+JTLa52QcZzJIblpYUGky+GglszQAmqRau0D8oxMj4xIy
	 heQDk+waRR1wHju3wr+dj40lB2cV7w8FR+swYFWowEK1P9wG0TstZCuwh+szuxXuVl
	 S/AcScP9ZozJy6LUFGVJeL6v2Jrs8IILKE6He8jUP3drbmwQ0139GxUx405PBggsBp
	 LRBH0iRdi2PBivM+TKmomOojKiLXYs9ApEdg7Wh9G3nt6Tcw9z5BXLM65ia+RwzcAf
	 Xx83zN0dh6Upw==
Message-ID: <sashiko-outbox-165929@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/38] docs: filesystems: update mmap_prepare docs
 for discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-usb@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-8-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-8-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:19:02 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Describe the newly introduced discontiguous kernel page mapping mechanism,
> detailing how to use it sensibly and how the API looks.
>=20
> Explicitly detail the various discontiguous actions available and how to
> use them.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D8

