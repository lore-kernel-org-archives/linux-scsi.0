Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5811D23D283;
	Mon,  7 Sep 2026 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749801; cv=none; b=pp/fKCJTIP3OjXOpHSsVoxnJWYdWqSsHS4dynq2SKqf8XU76r7Z0gkfDDGwHtW69UL4SN22oxtUanJzIkIE7SsY8m5m3HT19feR2imIPqtf1Jym00zTZTsIzSFpEOWYpoNsFACm2DDc7fl64pX2mNElJJ3oXQQUMy0GE/Rg+80s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749801; c=relaxed/simple;
	bh=r+wYln5/TPvP3moCzDLnH4vYiuMKOJ0oI8OlJw3uxbo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iHlhzQt0rLQJEoKqhSLEVy13apE2MpMcYMrNFIvppELIVdH7OiiGB2lzy3i4lTbhDCu03fA8ukpQaxNvCZ3YYr1ZFyRv3od9YFw3t63mH2FQvlo1qOPq2f1h8kdqJjnauxY/Dr0W4kDtJfs1BnSJ3taFMpe8pw++G3aYmu1wIfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwkoVzD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwkoVzD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B4F1F00A3A;
	Mon,  7 Sep 2026 02:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749800;
	bh=r+wYln5/TPvP3moCzDLnH4vYiuMKOJ0oI8OlJw3uxbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SwkoVzD+kD3Ktr2FssQp+HZk79BKdN3YidxfKnVgXvv/TMJXhjlRbnvW//1RTzlG+
	 6IsPbEgt/k1IDQovWFTZq88fumW23vO8c2SVkqmJRXV1thaQMhKGEx9ctM3B9MzNbS
	 Qn9CzIBfhfamyNpANVARLF/zsa8t2PbfPzHkxRckEEyjY5tG+7c3Muxk/6+7Qgnq+a
	 M3RSSC7wZW4xi493HVUuoJCVIFMf6cDCwIqDJ5n/baG/9Fy/dHq0av5FCYSUY1hkoX
	 2i1tabZtzspQUoSvQZ2/Dg37jbomgyRje3f1YVInxp1QA+7yzcLKk0aiZMBaalC9vn
	 gn7yMSIUgvCzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 10/40] scsi: ses: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-11-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:56:38 +0000
Message-Id: <20260907025639.B1B4F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
> field of struct scsi_failure and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D10

