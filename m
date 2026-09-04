Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08DC35201E;
	Fri,  4 Sep 2026 02:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490171; cv=none; b=ZpExarI1x1eo+PPPn0Nh943TJeYmogrdXiAzhEMIMSYlwMcRHUpdlhCruZ8OLhwZGPuxx33sBdVlNYDOlNdnzvI3kAo0VjH/qWFKw2vH3C5g0PTzFgsiYdsOk57C8PSqb6im1AxGkldhXFllO2xrHnc8T9DM7/WfuDjcc1ymOmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490171; c=relaxed/simple;
	bh=kxzXoBrsPwVKr94fCK/whqS00tp8QUVJoNmD6DMcuiU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=suzdpKKjU/Eey8BgNwChB+bFlt2afRRuiaxI2efkK1XaYbOnz7THmapxZIzBCS9391vWuC1/N/98nxLR1tSKRDXyjd8cs0Dt4cg+rQvNYX2zsCbbAVurNWgwF+MGecv3WyehDUk9R8F//7dTUPHxN5pPkduteq+S/BBYQw5727Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohcmQRor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohcmQRor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134A11F000E9;
	Fri,  4 Sep 2026 02:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788490169;
	bh=kxzXoBrsPwVKr94fCK/whqS00tp8QUVJoNmD6DMcuiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ohcmQRorHDE8QGLIFMIuxwXzr3iS0vIb8UR20HLjXScPNgeA2zD8Fv4JaurkAqHBF
	 8FadCrsWw4aTOmE6pNOzvdqVRJEoBv7gzLHqsdMotzlLriMPgGEVh3UglaTaWwA1cY
	 qNGan3wHlT5qwl5f7hFSMWfOalRG2WCDTy9rkYeMFJ3KCf6WtMJZGhRgR/sq5WOMDc
	 ilt8tJDqjYtibiCJvtHBu3S9ucTV6+PhSpdyaEqIqvcEYaijwdqyv2ofH7F2afk69/
	 x9ETspeEKW1LscbZOffYD31M4532HzlPdxl5c3uqwbLNNKQbvjkc3fcKer/Xk+emZB
	 2mEN/tMHxfzyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 37/40] ata: libata: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260904002644.157668-38-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:49:28 +0000
Message-Id: <20260904024929.134A11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor libata core code to use the 16-bits sense_code field of
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D37

