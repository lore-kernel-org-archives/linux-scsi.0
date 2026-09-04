Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3986FC3;
	Fri,  4 Sep 2026 00:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482927; cv=none; b=SiwBth3CesG7gbcWMBEoej3ozRAnC6TCb/cyhvgPojMMniDzjAfYEHkW6zJze3nfqD4sak1HGPGbiPxsvYxW3AK06euJ48RagPzcPlVaBvwsVNhkOoDU8WHQtT9ype3+7nkbH1ysxHa5e4PMHYinlULaUAfUD1wtIGFAgZQbXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482927; c=relaxed/simple;
	bh=156tMbv2ozDdQ/2iCchoSasdUZlW5/vOidX8XtiwC7A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=REhBxIclqksK7DWbp2KOMvFd3zuUMI2DPfr0arAQNxpbLk5HEwMP9z6dFF2NBf6j6hHRJFf22qQoJARvYXAiyUJEQRW3Xvy+lQXTmVRPF87UEBiu/Mm14IdegFf7WBeet/ewokeDUJcfDjUlBTbFTsd6lCGSAuwzoyieSPL/UnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODNhUqu2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODNhUqu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7806C1F000E9;
	Fri,  4 Sep 2026 00:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482925;
	bh=156tMbv2ozDdQ/2iCchoSasdUZlW5/vOidX8XtiwC7A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ODNhUqu2vhHC4oSGnx8BxO4rxoDYMbEQ9ImoEzgqdtMv6AJsHG47Cx/aGGPKZ/cBn
	 Q9lzAsTrDpy78R1GEDykVvlCvRkv6eYr4kkHC4Q040F1Kf34yb4FqVgE13W065pYw3
	 CpwkhlDbq25yVKCqzkTyx+eEtMbw/TSnznhVvtCnt2u6KFNotjUM5EppXxb4SpWNKz
	 BU7XuNWEu7kh6V7pZtjQ0nXARO3JkUAbwcRHsQwOrpzBdlYbWUOzlUntS0qirJ63yr
	 Nf5Bv2HpsKcytK9OfD6vxpFlWmXUtlhlpdGUgCs4Xz3f/DoDDbVIsxyaCSYozfLWPS
	 q9kG0u7s8ednw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260904002644.157668-7-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:48:45 +0000
Message-Id: <20260904004845.7806C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Instead of passing the sense key, additional sense code and additional
> sense code qualifier as separate parameters, change the functions
> scsi_extd_sense_format(), scsi_format_extd_sense(), and
> usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
> access the sense key and sense code with a single argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D6

