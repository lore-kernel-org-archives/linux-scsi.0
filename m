Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3374C35E922;
	Mon,  7 Sep 2026 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750688; cv=none; b=P6o8kObxfgv2ugiO1HzxM5kIsZDt89OnF3WkKlRJPcmgAs0Dw3NpNj6Wgp3pbVWRgRsWpAtfHjiTR8Jt7OkwF+jy/VIgGfdQV1UkXP1HVbxYA4BShHmbmxB7APrRS4khd+xpe9TRkmWKdrayYbjZRxVXdp5cff8dPFReT1ZtUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750688; c=relaxed/simple;
	bh=JfuIgqD006TNfq5P4YDQYlCSW3RdQPhHWXR2G3tXVJQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TysyUBe5McaFDkoev4NMwXuHYAwXCFAnbHv1SAlVHnhG1zpygGgCBs3FxKNGwf7KuQeXDYLOsQ5BCSRBZ4gmDtQH5Pk0KEfV3iTghzTfwsF/Ac7O3f3wuRcnjauG3y2rG7s5WUy371bKRV2tPm5PqMGMXQYHyZEcenME78HEyRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dH/QKggY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dH/QKggY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E3C1F00A3A;
	Mon,  7 Sep 2026 03:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750684;
	bh=JfuIgqD006TNfq5P4YDQYlCSW3RdQPhHWXR2G3tXVJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dH/QKggYIj+j2w1t4WhmEENqyuvYdtLqstvusoqrIhPEvCHjKcsOJx8bA1UkhlyZ8
	 GokKrBj3HNMtshloEzqwDIDL2CX4F0xAqo8rj2OmsTAujHQHWdjC8A9b0mBJjVbgO4
	 fY1tk7Z4sm4aK6k0ucMnrMcJCDDTNV1lizgElVM04pCBSShYU9tPS6kW+k6LuzZ3mt
	 1wJu95Hwi4y7UizsxEFPbP2KMtQJP6+de14Bi/NCOPv7N1qaDBLUdQUL/JaZnEtC2x
	 mB5ttN2bOlcAGpTuLvJuaK8aJoHXHhHjlRFm2f3yzV7X9OQtNu6gjZFak8nusGlmYm
	 6q6wLx4J4uaGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 08/40] scsi: sd: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-9-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:11:23 +0000
Message-Id: <20260907031124.18E3C1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D8

