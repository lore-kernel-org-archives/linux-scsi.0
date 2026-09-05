Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83936A022;
	Sat,  5 Sep 2026 03:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579286; cv=none; b=lJnZA7XiP3EbhjYmscXYoRrOXDk6IEhU8juNLlTSXFrnaqh80YGQGBHG7mcEu1CKkkDX09jHyQS0P3qgPyRB3plN4SKtySu0H4UTav1fTIBRPkDVJiduEI+M+kCQO0RsAs9UsHUoPTcJBBV6vMRem4GvbBc4h+J5MyT9K7cYEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579286; c=relaxed/simple;
	bh=C8dLa97Ny68qp+f7xcCGco8QlkXG+bxa3IN5+YI9S50=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r+v+ExF61m6XhXfUto+SHPyDS31SnUbR43KIv2rux9Z63BbGpnnyJFFo5ulQBwM4zAE4AnjdKhZRmG/yFq1ice643C9M0HT0z3zM1FFwyuRdHB/3O60wOsEkPrUxD/5C0H0D0+KwznEKGzBActnDtWfqn1UovUZXASlrN+X3LKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7qY80Ph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7qY80Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0FD1F00A3E;
	Sat,  5 Sep 2026 03:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579284;
	bh=C8dLa97Ny68qp+f7xcCGco8QlkXG+bxa3IN5+YI9S50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7qY80PhIl/FJxbG4NjW6nvApim9jNR4CyfTo1pZq9B7E7xHJDHhh8Agwtg6la/bq
	 4tKomOpTrnUBR84UHXoQ7D40xyYoMnxpg69fGXofyT+MFDhpX+1kUWxQWVl5u0SKnU
	 cuiNSnYgT9oTDfd/FfNalU0v5SxoKzuPIPbco5aP+cbEtJTdsGMCmZkHsEnGW8/qvB
	 GeTfdzwdyYTE3ZxJKnwZJC/lDFpro9yGuLKnTJ5kMU8kgjhWOxstyIlPwmqGEnFnrw
	 0nlHiuPYljbB0MpsMDYJEiwfL3LE7nPV38ny0WXYidCOPB8eqBOwE1Mp8YfjeR4bUa
	 6+NBaPd/19mWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 26/40] scsi: lpfc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260905032224.509860-27-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:34:43 +0000
Message-Id: <20260905033444.1E0FD1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the lpfc driver to use scsi_set_sense() and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D26

