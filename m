Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4443AD537;
	Thu,  6 Aug 2026 07:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785999916; cv=none; b=scYnRvZClfIZMEBxsyM9iV/YsoRuy6s/8wWs7B9AzjgfRy5kiD2jK6lp2sEoVwz/SjQUV1/lj4rgzaNmJKGhZpmKS2BizUMtsivwBUisETYldHmGq3c0jeg2qF4hO15zYNa/T2yo64Y3PrX5NtY980u67FzEFqvY5zx4qivo9hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785999916; c=relaxed/simple;
	bh=Ioco7OVue3aRIdqHRF+bq60y2AgXB0GTbcuCzV7Dkfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fexhu05AhGRtX6arm3NEd2F7vYf5oNzFwoQhgIthS6o5Q2b2hFcbCa1ZMXEWIQv56ij5L7BrBe3k4C7HX4r7EOGJQ/x6Nby+cWpBmpWi0hK3YjRptCLeFMeATs0y0g/H+V7kFz5jijZ+xqGm8hw94/45mB0I1DdUf6cdLN+VzuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQ0SIge7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQ0SIge7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB13E1F000E9;
	Thu,  6 Aug 2026 07:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785999915;
	bh=StZpRC4UdL40+r01FvxYkBdHfrGKIGU+ZlSJfqgqV44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XQ0SIge7vmOKhfMTQ96S4l4/xyFk1qsdoMOXSAYiBjGbADyJjhz/K/ZPF3JJYVKQy
	 6q0ZEcavV2qg1wQMF5DSYV4wjqg2wPPk+CuSRy5bC3ySdrY5XYxLddtw7vvDtjU4ht
	 7d5VXADLioMlWkrxw+clOsGJvZz0RNxBI7Ls/fGhluA/QGvu5Y1wWKyuZS8EYhM4IM
	 8TVno8yEs0qaGhPEODm/ycDVEKbV0v5ciaD05FQyveIoZhLjYRvErgW2WOUk3RPxBC
	 a+Brh2v6FFzMG8Lp9v1zpJAs6MofEhon1+tuxI4gjtBcOcHdi+mHbIrxpo1t4RFb3S
	 y5OJOEQFFh7+A==
Date: Thu, 6 Aug 2026 09:05:10 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Aurelien Jarno <aurelien@aurel32.net>, 
	Jennifer Berringer <jberring@redhat.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Message-ID: <20260806-prudent-vole-from-valhalla-3eae39@quoll>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>

On Thu, Aug 06, 2026 at 02:56:18AM +0000, Yixun Lan wrote:
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

You keep having the same failure for every version, no? Never responded to it...

I'll drop from Patchwork.

Best regards,
Krzysztof

