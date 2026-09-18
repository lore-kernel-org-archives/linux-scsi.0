Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496A490BF7;
	Fri, 18 Sep 2026 09:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722576; cv=none; b=j+halHtgtbsxqsz3lPoIAfgbZcKOBtpZ3KIgMEmeoaZMWr2uSX2jJWQ7ZuDn1z5WHFmtjqjiMXOAGN56BN09A/bsFc96c0V6TPb7bYIldlaljz+x7hUSlTcOSQYyjWSUz+AKcRTFv/86CaLeyUXxf6MLeH62hbf8Zqcd5ilZKBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722576; c=relaxed/simple;
	bh=lg4of1NKR+OjZ0zYTKcVKcck26DAd+vuotjzYU67cZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHXUPd+51qztOllEWlc9Uc/TeitMse2BouHdGouDaDlifmvxswYLf8DIUT63noXOUkc6L7orNWzN96jQUHMw5mxMaPa6QguDUAJNDHGGnLk/bRK751UcFlix2f/ZO7T9LVgC3hiSoeiezadbj3oEG/0yGn2Z9Xep1v8k+R8rRgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0Rf/517; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0Rf/517"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350F41F000FF;
	Fri, 18 Sep 2026 09:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789722574;
	bh=Y7Zaebw1o68QOaII7IAX+WBWMhMnWDpU9cGJblPhhhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F0Rf/517Tzdkfa92kvtg3/aNokoH0pyK9SJLrrLOoWzCrg2nbArA071Jb9Y8c1SeK
	 Kc4mKrkHjumtZcHDqkWTVvR+ObgvgxHvzjWTy3NulJ5/k5K1KVwXS5C3erCbO7/+8b
	 qP0+fFaIhIJshDdq+0sLxia5S/QD8GfqlbMLhbOg1znf8l7K+HWjzI8xRSM839AkIB
	 f7WQtiB4n8QYW5oq01jKw/c+hcbQC2/kTW/0z6btbjiV+otGN2QE66Ncr+M+qzxhVR
	 QrDL6A7XWnYs7noqPcY1M1PWWmykbRxPJmTCJoYr0qWGPjQcbFSartu9GAwWi35Bkd
	 WAvxaQqWe0eZA==
Date: Fri, 18 Sep 2026 11:09:30 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>, 
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Message-ID: <20260918-clever-daring-cricket-e82e8b@quoll>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-1-1f5d71f1027d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916-08-k3-ufs-support-v5-1-1f5d71f1027d@kernel.org>

On Wed, Sep 16, 2026 at 02:59:53AM +0000, Yixun Lan wrote:
> Document the compatible for UFS (Universal Flash Storage) Host Controller
> which found in SpacemiT K3 SoC chip. Its features are listed below:
> 
> - Compliant with MIPI UniPro v1.61 specification.
> - Compliant with M-PHY v3.0 specification.
> - Compliant with UFS HCI v2.1 specification.
> - Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
> - Supports standard low-power hibernate to reduce power consumption.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

