Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D29DF59;
	Fri,  4 Sep 2026 01:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788483984; cv=none; b=fjfMfjHp61yTC9xo5JotRUGx0ifE+i723b2CU2jBQXKwiSrUVqtpgiSecOY4Je8bBpIMPMBk24h4UvqdaNY3LKumfbv3A1wvYjWO8sGcxTJsPc75JTvkFvoQmjpsqr5E+rf3BrMV/ZuQw+0qWykBILYCDszasZBE74F9NsOl5VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788483984; c=relaxed/simple;
	bh=LZ1pxggIYvmTg+HOEjcrFXys8STa4K4w4UV5zITNCrU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HBpA1Kfe//VNKdvaRlRyopF8LCRPw5uPexD1XTkHLbcui1kD9AfcHsaL+YBh6GnmmdZkzktOYeL8mHKczRT3a2voefhjHIlbVVcfNLaqHswLgCNdG5ZJJveMSIn2JxAkjP53KpbPcXGJOpY+7yFNDGRqCf/ib4BkYCEG04dBTdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/cCatXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/cCatXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4601F000E9;
	Fri,  4 Sep 2026 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788483983;
	bh=LZ1pxggIYvmTg+HOEjcrFXys8STa4K4w4UV5zITNCrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n/cCatXQmH4ng7TDb5o2a13pe0Qd8lrJp6agFIAPROSjC4KLzOg1nQ0JTwWqfPBKs
	 EbkuJ5yQPrda1kGKjLEoDKytDfpauiiGy54dWd8eJ+J6quqfu2weUht+LjIr+NGoQU
	 YgJuJNx9F+rq80kWDQeOvgCAvI9fHMiCnxUZZpEhLM8QjJ7NPiQpgrP1UD3OFnH9LQ
	 ro5KE8D4HH/+NyFubxTF8q0XEksMAoQ8AURaVAZtOkISviSMWkPa1jbnw8byCSvtQ9
	 Vwye+0yHHNLd/XJBWIg0cOmkKrj62F158D+DwKBlqgzEJklrAuMzLmNipGIWiVpwV8
	 UZFsLPahJlTIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/40] scsi: ses: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-11-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:06:22 +0000
Message-Id: <20260904010622.9F4601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
> field of struct scsi_failure and replace all hard-coded additional sense
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
68-1-dlemoal@kernel.org?part=3D10

