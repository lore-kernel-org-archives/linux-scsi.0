Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90BA4A5C24;
	Tue,  8 Sep 2026 09:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859990; cv=none; b=rVLncv3V75jQ8Ir/57Pgh8bZN+4kPspirQJsfslv8gvhhRnKZMiKT+GIaMljJvzuG7GQUgvp+7DOAc1gWAsc4QRNjiyuG63ZFXzEfVXNOT9lrnMRyTxSC/10El2NN1QyNvhcAEWxea/6mz24MK4NTtKwqQk1eydHUyGcm21jt9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859990; c=relaxed/simple;
	bh=+UYHQXbUbLLMrNrLJ6dyyOzXURhB5CeLAsGqvpGuYZ4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fVeoAq7gjuxw50I8F6Z9ka+7SNNJqKJE3DhadWQStnBDIGTEYysBeMd8F3UBVGGNMivmj9+o2ThLYvhUxiK9EseCJbHH9ASfq9fbb7ORRfmpYaQWenOZBSesXBDM0exqayVO4fs12/whmunoetqcgZcMYlp8yAzFeIXcQQA5ZpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUSvSeUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUSvSeUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE01F00A3F;
	Tue,  8 Sep 2026 09:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859989;
	bh=+UYHQXbUbLLMrNrLJ6dyyOzXURhB5CeLAsGqvpGuYZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DUSvSeUaGGluEHnfbqq4TWNziQvb4G6KbGPqPTUB3LktBWVaV9lUiYGIGIA/Lzvmi
	 AzLfoVW3BqLYgDA/Bk4lNY8e0uJF0yas/7zUj9Iw7o+sg3fZuEtVKZbAwLETzZ144P
	 GNAUsbiAZkm2TfKs9kQW/z2PgK4rU1raFIxa2TnYB7JdSExYMMfsXt+KlOkaV4roTW
	 P3GetOMgk0rXwvwQ4zapgx9BfVzQ7kYYLnhv6wiBbKZMKvSa82JvPXLN96Xlc/MXmp
	 zJEPjYx0gCGKbPjuBGbmYKKEId1bwoOCVKbXQZ0fAYsQB6FylFJPNNARCA5asI5i80
	 nVf0sl07WaLew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 12/40] scsi: st: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-ide@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-13-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:33:08 +0000
Message-Id: <20260908093309.28FE01F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI tape driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D12

