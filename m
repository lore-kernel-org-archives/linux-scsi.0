Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010737A856;
	Thu,  3 Sep 2026 03:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407572; cv=none; b=oIo51qzE4xelutNcwKC6kvdnSJXoIMatGHk3JXNKIenlTOpc0uetMcA9/dRMFnUuaQvCcUbtWLhKV5ITgu+j+K6fL0o+1QrxodW/h0AFFpiXVp7+qj6OZ3t41BRTMYhMjnISevDtK/AL9P5SY+2IIF5CO+7GQAcZFNoe2KE8koA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407572; c=relaxed/simple;
	bh=j9sjItV4pF2El9so8vYO5In4Zm3mulqfCk4omADX2x4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u5Bv2txdbZNPjz64iAT56ZcB6AbedaPWih4rpvet6vNVInYUrKBnQhqyfhxpIhkN7Qg56KxAfm2tKGUIMlZsM7A/pdnhDEZMoDug/4ZPnoWfhGIQQ0Ts/phVSUIhwpK1aYg2CN6dDoLZPBrONBRb+JfrcejD+5k0v271l6kyLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbbnrmRR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbbnrmRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEDC1F000E9;
	Thu,  3 Sep 2026 03:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407570;
	bh=j9sjItV4pF2El9so8vYO5In4Zm3mulqfCk4omADX2x4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GbbnrmRRF5mYxECb2ak5tleUZl/dmW7+fDrjBXyYgkkg0iL+41o/BeKNcBuMywg4k
	 oaQqOG8dYnhe/6LXwvYcCzZwg4gsQnHbijAhwSsUugHfbeY6PIf2NqA5fD90RLsxUX
	 2fnNTbmTXCJG0vOnbDV6+ujbSxIDCnStlQ8euT7xQDvfim1EBovzveehGJG8j/moPk
	 INh31fN5htpykvL+VloRQloMZ4GAu03DFvf12fg8i5XeNbmXBwS/30JGBhr75XyNc9
	 tHZjnQeVwrL6NTj5y1L4fCDq2K6VzOpC3mCKWJZvmt0a72M2lteshat+WWiz1BMklk
	 AwjFZJvoYiaqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/40] scsi: leapraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260903034201.112211-21-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:52:49 +0000
Message-Id: <20260903035249.9FEDC1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D20

