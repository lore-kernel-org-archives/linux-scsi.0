Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47A537E2F3;
	Thu,  3 Sep 2026 04:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408075; cv=none; b=EQ+1mPrM6WTKtJjjlFi+ajvnt7itTH7oEwACb+ZnWOKFvLfxnNu3CjpFZc3276o5SuPUKAuiGWK7vBE9KqqNCMk8I0lVMH1Nb76tCUocow4eZwkBt8VPxZGBq9jyo4COcd/4fO8ZIeexcw8WsfL0EC2xpr99bezhXk7DmFs5DMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408075; c=relaxed/simple;
	bh=QahIN2f2eONOyuTjvDuThXkULd3Fvp3zp+IuVqjQXZg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W9v+IVaYIMyyi+N+btYOaIDyGANObAPaZljM0qrxaF85L2OD2idxWLMrQhLcEc4KfBC97EkNmW3hWYpA5+JTJYQctMYbCcTbZkNiwqYl4jpH/YRwIG7c7J6ghzhc3cAvfeAYOG/Yk/eaI/9yhohSmJK4oxoJHP67/qKzVuCrUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GADXgIFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GADXgIFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43931F000E9;
	Thu,  3 Sep 2026 04:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408074;
	bh=QahIN2f2eONOyuTjvDuThXkULd3Fvp3zp+IuVqjQXZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GADXgIFxTYVCrCXJaXmPS3Iuco6U5O+xn82XjYQd/ZHEItasNrn8d+SsNTSWOSLIC
	 tu2MrIgccqZY8Ka/AjD/azi0SCnY70CecS/Dp2OkUZOn3XhZXcJcEMPoTKfIqSo/+M
	 IsDBQFww06ANOF+jpENtPyor3AG66wsYrAXwY9U+SCdsWGids5m9Ue2trRx0i4TxX/
	 A7U1vcsp0GO1Z+DDHufMSNpD1+dQBm+fUfziGGy7opfLolVhdXwqgadui6mcqvAeBq
	 4Q2HZvESnyhJA+xtz7clhH9wPfLEKXjCGMvXOXr3wh99mYybzSBYmOo4kQMOOoY6e1
	 2sUQQkEsAFuJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 35/40] usb: storage: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-36-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-36-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:01:13 +0000
Message-Id: <20260903040113.E43931F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D35

