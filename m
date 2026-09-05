Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE214272803;
	Sat,  5 Sep 2026 03:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579442; cv=none; b=Hu2dko0Xd5xzeKrUhtEwwtwh3117pINb8jAurg28WIjcROsSBfddeAbmQLoK8Fx9NHb/llk3Uk9b0BXIw4IUUU3Nyzza5uRqgEmFuAgZ+evmwi3Eeb2iKAk3ws+7cEoGadVOn/tkCyEM2AIcmUpGq3MNlCUsdctzYugXk5frOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579442; c=relaxed/simple;
	bh=m99DfB1NVj/HcgJze0a4ZEcTlV+T871HvI1Yb/rXptA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FnPjzW9/HoZgjxcA17FNQ/AtNvGB/oiCOJFyUQpA4bh1DNNZdvbrMSuY6xrOx3yhugEKDeDx9rxRNrTiR8uvZRWO0wUe8kbvWUafTJt/ykmOTbcmDfynNnq0MRSpV8YZ4wi+mcyquw+nfyxNWEfkhLGpFxr5HmELnqZHcEdYVxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWm0Yf1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWm0Yf1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C991F00A3D;
	Sat,  5 Sep 2026 03:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579440;
	bh=m99DfB1NVj/HcgJze0a4ZEcTlV+T871HvI1Yb/rXptA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QWm0Yf1FpS4HQIlyui87pvQtmzQDef5Gz37vukchxhdPcmwQmnLNokRUlvexY/iIN
	 JFSwpav6SNF1QPyLHL6YJWpu0E935BmQNNePjrqIUvyu0lKCxYl7j9NjcxNSW62Rum
	 1fBrTLrSyb6QaQegDIPx1j48Pl1ZDqO/5eu7OaAHwB3XD6fa9sqguB2dwZ+HgXAiqn
	 W6QOaNgs42Oi/CgDAi8ywqNSUvSwK2xIjG/1tJqaEWWr0cYEHt0CYYAqXNjolV0gQD
	 v1XjElRbSOkAowQsDAYOpLnFNe82EHB/PAwVSJ7TUAox8YjseL8me5dwUIhweMXtoN
	 obGs8QnDc3pnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/40] scsi: sd: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260905032224.509860-9-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:37:19 +0000
Message-Id: <20260905033720.05C991F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI disk driver to use as much as possible the 16-bits
> sense_code field of struct scsi_sense_hdr and struct scsi_failure and
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D8

