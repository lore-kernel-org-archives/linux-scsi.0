Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E720411FB7;
	Fri,  7 Aug 2026 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786106039; cv=none; b=ABK3k995uOrjp77emHttQVXXuwad4NUEbuTEepqjQSCqhc6wCMrSOOhoefO7r2jz53bexMBod4lI6fpcEUDkknmFGPX3Hw6qeEUsF/V2IkLtVRvCoI1czhDT7XA++2ddKA0MulhVZW2S3lSXpFa1c+Caw7SuJYbEHl3eYvTOrTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786106039; c=relaxed/simple;
	bh=KdS+Q4TZFYYBcbh6QJM3XvuSwc0ZP0csC//YpSqwR4E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pIoM6mMBO+cMQ+uRy+jD0yb2JXSYNh4rbEplQqp7pU0L7/EOOAmpCWpw35tM/6mzQeDvRV6IbsoN0LKTHRNa7mPr+LwOim63zdLFe5SXPfgPRWYdFNAH3016vYpITi9RQ58jzpH0yX+SLW/e3rmWbuKWkztHqxFy0UHBSx37jzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhrNh0LV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhrNh0LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6D31F000E9;
	Fri,  7 Aug 2026 12:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786106019;
	bh=i9losdAECiBM8oEcHaNb7WL0fGPaUuj+15/i2rCME1I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RhrNh0LVfPsxfSfCUfH8NH0UFkb4oADC07ruWkfJNA5010mD/ahze8iHl6GmoQJu/
	 nzeAqeg+RMiUqX1z+jVm3ah4M3pi8HycRD6/0FTchLUfzmWP6Lg6VG2PD5yt3JEhgn
	 YOFDx+d1MEaeDDVhZ9uR7HZ0ndc2HCqIY/XFVszNo95r7w3nU7fPFgKmLdhD2CFxCH
	 Lo25yaitdeiYnAHjpmYmvEsszccX1MtszY26+xCuVXa/a0gEUYXNlQ2YZr+0ObVv0N
	 TNBZ8umbaqqG/AHz5JUpAV3H9UcWt5mkKkqLqZX1IserlM3wN2BbMI2a7zCUMF4eJT
	 zwG9wZ5y2B9ng==
From: Vinod Koul <vkoul@kernel.org>
To: neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org, 
 conor+dt@kernel.org, mani@kernel.org, alim.akhtar@samsung.com, 
 bvanassche@acm.org, andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com, 
 abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com, 
 palash.kambar@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
In-Reply-To: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
Subject: Re: [PATCH v3 0/3] Add Hawi UFS PHY and Controller support
Message-Id: <178610601225.740291.16313821217075665373.b4-ty@kernel.org>
Date: Fri, 07 Aug 2026 18:03:32 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0


On Tue, 26 May 2026 14:39:53 +0530, palash.kambar@oss.qualcomm.com wrote:
> This series introduces devicetree binding documentation and PHY
> initialization support required to enable UFS on this platform.
> 
> 1. Devicetree binding documentation for the QMP UFS PHY
>      used on Qualcomm Hawi.
>   2. Devicetree binding documentation for the UFS controller
>      instance present on the Hawi platform.
>   3. Initialization sequence tables and configuration required
>      for the QMP UFS PHY on Hawi SoC.
> 
> [...]

Applied, thanks!

[1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
      commit: 24d886d9344c7973e202a7f275ff8280b742446c
[2/3] scsi: ufs: qcom: dt-bindings: Document the Hawi UFS controller
      (no commit info)
[3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
      commit: 2f7b4bc47b1e22c3e510ff6e25985edbe9cd9f97

Best regards,
-- 
~Vinod


