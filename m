Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88F525A98;
	Tue,  8 Sep 2026 10:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861808; cv=none; b=aA6A50T5APTIsWQ6ABuQomgJGD0ZtgLCIwFlUa0a2lMtf4fQ+EktZQYRDieDygAJ4dmFoUViPfJPhUKMVg7S0g+9iAwOQAEo/T+GXppdJdpm391OuC2Jn8RCxHo7ip9D2ZjmGw8GnL/OKhn0a5imzcjptAdvzjS76+7zbdpBirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861808; c=relaxed/simple;
	bh=cCfgGVItVg9zjlquAvcf/zVcrXFYPePQlNm/pWU8cWY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VGsR0ytYmEq1snTJhDNdFRTU0YIOMhKLdC46ov0VncvtUPyU8y/sfsL9Gq2Sx5ey73aYms/BGt9f5fdXDzMqyzb3usoi3lusA45Z7vHnzUVOA3f7Usvujr0r40BZ6Mgixl1qS8KlixT/FuWn7/jlXnTUg9rFDCCXWX5MJSMRAeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A206B1F00A3A;
	Tue,  8 Sep 2026 10:03:25 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 26/40] scsi: lpfc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260908090308.1085097-27-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-27-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:03:16 +0000
Message-Id: <20260908100325.A206B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the lpfc driver to use scsi_set_sense() and replace all
> hard-coded additional sense codes and additional sense code qualifiers
> with the enum values defined in include/scsi/scsi_sense.h. This helps with
> code clarity as the sense codes being processed are easier to test and
> self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D26

