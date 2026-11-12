Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794482432;
	b=NnLpRhi4xdFWpXcHrE9tx1RFQhzPckaFbnQxl/V7jkBnMsFDcoOf9CzHARDvEMmtF2al
	 +n0dLk79KVk6dVJ+bjI30bURLZV3J4HswiY78ADTcxg6Q8dt4eUGbeqXa29ghrLzPvXO5
	 6SYIwImbBWWVPexc8QqSr/rTslYw+f3SKqNDsOj1Ct+Q4/gHuehjmXSs1Q+HRwPNn+5Oh
	 7irrRtFK07qpeozspptdsez7TH+zoMoIAsRPfZt5w9dPA1yrF6LHBQxRIfk3VAf72Ww65
	 /+vyXplXAs8/oKZpv5NhstXH/ifc+u+UAxkr7C9HKbmI3S+5uvJZE8A/OPFceR1/7zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482432;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=hAfL/WFmB05akBiWgGs8l8XrwU7+jMrFoaHWisRpDqE=;
	b=tUmvDEGfK/Ohh76gTCI0dJhW7dAIlsihEqOupkCAvHo+G8+t0vaGS/5zg7K5mNZmj+5z
	 Phf0MfKX+QVWd9FiFCcDS0oVFiDIEDkrAkYHLIziJXZXUV3egGOlRvTpysFklbbu+bUWr
	 0v5NdMLtFdj5G+LHrn1NIC7/mR+6fECOyEP+VQHxWdAbf6Dyt8CqxqpTfdjrjlCCjDmv/
	 TiBQHtpemokbZCFKveYKaGyFveef+T1jsAt+SAQZbUXQzwEcIJ/VALhL+mW6G89WTWPEM
	 qPcYYd6coonuULaDDhpSkYU8GwxBBBJ+GKQBZYqBYTLb0AXOMssafiNnqKz/V7yPIxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9B82kd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77256606E757;
	Thu, 12 Nov 2026 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9B82kd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953891F00A09;
	Thu, 12 Nov 2026 11:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482432;
	bh=hAfL/WFmB05akBiWgGs8l8XrwU7+jMrFoaHWisRpDqE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=O9B82kd8G3xrpV7RRBTWam1Xbr5BivytF0MyJC0hZPGsQTfR2S6JIx9WTBLucYoEh
	 eTrPgMRUvFY9s4CMw+AQ/HMrXIVCwhrVk/qs7uXt1a/ofmJsL9L1VX9IvlYPQObpJp
	 ekBo398K8SVCEO75zGzCbxtaUqpvrb2niUUSvjDw41/MhP45sFWq6flqfa4+DtbmOA
	 1VxAxZ2Knel6Qe107ru9mBRtye9E5wJ+3pqySdSOHdGJCWQjU0VL3u8/sO11PTNfKP
	 PsyOiqeWIMkP56w3YInIhb5zK9Kc9eMGPVboa8IRkKrXDV0YAw1SH5uJfaM9Jfz3c0
	 tkhIPklAbSsyw==
From: Vinod Koul <vkoul@kernel.org>
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
 gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>, Abel Vesa <abelvesa@kernel.org>, 
 Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com, 
 sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
In-Reply-To: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
References: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v5 0/3] Add UFS support for Glymur Qualcomm
 SoC
Message-Id: <179448242524.492462.1764919670468855498.b4-ty@kernel.org>
Date: Thu, 12 Nov 2026 16:50:25 +0530
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 28 Oct 2026 17:54:45 +0530, Pradeep P V K wrote:
> This series adds the device tree support for the UFS PHY and UFS
> Host Controller, along with the required PHY driver updates to
> enable UFS support on the Glymur Qualcomm platform.
> 
> 

Applied, thanks!

[3/3] phy: qcom-qmp-ufs: Add Glymur support
      commit: a3ed89addd954c5c2ab6f745da93559612392d7d

Best regards,
-- 
~Vinod


