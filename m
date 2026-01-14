Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443A835E531;
	Wed, 14 Jan 2026 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768430194; cv=none; b=hH5N4dk7M9VtUDM9TuSa4+s4pJbW7OZ3UMN6XV8xC9mfebGAAOTV8YrmjUfNxbwoRi/T6f33R6NmS+d1nG6vAmkhUqztRQWGReF69kB7gUD6b4S0Gr+61IRrKtiLg4P8/Z0x4OWyXMpOSywMKi3h8PZronjIdrBG+h36uJNlRWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768430194; c=relaxed/simple;
	bh=tOITCwcNkvuX/Q3/odZsyWjcoRVv7aqf+H54LU9E1pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAnBPIiX6CFwwHgm10vlD+o9F+zCdJmUTy1rEJpH39XionS56b6YMb8lKdVy8oos1S1ZSt86x67P90sGT05yno8gTT0VTiPDls+D6MOeO/5hLS/vFGHFr7t2nLvl6L5m1DWxdWFpWIoDmF/6dMHjRFH4iX9CkQR5mwkXrN3IhIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6b78jPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6b78jPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6142DC4CEF7;
	Wed, 14 Jan 2026 22:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768430192;
	bh=tOITCwcNkvuX/Q3/odZsyWjcoRVv7aqf+H54LU9E1pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f6b78jPE0dTDU/gdnUzi+iF1OneQmqH2B3bv5nS6hWooWRBVXoS9rgosUIllfcs6d
	 +EYQbtoKircuYUAmW2ZFXWNETz4iOohJdUtUsoFL/SUfiRBxYEgDOCA6oLxjZQWUCz
	 hXQgycybxeg/PHYM58aZBWLdcrOuQuLjIRBKdRlRI4/6ZSksq+3WEm7wKo7MjfuKrJ
	 ymmcnKtSSzjO7AdEtFg/+fcvB87LjpZ6/0YZhEizfjgTyJ83UOCuIB1HqIoQ8174if
	 BEBAaehDBfolZ0Li+T9Wk2ihwFkQBYvGgXIcRyhlT4yJ1tK/JB80wvw/Th1EdrSTCh
	 dHtBXz8eCdwqA==
Date: Wed, 14 Jan 2026 16:36:31 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Conor Dooley <conor+dt@kernel.org>
Subject: Re: [PATCH] docs: dt: submitting-patches: Document prefixes for SCSI
 and UFS
Message-ID: <176843018897.3319721.14136829860575398565.robh@kernel.org>
References: <20260107132248.47877-2-krzysztof.kozlowski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107132248.47877-2-krzysztof.kozlowski@oss.qualcomm.com>


On Wed, 07 Jan 2026 14:22:49 +0100, Krzysztof Kozlowski wrote:
> Devicetree bindings patches going through SCSI/UFS trees also use
> reversed subject prefix.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/submitting-patches.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Applied, thanks!

