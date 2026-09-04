Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC635A38C;
	Fri,  4 Sep 2026 01:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788486496; cv=none; b=SWWE3lYBKvEwqju8bp0HiqL+qNL16G8UhDVK30HM3y2PUVJdmSsocMsWQKuBFh663UYn1/DXJuTcFT6HgxPMr/8jAF1dnhmfQ+R/4lwtgJfz34RCImPVbM/PJO8XD04a30o/KOqXRdYFNcvZ9f9wyMvB+wQObL2p4kqCTPOcupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788486496; c=relaxed/simple;
	bh=QoPlLyqaEh19yExnrogRHWikXpcB8jtMhyoaZlCpNKM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bMdOy5yHoO8tFhlHQ09t10HFWtrVMxJOJ3zPlLZ4BlV9gaJRlMGoTV5O5p1G6pWlMvf4k90FpTGrJr9jxNKytZIboiP4D9awINcAc/A+Vlt9dTgUe79s5bMBzWG+GI/pUp+zDalOTm8R1pH4tJm21ti0Zrz27hn5Eg/LZKEeuv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liKN2/Nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liKN2/Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918DE1F000E9;
	Fri,  4 Sep 2026 01:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788486495;
	bh=QoPlLyqaEh19yExnrogRHWikXpcB8jtMhyoaZlCpNKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=liKN2/NdVGMIJ0P04LYYuYTtns9zZCm+JPuGucBUwxHo5T1/ihFzWkL+mgMugLJKz
	 QwCS+1JZxA1bGnKGW9XVqtiOeVRkxDTXTprwsF3MQGTskAYAh0xZWhMcOK9F8iuU9A
	 ryt3CXhlWIt7linjs6XK3YFR5NRr5dt7JslpJHXeD5E5EDd//2rrqhr5qFsZ2Fyak6
	 32dOkUW5C+Zo6Gdw2tlsbZAutUc2ve5vusRmkTsofOqA8RzMzrfCVfT2BRkD7u8duu
	 jZveOfIYA4QTRbizDc9UbTmGHNjG8ix5NqP6TOZvdbu41PFbFDnwsccgHoG5/1hdaS
	 NWqPlxLQjWWrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 23/40] scsi: smartpqi: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-24-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:48:14 +0000
Message-Id: <20260904014814.918DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the smartpqi driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> No functional change intended.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D23

