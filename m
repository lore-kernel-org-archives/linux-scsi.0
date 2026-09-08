Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7A4B0499;
	Tue,  8 Sep 2026 09:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861061; cv=none; b=d+fyX+jHB1Fg/uAUB86FI55BhxdV/2pwIqqPZrQlttUI3c6+zM8N43pwV4PiG+Kv4OzBkHrKhJuYYQwwu4b7LwjkQJWUeIZ9ENuiUIMEps06uwG3oGQMiwsiEOIkLKepzJYDrfS9yNy+aCvNT9PtfP60qgyml78LUsEJ9Gzq8Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861061; c=relaxed/simple;
	bh=Ziiuumg2qelvhLzfH5q1xd76IUnJMrmjbGAqS8J0UdQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CTgzmTD9YjtRo5zoG+fU396Dim0xxv4izmBF9fkk64JZNrkMi+zyWvgeQMAMO5z8fr/ZenetU5NdrALvAfLm0rSEo2/sVBC1mPJ8cLUV5vWCDDD1mL5ZuzxHOwb+KMVyAxBFg4/BykN+CGouUBqUPyn3VHDFuiANjLWzyy7stms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+g4KlHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+g4KlHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA6F1F00A3A;
	Tue,  8 Sep 2026 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788861059;
	bh=Ziiuumg2qelvhLzfH5q1xd76IUnJMrmjbGAqS8J0UdQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S+g4KlHkfQcNJO87bQCL/Cf6Ay6e1WdlmO2mjRriGI5OXnCH1UXGP+argIRhfOSyV
	 ohbvy3qqcsfLreA+NuJQ2z4Jtk1SNIYs9mqju8JC25ZgvWDleFN5xvpkTZ7cXL9SnG
	 rBSxcXbXFm+6dLeZjrgXWvKRChvdeWnFV/PElB/PspdOWlcsN1fDkqwh8vudVu12gi
	 u0XDzgW0A9K6bE9zAmwM8QnZSmvhivXaCkzy+4jAJSkgyKWfHBq97uC9MhTkMuFegN
	 oJz8stspT43+9UwHJV7T/XpvgFq4DQ3L30YcTyF61X3vRuirolGxWbrTL85ugkGByB
	 RIa3KZmQDJ+4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 20/40] scsi: leapraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260908090308.1085097-21-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:50:58 +0000
Message-Id: <20260908095058.CEA6F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the leapraid driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> With this change, the locally defined macros for ASC and ASCQ values are
> deleted.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D20

