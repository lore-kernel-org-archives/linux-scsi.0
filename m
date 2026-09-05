Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5423392D;
	Sat,  5 Sep 2026 03:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579585; cv=none; b=iLuAoHokefH0M2b8XQCp0D1YV7qamtSsg8UCapTFhuHlVjRQneCUQ+F+qmgzIzkGlrU8iubFDQC+d2FSlZ0Ppqz/9coaznndPXtVwWad/HY1wBWjQTvgoFvOC6o9oNjasUohUZOLVgbt52XtzODb//8oGeihluubcJPd26Gp1II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579585; c=relaxed/simple;
	bh=MFmdOQW9BFZ/aOI3kWHaRvKlJ8SqakX0KR+zj5AlP4I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pwR7rT+jeeHge1ja8HAJf9yHF2WodvGBW4u1vkn+TbXhIy2iQADbJJdC8Ex81OGR+1pTRGkDOvQAN7mSx90aJOkrU0MChS9ujy2YzG4Bfp4bxgoM0a/j14I84LVL+B0ZfIPGaRDjSKaLzXupftbZF4motHu4h6Um+DxuJD0QTAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fD04azU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fD04azU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5991F00A3D;
	Sat,  5 Sep 2026 03:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579584;
	bh=MFmdOQW9BFZ/aOI3kWHaRvKlJ8SqakX0KR+zj5AlP4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fD04azU4vKc7G8gept4RHAXWyCQ/pNot62aap2ySwtEdB6/rgN29FWt3y/eways3c
	 u0shfVeYW5o3W0xSlXUDJX55hj4vpEf5atP/xj+wv+/eCTKSdZxTexGS0heVGsIdUN
	 iLUh/prDEeX7AKXnpu6jZjhA/vsEfUkMAA6hKbTPK1tgQuaBn66pmnr/OQszvWF5Z5
	 37JYWQIYlU0pvxWjP6dO1gelGnTymwMTn7dkqq1g/5p40tzPOe+kTr5PacYab4a5bN
	 LrxVxo7CBmT4tTMtL3HKc+yy3BDuA89vOZ/Hmdy/2ymKqc+TEvDS0gByXnKCTz0Uxa
	 zwcrNlpT+KoLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 38/40] s390: scsi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-39-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:39:43 +0000
Message-Id: <20260905033943.CE5991F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the 16-bits sense codes and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined
> in include/scsi/scsi_sense.h. This helps with code clarity as the sense
> codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D38

