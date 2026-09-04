Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E696356773;
	Fri,  4 Sep 2026 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488630; cv=none; b=p6cKCGaffQ7ZtP9PtXVWTkLf0AhKJumWivB8MxUp4TOfsLuJ3UnvRlcsemMyTO4nEV4SJOmzxnj3itW2Xh5tV8B3Sgc8Ks5ZKf2iBl+u5OHPPq2TqTSpTSfTxcFd2USRSbOg0CsBKZCzuNcuRK2mo60IEWntzhQ51+I1cGjhIuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488630; c=relaxed/simple;
	bh=Let3uU5MBkVBxXWYNHX0LqJb/nBXhzJJ/MTJnkXCW7Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qyItCXob97B4WJqJKxCuXkjiz0kr6X6Xi67+gHhRmlgMznSAS03+Bm8UJ4PnPPb0bxZwwp9S17/TYgsnaq35m/WSFA52x7qKho9/1k6qk8aagabau1buKBK63SS4Pk68SnGIQIRsassnsqnG5ozA/E9WwifT+GrCcyCi/h7ftK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPvqtatn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPvqtatn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44BE1F000E9;
	Fri,  4 Sep 2026 02:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488629;
	bh=Let3uU5MBkVBxXWYNHX0LqJb/nBXhzJJ/MTJnkXCW7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZPvqtatn3bPAKXvWdWT7BWaipIW0Q9rf1u9RHSDkBf6hm3M+vTXplca2MjyF31cK6
	 pDvs3MylFUGkWl/25h62447U6EeyOz0MIILvmONI1WkAsY7xNWaxSdJpzUZUEtnVjk
	 yeBO1SAvu4d/tirOQpiYpyjnsLIPYHASjFl9W8uFNICWrUZJeynZ3gAEbbtQt2ePGF
	 egADC1Ym/NV3fo+jOD2vKectIHbSOmBj9Qylv4jz/18Aw8KoTbT36rGEc4zjFO8Ez0
	 eHSSb9hurcGrGGfnYvQM7bJ2UVEwvKTQAGkeHVvcB2xQsEKi6kmCk/Z+1bfsUC/RNM
	 jzKCQZ8b9T5tA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 31/40] scsi: scsi_debug: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260904002644.157668-32-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-32-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:23:48 +0000
Message-Id: <20260904022348.D44BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the scsi_debug driver to replace hard-coded additional sense
> codes and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The functions mk_sense_buffer() and mk_sense_info_tape() are modified to
> take a 16-bits sense code as argument.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D31

