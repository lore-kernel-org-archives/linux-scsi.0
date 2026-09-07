Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F43E7179;
	Mon,  7 Sep 2026 03:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750267; cv=none; b=HOO+jT4VeD0Ip+HhPn60Ij/qw9yOlk2idVMR6vAwYTAu7jzufm5WoGGq4XSWkb+ISR4tOFMXsBfrNmc0eozBWoMX20l8aEx66CFlGXXnCIGaFG+yWEWEQxE+FVrYMgrU7CPHeXrDpHZwn8tnkXhjOfpWON6OUWj878pGv6E+VW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750267; c=relaxed/simple;
	bh=r0nMHpF0fuP/Koct9QtkNe2Yp9fpKZua1McXvezpBtQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y9tOyOE3/Ur5IDYitSp0ZNhNWulCUUaJ9m55/0gYtNxpNNa/NbCUWAAxst81yNsQwMf2+lIoOEloL1thuGlE6itMv5WhFLY3aBgBrvdlZP4NvI3P9kephMPa3rGfxrvNnQVKa5dTgLFAo/LvSRcQttD81iWIRmCMIIwBJmun6SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4hYKEVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4hYKEVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40A61F00A3A;
	Mon,  7 Sep 2026 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750266;
	bh=r0nMHpF0fuP/Koct9QtkNe2Yp9fpKZua1McXvezpBtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f4hYKEVBSvrzS7gdqUqvRT36Pq0MvmL//KyDxtK4mMLc/bSR5SsMerehYbzNJeXbA
	 Q/KstiLtxqnGSZZP5FnqE5Nvem7/fQHdaEyeLp8KssH4bdtIq5Sq2wLWgmyN1SKvv0
	 TDgtEWXUpUJssl30qXGQUWN+Y3qIM7gsnFkh2+fOo7clM4E1nLk0iMTJLefRuQQbOj
	 vDMLLVDi7B8x+191Y2wBybGswa9XalH1e+n2+VtDQJKWk1UZVcdakZ2F5hRDoD+L1x
	 d4PVxQGYgthZO7QHua8TmGLYVBHBDHilTRCXo5P9Gt9sGJVlvtrK9pYky7tQvBgNH3
	 t4POWelmi5lvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/40] scsi: stex: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260907024343.1046387-28-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:04:25 +0000
Message-Id: <20260907030425.C40A61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the stex driver to use scsi_set_sense() and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D27

