Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2561B4E3EF8;
	Tue,  8 Sep 2026 09:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859604; cv=none; b=b30vI4zeRLmfkLSvRpkemTfC8G3uwSFi7ytFil+3OdFlmK+H0Nc3MiA2fLPrU9dsztMCGAvuikv9JJwewSgoaHtqG58X8UgmTykIt7UaU56h99lvsqs5a4VJIR334c3TS6xFT57UwPtsJQb4rmFE75qw6KqUY7fpKFYvvZTzLlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859604; c=relaxed/simple;
	bh=xQ241fPFmiMHMyT7R1cU+6tgSzOV4IsN2h+e/cIEe4o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Uduif4n9R/rDXirqXDwpAMywiyccp9mRJYnmb7yseXjetXUV40pVVMqPXVxXM8sppQuAuaoQb+AgMkZqwqozrWgn+cemmTTnhfs6jS3VqrIzD0hUC/JCWhON0zz4UX2h5KDKrmuJBIZ/bfX1FHxtPGNjkspH6Z+yN50UDU8BFT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=It4P6pry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="It4P6pry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431FE1F00A3A;
	Tue,  8 Sep 2026 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859602;
	bh=xQ241fPFmiMHMyT7R1cU+6tgSzOV4IsN2h+e/cIEe4o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=It4P6pryNlBrudhFqzlYCvDne7JmQtDG8DYVITxzqMBF2Iy9zVJFCD0YXG136h461
	 TDGVQNDmSHtE9KQnRHRTguguxuLUhtaJAOHimAge5koBN3+nWNTbWw7g+ZgphicMJJ
	 p2x+BdP7/g7iGyN3u7vkxKjsyP3VsdvXLu4HWtxBjPkuSvgbZjagiaix8H+hnojut6
	 q/3rXwJ9zknjvJdlikCX7awbb+3ObfesEa6u05gqQtpjxKVJxM0l/GxRcwS1qQ7uS3
	 557OgAvv7cBYOeM9FmZBTspc5fRGpCzR6r3Mzd3d0iInuZ4VB+erF/q5hFEOXc4YDZ
	 cAWn1k6sJ52Yw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/40] scsi: sd: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-9-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:26:41 +0000
Message-Id: <20260908092642.431FE1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D8

