Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0211A356773;
	Fri,  4 Sep 2026 02:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489840; cv=none; b=I0RaUE8i2femrVNrXmSKl8O507ei2g2h5zbLAT68J0pQ9D9sGXIo4LPtqUOespN6orV5d0d2Jn9QEJWBmhc34nplj+6JksnNEx4MZaWtjuytFb/ktvzTWNJU4S5vjRHRDVvVONfrt+B5ZUxZtM+uv4Vi2WCmqq466pJy5e0PQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489840; c=relaxed/simple;
	bh=EJ1fQw23IG5a584dfTix3wzAWDKE8WP47gkjRDCKs/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tPlkdMttIr75P4PAhNc1V1Em75ROoCdfkq99dRsGJ+wj9cE4eiBe+k4IIcajZwYoNxmUrViPDlhJv3p663a59Jps8zrE4VKkstDhbNqf4EtqcmA4TyVTgR/bRSbAIK/M/sjcl6XJSaX2We3zXgTfUZRqQOS09Ncu99eluDrjJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKkUVNOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKkUVNOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B931F000E9;
	Fri,  4 Sep 2026 02:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788489838;
	bh=EJ1fQw23IG5a584dfTix3wzAWDKE8WP47gkjRDCKs/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RKkUVNOufVZug3MW8DWiCbFhdNU60WqXzgJMcIO1IN1tZQK/eqI0/XpEWqW/LWZK9
	 Qv/9dC4Y2egggnL5rWTLxMtITKDvl7Fho0999qNgJMbiiiekML/mT+76rCcinVOG5x
	 aaO80scJc7Dz/iQOnINPGodSx7uMFOxdiVfqgnuqrZezfd4v2g3NiOtzslm5uVoc/T
	 xTt8KGZTHunhxQZQFiV7goqYJKs4v3jreQS2UYnCEAjKRYS4HG+pWuY/eQpXKB9v8n
	 rqIc2CqnW17KVIlzG7mu6Z5qh6fZm+v8p6em0uKhrzg59h5lV/3zj5VjUfx+GKRVbW
	 5LT9v9k/l9K5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 35/40] usb: storage: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260904002644.157668-36-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:43:58 +0000
Message-Id: <20260904024358.75B931F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D35

