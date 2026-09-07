Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D82E7367;
	Mon,  7 Sep 2026 02:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749567; cv=none; b=gpJaC2hkS6gKGChLIqm7pOHQBbLcAxLTvTgmPJ+DJuRmvqPQ0TsBxy8etoiiqnoK49l6iG3Nd9Xa+jSunZG5Fa303fwS+N6+Oj3zeu5S7LpS8zNppP9fJuOwSCFr/UyBEN5eFl78GxxsOwQ4Efv8Je+VqbJZ0+z13LaDcrHp7gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749567; c=relaxed/simple;
	bh=EA9sS7hylC0pmd9sy2fenWEtcemwrg7dZNRa/33BgYc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b2yfSpejdAY7RH0B6RBnMuzEMvgpIpCaNpdRFp8N8TmXtzGSgXd+II27tBDg0CxA7Urwb0m3B+5gMZUkJ/L2HeiVQ3mi/lRCHQF4UGfKd7aflpIaFfGFwHESR6IEAkHj4BN7TpPh932quPBm7wA+ig02KKh0qVf3S9/5GKWQPjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igJITPRM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igJITPRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126131F00A3A;
	Mon,  7 Sep 2026 02:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749565;
	bh=EA9sS7hylC0pmd9sy2fenWEtcemwrg7dZNRa/33BgYc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=igJITPRM+iuFwMZNWuF18UcOanJulGfnjfWXYR+rV6UDeoZiob9U4hoAVlis3Ht++
	 0Wf0987gWXwuAe9IL76rOgZrDuF0gwPI4ZjHkbpNcYSKHAO+f2CoBTT0hM6wPU5NTi
	 hUJuDQY99iFHhVsCkBDQozPDV14Nf3gkSvJJDWkD/jW18OD9UVDWSnylQ7cEJV0pJ3
	 kzFcIlvmcGn18DHlTOLRnlyqaouYRjd6XG92nH9Lsh73NEm4M5Z/NXN83UmTSIgp8d
	 s3zj8e4wBHd8pv2bYyRzeKE859XvybVa9SIwd4XZ53wUDa2M0noh81NqKK8AMJIexj
	 sfmt5iFfKWx8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/40] scsi: device_handlers: rdac: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260907024343.1046387-15-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:52:44 +0000
Message-Id: <20260907025245.126131F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D14

