Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3683272803;
	Sat,  5 Sep 2026 03:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579313; cv=none; b=mpzFXgoGORRaRS1zp54rDnEuzBF/UKtoebBzwncN77J+d77qXwM/JJtJsxPLjS8/59tbokuhCpcxDd6P95tBsJTvbW1/VL3pnHEATEnk5KmG3SYNdlW1JTazq6Em5pzzTAmu8Jb8Jkoypd8eJ7pw/tTR9EoF8E86wGUQjZm56ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579313; c=relaxed/simple;
	bh=9u3ty1uKto2xwyv80pM7dNlC+4PFHurVEMpL3EXCi6M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eRoSkS6W2qXIQsiUf4+r8mH8AHQyd5S7ambUAgQKN3YcRa/W+8G4V8IItnoKvZBQybTX6o0NyXrD3pkhfdOWFH3OznsZ4J45WLTkga1i5c44XZX7mwvkjAZoAK5wIcKo55jhp1yDi6grUsHrFD59A9We8wu3t3OkwAweObfIFlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8LyXvIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8LyXvIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957AD1F00A3D;
	Sat,  5 Sep 2026 03:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579312;
	bh=9u3ty1uKto2xwyv80pM7dNlC+4PFHurVEMpL3EXCi6M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h8LyXvIwsPmXRoAw05QUIcKb8cV5l6qWEbOILRUKOgH32jwhAg78yieBEbPGCne5C
	 Bv+AfPyN9AKqHvuhoAk561XKfHYBUqbwknxZWG9QI7fuEO/Jj5bxmih+R+Zj9k1d92
	 aeCZFyGyOy02JEs2DWcEIMWDBOOVjRRGtVZ+aC/bPICYoqfPbC73wRDTquM8ou1Ak7
	 z2Yh/3oZdotsViOdvWOmtDp1jIpMPLXzxF6e89AQ8XluyBHv/1xNB7/B9cTOOIeFyn
	 6m26KXrAT6SBV6q8XDI4jLzBN8O/9y8d91zZtMzBOCqp3EI/4B5PtqO7zqp99taGSy
	 AUSXws+qFtKiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/40] scsi: device_handlers: alua: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260905032224.509860-17-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:35:11 +0000
Message-Id: <20260905033511.957AD1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D16

