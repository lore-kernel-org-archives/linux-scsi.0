Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D33546CD;
	Sat,  5 Sep 2026 03:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579492; cv=none; b=HcBkXozLsKMDFJDCeehHg2xpA4q5wviQmu0J2i3o1kPZ1sN9CQnIRFf4G8h4FwCOGZZiMh2xvNSeejbwB501FOQ0JuorMufVg5S76V+9rPspbXl76bcixcV7N+ZTOcIRfOPxULmJLjDm9RjDhJuINpy+XKUhdlp90dNN4h71CaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579492; c=relaxed/simple;
	bh=2QblFUuYRzR+HjnFC9kpfw9KUSV+i/hmeT3faRlIyZc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mhawLGiJxNwCU/i2AarbzQv67QZX2OjgnpSFBN+G+LdqSCyW1SFbJfXxPvAYF7V5xQceE/Sr2tzUJM5gd9AYeW8k+idy/7WrMlrbcIv+KJuYLQnuoLM0qsvVJ9VLLSCzd20tDW2UsxkSUhld0OcLuZYA/EPMp/1KOSaiq6YqED8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lshc4c95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lshc4c95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DEA1F00A3E;
	Sat,  5 Sep 2026 03:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579490;
	bh=2QblFUuYRzR+HjnFC9kpfw9KUSV+i/hmeT3faRlIyZc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lshc4c95/8h+MN3cTXrOh7fPqvXnqrYRmGZEEWebduPofIadphtJeMeGsn+4pxnL2
	 cWwi2MsoFCH2rG3bHNVl+9+/7yCgW+/hJo5RsjpoGnIrKezVNcm2Ut7NHUKAtU1AQJ
	 yl4O/+yOAhyReZda2yaoZHW95mxrMfmsHSc1fxjirl+zCLSacw9xwE87e/8f7jMfGB
	 UDnAlkzYy9BkLbEuR5YlF3fP5c/vLYWv4yuclsCrLNveQtn9I7LCimS57xo083PogE
	 ur/pbme3WNa0o4HXAbx8CWiE1y679fouOGrYmA0FunAF4EIHrDwkhnoCMd8KuAOmIO
	 lag2WOt02zhOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 25/40] scsi: ps3rom: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260905032224.509860-26-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:38:09 +0000
Message-Id: <20260905033810.58DEA1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the PS3 DVD driver to use scsi_set_sense() and replace all
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
60-1-dlemoal@kernel.org?part=3D25

