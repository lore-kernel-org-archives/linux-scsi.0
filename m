Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE25215161;
	Mon,  7 Sep 2026 03:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750220; cv=none; b=J+ClD3SbdHhhVtYT3aul3a35NzejmpDm+bm1jwm8dxNVL19Pmvs+UyHkpyDcrowJDlqoGlO7rE6h84+52DnxE7O7xf7RJSYevVo0YdnuW6ORYswcs7zrclKfB7KPS4qfsND+qrSmOlIvFTPYvyqEOWn1OnwMbowWHBq7aiflXBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750220; c=relaxed/simple;
	bh=79Ao2WrNLoY2314Zm9zmPm2xe4Pco2T9UxENjvea2qE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CQgV7mhw6S7hcDNGKFpnEvLM1K3w1F9VTlkCu+dNZbDjmSphhW0Xgr3WKCWA0RXbNb9s8W40kda0ZgVgxn5+z+oww0OzuYpfnDuZghvbYou9qpC9DEsOI5n8axDB2y7InYSAzMChDjHzQ0mqG+IcXiZ7Oug6SMUM8ZN39cs8+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ie5wuZZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ie5wuZZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9AE1F00A3A;
	Mon,  7 Sep 2026 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750218;
	bh=79Ao2WrNLoY2314Zm9zmPm2xe4Pco2T9UxENjvea2qE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ie5wuZZQ8M5f89lBLNj9G25Q4lKw02RGlba422SZ+Ag9hGChNCHoWG4WJ0LZtSTG1
	 e8oDBETqxNJ4kOArS9/KlHnMgj+1YIu4nrK2pk2wqJQS6vVKwoE3jBQJEje38yY+JD
	 A5nleZWCmZ5aBpDZo9CGGS8drrm+Psj/cKWgdAiQDhGvHI88r7mglVikUudQfDsbkz
	 JCkpZOrpTprvUGaQuAmUugn5auEHL4vw4B2PPDy6VlOG/ffINv8Sd1djwUzHSt3wSS
	 MOgyLCdgKA3XiOGRM8L33LpBVacNuQitfNvHKdrfby1v1Je6W8dNiM4HmgKItqV31E
	 QwI5+DSm+ea0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 29/40] scsi: libiscsi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-30-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:03:37 +0000
Message-Id: <20260907030338.1F9AE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libiscsi to use scsi_set_sense() and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D29

