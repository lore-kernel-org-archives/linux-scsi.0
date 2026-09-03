Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C336432D42B;
	Thu,  3 Sep 2026 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407693; cv=none; b=eRp3cw5n8loCaLuam7ewZ6Be0gmM5sIg0I3pA56qxzqo5TlSYdbCyi9MxJyVBxFLrwooNyC43wwwozAw3WKBAoBIrvZHwEAi1M4eG/90KmMhoPsi6JOjFIck9+NrwRGCc4ZiAQFk6xlddyqX/Vw/HI2MvJKEs5ToX2t66GHPz8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407693; c=relaxed/simple;
	bh=PK8SFLrbCJoFGyoTyytf95NF2BTVTlsyfNtstdBNsQ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TfZSHR1pBvVybFxjEEgZfur0Hg84CyLxplRVRJij9eriV8OFQHnUkhNbkgtDudPmU4QNIw8tddgRWwR0PQP+NKdNvK2Zq+axJqyhpw2S+QMiy8qux48XgmZqLs/LW9uiYFHtHPpbUIa+H9Gqq7WdFraxkHsft30Sg0F6AsJrj+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcmjTyQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcmjTyQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0181F000E9;
	Thu,  3 Sep 2026 03:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407692;
	bh=PK8SFLrbCJoFGyoTyytf95NF2BTVTlsyfNtstdBNsQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WcmjTyQ4BwTg+/wlKBt36TR3r5xMa/fldKCG4MAwwqFwy5vaFHiOspQLXd9Z5eiUi
	 qwjef26+d5PQL0X8Mnkfexy5sl8AyqYoeX3qvs2ZuDgnMctNqXKehF02LN+Y9Wigw/
	 s0lE780MZt4oJ6aYWZ0z4N1krfg8WpufnmahDtwrdh4udd1uf1iaj0LVR1Xn1gz1K9
	 vpsBYnwHn37/Gyg+2G4xdE2ksJDtE4ZACS+s2cLa6nS1d+s1oatP7HMLX/zYrKTBAH
	 fF7yuP9D54pmSZZNgnXcl5tlnQDEHwfbrHML6zbBEKJV0qtm/PibLudg/iP8dOdVLI
	 3RXEpDgZTZhjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/40] scsi: smartpqi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260903034201.112211-24-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:54:51 +0000
Message-Id: <20260903035452.2F0181F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D23

