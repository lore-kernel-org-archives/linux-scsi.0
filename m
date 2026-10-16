Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75352F7EE1;
	Fri, 16 Oct 2026 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792144368; cv=none; b=DwSHFmZwzsyRk15A0iD3PIT06z1w7NLVUOC8QymPHOc5zgqi8AEJKIUn7rhuvLlakP5TaqxBWDXhvoGqhonCtl7lmZSf3SmM/ZPIuYL9ca50cuqau6Ch7H5B1VMygY2MLTf9zmAVn6mvUXxSnPpns5pRy1AxOQPNDXgb/yHlDDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792144368; c=relaxed/simple;
	bh=4m0G5Fxd7cEt9q2bJP/piomErw6XTud4jUu6ChyyiHc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=sQS+HVM7CAFXDtgC1SIry+3EpkqEugTysWMb5NCna2hJDWL4sprkRKsGqAnYt41SYUT4+GkLgrnCtwC316eRQrahfGAleSdCxwWn6jXyT5yMWuvuqOAW6t+Fb85VVsZxy6qh1DPyilJdLY1XupyYWHgE2p7/Jw/dblh/dwHZXeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leqoxnEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leqoxnEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A011F000C4;
	Fri, 16 Oct 2026 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792144367;
	bh=S9qutPbcIRsUxmCjo4h9+V8s4IY3P9RUmUbWSOzj7zA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=leqoxnEsn3QjFcjdO0gJ0pMZw1iU/iU5g+o1bqhkg788IHUpXjr1pGD/hhUoLgtNC
	 SB3EX13bmMngPwVi+7WcQvvckj3V04vFUFnmh6/FDjr6REr6wd5gKljlpXaVkLvQj6
	 NFX3g5Nd9Rxh8rVAQKwhsNoPmLzYpddljp72bDUCRbVUOBhcJLYZIYLmYNEirc7ewi
	 FHG+uvyGitTRqBHO3QRIbF2SWFR4+IDbUzqvQYqa6MFfpEbUz1/LEMfYRaAv44Ws9c
	 w+OIXOZnVi3Op/kZ5lrWM3asUvZhDzNaBAx+PzcfeM9WkXvSIJ2ZcDsAWr6jF8Rz70
	 nDgQlWDjktdPg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 5/5] phy: qcom-qmp-ufs: Add Glymur support
From: Manivannan Sadhasivam <mani@kernel.org>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
 gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>, Abel Vesa <abelvesa@kernel.org>, 
 linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com, 
 sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-5-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
 <20261009-glymur_ufs_qcb_enablement-v4-5-9a6ce83195b7@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 15:22:33 +0530
Message-Id: <179214435398.106618.10901078741061119278.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=653; i=mani@kernel.org;
 h=from:subject:message-id; bh=4m0G5Fxd7cEt9q2bJP/piomErw6XTud4jUu6ChyyiHc=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq0fPlItkYKusz+VRokfHGafUEG5kcst8lxkBry
 2INrDXc+MeJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCatHz5QAKCRBVnxHm/pHO
 9UlsB/93uTUB7pO9AQnLoeG9/we3xioUjw8aHx1Erb9VJTwehBSjCApaHinNikT4NqtncxFeqwz
 N9Mz7HST615kmLPHuvN5/1QYRFN3QmzXPWR/KOe4B/ysV4siNDmL+LUs0rPmscpYnEh5fibt5C3
 3OQSvD4ND+oEMoMxhhfuxcyPXVnGod9WS8lfSI+ofwsGnrug0E26/5Zqw2Jj1iQZKW/35GxRvy6
 grzKdo/E9uX2g0QJKREdZdlv0MBHL5dh7oWvwG5fhweIaWnEBJTc/hhVgz476KXaw8u7lEgRhVc
 kVLQC6fEfDHBciykF7POskcp8U4SpStbQWprFITTNm/fc0Jp
X-Developer-Key: i=mani@kernel.org; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008

On 2026-10-09 16:05 +0530, Pradeep P V K wrote:
> Add the init sequence tables and config for the UFS QMP phy found in
> the Glymur SoC.
> 
> Similar to SM8750, the QSERDES RX and TX register offsets for
> glymur SoC follow the v7 register layout, while the remaining
> (PCS, MPHY base) register offsets follow v6 layout. Update the
> register layouts accordingly.
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani

