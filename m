Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852A43B83F9;
	Wed, 26 Aug 2026 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733573; cv=none; b=Vg5Qa+4ZCo1eD3CkEyCOadE0pjALy2CQxHyb4p0BAd/s5HQm2Xf6kUtPNlKTJ563pDJJwAPNE2GZsChuTu5KjSW9dhK0LDSmjlAA+q/LNea7xHRVdj/BNdQ9HaEzdlOfKce5uPephMV7RVVKTRR98CBXAriFuKn8u/TPjHKuoGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733573; c=relaxed/simple;
	bh=h+wyz9iuptKq4hTBhNgbHDQA2SQHKm6TdKAi2tnh51g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ncRtD/9kIZ1Wi7X6nT2AHk+MV1VQl/Q1tmCuPtaM+XODjnMdwbvXWn8xXLuKFgHSIe4l8n+afa/dULRKwml/5G1IsbmjMIxlydOIB2nUKIrswzamlipfNBvmRJaWBU2wISmoplYCz9KdQGXGfBMGRFowKAIgoJ1D0AjeWCXsIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbpJBZE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbpJBZE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19E51F000E9;
	Wed, 26 Aug 2026 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787733572;
	bh=UxJK8+Foae8ykARXQOFz3KahwcHGmojp5cshlNT0Qu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VbpJBZE7DKZAIC52tGQC4cnNFKpER/dx0pFeyxjkoaxs67k7qjMTLJA0d1chIBgBq
	 4NT3vIXJo3OGF0zyahqLrfC5CZZNoI9sB+zc7X/4S6X+c8w1vOk361TlwQEXqNVwYf
	 CZJmXUDyJH4zbFewCTL9sYAxT8UXNNkjX1whuz9pSnRzkCFaF1PU9vWR6bcSqB7ZaM
	 2+IB6X0kYChD/eEfwryNMlagHADQ3mddQ7m0d/7/OxzaugODGBCrmGLfTi1+MkoXCs
	 pnl42ZvwLBzHVCDfGOBSHI96jO2JMjg8bohs0YD8cOGVqzirQ6ukL2Itrc5Nf6VVEg
	 6cVXvUqJSxJUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] treewide: fix spelling of "overridden"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Yang" <yanglinlin@kylinos.cn>
Cc: dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org
In-Reply-To: <20260826083715.625136-1-yanglinlin@kylinos.cn>
References: <20260826083715.625136-1-yanglinlin@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 08:39:31 +0000
Message-Id: <20260826083931.D19E51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Fix misspelling of "overridden" (missing a 'd') in comments across
> multiple drivers.  The correct spelling "overridden" is already used
> 292 times in the same drivers/ directory.
>=20
> All occurrences are in comments only, no functional change.
>=20
> Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826083715.6251=
36-1-yanglinlin@kylinos.cn?part=3D1

