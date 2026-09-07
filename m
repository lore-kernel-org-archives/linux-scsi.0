Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8597A3C5540;
	Mon,  7 Sep 2026 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749310; cv=none; b=PnIi480FKlveIZ2t+tARiombXIIKXKyZ/JQxyTqu95QDwWPhZAnFKNnLTymAlerhI3idfK0JlL6ETzEH5mdq+ch0fLJYpI6GwMXED6gvTmAzJFOB50TdVitfIJUhi0iQmS+vUtzuaJ8qOmJlOBqyj7dx+H1wb9GwK/IFjELqedI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749310; c=relaxed/simple;
	bh=+w8MmpcYGN9zRzB9MgHSPSYhzycM6bJjixaxm834kp4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZJw5y9xmi4xFNpxP85OU+VaFtLxUwmygKYxNuXzFA9LgqIO6OkaNbUpVLnn8AIF6MVJ+f6geTyGjH4b0LqKdwUsIN4V7eFLl6aB9IadQ5/BI7oLr79UuGa3mUGEw97YMHV+VsrfiDEmDfg0JyQBq/SlYx4+RaivYCOj0Ritn7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0pD4Qfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0pD4Qfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864A61F00A3A;
	Mon,  7 Sep 2026 02:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749309;
	bh=+w8MmpcYGN9zRzB9MgHSPSYhzycM6bJjixaxm834kp4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G0pD4QfvtBmfKkQ4WHmdjVgwJFZc4Ry8kb5HjlYT1ZtoekU8p3SOxvYbebgiisGLN
	 A772lXKMpiiheBLAzDqat1zhIwkyDlfi8QZTcOT1ee12GBCxLD8pOhuAudGacD8Hr0
	 D0iNUMoGa9cOAYvZP9ok57sWiV8j0OWveXTxz0TAjlmNupdPm1pPOywrsFqwvgxp5n
	 qlnpqXFBwolWFU7cMuiasqkhZ+tMnbYIV5/yctY/kjCVVfr7By1/LCTvHjCUYwMuKV
	 HU/NmT4Q/3iS4RWmU9Utz5mSLqjaoRSzPSYISJkfH5bET7bmvTxaTJbMqcw4KC1P8s
	 8LHV/RoNGA0AQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/40] scsi: constants: rename internal struct field
 names
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-4-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:48:27 +0000
Message-Id: <20260907024828.864A61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> To make the code more clear, rename the code12 field of struct error_info
> to the more natural name "code" and the fields code1, code2_min and
> code2_max of struct error_info2 to the more explicit asc, ascq_min and
> ascq_max.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D3

