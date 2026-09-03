Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AB3271464;
	Thu,  3 Sep 2026 03:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407508; cv=none; b=pxPbAF/Xgmai4nkOA42+MgKbttd9JDINGIPcpIC35V9M8oneV6pnhCey17wGjLCSbZp8j85qbHv2/eBNJY2TT/duUJTZ3/qcxxI6K3Mq7slDBwLI1CC//O7p79C/HN92FpNLccy2B9P9t5mQQGi83SV151YsD37ONnpTrBfsvQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407508; c=relaxed/simple;
	bh=n7TwCZ/nW1PFftTZ2fBIOIL/Z0eFgEWhfHe3IXJWMWg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RtQWcN1kOuaz05bH/dV8Bzdu61UndKOVqrje5DfhavAiM1lE28hCQxQ/bnF45TK23zMf/o6PtDQkbj8FYLENv6uJyd2biLeARL8Tvg5EnwDtS6HHv0esVlHSiWv3gwA0FEolsiGxyAUFTvtH81/gvpmXLCcf52d5zubgnxtZ3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehbLnlv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehbLnlv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BC01F000E9;
	Thu,  3 Sep 2026 03:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407507;
	bh=n7TwCZ/nW1PFftTZ2fBIOIL/Z0eFgEWhfHe3IXJWMWg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ehbLnlv+f+AkS96456Ibct8+Thm1z2/N8MATD6SkGPqQyICYiQYrHJ50j+gs8nBRy
	 luTWqvfZFq8R8QmjLX7jRNd2BqDLOkpN3auahBxAnoC7pzBFu4gKUGyTcwcPFF7NCH
	 APZnRZVxgHkfVOE/WcqL23HZZHacljaO8ajdIB+GCds56n/zRqG5DLhwRJDFxIilJF
	 vGDtz+v/bxSl8/ll/em8ITKordyoBCa6cRKuNcSaE+keR0b7J1sIka9IAmWCqJsg70
	 GJKRABthlR4FQfqPYL769OypI5xyWYHzRCBNLY53Jo3m92dn/1wmn8qahBVhqZP2e7
	 A3Mh/BEJ9kCGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/40] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260903034201.112211-18-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:51:45 +0000
Message-Id: <20260903035146.67BC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the mpt3sas driver to replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D17

