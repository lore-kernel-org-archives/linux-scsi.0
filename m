Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80D7357D14;
	Tue, 16 Jun 2026 15:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624067; cv=none; b=GRu4lakGOfHrkMEFRB39/VFb34+lpNn6NCmNKE5l/fkhTIhpa1h67wmZFFVUdHYSdo4VILLv6GU1FX0O4qo6CQqBHz2f4Gv/zQrSGigsBp0C1+6FfhnJ68XF64hZGLhWQrVbNIjC+82tQj8nDfFG7MXlgkhfseugTiyrcaNCZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624067; c=relaxed/simple;
	bh=NwO7YNCf0e1FMcg7/ofLmjRLIHPiMnVoCeVCy0QUwaE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IHf5uEOkNnKrzaMAIKFrUnOft2fDung8bIH/3uNKPrCF1QvBS/Go6dlimeRQppNZ6Gg6d7SI1RmDSycBtrqjBYHBGjocLP3m7oF3E0cEXAxD6SLmpriO+1Rl2f2KTpK4AlD/cGUWZbmk3qhJICmeBdlbuPAj6xByBh1j5JOqrCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPLz5b+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPLz5b+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115BF1F00A3A;
	Tue, 16 Jun 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781624066;
	bh=uHrIF9VuKTf5vcJELvJipBtDqmZInOSVh3vezwZZz40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dPLz5b+XX1zwsKN6rMf8jriyGyemsejvWFTVM1f+U60N3djGJm1m3RK2glI0RIG86
	 l9E+WxMXDDUXWnnslxwfhhfIFwbnhtmU3pfEkpefR3+BvT11kj4mRj7Ul6S3rR3G/M
	 PpUCP4XKBD3CHxV1hT9hjpkF5Lb6cljL0GfHMig5/3nvlPMijwkceyPASiobBTyNj5
	 s+tawVAyJNn1qnhWkOkIQRpdUWb/E2jfl+vvU3Wb4nR00NONkYhZ55YLtXXg/Izd0r
	 z0Ft3TbrUpm6rdiRvOHlicaK2mYSpBMhmzBUwk+L/o5PWXCSd57soFXSTT4iB/DP4q
	 DSIOR+tp69k4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260616152219.6268-2-djeffery@redhat.com>
References: <20260616152219.6268-2-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:34:25 +0000
Message-Id: <20260616153426.115BF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make a separate function for the part of device_shutdown() that does the
> shutown for a single device.  This is in preparation for making device
> shutdown asynchronous.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616152219.6268=
-1-djeffery@redhat.com?part=3D1

