Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DDA38DD8;
	Mon, 17 Mar 2025 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742208667; cv=none; b=sZH3UGP+YvoMagrwB5nTZSjNDS0w4aglW7QnjbcUpLNRCeWeIYgR3iMtPUmiM8GepsCE6vHKFV9hGLKvFCb9hU50Y4GOKQfOY491ECbz6KrYVcTDGE0NHT5vylt7V6yTYihzEOfFURO6ud9uewGmABytIEw0TbFeQTIJNBmQM3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742208667; c=relaxed/simple;
	bh=N5vDIP/ZC1r9o50B33oF2VBCYpl51zXDjZlxWywD5Qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrD1UiMwJrXh8bHVhfu0kW5TQD4Mx3FKQPdsqaWpVCsGVNRJEuL4WYoV8R0bRC2S96izmdyJc21VNAb2CMP4DSRcBeFHIryArvnjWgbC7TKvo4g3Q4mdC3ceuZSrpNUb78ffRbAtr9LvgnCOnIk/0nzDwOwRMqVpJaw9DzgO7AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C537C4CEEE;
	Mon, 17 Mar 2025 10:51:05 +0000 (UTC)
Date: Mon, 17 Mar 2025 11:51:03 +0100
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: =?utf-8?B?QW5kcsOp?= Draszik <andre.draszik@linaro.org>, 
	Tudor Ambarus <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-team@android.com, 
	willmcvicker@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: dt-bindings: exynos: add dma-coherent
 property for gs101
Message-ID: <20250317-gorgeous-wrasse-of-aurora-82ee0c@krzk-bin>
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
 <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250314-ufs-dma-coherent-v1-2-bdf9f9be2919@linaro.org>

On Fri, Mar 14, 2025 at 03:38:03PM +0000, Peter Griffin wrote:
> dma-coherent property is required for gs101 as ufs-exynos enables
> sharability.
> 
> Fixes: 438e23b61cd4 ("scsi: ufs: dt-bindings: exynos: Add gs101 compatible")
> Cc: stable@vger.kernel.org

This change is a noop and fixes nothing, which you can test by testing
your DTS without and with this patch.

Best regards,
Krzysztof

