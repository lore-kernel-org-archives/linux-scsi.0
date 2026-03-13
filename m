Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4E370D42;
	Fri, 13 Mar 2026 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388812; cv=none; b=u0fSUl+h3DKQgBRrn2qOi/W7yNasIw6I1nrGmCFsmj7n+BDRKZn2K129Y9+0OFEUj6qQvC+u+YrmtyAnxO7WbfCfJg0uL/PAuATg9VFMraxssKrpTcPtf7Ldnp8bJCcsx9XTvxEQBBcMuRz6sPDzMpXSmAh52DO1iYSwm6T6b8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388812; c=relaxed/simple;
	bh=rPbyzzyhYcYuyC2z700AcTwx4hrO+t7fLbt3hPQWmWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0KJHZuOG6Xk1TmO0PMNZSNShFEdE0dXAH88i58anqno6PRljCMw1PpTHjhZdxwHBoObscgHFgh3UI+TteY8FU/Ebtn+o/J6dIEDY+LyxTu33H5k0GlZR8X3JCHRzz60YO14LdqkfEJV+hSs+hzr6dCbbrT6CiS9J5mOnJZECcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRldbB/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRldbB/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13669C2BCB4;
	Fri, 13 Mar 2026 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773388811;
	bh=rPbyzzyhYcYuyC2z700AcTwx4hrO+t7fLbt3hPQWmWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRldbB/clocZ3MiaQeG2MEMUwOwno35Qbr5d6owUcUsQU3nnPLSiYXhhRtNpCX5DD
	 I1Kd+izohXccq7pXZGHtGi6k8VdeEzmsmVbu6GuKgBp1qWPcDswRRQTmKdc8aS3Ruc
	 yKGNYYN/6Ci12muBvEHhz4C9n/89im4BpHgTFRDpZ9IC85U5ugBFi3WN9zXp3C9dHp
	 I/t/nFiPJ9UvT40ain6ZkWmc0nunASZHU8r1ZoIs7NO6V37axjFCrWkvAfn9241ca7
	 goMPCFibDYG0UFfVmIhoe0gVa6NvLoeqfE++aYovQ7hb6OXet5ofzNQL9ckiGVhoyf
	 L3K9Vl7PNPOLQ==
Date: Fri, 13 Mar 2026 09:00:08 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Message-ID: <20260313-classy-pogona-of-dignity-edb617@quoll>
References: <20260311-eliza-bindings-ufs-v3-1-498b26864182@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260311-eliza-bindings-ufs-v3-1-498b26864182@oss.qualcomm.com>

On Wed, Mar 11, 2026 at 03:04:04PM +0200, Abel Vesa wrote:
> Document the UFS Controller on the Eliza Platform.
> 
> The IP block version here is 6.0.0, exactly the same as on SM8650.
> 
> While MCQ reg range is also available on the already documented
> platforms, enforce only starting with Eliza.
> 
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

