Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15FE3655EE;
	Sat,  5 Sep 2026 03:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579067; cv=none; b=hDH6wgJOR1mGE7sDP6l+c+TwSP1eHd/vzhFiXekyesqFPHJdAwUSV4uhutnqraw7/G3Gv0E9NlHh9PpNjuY/syxsCCV4jBfnOjoOIxrTTd7yoyPbt18Bp1M23kTMBn2SD/c9tj9zTdM3qjdHcuT8Pr7bMoS6TJhVPaac63qy9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579067; c=relaxed/simple;
	bh=gaRmbo0EFPOgUwch0IURKdJ5yrtwQpQ+NtwMtXrFADY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lzscC3iedllYaAkmoJEaVLoPpXBJm02Gna/RfXDozycuuQ/m9Z00f131AyS9idOXKpECcAfofFK56rUgJpVWIBMJ4Hs6zHJw5rsU3HiHGiOVLMKlC6CXPcPOpJlKNWqCHr/nBxyYhkScJx3P4R8NG507MmZ8ZWDsMEzLOhAOuBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkXoUbJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkXoUbJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF541F00A3D;
	Sat,  5 Sep 2026 03:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579066;
	bh=gaRmbo0EFPOgUwch0IURKdJ5yrtwQpQ+NtwMtXrFADY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UkXoUbJ/vLZxQkIQ1JIuQ0uarmsJYrLHJmRoYIBB7TIwaI8IFIW38KMV2H9oStzvr
	 QosCt5EhBXBxOpMzhNOh4jGeooooISHh9qxUkcJEOmUzKvBskep5Q1h3uHGXPCvyMt
	 Qf+mnrxO+FAoLaVQoqf9GdMWOuJ2skJ7fglYpZX7Vuzt3n62mP1J+ppfWQl3W7YzN/
	 +LzWOTnGzX8vwibPRBkHToniYpUBJqzr5h/JKsrDk2EQRL+R+13uliFLkJyW+6+pFO
	 WejtdWrnSRycnD1Wg9Ryrj0sdLEHaN+2cz5BfYi0he399HewOEchzgVVUSLzSHGxEq
	 mmNILgOednL3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 17/40] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-18-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:31:05 +0000
Message-Id: <20260905033105.9FF541F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpt3sas driver to replace all hard-coded additional sense
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
60-1-dlemoal@kernel.org?part=3D17

