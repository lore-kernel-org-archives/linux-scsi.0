Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5E215161;
	Mon,  7 Sep 2026 03:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750208; cv=none; b=dmmWSbG0COfQKLzLJub5frzgLDktucmo+h8gnqB+EOid7F0iQyUUNG5vSMQLJYhhxwqIHh5CcB9vEjq5laUbuDv6HabfMjgopKxIipqPdrF5/lsJbbXbL6i+Muj3WOdMbHungVcJo59Jl+dQfnu4oq7xUSNkpg2/+NpvYgZLTZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750208; c=relaxed/simple;
	bh=zKtSPtysvis5/AnnB1s1nPufpAzOyAMIeaj9wcJqhVE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QRU4rBg0UYBv0QBD3c6ZobdUbzHJTFp7I54c2ZQdXg0q62/o/RdEAnnkNvURhRJRUnDWmgVP3u0VKP3wQ+Wx/yOETnsKDANdzAVgH9H2OkdzTMOvScEUc7RwFvnyDS4jmTDN1j1qXq+b6jcax4PHbsJQ5IRyy9K13+2vg5K9x6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DipKwWRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DipKwWRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5F81F00A3A;
	Mon,  7 Sep 2026 03:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750207;
	bh=zKtSPtysvis5/AnnB1s1nPufpAzOyAMIeaj9wcJqhVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DipKwWRIG5bbwkU1sWrm6Br6apDDm7i0UKQX3VqSKekkb6GuMVLDMsxz8V3M0R1Bg
	 4xrv50xscDXlPllcRlGPpEdh8pxNwzotdrW+KNXn3UanBEVF1wntFjoHk4oNe89XIi
	 IHuayjOSxLOyQIqvvjjgYEJ/IW+ad97I13bi+9KkMg2kufMGoPSZOv35suzBCBCvqi
	 Pvb0l/jDvY9x7DXt4peFFdLVLHrZKQ2LSQshd8UVaN4WuWXsIe5yU+Rdx++NG/ZEh+
	 l07ZQM072xtU3vpK6FctpViuhHBDLxCtjj8fiRwHhZOthq79xZQsxIdzmmzsAB7BoA
	 WYPlio2yfdgkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 36/40] cdrom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260907024343.1046387-37-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:03:26 +0000
Message-Id: <20260907030327.0E5F81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the cdrom driver to use the 16-bits sense_code field of
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
387-1-dlemoal@kernel.org?part=3D36

