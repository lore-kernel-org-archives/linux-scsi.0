Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF9A3E49C0;
	Mon,  7 Sep 2026 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750274; cv=none; b=V0dK8MC++3I3PguBiJUAqoh4GrZ40P4A/JV99Ds9muKP9DRhAF3Ks7C9ux2T8jpuGGcHEttVWP2UP9RgoFgz2eAIztMCEzly4bjbi8Aft51xFci5Rn88BzO1TsCmQQ1E+m/QqyNJW0EWvJDedHP9ShmJS9Mz9K7tYRPZE8SOy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750274; c=relaxed/simple;
	bh=G4kNSzLepzUYgV/rnQ0G1nHmOiB0VfquTdpHq9A9+8U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WZv6WGgIgjG0tuSerdwRa4UOm0CfOog5LQiBVhG+ogwzv4kcl0VTPJWP+D5UXiF64W2OIBI3iS7s0f6T6phsoRZnPjfvEk+DRwNHoRf5tZ5Zg12Ni0jfYpbrf4EzVmKXubr+Jg9GhBcYiEo5CP1o7zfeJLChbu1I3FH7dnAlVrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1SBlCEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1SBlCEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06461F00A3A;
	Mon,  7 Sep 2026 03:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750272;
	bh=G4kNSzLepzUYgV/rnQ0G1nHmOiB0VfquTdpHq9A9+8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V1SBlCEo+k1QDYczN/H95SirTJzYMHOYhCdizIh71hMZmv+qAZOlwW38Z2D9XMB3X
	 uMzVsMMf+flq+ZWIz/y5f54w9ndgtbqDVujZ6E0117G8bOgTaJLWG4KWHVY5b065dK
	 GwfgKhCnLsx9G4KeRiFNj3gUKFOISJt60bWtiHEf+XUvkbE3E2R5EXxuE7EwFdksRy
	 mtpc50svIe0MJAMB/rob/Oj1ZyWE/gw+jSeswHVhHiJ0915qiQlpfhfxTbNw5RdGD1
	 OJokusfIWKFFF75RfQpuLOD+MQl2cLBxKwW2+pT/ItC8g3oxumMGTSlaMHGQBsruIB
	 7DyOUDIPLynnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 37/40] ata: libata: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260907024343.1046387-38-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-38-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:04:31 +0000
Message-Id: <20260907030431.E06461F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D37

