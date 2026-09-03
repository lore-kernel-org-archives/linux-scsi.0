Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA593803D3;
	Thu,  3 Sep 2026 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408092; cv=none; b=Y3ih0Q9D17qilk43H+FofuSA/RacRizdCde7o987dRciPJLg1Bs8qlIidyfqbPRAIhbmfJ4YOJ+t9Y8GOhwAGrvRNzp+aeYC00NbYdOxfOmAMXZDKa7rzfSYz0vJi/zgi6b+BzmZh/oy3BIfbRWybhIG0+rWsWuZOR5Ygzp0mGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408092; c=relaxed/simple;
	bh=MD/XAZ9xNJL1yQM0qIb0qjnRcp59d1LUgsD7+aSJN2k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=chFMmUTsqY+MX059mRTuCRMi4ZF83rO+4UnBniJjCjoDpkm+X6kI9kEe6rGMz8aD5ZUwugmUU/zMU4jBbb4lTTjmmz5tU9EKvVV+FMAQbJH5PTyE5vO4alADUvnOopuNEsjo9geRPzkd6J0rSjKBT9mjHoNxCmsg8Zd9ODcEx8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ks0hvo/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ks0hvo/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEEC1F000E9;
	Thu,  3 Sep 2026 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408091;
	bh=MD/XAZ9xNJL1yQM0qIb0qjnRcp59d1LUgsD7+aSJN2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ks0hvo/hZWC7wqprKBkNfkVmGkJ2+5drRvP8vmxNx4WwzDH0dHpnFmgVq258SIsV0
	 41hKyYeMQRSIxWQN7tXtimC7ocThN2RdTyrOHkI8/MFHwI76pqTUkEj8hmWJAnWn9A
	 nWaeuJnTMF40HJ5C4nvyEbtuG/mtMbWC6LOzktdhT3qhlMQkZaCpYUYARzwKZXxXI2
	 TRb8muNgaOAeeU+mV/8lrSWFfTxxJEjsTrEnD/oCBRuvb3rcK2wnEibC1kZOEGx4sa
	 LcGE2oW03N6Q4jRSddLggB80lNwAoRbZUcbgeaEFE2GMNDUwBZ87IvRs4lUzjyVjAT
	 HR7Oq1i51MzLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/40] scsi: ps3rom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260903034201.112211-26-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:01:30 +0000
Message-Id: <20260903040131.1EEEC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D25

