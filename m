Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD96337F30E;
	Thu,  3 Sep 2026 04:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408113; cv=none; b=S3xme0kVL5Ox3pHTbTqk2V+EOxzk8oeVmMtWfZpRtSHcDBYbroP4NGDOd2I/fnEzREl8HzZVAKtcCsakbjlafYZk7pIiQPX/0H7EvGJUK84Jh6uOgKKkMXExfRkGkxycZVyDx9dHyU8i7wPKLazIXsZ0+EwaMSWELUO5WWaNNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408113; c=relaxed/simple;
	bh=tpbCxASqcZm3Y3WXrIpMqsNAYq4Hycaj4Att1JxRyok=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e3naZGJMnVehkxMS01LRRQxOUgxP9JB5qoCabK20ZSat3XdBHkgU7IYznuNDynpsknSjHXWoQyliRLxeX8eEGiPiDk6O8OG3Im1Sf45uJhZPdYFqROT0soxoPcJ2KSQjHwG4lsVevlqeGA2MdybwjzDFUtRGLO9x7WB+9873c60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPidNbRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPidNbRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323681F000E9;
	Thu,  3 Sep 2026 04:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408112;
	bh=tpbCxASqcZm3Y3WXrIpMqsNAYq4Hycaj4Att1JxRyok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZPidNbRpqUzP1moU5WrJLIhP5xRvEThQydD0MPWsM8FxAJQzgfCcp6Qp/nBx8JaEl
	 r+na8nXA5dGX2kEJwsu/j9RiSLlysYCLxzaIoYLCMLteIowC0FAN4LbZXqHuaJxAI4
	 tczbE4zaP8yGimJSvuK/Zj9oBUPGEyNtZOUv4BfNMd6tFc7oK56epqxeZ9a6C/cMDY
	 uFH7tAtsQ6laW497PjVudv8R701g/PgHXgwdlZ6kPQYstTorRzeHzFsilVqqIxhYW8
	 SVhgkwx3AqN8i/TwUCAK/uyefiD9i0++zXRYMN/f0tzTdlFH6YAMT43sG5EuemP2Hx
	 WVCiNKuMRT3kw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260903034201.112211-32-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:01:51 +0000
Message-Id: <20260903040152.323681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D31

