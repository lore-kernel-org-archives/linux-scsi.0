Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CA737C936;
	Sat,  5 Sep 2026 03:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579321; cv=none; b=ip+LvAMlniK3vRpcoUGBglz69Wl/ZsOTSUOUcn6sseHI8Ib41GWCrI08nE0oAs7KgGtfpmvwtbr20oEBv2oQKd5UOgUzRfm+CPMTd70Smap6FqL7LTZchztoVS3yjpklTJ/exRloxVy68ptdDBnqUlnBGwhBk25y2dkQtE7HFqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579321; c=relaxed/simple;
	bh=8di6nFOmXFxTMhS/ZziJyplw4GSLTH3mxuDjNVGGOKA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bj35YHgYpbPuKW/CfmamxeXVEnuoG+WJEdWOkczXjDmS/nIQlI0kFlFEf0q2bM1iC7b8s8abCuSfyteBaKmyuErQ+CO1uSmtd2fKs7W/du9AflfcIEqAV5HK5RwTZZMCm/u8zygckYemKTp54e/k9WAuy2H64I6lpG1inN3YE18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQi3UENR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQi3UENR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DE1F00A3D;
	Sat,  5 Sep 2026 03:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579318;
	bh=8di6nFOmXFxTMhS/ZziJyplw4GSLTH3mxuDjNVGGOKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YQi3UENR4LbhI+hRm3y58Eea0fn4DdgH5Hmd2U6jGTsfpH4PP/yOJGBZAYH9HtjVV
	 4WtYMzekKriwUWu+9eyv83uFO5hAQRlSXtrtS6LzPUY0FEgXnUCXVdWPQHOR543/HZ
	 EEGPT5FCv6dzCXheu3oEFBetDyBzVtrS/dPL3gtQMAyGBX8nkdSS766xng3IArs73o
	 CJU4znQgs9gCeVSv39NV+u85zJQGNhTJfXDN2FWKdArOZ65Njid6+JJZh0oN+OCHaA
	 3tOwh4wI0Kma1nf8pGGlXMwM/wDe1eeP4OxeSLITGVE2+0A1nGoyAx0xN26IS+4Lt8
	 wFBxFSETfi3eA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 29/40] scsi: libiscsi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260905032224.509860-30-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-30-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:35:17 +0000
Message-Id: <20260905033517.AC7DE1F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D29

