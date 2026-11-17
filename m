Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794877528;
	b=FnsIsFOXo88uav0JhrAW856TvlDBmIO89bj5NZsbycrQ4DOhdLSYV112eJjEIhcN2dKF
	 inRhM97+UDWoJ1Rzzsit2/YTCSykELGiKiXEXqIIfJuQVPyBL3tCyFsmAOIKbUztkxXa6
	 c+PY/z/4zvZqLGUk1ftTKPos+cvacL1Q8ZEaGvER0B9/O7gi2YDhrsXB4Wzp06BPEbpnH
	 b5lXzsp2SmKMcKFg2O8LkOKyvWEsEsCtOT8E5SR09LqAqD4QVCtZ27THu5j2pKpQIp6t7
	 AxlH5bZgHOXVqcSSweTditXaXZZi5JQ3kis/MPFZsUcHXnUzS7JI2uEzElz5EypXhtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794877528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/UkWV9wiljkzpRUh8n4QsLNGR9pWBAR9Sxb+kw79GmM=;
	b=l4/IDYQNGpBjAPAnO8jTNVpNqn0Lg9ZM8qDUH7uQjxLPbGcrhR649LPsUEeGFw69fAXl
	 PBtn0KSVkPIDk+qPc9F6P2IJOgTmE0xXSNjKIDwD5jIaNTmD3QC0ws79hoBxwbB1OQAiU
	 O4D5lFchozwVTXwuDIaGwyoM2JlMGuKW+vwLUx70G5QyVJEC9gPr6j0hJPDqnVpSqnidh
	 /k0ySdOGWzjFZHrPBKqfGELCk5r1GupuiDEHqMCQw12vp9sukimLVqdUI7MFhvEf94WCf
	 KljC/b9M2iKK4vETSGNFBiS8sIwYaJ4fFBM0wLPOs4WlmlqKEZUcsuPo1VcZk0GasBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwjZyrOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE63860A382C;
	Tue, 17 Nov 2026 01:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwjZyrOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807481F000C8;
	Tue, 17 Nov 2026 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794877528;
	bh=/UkWV9wiljkzpRUh8n4QsLNGR9pWBAR9Sxb+kw79GmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwjZyrOs6yAoRkGGPgNJEV0zHRJ3l1a8JZxCQxZ1fZnf6bAagYd5S4W8mxpfpLz26
	 qBzpMhgnzP84EpVDOzE0bSN1uMIXepLYZqXU7gqGOhTNkk9RzINK3DqE93WDgnwBpL
	 T70W70hF/uCi5obVNYx3IwKNPHLikZxAD4xjzTRUhHxTdo2m0IomZaq9c4rdthrilo
	 1NVKz3UOXSkUuNJXznHRHcXQBlllKNC3DbPMPsAfEiY+ej29J0SpI/DFgfe3nrmOqX
	 unQAjP0iwH5yorg8KMsj5oAhNjH/AA9H7jXi8OPmuhnA5zehYCAiPGbdbGvQbb/37y
	 Byd0vv9RPhVZw==
From: Bjorn Andersson <andersson@kernel.org>
To: Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	gopikrishna.garmidi@oss.qualcomm.com,
	jagadeesh.kona@oss.qualcomm.com,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Abel Vesa <abelvesa@kernel.org>,
	Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	nitin.rawat@oss.qualcomm.com,
	sibi.sankar@oss.qualcomm.com,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v5 0/3] Add UFS support for Glymur Qualcomm SoC
Date: Mon, 16 Nov 2026 19:04:54 -0600
Message-ID: <179487749333.432567.15654163830275784357.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
References: <20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com>
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
Content-Transfer-Encoding: 8bit


On Wed, 28 Oct 2026 17:54:45 +0530, Pradeep P V K wrote:
> This series adds the device tree support for the UFS PHY and UFS
> Host Controller, along with the required PHY driver updates to
> enable UFS support on the Glymur Qualcomm platform.

Applied, thanks!

[1/3] arm64: dts: qcom: glymur: Add UFS nodes
      commit: 6de5a900a65d8db587ee14ca9f2fb0b57ec094ed
[2/3] arm64: dts: qcom: glymur-qcb: Enable UFS
      commit: f05e50b7daec3b6ee914d4aed63e7fd145825f5c

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
