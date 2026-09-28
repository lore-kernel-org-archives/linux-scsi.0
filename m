Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB56390985;
	Mon, 28 Sep 2026 19:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623788; cv=none; b=fHvCyjK3nVQb966Onfmi4SLNUD9hGEtjFWpqHEpgyBkvPY28zzKzwyamb/FrsJEqTFpvYBVBmf6nBZKlp4j1dqe7t2+/nRGN5U7JWKEsXgahSRzsm22gn22ean4vJF8A5iAtF/Iqu94/Yt03OJl3caC4ubDhwukDHTB4QBH8xAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623788; c=relaxed/simple;
	bh=mXyP7NxnRI427OIfXCH1zqW+0QfzR9F909esKWngdMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YemCT4FCUbyyfmR/4o6k2XNAW5chLprHHeHKyvNfhHoYKHkM3gdiVOHh3kwFk4UOGnrDzPUkvkjpAy1ZSsxZefE6+0vm08K2V5VFh2OMXQSAXmD0LBOscpX9EB2LcQh4IZtsjZ1KCNMDJ2NpJkowyi58g1Lh7LQj7OVpnI4CtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1uW/jpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1uW/jpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DC91F000FF;
	Mon, 28 Sep 2026 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623786;
	bh=n+jDmQgRat9NDDI5uzAJtEm9Oa6XAnXyFmH0bziUoq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R1uW/jpQm0e0YaSLYOyLLp95EnOdOMOA3CNMdDvWLS2uSD4mJuSEztKePuvir6X4e
	 uvTOHCrXhvimza9jJGWNQJX6RnrY9UrI440XKiRMVFsgHMb88JJYDfRYqAwSug15GG
	 h2nP3QE3tzEtx0FXc1Vm/yAtWSRZ87T+EFZVVYAN86BJHkDyAqLYXfpYbLdAlxDxLT
	 zBH+8gxXBK4kYC/adsdoCd1h7LtxlSnoIy3fpCzxsC7uVISaqN5r0kWH74jc1qRFQF
	 G/1dZco0a2xwFYiPcjuOqyK8TKckVxth0MDYCIp27hFE0eU+szoKb30vWakdThjuX7
	 ivrFxzmueSNIA==
Date: Mon, 28 Sep 2026 14:29:45 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, jagadeesh.kona@oss.qualcomm.com,
	gopikrishna.garmidi@oss.qualcomm.com, linux-scsi@vger.kernel.org,
	sibi.sankar@oss.qualcomm.com, Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	linux-phy@lists.infradead.org,
	Avri Altman <avri.altman@sandisk.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Vinod Koul <vkoul@kernel.org>, nitin.rawat@oss.qualcomm.com,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 Document Glymur QMP UFS PHY
Message-ID: <179062378451.401860.6157589865548275713.robh@kernel.org>
References: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
 <20260918-glymur_ufs_qcb_enablement-v2-1-16619f7e36a6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-glymur_ufs_qcb_enablement-v2-1-16619f7e36a6@oss.qualcomm.com>


On Fri, 18 Sep 2026 16:09:07 +0530, Pradeep P V K wrote:
> Document the QMP UFS PHY on Glymur SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

