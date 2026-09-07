Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8556C344D8B;
	Mon,  7 Sep 2026 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750175; cv=none; b=Nnf+mqt/HtPs3zoNM0PV1xi0R8+PjAGlMY1ETkws9xWkX2OSM3RiM2IK+Wp/8KFY5YoDlsH8YxaWlhrgrUODmzWSXZX2ILQ+GrNbz6ram4+EZc5N6LGTQaXQbCbsSaPKJmSsYPdUsAfjiVA2t810YGX7PrV85Es+Uyx6Scrhces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750175; c=relaxed/simple;
	bh=axg4Vn1rnYtotGBFHXJkVAholeV8oCaDKfoOpDQHWNw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I02JkHRS4QrHazLuVv7yo47BfkBOD/tSCAZ4nGMiBTkUdkMRnsBdYtsuEZ9sCZPO0gReqnyrHFKdKkFsldxOzJzI0TGsrnYJyCsL9VJtdcVGfa7Hz3gh8Uz0w+nKGtUlKv45Nee8CwLWHIJWOw8sCYQrvFObVNb8hiCOpnojMJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAqZaNjb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAqZaNjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51491F00A3D;
	Mon,  7 Sep 2026 03:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750174;
	bh=axg4Vn1rnYtotGBFHXJkVAholeV8oCaDKfoOpDQHWNw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QAqZaNjbazKyQ4SXxmU8d1GRu/b1BXuLKuFjjBAHReQNPTv7QME+nG9672uIQSs5j
	 yDuuCLzAG0HAyMIfZfMih/+/8mx2WLjgYcrHFWuaH3fjjv5jESKeOzlKQFG+EX6Mwg
	 Y6q74ysqh0r48D9/eV6KTkYyHDFJ6+AcHn9bppuWsM7s7pQY4efT2pn8arYdRGnY0P
	 VUdIaZ1xAlycUzmbLRR6DaeOEipRVs9ziFTrduZK7E5IqHxqNsO1RcMGtGPikYLpiN
	 hpGehGsB9Bzv/oIlLhpqEEF2AdiO+FQSLWaiquQx7ktQLJ2a2Sett+k1XHYTPcrq63
	 k3mpSBUk0yxEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 35/40] usb: storage: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-36-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:02:53 +0000
Message-Id: <20260907030253.C51491F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the USB mass storage driver to replace all hard-coded additional
> sense codes and additional sense code qualifiers with the enum values
> defined in include/scsi/scsi_sense.h. This helps with code clarity as the
> sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D35

