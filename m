Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89C533A9FE;
	Sat,  5 Sep 2026 03:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579159; cv=none; b=qoPkb7Vx9jGffvkHEuoUi4XS5BBHf7IJOjwZpLA64nP5tmo+yyRD/NNAwCn9FXlHdH3b1nOLqfE6ANmCTOBewAHRkj5+roQJ+ZtSax7CLoYBWz7JkqONToVrjGzT4qxw2FtG0WrAUGBucfnA8nEe7Xu1Qi35sJZHB+YGBLymtto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579159; c=relaxed/simple;
	bh=QB3+Hi1qBX1R6//z6CkYWWh2yL2oizqXIF1rWZFt1NE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iCEdwmB9yZHVgVuB4EqjBDvKG08yn2BOAdHeRgePeCGLijtrS5+90K6Xnt5wsgTjrs1M1gMxFxEGzzXLbr9FGZfmnIhW3AY7JgG5BF2wdxs4Ul48q0fKfXoCX5esWA+IYh+tJl1xOXzGfMvrgRcJkYEJ621BoPXJPcqPLuXKKi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpRUs7tu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpRUs7tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6621F00A3D;
	Sat,  5 Sep 2026 03:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579158;
	bh=QB3+Hi1qBX1R6//z6CkYWWh2yL2oizqXIF1rWZFt1NE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SpRUs7tugZ8TzGs+DZ8nhhATBebVjX8eHWTDzjyq1tK+53eIIyjDoMQ0g4fqQKrVL
	 80RGrqyyBRxQnNhRYAC2VXiZo51R3V6dzq6BBjCr1D02+yP5mSUaQtuiQGxeVYXwlg
	 ZedrWvPsEW40jwtlHA3k4BW1eeXhu9F4rqWGmITah334PH8za4ou9oWzNM5kc4pA2T
	 Bxm0jKA5tJaWfbKGcy41PczvOG5c4tvEaajvUHc8XYzMCkAde+00dC3YTYGFhDqd+v
	 XSw17WFBLFBVxx6hf+BEE+A73yR/FLKME/QCvdEIGWnic9xV5NyZPMaZIa3cz3diw7
	 5fpXAMh0JC2+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/40] scsi: ch: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-12-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:32:37 +0000
Message-Id: <20260905033237.DB6621F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI media changer driver to use the 16-bits sense_code field
> of struct scsi_sense_hdr and struct scsi_failure and replace all
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D11

