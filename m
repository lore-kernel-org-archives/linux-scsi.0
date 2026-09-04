Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7940A131E49;
	Fri,  4 Sep 2026 01:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788486143; cv=none; b=oCdNBABR9oOGkQeysi2iTSCLocHT3hgJqYxB32P5PeohtXtaig/16YokxcXGUw6yHL9PSgvQTLsLclO6Rzx1eLiNhWDN9rAdS8cncG6vv+kRj5Bo7ExSpgCrN2a4VO+lnm5ySnhDu4/1v75QiJAAVL2Iu2+JrsFmuQCw06mRSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788486143; c=relaxed/simple;
	bh=z/Wm21amLR43C6+AcNIn7WvEFct2hOwaNZcuTu6Y9AY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LAkrzCBvtElPiSd7zeSsZ7q9Jr3WHAFzSFJqzRGPphZilFMmgKeK6wBZmcLhpUjtsbevR3w1nHYaBJ3t/+DWV7vKRN5pFXcudYe1o6+kWU0SURErbNMmfJFj9xTqbLLrz+myvN8hvLKaOEv6UY0nxpibVRNU85atYjAWiicfRJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9gcEDCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9gcEDCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858701F000E9;
	Fri,  4 Sep 2026 01:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788486142;
	bh=z/Wm21amLR43C6+AcNIn7WvEFct2hOwaNZcuTu6Y9AY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9gcEDCxOC5QGPiiVlUi1t8WqJUOvySyv+ValdfUgHpjDaaR9TEwwsPvRnuXOkQmd
	 ZmlPBSPwkVTRV+afmVPGpH8cJk6MfTIfYgGGKWS0ioobedDdaLppdDVWEMzdRMJCWR
	 BzdYGaEATX2fmbxxI8mu8YZTd2Z42ZVtYBgoXXP491Lx8dYMAIga1yRO/KErh6NW9A
	 Q+3UZvcwR6ccIMwevK5AokkHWHDm4kOQIusLGl9SdV+9Lk09tFModvxa/EnZMHy8s4
	 ZhmsJ0IeV/nbr7d44ljxJpT06b0EMRtf2sxS8nPZ2E3Ezcn3wcLsxXOWaXVPCv97cc
	 fyg+vlw4hW5PQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/40] scsi: megaraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260904002644.157668-22-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:42:21 +0000
Message-Id: <20260904014221.858701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the megaraid driver to use the scsi_set_sense() function and
> replace all hard-coded additional sense codes and additional sense code
> qualifiers with the enum values defined in include/scsi/scsi_sense.h. This
> helps with code clarity as the sense codes being processed are easier to
> test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D21

