Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D6282F10;
	Sat,  5 Sep 2026 03:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788580294; cv=none; b=UIdvqIeEK2D0gor8b3fEZ2b4MX6Sy8zkUtKbb2WPI13K76mn3+rz0FcYk/CjUNXTLKjM8Y2dNsYfBaw3eV8wnv19qEn72yPSPlbwQ8fCm7zaEQLbeSEaZ4VnQtbYP9hNj3L56qB+iJWs1tWl72Ps3pY3eDgrxnD4r08Pip7BeXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788580294; c=relaxed/simple;
	bh=TBMlLcX/MtGfNe5Jz4OyiOqL1o4L3nYRRYExX9Ta4xI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u1Pv0jow00cmWCbmGl42TgHUrp6UuVwaCLuU8SpuFM6/sJwH2EYJwkhWviGWvDNw69S6kzDMZdXh9vDx0i4Q5NwZysh/k/Te3yYtUBBKp54kzUmfOIwuwlMIQkxVsGtWL4C8hGoLAxR9Vz7vHSD+0AsjfcuHmD7GHGEg/929r8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNxz7whZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNxz7whZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5509E1F00A3D;
	Sat,  5 Sep 2026 03:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788580292;
	bh=TBMlLcX/MtGfNe5Jz4OyiOqL1o4L3nYRRYExX9Ta4xI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TNxz7whZMsrVet7fBd1ggBbJzcAXV+c+fDzFZB8IL45kCR5I2dj6lLz7Uyq8pbd0F
	 BKPZDaoI97IQ5N4wgp1mVw0yDtXxUoLaDlrf0x4ueMigZ4RCYJI0SpuNjIcZGWGeGp
	 I8HviW3K5lSFlJ3NUvdlvUh4+1H15kq0uXHQVGgzSz7DowSoTZgs8RWVmrkhEPXxXQ
	 U6TWt3zwNFabHZQfdqj5nZHnMYsybafFkXe/VsieFtGZZkYmvvYyPoi5vTC2Xi7E3M
	 OcKBiFgGrbGOFzRmKqQMSeBx5/FZLubGolGaAoyjC9JH7Iz2kUnF9IsU3yRU+Jwkb4
	 5JJ7k4Rx4Rd5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 37/40] ata: libata: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260905032224.509860-38-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:51:31 +0000
Message-Id: <20260905035132.5509E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libata core code to use the 16-bits sense_code field of
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
60-1-dlemoal@kernel.org?part=3D37

