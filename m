Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.154.119.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794944712;
	b=mfHPjcx0S6PlSCjEZLgboWUkkm0C8SWhuo1mWB3PJDa1NNHI61P9R9ef0A2fd/gT1cPN
	 TS9Fg0/3td/EMkNcnTlNcGd3wTs1Ge7UWgiL3zsIwwUlv21cbhwJqncs9e38s2S0nLubA
	 qf3uxW75dmfyN1z42Q78geOTd5GOeJ3TDJrl5Wn1q4aAhgynBsT3T/CIBPFLBIC1AXGWF
	 4ApBAstqM8rik7e4MMXCX01LjxDSVUSDXv4PbN53eknWDPBWgly/n7V3MEFe7tIZZrSW8
	 N1t8oE78MExjbrhOxNpqqI3vVMC7u8DGVpE6zYcqMzScndshFNgujXHrZpXc//J1vfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794944712;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:User-Agent;
	bh=xMOirzj/A0MDRFwFon6RlS9/MgqYCms83N5vsqNPifA=;
	b=YafdUYDxTYpTPrgFmuaZVBTnxF4elJF5Ob5cl8GpgKWeyqrisJCTXrx7Yg0GlJBECus4
	 sMC0shOiAhRYTe62dMd1ThMCXjh0256PNFFbyF1bmsUlzBrbldLIqZBKHTOwT6MfSXMqi
	 u+dhJtfR3j3ksC0Pb8QV4wC5YESHwuAYX5GYKX1gXcpRG6Lb9JzBVoEkTydQvLllON6cH
	 /HqWXL1bButHjKQ95ueIjiE/p72xt3xtJ5JZdY+R5a7MZPtEXneju9n5tTsLLaboloQL5
	 66YxQQcE/1CjN/gc1jjilSjuSIyS9p89Nd1cjeYopaTNqFEkyuixDmrUTxETBUjJ8qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=aurel32.net;
	spf=pass smtp.mailfrom=aurel32.net;
	dkim=pass header.d=aurel32.net header.i=@aurel32.net header.a=rsa-sha256 header.s=202004.hall header.b=VNUwz1X6;
	arc=none smtp.remote-ip=195.154.119.183
Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15A7606A331;
	Tue, 17 Nov 2026 19:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D15A7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=aurel32.net header.i=@aurel32.net header.a=rsa-sha256 header.s=202004.hall header.b=VNUwz1X6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=xMOirzj/A0MDRFwFon6RlS9/MgqYCms83N5vsqNPifA=; b=VNUwz1X6OZ7DPmcUaSOQOfvrHy
	/605fcTZCt3425bBBrYXYwkMC5n+HWPcrYguLvJUdFLjajK4Wg74224g15Lw5HmYpduY5jRUY0yIN
	A9egzJPhyiDc//nU5BzbZVTKoWAzv3j/Upmn6vsIv7Ua7a9JhwE+fMJ/1fkfGXmiAPX6V84IVuvW8
	X/kOYUQuneMbVmxGdaKIPxYBLp8UlRt2zxQGxlGvDbRdswMVSxXjB8cjXw/m/QGDKymldDupLqb1N
	5cfI4LMfTFSpV8D8Qzamgdpc8iXpFXnlyMejDwvvYQZQCdLo1FvMmF/Q+YisPNWI+t094tK8nWljW
	xAQq96pA==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1xTP6x-0000000GSWe-0hXU;
	Tue, 17 Nov 2026 20:44:59 +0100
Date: Tue, 17 Nov 2026 20:44:58 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Yixun Lan <dlan@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <avyuutpzB2j1vduf@aurel32.net>
Mail-Followup-To: Yixun Lan <dlan@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
 <20261116-08-k3-ufs-support-v8-2-e3b256972dd4@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-08-k3-ufs-support-v8-2-e3b256972dd4@kernel.org>
User-Agent: Mutt/2.4.1 (2026-07-04)

Hi Yixun,

On 2026-11-16 03:46, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> Tested-by: Trevor Gamblin <tgamblin@baylibre.com>
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 655 ++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h |  77 +++++
>  4 files changed, 745 insertions(+)

Thanks for this new version. I have tested it on top of 7.3.4, after 
renaming ref into ref_clk in the dts file, and I confirm it works as 
expected.

Tested-by: Aurelien Jarno <aurelien@aurel32.net>

Regards
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
