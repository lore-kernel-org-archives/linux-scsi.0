Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332D242D88;
	Fri,  4 Sep 2026 02:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788487960; cv=none; b=mVKYdsweu/r8IyViP0+mLMqdUW1rhLAicvAMeukpiznYkjc43VifiYxeXPKJ7RdRneFskKu60mkHQ2Sw7AprT2PmV54z+jzJZeFiszH4gLlFvKAIX61ONCd/dd237qTu8ZcNDg55RhN2WwosJfzWy/S92GM+By02K6Ea1f6INNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788487960; c=relaxed/simple;
	bh=qgZ530366g0odKigjWsn4hiKJoOf3pxrVUmohB7c5HI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qc+r4u4K/k3sHzp2Vykp1+K3msg0nXC97704XC15P07IcW363wytfoQWFrDzch4yppvr2ulM4aGLdl3AOGk0WrtDwM7yNqQmvFqHxjHYiywTSwsdpv+pic5e2TknpgNa+JV9bnUCDa7hyDYtNJ6Kxc2mQLHECyVqIut4bhtGF80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuPw0XLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuPw0XLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C84A1F000E9;
	Fri,  4 Sep 2026 02:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788487959;
	bh=qgZ530366g0odKigjWsn4hiKJoOf3pxrVUmohB7c5HI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LuPw0XLTP1BQ1itAWiqHiLdX5qa4FCuuMZIXIz+kWYQsmM3Kyfhv33l3q7tr48mp7
	 9VCl/lAXLvw2j14+O5Rx3aFKA1oHMKyDLa2zBYZzOrgBlWH2+n+wzPsHAKinaU08gz
	 KvRT7wLIMlelmqPbl30l6tkluceCVT0Zivo66zTdMniq3ebvNZX+x/phpeogo6nOK7
	 afE2icRExPVrgZD08RP7fk0cfGvXxTBw/nu5pw38at3Jc6JnwEhZV1DNynRb1zQb2k
	 frvyY1tS+DOSyD2X9By8XBysRm9QM0HwQOu9XZtOh7noNGqWOy/0xlpJmWvOaeiOfE
	 twu+YgO52UjNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 29/40] scsi: libiscsi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-30-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:12:38 +0000
Message-Id: <20260904021238.8C84A1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D29

