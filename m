Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37208EEC0;
	Fri,  4 Sep 2026 01:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788486739; cv=none; b=bgd7hx4MZPEIzpGW/hxJvCSBH5VlUz3J9wUxvsWirovQpgs46m9gliz1glpJeByWktnfiy7IztrfuEgnJ509TQnU65hM9RHHshyhzWHJLM8IVgEApo+WsHohYgmB+/uQQqs5naqzPGdxle/FS7IOGDdLbE5TVRPrxv1agRxfl70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788486739; c=relaxed/simple;
	bh=h3/HvkdSW0v/N1jb41s8Sve3GjQ0gYbQ+dQ8p2ye2pk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NTvcRo9geTXSOmwX1OcryEKeBMfcusktEPFw3daufpejhuw9eOKkpID8D6EtDXJQ4UoTebfpjFW6+Xa4IhLXjydmoLqvIDC6db/nln9U0E/0vMze4Iv0mH/WaGELXaJD4wYa6lBIAznE1M13D68c3YoAzi9COhH9u9STHZ6vv3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jthXw/Yn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jthXw/Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FBC1F000E9;
	Fri,  4 Sep 2026 01:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788486737;
	bh=h3/HvkdSW0v/N1jb41s8Sve3GjQ0gYbQ+dQ8p2ye2pk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jthXw/YnXh1MQKRYGCUcK7KI1vgYUORne0O5cld4SloYvdvuJGRjh3qbgDqECmk9j
	 StbT7TSWKWHJfoqQM3Cf/SSq4jm9IoYvXAZ80s458pBCzsu2UySQ3whdR4EZOLxMFN
	 srrbSqjFytszmpVXU0JIw7+GxuayAzWwUgLfCgXLu/tcqEOZc7Xd/by4mR6W4l/oxp
	 0p7qu7qFeUsl5z2BtHVHtcuUS8m5m6Or29yL3/J5r4sCkihn2D/QnyP2JlbSFyjYAX
	 8iw4UbsUc9tEAj30l2DRd8anbK+1h1KGegKl7yNM5k3FXIEU4CNbW2FOk/SvVAkb/e
	 /A6zMZxyk7fyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/40] scsi: qla2xxx: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260904002644.157668-25-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:52:16 +0000
Message-Id: <20260904015217.46FBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the qla2xxx driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D24

