Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688421F4634;
	Sat,  5 Sep 2026 03:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579330; cv=none; b=X8bwz9sADfccPSCr+7a4nqElacx/aYGa1r15Nh84YiumaU75OqbFWkabCn0/KXNIZaQ2f6qs5blHl1ZVkD7Sld/9RrqS5xMJOozX6P9biICWqhCGLBdxg3RADNZc1/NWFVGGzsNEYV9uP5P4/Bd3D9o2ThRZYbPzeqJYBom77Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579330; c=relaxed/simple;
	bh=1xqHek7+n89LVrZGvDIJiMwh7usKsi/Ehd+bTqE0noQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BeYiqo9g9obGuRocQTbiKkxdsA1+D2VkWxLELPl+fynUzeKPlO4QUG09CJU9bd2P8NyN5ctzgX0eC3V92EWMNXN0kIFvIFWcafYkgBS3DuB0BFB8NlYNC2k1ROiBKkGq17Bc8TGsVy5xk/6TtmgBm/8X0qABdUiB1hZjSi/+09E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezJjy1DS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezJjy1DS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C178A1F00A3D;
	Sat,  5 Sep 2026 03:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579329;
	bh=1xqHek7+n89LVrZGvDIJiMwh7usKsi/Ehd+bTqE0noQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ezJjy1DS+ayYOyia9oQx3XOhVXcAyi/1v5jKylvMu8KYtbdJ5bNws82Vn+5lAjuhw
	 aivI8z5bW66KkasuEqSO0snu1s3ZNYtJ22KQR/w0MJD4pQy9EPYNj/rjeKwVEuUF0V
	 Ihgyzg/1dILgF8Y8TFbAIWkk5kUIlHl5aDgJfpoOiYE5lKYMpMLmwB6GRB+nxds8OO
	 XbMRWb+RdQ8jhT5c9yPfA/G0qyvMpH/XctvPegYbjnXhuw5n8gCk+fs6dEd7+Xjfnh
	 ZI1YF6mOd+U/S1YsopKRazwW8lnO1VVoSFQeXZmD9dYiCfsafV2QjHEyi+uyGpPCyK
	 pJQYlUyq3LYrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 21/40] scsi: megaraid: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260905032224.509860-22-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:35:28 +0000
Message-Id: <20260905033528.C178A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the megaraid driver to use the scsi_set_sense() function and
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
60-1-dlemoal@kernel.org?part=3D21

