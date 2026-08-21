Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07BC469848;
	Fri, 21 Aug 2026 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323095; cv=none; b=QtTBQ/Bo5j0J1SaIkI4rWKCTODvpo3N7rm8TDCh49UDRdwJxizJvgBe6E9sAATVOkrRp0ys4Dizxya9Vsy1NxH3PU5NWqrlgBxssG3oE4EuN5Zrikuwc/eKrbFwzuCDu/AIco4Dt5lqvesNSb6PPKJJNa12VWP6jI1mzCbKX7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323095; c=relaxed/simple;
	bh=g66c49g2gV02OO4Gv3cC4Wj3wRt7WKGsajCLoaK9RMM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pv6qiiPFeTv3hvcKp7U0KLftp4uSHOaLYM+sVB3xkw8NH6ykKn7Q2xOBzSo6NYwiLcCwwewIJaBCYzv1w6TwoMcFzKoq1EdG7CNULvpa/FGPsF9epc2VW1wbVWkRUF+5wfoRl55BzK9sGuAcoOflD4keo+X1Y8REgtxiQmBdDAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzvymU2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzvymU2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C091F000E9;
	Fri, 21 Aug 2026 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787323091;
	bh=g66c49g2gV02OO4Gv3cC4Wj3wRt7WKGsajCLoaK9RMM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bzvymU2RPAsv3wSAa5p2l0mkt0IV53hVU/wNN+a6Z5ZQ4SCILEcEMUqPZEmaq/V9O
	 s88J+zn4XE3LaGhvWULGvyeuVGCQXwsVew5uL4r+q+OtckwsfDFc6QZbA8cALbkDtq
	 6dtq4iLNQIOaqVYswE794+M1zNZUxTfqdl1uTXD4gN7B+AZnM5iK+qxYivpWZikpBf
	 1tgNlWhFtmWZ2qJ7Ltd7nQKlJjZoTjLjQb5U7HB7jLXwsr1HhHi6WCQ9EYGu50tYC5
	 0rPcFmJCF6zvhGaCcE/YABiwa3fAZVLJEC+tCe352eAdoqHBF4v8Mtdvduk+obCgKq
	 5i502SUxNqIxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260821142414.150892-10-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-10-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:38:10 +0000
Message-Id: <20260821143811.27C091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D9

