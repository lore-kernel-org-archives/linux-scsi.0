Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75310547067;
	Fri, 18 Sep 2026 23:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789772583; cv=none; b=BfKV6XHnOkpqjNnUDOKJA4CBHxFeSayDwdLYvDXCDsP0TBFtgtx4M3AuIE+Rmm/xjES0PG1hrKQz4CcBru0pExXC54Xr+X61J0onAasdQ2uaurW5gAPvGuBTcyShuNA7ST5YzsVqawLOAlHf+Tbe7UslTLpfJP5Tkxc87NEQHyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789772583; c=relaxed/simple;
	bh=fBqBc3Jy443rwJVSlTXTHQbto0sf3nymtAcrMra4A+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+zhm9WtTRsQFUuTajh2+suT1sbrTchKZjwUOUktjBvFyIrYOVNHZ+LT32M7P9beCu4NZHEb/hfLECcUMsDtqKJYG1NY+TP/SWvPW1HSX9SWikTuB+bN2HssSeky9g6Od8/FW9zJGCCVri1MNmzKYkq/rEHhxIUJ441DOwP7/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rip47fgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rip47fgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F621F00898;
	Fri, 18 Sep 2026 23:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789772582;
	bh=jHNs6AiLAnXjxOSEL4ZlVQ0PBlGJFDV35U3GfJhTtpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rip47fgogMqlbmNb1qqYNEe1XC8JTQFskqccQH4DQ3hrtax39/kAK5gQ8Q56UI6FL
	 sQJH+YDyD8kMcis7lAibglrAjR4s/saQiI243scxL+bvbj+WRw3wGk+EGvnls25qfT
	 isCEYLfiMsuyJvHExcULWwGwGWTYKzqYipnNxAkSCl/Po8ZROss4DXGL7H+WurwH5/
	 5w7Sqx+Hxab9L/LEULxkYCwwzG+EQxvhd1ge7iWilmgb2kZ2AV/1g1mt9wEBQN5Xbn
	 ZsP+unnf2M+BBSbgb8wVRqRpQmHEbPYXI4wK5fsNwzH9t97EVMM8PGINSOlWQuNZFm
	 ramiBSZCkLo5A==
Date: Fri, 18 Sep 2026 23:03:00 +0000
From: Yixun Lan <dlan@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <20260918230300-GKD297024@kernel.org>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org>
 <20260918-belligerent-succinct-kraken-7fa592@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918-belligerent-succinct-kraken-7fa592@quoll>

Hi Krzysztof,

On 11:07 Fri 18 Sep     , Krzysztof Kozlowski wrote:
> On Wed, Sep 16, 2026 at 02:59:55AM +0000, Yixun Lan wrote:
> > Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> > it both on Pico-ITX and CoM260-IFX boards.
> > 
> > Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> > Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  arch/riscv/boot/dts/spacemit/k3-com260.dtsi  |  4 ++++
> >  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts |  4 ++++
> >  arch/riscv/boot/dts/spacemit/k3.dtsi         | 22 ++++++++++++++++++++++
> >  3 files changed, 30 insertions(+)
> 
> Please do not combine DTS in UFS patchset, because it might end up taken
> by SCSI/UFS folks and it should go via soc tree instead.
> 
Ok, will do in next version and send DT in separate series

-- 
Yixun Lan (dlan)
