Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C968F3612EF;
	Thu,  3 Sep 2026 04:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408052; cv=none; b=q5ylWAccqnYkdaO9b4SDKC8VobzJrHc5KWlTy+bsUFBuxsmTGRL10Jj+540IvYRMJqAUNE/ym/DzPZo2/awksSIbW9D6z3JAk+j8IFcLPzNgKuNKoBt8Famq0z0PfrleCmi1+fadnNnaqds/vPFtxPr5TWcgaOuBBHrV7QvTHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408052; c=relaxed/simple;
	bh=j5MbUEUk7Frj4Huqububnzgjqmbz+Pl8LFA4/+gHI1U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nfRzUC76ZhUAPuroud7mrZzfnz2EQbi2RknL+on9E2rJSUI23US3xhjMqtDYfdwMI+a+sXweQHgbND5e5kYs8GrWywhrGY6suq8Plljjc/7gRK0QVyKvI+pTukGySTQ8cw4nFq79xx7Oi2Loy5QTNvWqVtEloGlqmhqBVllsToU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZPldWDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZPldWDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FBE1F000E9;
	Thu,  3 Sep 2026 04:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408051;
	bh=j5MbUEUk7Frj4Huqububnzgjqmbz+Pl8LFA4/+gHI1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FZPldWDbYzuHsuoHR4767ifHLxbqIyn+wlwXns9T0enOKdonwIVHK2A7+SbYUBy5Q
	 1ZWpUcavDRtdNfafuT3l0u1EdCENe7HJY2fSAePEhob7n7+wk7AyZePi7jD9q31fp0
	 ZeeebjrqB2rnpvIYR71N68zQamGzPkmYXI+dP8wnrWrVTiqKiZgHW/QslOQHhlCt3J
	 Fcz8oXQ/wkZTd7MuSHRcMu5EiBTpIzQpFpuXtcw6FynQ63w1+Gm7kOFjAvD9S94bm0
	 34XczGQsxTnF+SOXbrfNljxKiBBGcrtAHxUCXXGydusYzJztj2J6leqJZfBOe5Udne
	 aOybf4RiQnNRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/40] scsi: sd: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260903034201.112211-9-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:00:50 +0000
Message-Id: <20260903040051.36FBE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI disk driver to use as much as possible the 16-bits
> sense_code field of struct scsi_sense_hdr and struct scsi_failure and
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D8

