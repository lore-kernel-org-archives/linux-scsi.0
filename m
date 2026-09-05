Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FFA3655EE;
	Sat,  5 Sep 2026 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579270; cv=none; b=qBKcQNmCwvrn/o5nk+6iOiGA3YLlLzy6wEt4HjITytgVeZALX6Ci1dGkwJz2FbwBLLCN8Pjklyzeq8w+d5xKQlezHA6fVVu+Z9o50TkSv4WgQGVNVbFR+KJ1l3J53BaTXL9L8kEyF6wsGgxeLJl+rMdqMQZYpHTJ+0pQjbejNrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579270; c=relaxed/simple;
	bh=pYjK6gM8MSdbwcEXLdHGPODhcS5fhJTjMYBjDjRjRfI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K6ibB0p0grvHQhltNYGfLmGjOTpSqCQP5JS23exBTECIGd6jFFThHnKv3VpMImaL/aMSu69R4JZRjGGA4EAOOIlNUjz9uPz1edVh8aiOlc/tUtXluoKgRRymQqYw/1T4/c4rJJGcYESABUFGOKxVGQO2sBFYFzHC1jnMMDnEIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDN4Vdoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDN4Vdoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A8D1F00A3D;
	Sat,  5 Sep 2026 03:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579267;
	bh=pYjK6gM8MSdbwcEXLdHGPODhcS5fhJTjMYBjDjRjRfI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mDN4VdoenCDTNtiig0gjqta/9G8H6Tcq0bvvGm51XZw0D+2J5CXiNoTaWokao/loj
	 RIyUMClc2er8E3EF6CakkV8Qth8lBhOngWR9nqvNH2QKi52Dg6SfZczhOu0tkP116t
	 nyGCczuXF5nmU+QwZPhVH8XCBltF2gJJ6vvRoiCo/H6ZK0y/01oViBUIVP/7MuVTCu
	 bWZKi3zWVrrSCTaJkhrLTS5/0SFDhsPlIn/8q1p0hF1RU1Lnd92kSANVWcb1lUDzLS
	 rqbfrbWvtYuPfWzoYQW7fzsW7qA17anhtlDXUPPIw3W1oYtLb19+N18+roAoZt5XTE
	 gzAOwXa+E6Yzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 23/40] scsi: smartpqi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org
In-Reply-To: <20260905032224.509860-24-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:34:26 +0000
Message-Id: <20260905033426.E8A8D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the smartpqi driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D23

