Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9228D347529;
	Fri,  4 Sep 2026 01:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485166; cv=none; b=o/rnR9AP1Skc0qXgAZLpZ12sLKXN9tYuC8r4rhM7shPQxiWnxhpCvnB3lgcaXMbxr2NIDplxDccfhr4Eya3TDMvqyNLnLWXqYJy2XkdlTM5zAOlUFGCCU0LijGeXCJornCwOooUV8YcxLUmCgKHFIaGgUPZMN6DR6V1Hf8aoM8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485166; c=relaxed/simple;
	bh=Bb/abtMkaaShz1esUwjWzlECXlQTT1anWt1Zqcac7sM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XalvKpELnt0jmwSRLiUm1bWIkQNpOSIRGQDAfMzlQz9W2JPSHyKXVQZRr61nn01xr1TRM5+rjy94hfgddhfZVR2g4YdY0CJJJx5LCXco+3s7aDeZco3aMPg0R3HsrCHfwNpuMO35u4usDMvACWf3dfTBMHWIZd/0XWBVmuPLLMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2z8fBOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2z8fBOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CB91F000E9;
	Fri,  4 Sep 2026 01:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485165;
	bh=Bb/abtMkaaShz1esUwjWzlECXlQTT1anWt1Zqcac7sM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n2z8fBOqZGEvcEUWn65MPK8yJxlkVsxWB7qjkm9lwoo5AKOsI9pMc/TL4BiLtbcyA
	 DRbtHnAaig8fLVj7PbeVcg+9zptclEmD3vwWRLQH+Khks3f3ObOcKew9JA6MnBETjj
	 IMu7HqXZASOk3mMK/09qU6cgBvrOYRalflFpbnIRKZrsr+Q/O8TPGC2qPWxki+vRTO
	 LNmwERxk0C5B16ydp+XUJPCfild6UYaPZq2gAP+dnvM7b4q99aMyU4ZJ3tI3seVTEH
	 b/6KAwRCJXKbMdq7cd7NYqZ3U3NSWpy63HyTg3k83kAJRSKVd0vfXKMNc0MDLXDwm1
	 q4JEKQPZyxurQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/40] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-18-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:26:04 +0000
Message-Id: <20260904012604.A1CB91F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D17

