Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0DC3B3BF5;
	Mon, 20 Jul 2026 07:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531105; cv=none; b=ZcgP2aADXIbOrwfgXrV1cjP9jJOPaR69dOx7r41in1kIU+M2+KPZ9kDq6la8KPwMiBIC26ReDw0ZNccv9+Lvk21cOlvwmigVlNrj04DP9ymcKUZog8zCPOUFzJFwHm2JjyyOZHEnde6k1hI/wcn4Ind2yNVttx76g4bbuNY545Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531105; c=relaxed/simple;
	bh=Fot1YxFALoMpYP/bm/GfWz/Y0Y6CUrPcm3vf5mob7SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNK66B3s5zkQqxWUtY3XEUk3JltEdLRqH/iYPlPw44tMP1YA1jhp4nKfuEL3BnRGxzYsGIHGyzRuUikvdoFxk4bvC2o1lHdGyS7peSRuhoMWs9zn5Exgv8jUd+9SUZIlS5+/ZO+xMdJnMEMaHwC5ZhhJB8/Nbwv+QNZLUM++Yek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfFbMMWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfFbMMWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F581F000E9;
	Mon, 20 Jul 2026 07:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531104;
	bh=1J7Jh465rFDe/UAQCH9XXmeQaQWHdkSPnuaJV9U0GMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KfFbMMWYaxJdLayNKDfOGg6CBnIS5azH7/nxWo3HqwgFv7jtZNk3beWYs/CqsxSXY
	 flGLgbWO2OToFRmh7yOMhnz9X3vB4qwgKa0m/7cdwPunTibcbKKTAi0byTXMNFS/gQ
	 TDtYiKLqRZ8kWSmJAaWDdpAaN9aCQfLEmvH/yhbiqFOEb1NYnhEk/Xzq7qrZasVkI/
	 68BeW8SHodRWvb7OV/gqnnp5sGbOE433kArkGlhQljWfygG3GMFMZyk0GJVXsFn54i
	 dAhZ0SD/UJ3wJut8Du/uD0tn8VaKLA6pXcK1FxlCdTF2rSKKqegcZ8AkHvqi+zU9AU
	 IbDEs/9BG7Exw==
Date: Mon, 20 Jul 2026 09:05:00 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, 
	mani@kernel.org, alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com, 
	conor+dt@kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: dt-bindings: Document the Maili UFS
 Controller
Message-ID: <20260720-quirky-ruby-turtle-aeb780@quoll>
References: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>

On Mon, Jul 20, 2026 at 01:28:33AM +0530, Nitin Rawat wrote:
> Document the UFS Controller on Maili SoC.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
> Change from v1:
> 1. Addressed Krzysztof's comment to update 'qcom,maili-ufshc'
>    to the allOf condition required for MCQ targets.
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

