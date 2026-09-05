Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2534F36A37F;
	Sat,  5 Sep 2026 03:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579618; cv=none; b=WVrCStM/jsF5vMyKZhs7/fVOJsHyW+v0Pd53yk+KqaHI/o2+bXJ9KQBCqzRDWP5sptiTCH4gsOT1M0rvaJr9bKZKKotLKAyWrbNQsNI7A5s/7uAeJQRwqdiyM7vzrHOl01hITN8LI3aN28zkWX1GkvE47d8T477eXvZAL30bsKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579618; c=relaxed/simple;
	bh=45ONS8Ian85IjxM4hVzwop40PN2jTdQa9S4D6SRotVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WGDLaaJcxp4SIE4+/5hQAR6uW3JNmeftxZO7c6pVE4YwfnY74PxD4NRy81HRrAF7wIpL+b9M2Txp4hExkDNDNe4/TXzqAGLM6wrCJH8DxkywsUXCwAF69H3PQnwX7o53u+IePM2a16Ehzm8QC6ljn8cnNcEeu9GhOQTdGJCER60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQcrZspt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQcrZspt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5081F00A3D;
	Sat,  5 Sep 2026 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579616;
	bh=45ONS8Ian85IjxM4hVzwop40PN2jTdQa9S4D6SRotVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YQcrZspt+jCsNxIUGov8IezPw3vnq2B+21HuaN5KBOzMwfMg18gJwWbmgtCJ+KuYe
	 7BQGPpoKk97/pCeDv/o1RbAGc4D7qu0893m952xSowNWJ3baGshbRhApcOw17D8DHs
	 jCBEw72gDIf3R9ANkAMMVyBq6EqfzN5aJR2ZBCiThdlDBd86C3CoPcF3QwlbLBlVXL
	 O8e/vwL7PllYr3OThRrs3CDyf91RBunmyLLv0n+eM+J6A3TJ7QTuPfm3uOqBeuZFQE
	 swgrEflFcxMOIO1/PBs4NYdDn4mg5pJnC99c/e28EwmL+wcppWMZ85SbMf2J6TsjHv
	 Ogs/+j9Gp70Fg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 33/40] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-34-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:40:15 +0000
Message-Id: <20260905034016.1A5081F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the storvsc driver to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D33

