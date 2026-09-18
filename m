Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694393AE6FA;
	Fri, 18 Sep 2026 09:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722466; cv=none; b=AAGSLrJhae1Zgqcv+4zZBnCkHEWjxFEakUmUvSOqFqPoXiBxzxhAFeGn6MJZdYGcMi2Ym20EBU9uJNkqXqfqzTYZONWlpIZApvrN3gJ5PDafkfu9bvmbtI0T6aiV+VzcItinsqfBDQjTPX/ELklsUJX+GSyTKMESXFZc4zhXw6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722466; c=relaxed/simple;
	bh=6y6bLzRoaZiGpSaea4CWtqMdOzZraHqLzVyABx69wqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzG3KwUl68Rhe2RrGH9QrG0h8cPG+t5scoZUN9oxqvALmTfhV4zdFZ9mHu6UMBPwgxjCiFU8sVeCWbV42CQPUUAxe44fvfIeLh/aFqF6HLw4bbcIqcitIrOhHA1wjML16O6+XmB+ZHwvheWmyQulLj3MJCzAgD44guJdcjn6CWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMaBZ9TE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMaBZ9TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A001F000FF;
	Fri, 18 Sep 2026 09:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789722465;
	bh=dOVqpqan0xf3awI8+3T+cWwtyOXJou4D9LjGXtl8pC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HMaBZ9TEg+yhwwYqza+dLBctDcY80Ya7CW4bTCp6GIdirnqRLGpdGevy4KlJb6j/B
	 Lec1reZYQ3lh60CbH1aN526gyrZAhZhsBpVqqPCs+Co0lR2NYvHpSQjrF8COXH9K1B
	 u27qCUejlrqJxgVEC37/YW17DmqyxXO16mLZK9pI+7f0FE8nUNJiTt3asbm5kZv3OF
	 lRnDniAZcHOUaip1J1SP1eq5AQV3YmInHR6+QXsOamRvjYHl/vI6MARrzcwE06c+zk
	 h2Tr89/Rs49EggZgPTlPPQ856RlCWLDuX9FQ6gcBsSv8cV4KqHgYFQfLxiJu+u8dwW
	 ekrYR+wtSmzdA==
Date: Fri, 18 Sep 2026 11:07:40 +0200
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
Subject: Re: [PATCH v5 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <20260918-belligerent-succinct-kraken-7fa592@quoll>
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org>

On Wed, Sep 16, 2026 at 02:59:55AM +0000, Yixun Lan wrote:
> Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> it both on Pico-ITX and CoM260-IFX boards.
> 
> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  arch/riscv/boot/dts/spacemit/k3-com260.dtsi  |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3.dtsi         | 22 ++++++++++++++++++++++
>  3 files changed, 30 insertions(+)

Please do not combine DTS in UFS patchset, because it might end up taken
by SCSI/UFS folks and it should go via soc tree instead.

Best regards,
Krzysztof

