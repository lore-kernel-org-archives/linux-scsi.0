Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604C63A984F;
	Tue,  8 Sep 2026 09:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859051; cv=none; b=eUW9qeY87At+W4oTjlrMC/QCzBFED3q4RDisF7A2XgEO4pcsie5WHwcKdeULvpduLmvKFyvegDb28Q+FcGrCIBuFXtbzdte47AYTpw3v5yjk0jIaAfsNJ6pGYU5uyrnDkXIAdzesgzOBnR51mMB1bpBGlG5KVT7RRHSXbX+dyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859051; c=relaxed/simple;
	bh=atieBc24xSxs+z6m3Cw5d19Yu0LhI2SUJVuhKk3T22k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cHvReRbNHQyeODUwRMKyCm21J2RE2SDFtbLVrc8eCxxr4szpvd18jJL/WpaRZYqb/Pes6K8r45MkPItyHGmKrwSOCaIMyiAZ8J+G0QanBCFwFszB1iN3cDYpkfcCyIG5KW0ku9crVp/WBOM+BCFqfTFLe3nFER0yH2+ftFfIkG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eikerSfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eikerSfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE101F00A3A;
	Tue,  8 Sep 2026 09:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859050;
	bh=atieBc24xSxs+z6m3Cw5d19Yu0LhI2SUJVuhKk3T22k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eikerSfoHoaLl8lVl9taKwEz97pBy0azVZcZ6Zo1c/bSmAplPPSYsodErYWgh3+PI
	 wcFOUlAKWLHyQrmNIm057XWGVgRj9lvcfPintaIQ8+hlOuwn7+vtJ+o5OwQbdxGLeT
	 7e9fVO3kDkmtSK0UEOIWh9yaRT/hQbcod4r+k4s6H3WTAvBUvIS2oGRwF6/Rc8z1WF
	 /hLogj7n28QPGA8gPsG2CiyNHQV6rPU9N5Q0aaTnl2gg+ZJTaa4FTxnLItIlzYr4Wq
	 Saov5AmmMuMWkrRS/Xfd0zjQK6pd9+65wrm/4OY3sfTzC6PC+8B5Jv/L8eF3Z4+OmF
	 GTTyEv/Mu5ASw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-7-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:17:29 +0000
Message-Id: <20260908091729.9DE101F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Instead of passing the sense key, additional sense code and additional
> sense code qualifier as separate parameters, change the functions
> scsi_extd_sense_format(), scsi_format_extd_sense(), and
> usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
> access the sense key and sense code with a single argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D6

