Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B81175A8A;
	Fri,  4 Sep 2026 00:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482175; cv=none; b=GpPspJJCR4TjGk4edz+z+HnKCml/E9YAQTvEmP7Dpk0Ig5BH7LPsr/YkTeE7jhovR9W67Zh3ngLVuMkZXwN/133odVSlCO1uwWf369xzNKWD1iC4RVMKQ7bIytkk5PtaWCnK9RMj3SY7vjfuR/NFpJX1jET3sGI/0s5viGW4324=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482175; c=relaxed/simple;
	bh=V9ZnJt1/kaDGAz3ZB8qZyO6TtNycuDkHYm1DuzcrXyo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YVAqgF6s8L73xjD8aPzPKraVqwReh41kWUfmx6L79HjPzEIPdnxo8KqCNJR1qyCezAqt+49F6vmfIDh8kJ3t9ihukJqe6Cqtqk/ozhnSFjJsxYhI5V/4yjjD0+MOWH5DHmqlgSuHm3nMtRwLvbgoopADVC0IifguTrzC2i27goE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eu/zBsjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eu/zBsjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788AE1F000E9;
	Fri,  4 Sep 2026 00:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482174;
	bh=V9ZnJt1/kaDGAz3ZB8qZyO6TtNycuDkHYm1DuzcrXyo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Eu/zBsjyoDBTU1usfEEj6foru5mK1IdJpbzmQim3M2bUW+t/PxL1i9+PwVD8TnadX
	 altW54Ac8tgDiohmsmYKfDurFN1LiX3I4uKOXM398LHpTLEPRMKprsUgi7ifvMQBo1
	 3HGuthlDhsytuT2d9oBDlsjluxDe0UCT0WYrSNVw7Z38fJf93WkeUrKM56pAJc3c99
	 vdINd2PSMoH5gdunfY/LDjNQ5GQpATUwxUzUDcURCmFQhEFxwjh//p27gyYJbmDBIm
	 j7LPHXB4UxMtN2CnKLGEoq211K4Fg7booGxAml/fDl96tky4HDgLOWWFtfr7sLZSgw
	 J0Bl3UynwJv2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/40] scsi: constants: use defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260904002644.157668-3-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:36:13 +0000
Message-Id: <20260904003613.788AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The SENSE_CODE() macro is used for defining the array of struct error_info
> which associates a string description to an additional sense code and its
> combinations with additional sense code qualifiers. These are however
> hardcoded values.
>=20
> Now that all 16-bits sense codes are defined as macros in
> include/scsi/scsi_sense.h, modify sense_codes.h to use the defined
> sense code macros. While doing this, 2 missing entries are added for the
> codes OVERLAPPING_ATOMIC_COMMAND_IN_PROGRESS and
> DEPOPULATION_RESTORATION_INTERRUPTED.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D2

