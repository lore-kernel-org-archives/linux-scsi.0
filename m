Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.154.119.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107369;
	b=M78QEjCv3vTOahnu7Zl+LnngA6nI74sgOm5O4g4j2RwaILU9D/HMdwuTxU5UWNgQ67z2
	 Kh3e9jhGtD7M2JS05Jeqjvi0ZB4fp74jh3ayQy71miBTKP3Sjle0r4XmHaRI3PLQvr/Wf
	 BUoJkXFpcC1u+hQIyTPatF9T47rSAgbZUnuk9uqilqreAaw63/p52rcUXUK9rjoR3DQkF
	 vPdUiuWRKyItdHNbnsl/4f9lCT6TKmQw2a8Pmg3PPD+IB0NPogr9RViOijb5+4SUvrKdA
	 S4myJ4AaeFAg2GJpcnWRiq6jnTjefrKs750PmQwmOEpJ+xm/iOWS62goggovOj5S0IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107369;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:User-Agent;
	bh=kwyugsNu4/tep0lvJ/4udRwqoAJgnB/y7VsHTKO8ZMQ=;
	b=D80XN1z0+EX8NsV6ddwgrETWuXaH4BozvZJmgJ3an7lCQtjQZki7QM4DyhTMrDbr/+0u
	 c34lXXKsjTiGcxvJeKzs0yKbwx0OSkOormtm+K3q3BQmIZjUjKLZxvJrDgRDfMGfmSzhq
	 D4S7YyTBhRWl5G3XqCjruJB7Cczu8YNWl0q1Nq3qTipiTZHq4zEkJC5Op/PxtGbX3No1Y
	 KLdL3EI0exYZ0AIMjWn7LNf0vADwSt93nqX9QOo7KOPBu92QaYL08xFV2QSlXlgvj+sNQ
	 A8kELEU/QBabzN7lZV32QDqmcCLXourPY1qUgB4VrU2Rl4YND1ad/qwjTq3JFViPSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=aurel32.net;
	spf=pass smtp.mailfrom=aurel32.net;
	dkim=pass header.d=aurel32.net header.i=@aurel32.net header.a=rsa-sha256 header.s=202004.hall header.b=EqPrM0py;
	arc=none smtp.remote-ip=195.154.119.183
Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D033B606A330;
	Thu, 19 Nov 2026 16:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D033B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=aurel32.net header.i=@aurel32.net header.a=rsa-sha256 header.s=202004.hall header.b=EqPrM0py
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=kwyugsNu4/tep0lvJ/4udRwqoAJgnB/y7VsHTKO8ZMQ=; b=EqPrM0pyAxa8ZlSkLqTAdR2BGd
	eFrq7mXsxrYa77d5+uWkY17tLHY4zE5FTGbMZuMLA2FqC4R72SLau9EsUMvLasDsrMOSNRd1QNJkH
	2OMzKnKOjsknyzp597Wu31Qz1kL4dilvFuWHYTiEy6bgBhNMVVnPFqI1qDjXCAm7Tas+lW7DR9sZV
	d+gmO8vyTEXUV6UBx9Knaq2NXLUCGwf7hrVqfcxWJ4Zvs+IxIUnWLr6eCp7rmACI6tLrVbopgvxCf
	HVDEVWByeAJ9RaJVicLr2vYAgH7lZvpqYBvo9mcCgZLVCKx7dgAFZnVmWMVzzmt2p58K1RnpoR6hc
	DW78MCZA==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1xU5QI-00000001j9b-0hMX;
	Thu, 19 Nov 2026 17:55:46 +0100
Date: Thu, 19 Nov 2026 17:55:45 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: E Shattow <e@freeshell.de>
Cc: Yixun Lan <dlan@kernel.org>,
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
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v8 0/2] Add UFS Host driver support for SpacemiT K3 SoC
Message-ID: <av8qEXk68wsy7pNe@aurel32.net>
Mail-Followup-To: E Shattow <e@freeshell.de>, Yixun Lan <dlan@kernel.org>,
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
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
 <8462a0d9-e9b7-467d-b2e1-7870c78e2691@freeshell.de>
 <avyusx36U534Bpu9@aurel32.net>
 <053b55fe-47d0-4cc7-ba53-c560fc9c1d1b@freeshell.de>
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
In-Reply-To: <053b55fe-47d0-4cc7-ba53-c560fc9c1d1b@freeshell.de>
User-Agent: Mutt/2.4.1 (2026-07-04)

Hi,

On 2026-11-18 23:38, E Shattow wrote:
> I was missing this detail previously. For testing again of v8 I have now
> inserted a sed pipe to change this as suggested for the dts application
> step of the build procedure:
> 
> b4 am -v5 -P3 -o- \
>  https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org/ \
>  | sed -z 's%\(clock-names = "axi", "\)ref\(";\)%\1ref_clk\2%' \
>  | patch -p1
> 
> Additionally to the build procedure, since Debian testing now features
> linux-config-7.3 and no longer linux-config-7.2, I now substitute
> accordingly from linux-config-7.2 to linux-config-7.3

[...]

> $ journalctl --dmesg | grep ufshcd
> ufshcd-spacemit c0e00000.ufshc: freq-table-hz property not specified
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vdd-hba-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vcc-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vccq-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vccq2-supply regulator, assuming enabled
> scsi host0: ufshcd
> ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BOOT WLUN not found

All those are expected, so it's great that the issue you reported is 
fixed.

> I did not again see the DL error event. However, the first attempt to
> build Linux does fail:
> 
> make[7]: *** [scripts/Makefile.build:572: drivers/gpu/drm] Error 2
> make[6]: *** [scripts/Makefile.build:572: drivers/gpu] Error 2
> ...
> make[5]: *** [scripts/Makefile.build:572: drivers] Error 2
> make[4]: *** [Makefile:2244: .] Error 2
> make[3]: *** [debian/rules:80: build-arch] Error 2
> dpkg-buildpackage: error: make -f debian/rules binary subprocess failed
> with exit status 2
> make[2]: *** [scripts/Makefile.package:126: bindeb-pkg] Error 2
> make[1]: *** [/home/es/linux-7.4-rc3/Makefile:1852: bindeb-pkg] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> real    188m48.844s
> user    1415m17.363s
> sys     66m11.932s

I guess the error is some GCC ICE.

> Linux is running on the K3 SoC here without clocks preparation from the
> bootloader; it is quite slow by comparison to a Linux kernel that
> follows clock preparations by the vendor BSP bootloader. Simply
> re-running the same "make ..." build command is successful in the same
> system without any changes:
> 
>   DEPMOD  debian/linux-image-7.4.0-rc3-k3ufs/lib/modules/7.4.0-rc3-k3ufs
> ...
> dpkg-deb: building package 'linux-image-7.4.0-rc3-k3ufs' in
> '../linux-image-7.4.0-rc3-k3ufs_7.4.0~rc3-2_riscv64.deb'.
> ...
> real    34m56.794s
> user    241m15.511s
> sys     18m4.532s
> 
> Similar build failures occasionally happen when the root filesystem is
> on USB microSD adapter-connected microSD storage. I assume the build
> failures with default clocks configuration are not constrained to just
> the UFS support series here.

Yes, this is a known issue, unfortunately the K3 does not run stable 
under load. See this thread (although it seems at the end the K1 and K3 
issues are different ones):
https://lore.kernel.org/linux-riscv/apSYF5x1Tu7PlyL1@aurel32.net/

Also see this Fedora issue:
https://forge.fedoraproject.org/riscv/planning/issues/36

Regards
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
