Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BBE1F4634;
	Sat,  5 Sep 2026 03:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579137; cv=none; b=AXztR/MGhFxczsh4PK2Zrivh7rCDvzGhOl7dRzQlTjuMXHCCWkvWnupl1odrQiER5bnGBYjqUsuGaGdx/KgYr2oT1LXtHhS2cFMhvviv28oCmC+JPu9P3OQGIoipSoxk1KuJSRCt5nYhIlzhhTO3Af1A1bMQXqMOggvAjkzf76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579137; c=relaxed/simple;
	bh=AXxPN1kbNgRIkgMPUT4lgOFAsF9qIkMcIq75XB1Orw4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r9wJtEhO7aO/Ej9voCXYwigQJooVF6ir3K6loR0OhfIvh/DvZl3j+M124M18HTbcwdxPYu+84iI7iCN8rjGPhh63PjPGVQ5hac/JFD7WmpNMiE/sUsdTaTHnZ7GxTA0IlYcAo/gEYdjK5MQAEN0ySTRqBBPfobl7T7V1G/J7HsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KABlJX5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KABlJX5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20951F00A3D;
	Sat,  5 Sep 2026 03:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579136;
	bh=AXxPN1kbNgRIkgMPUT4lgOFAsF9qIkMcIq75XB1Orw4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KABlJX5JdAMx5adZ30N9ZcPuCmRHii4F2S3UzTZQRVqMflF9z40AeY4mlNWUqKZ6O
	 pZrQe/BFqXzW/Hd4utOxwGBkornmt2xOefGfmbBhWuh8t3ZWPxzwYi0vyfe3mfItFG
	 DmqoTE3QB26qPewjQSwqw3DD+Wsp+ZsvZigEDnCu9ESU9qLvVoekFNxSgSIBJelqtS
	 gA9UW+okoXRWusyh2d6DOeQeCGngrVxLs70SqFpqaUFCYUg6oN13xVC/fySxfAniz3
	 CaWAK3cCnGhXoRKPV5jR5fRLw1GViPiIV1ugt869hPDIP6FwS2nyyZnNgqTyfqfMRT
	 sUVXROymE0b9A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/40] scsi: constants: use defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260905032224.509860-3-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:32:15 +0000
Message-Id: <20260905033215.B20951F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D2

