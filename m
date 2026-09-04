Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD363515F1;
	Fri,  4 Sep 2026 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485262; cv=none; b=jceAL+fOWVCL0NN3VO3Ux9Tom4hA7+s6/OBq0TTJTUliBXy3Bi3sS1AMnRQWuihx6axMGNQDvUBQnoqgKxiidDUn14yGw0c7L4+jjX0Ex24hYzu65qa/VwSdZbu/qdo6mjWzQBdommKdqadkJ+iVRzK0cKPz3QFXjyRUSJke9NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485262; c=relaxed/simple;
	bh=sjYzKUz558uMP38kGLkI2wt+Pz2QVrI/HVZ17qu6V3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T2D6e3OFP3YQyqMxMgX1CInY/jiINqw+TPMeCnvgOtfJ5+7pXOcY8Qj0UkY1kiynH2wR663DoyuZ2CvBsNet5CZvKoA2tdYRYshcdMsTfKo+yE9qZJTcO1gza7FMKxrKQdHkS8CxwbsAWiDEqAGmQfwrnRQ0E9njh6xLLC3E/Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTgKIhYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTgKIhYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73C11F000E9;
	Fri,  4 Sep 2026 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485261;
	bh=sjYzKUz558uMP38kGLkI2wt+Pz2QVrI/HVZ17qu6V3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UTgKIhYG85vjYSn8msZmZwKnjPLG7NyNfh3AiiBnsaJz3F+WicDPfUohCeQPTfTkL
	 L3eZLyfTQRPNHl9+HTgmIfrSrXPxmhyal/2tzuGRKIIkj9OL8bdLdNp97JG5sNXTD5
	 Ci5DP0k0Z5onRLLrXwD9UFf9FLABTFXtBzuEVbgrNmWcVx7Rh9OfGBmToRhlTjBgCw
	 ndu1PNnVZhjCJa6zcZXa38AhI0OUEFsI0KnyERlNVsGRtfs6Wd7keP/HvMcVd5jJYI
	 xZ3sDeXJpZDXy+Mg0si7ODHXHMwFEMp7EsBbglRM9xg+GHZQLFy+jlDB09lG+sTamc
	 smfeU5/F5+ubg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/40] scsi: device_handlers: alua: use 16-bits
 defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260904002644.157668-17-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:27:40 +0000
Message-Id: <20260904012740.E73C11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
> field of struct scsi_sense_hdr and replace all hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D16

