Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC82E2286;
	Thu,  3 Sep 2026 03:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407485; cv=none; b=swuR5Bb4TpG3YqBvry4qGNIRREQaEsDRryaX28sHbI/xEQkMawCXvkvwocp30CDguroZNd5IQXQiLyGF4roeeqVpDCzZJaINq/UJKBp9BA/HnQKOx0cGyGoR8aYblJSBOa2pB60PhBw3EcVcS21df9mMMm6Uw2xEnjsIssaXapI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407485; c=relaxed/simple;
	bh=2fOrTUNOzhz7HxsDqtTsVrgzlc0AYGKq7r7LacQdECE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JHmia40j7ONZmXA8gUnGjDkFDk0IDK8pjPNpKPigB8XTb9CCK0za6AVz0Wz5Ysr7/Qq+Az0/sH62fWLiZQN4kw+wLceU+YNnrBzRFF5guuhArvnEY4ac18UqaPZL5tU5q0C2CTZTeEd7/D48QtIZpOlHNXY47ZuB8D34FwijoE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moYubxAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moYubxAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFB71F000E9;
	Thu,  3 Sep 2026 03:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407484;
	bh=2fOrTUNOzhz7HxsDqtTsVrgzlc0AYGKq7r7LacQdECE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=moYubxAoMctOTubj88SG3tyAZER0VmxU4OknVMO2RXBehKXXdjGrZBejqhqE8dlDc
	 7/HkawDhP+yoAXvvtYtmVS9RY4XxQOCQvwVeiK05+Xwew9dK7DJpPttDEqHTteH55g
	 St49GsCn+59UZsEKgP8EVQaoD/IpHbuj0jMGDNF9Z+NUJMsRz7/6wTnPm4VzgNkJ8O
	 6yrdMd4e+IkToWMCiyTjmZoUJy2FE7pNn+lL5JbaqxqDZ9MRYo88hphMY4C/I9lx/h
	 Ak/pYUfPrggP08X6dZt4EUtkBz51LjxcotaJZB0TV65XsRFNs4KGgm989mdCglojCZ
	 VfnCCxwhlqD0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/40] scsi: device_handlers: rdac: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260903034201.112211-15-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:51:23 +0000
Message-Id: <20260903035123.DEFB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
> 16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
> and replace all hard-coded additional sense codes and additional sense
> code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
> This helps with code clarity as the sense codes being processed are easier
> to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D14

