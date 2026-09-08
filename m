Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4067A492520;
	Tue,  8 Sep 2026 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863687; cv=none; b=pcmO0qgRW+H5Cg1GehlvcQReMl2CNX1UVMPwPgc7VgJSK5ncDcKB+4zhNWaA8+x9YVpivzZMFzz5VVoIrG05BlWQpvAJKtUWYC3bG7N0Ny/Mx2IcILRBBsVKjsS+jRW/L9BaolBRIbx033r2xu0H6Byj4e1FAP+vM5Li3n5Kovs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863687; c=relaxed/simple;
	bh=KyQDYQer0xWvi/98voO8kz+lJuLQc0ph0anNtrgPj4U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l7sYyce9LssQNptKI8h9RwhRINZ9aMEhCjVn/kAdZx5TCXdNB+VpuE8TVx2s4AfgeableJUC6wz2O9lBqalKdE0NpcORNsL9kVQ3AYoY1rkusLGb95TFrgMvcUcZnOPmTBtlXJq0pV5/7Y05L9EN/ebzAowkDsbiLURzJ5smmBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBgPCcmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBgPCcmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9111F00A3A;
	Tue,  8 Sep 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863685;
	bh=KyQDYQer0xWvi/98voO8kz+lJuLQc0ph0anNtrgPj4U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fBgPCcmHiic4xWb5OYiNYeEFEMGo8047OOVqX61X5WHDH+JuIY+l0MB4rkHTJq5Mf
	 7VRHHe1r95Fq7pzR1Z5H3HNtlDVxStRJv9WjG7tlo0mS0Bj+JhuzKyw5Cm+3hNAqjZ
	 YfC2yGzJMxHoVh/taEFjDPZAhfSyIL8OqTfGFeVjz4rrs+lrnfMb7BSCpXiuQnP0DL
	 2vW7cIZRug6SSUZqTN/U7NCgq//S6HmJW9/UaHxX4poKSBS9oI+H3MtAlD4yUTRJkM
	 hmv6HLmna24sbnw0XEibBn+7XqVkgcP5JSiOmHHHNLsSG35/7YDJCku8ZAkx8johLD
	 M3SAlUAR2NQNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 38/40] s390: scsi: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-39-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-39-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:34:44 +0000
Message-Id: <20260908103445.3A9111F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the 16-bits sense codes and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined
> in include/scsi/scsi_sense.h. This helps with code clarity as the sense
> codes being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D38

