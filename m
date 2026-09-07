Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D501D149C7B;
	Mon,  7 Sep 2026 02:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749545; cv=none; b=N0yQs634b4vE44zm21J14fpQlgENUBT5IlzP0sxdLf6b2q+/TtrMZebSK3N01W9Ldf6XYlZ4cYTcN0kpTn1GK/PkK6Sd28jIA0Evlr7QCjLXAU+Awk/FYbMH5ke3kpels9FFu3bPktMNbdt9vXNumHGZaoRaCBKhcCZxsQ/HcVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749545; c=relaxed/simple;
	bh=h9dDi01kk9SMyh+t44caCqXHRe8FlBzlp/ZjefY/5E4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cDaTJijwFcA7nRilDMPfCCl+Ly7BrUxzDqYrrmj2je86GNqDRR9NHkDCaWhDgqQyP3oYtdVqw1FjWHtViy5BVU7zAR8/g8q4kL5Qh/eoCZJD7Ab5RucPWJqSefkdPPF+MP9tmUaNdgk2SNB6hw18Y6aRHH3oZk53PxuPGXDj50s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqZLVGC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqZLVGC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294C21F00A3A;
	Mon,  7 Sep 2026 02:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749544;
	bh=h9dDi01kk9SMyh+t44caCqXHRe8FlBzlp/ZjefY/5E4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kqZLVGC5Ch81bnaK/zTo+zrL041u8e71S053lFQCOUOBlViusYEGFFdaW+1ufPcRR
	 VG6RJS3XPJyZDK5rAeYm2XTB96Em6F2YdPKwW1IiRlTaxg0l+vDwfPfld+eCybp/P4
	 R0JjlVnDc1uswIS1LHEW8ZPcfnhr3qOTZei+p6q2bNlLoseXOQwHi2tue8gguYrjyU
	 dNo6SIVuyXeowHExyPH9GUzVn4CuwRl4CuJKXJ8Z8pYNLSF6U+lj9S0cO9dIOaBQiv
	 uMbC2q43SSe+F/BTYZ0wJMGRjAbd0/UT38x6gqJpCGXa1kkDPuLmUeQ0qUpGvD9vXr
	 SIhPsUSl+odwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260907024343.1046387-7-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:52:23 +0000
Message-Id: <20260907025224.294C21F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D6

