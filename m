Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0981E98E3;
	Fri,  4 Sep 2026 01:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484536; cv=none; b=SZ5tzlZda2oBsrFg8PhGarsTl+hJZt59yJWwr+A2fKJiTmwBf/zd2coqju0EgGypPC+VT+vjLoT7elGmC8B5HovgkPsdMpFbwKUpjzUg5Z8r1WHWx6FQf4xBkXoL6KKjzREE4PdRFCQRtwKifoumun2ShP9hUBsvZGL7G9xxXbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484536; c=relaxed/simple;
	bh=DD4G99UfpvkNYRPQjb+vyxXTOS8d9bsJDvp3jrZxL88=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WYeVjNSf4QhgvTGEXgDYSHVFqSTdJuLOYorcD6ibyViBcLMz8bpDx5ETX8b03gtuc0hmAKKUit8JI8rRwaKUwKQKwg1+uEjS5RCBt9u7IBEmLZrnEdtEf2f3j9hEth05iGURZvDfe1LcpDUYj7jF52tqU6lp9kWgxTKsoiZg2sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHxBUrzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHxBUrzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200DA1F000E9;
	Fri,  4 Sep 2026 01:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484535;
	bh=DD4G99UfpvkNYRPQjb+vyxXTOS8d9bsJDvp3jrZxL88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nHxBUrzm2lRalfUkGG0tBWhnCRaNcPDm0ia9n1yA9H7s8694DhlHH8VBr4NTlTRAY
	 v9T66o7wbytzaVqqdpd2i0TeBuR4b7L/u0mDMnNyj4fp5ha/xSK8HaEYkcTjZZKb0r
	 eLjmhR1WDgasgWL6J0NE8MiY8ckdiviV9j0+x9N7YHP1v+9QBANFIhPNa+jO+gpVWC
	 k2Y2MMpj1lqU1qJhj2eS1C5CPQTAYmBtFO32JARW6rbdHNjAOSMmKraub+w2jKmIbf
	 gJXvvjELMVSUJmVX75ETryorew/Y8BI5QtSdzarBm2Rn+mPtaHz46xCVbk7pMWqiPf
	 yX/iq1n+atFzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/40] scsi: device_handlers: rdac: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260904002644.157668-15-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:15:34 +0000
Message-Id: <20260904011535.200DA1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D14

