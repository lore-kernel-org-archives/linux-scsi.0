Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B613344D8C;
	Thu,  3 Sep 2026 03:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407665; cv=none; b=dqZK1fI+TIRt5/LeCzMIt/fzawtxotBEtkK9xidQIi0Vc/CCJ0cg5F2CeekvS1yGyXJIHRA0GgwVpwPcerm1EXR3wG9KYxOLXml9Hdw3fP2iKCkGQAsdM28pYcuM2g1th/9XTQSWq2T25RvG46MrqQ6eueGRND7DY4hyU09NgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407665; c=relaxed/simple;
	bh=22rzWkUZmxbu54hKnKP3pLhgcZ57hYWpRGkFQyUZG9Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g+ixXhln+H7Q37kVbYlzGdMVOEe54V3Av32gbUxJ06CmItOMTg0ruHCJnABzbk3QbDjzPF+rBGdIsI4AiWsVsrybsiH36N+I8ECdO6idUyQ25AwBN40YdoNZGxsophqWQ5OWCfi/l1tkSLFabsdGgd4Sk1hzUKgzITes6h1PORE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqoO3lhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqoO3lhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D325F1F00A3A;
	Thu,  3 Sep 2026 03:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407664;
	bh=22rzWkUZmxbu54hKnKP3pLhgcZ57hYWpRGkFQyUZG9Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PqoO3lhitN1eX7otyRVGJMPk0+Yh4z06ozm9LN92/P3z0mZ0QpuY0rQZpV57Ft7oU
	 9Tw4pRKuIKYGtYyDyHYU4vzUwAcc7Sju09mA8pDCoUl+1LCrQIq27L0mFRuiGOwLTU
	 XfaoVJiltKFA6uKUCIk+cfhYL2pURT1NtsVO8W8dKSySW94uNLf9MkwYEJddbD8D93
	 liW+/SnJAnBsBPeDtK5QlWbJzu2PNn5OZ5apdzdx7IGp8O1lXJ4BFJHqt30y06cbHN
	 OszmcFCFhiz/K/Pwd0nC568e60RBi2MxxI8LNlM5ySjg9+mSiQxcYFFHxAYpQd39GJ
	 gZoHxfJmE6YlA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/40] scsi: megaraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260903034201.112211-22-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:54:23 +0000
Message-Id: <20260903035423.D325F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the megaraid driver to use the scsi_set_sense() function and
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D21

