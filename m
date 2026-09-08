Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AAA2BE03C;
	Tue,  8 Sep 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860902; cv=none; b=eIH5EhkstBP1R9UmM1RcKIUB6/BoPSjBbmm2yr/CpOkZPzfDMI637sHeCDodKaiLRaMiN0WHMwz+gZdtg+lAdLBvHkA0he2057W/wlL42Ww8547oT9S7FgL2/xQA1BEouKkunS5sAC3LNkaUmVL1GyWQwrO+p6duz2Vzbvn4Lio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860902; c=relaxed/simple;
	bh=cYJAiEi1Jm435KL27JWFjakgTfYnHKC9yy+m9BddR4A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Snp65PLmKnfTOxs3rYEXsHSrmrzG81gN2i+R+c/YxhVklPj2+O0gSScJjansHC6QMVteIHHpgFgmQRc+NDBOMdsEyoB5xfGwx9wD9ZPqiQQ1eTZ+swOpFiEtu3u88IgvsBa106PEDYyV0Q70ExM2UcwWHW59RzBaxOAdS3bx8Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B991F00A3A;
	Tue,  8 Sep 2026 09:48:20 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/40] scsi: megaraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908090308.1085097-22-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:48:17 +0000
Message-Id: <20260908094820.E3B991F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D21

