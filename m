Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96BB4B4897;
	Wed,  7 Oct 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386706; cv=none; b=lT5zy+sMgglMFg2vGCGlCkk6WwiI+bmiAMWUo7u1Fd2lEVn4OfkjkuZS1wgEITrRbJ6ZbYBMbRo7XucB6IlFW+ByjXfn1gAckfusw6Duw2BQJ5RYLtd5gHokL8X7zESlYOEyqoszdKXsZuEjlGLXRBOtONVxvPpH96tdquYSyVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386706; c=relaxed/simple;
	bh=x5XnwiJBjJuut/uvusPsQzAPxb2u4hiaGmfomOi8i9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyOQ59mxRbdfnvIgzH/s7AKgJ5NscsMCyVJdPgGZ1M8sElZb5UAnbF1IJB73rc8UrCpQB4Z+W6b8GhNmrID+QkzkmeRn8o2meirLTFD3rIyNmclcsMCcp2/quDInBKeKIQpq88oDQ2SF8suwaAn71LlLWWfBIFJVxF7SCaLM4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqWmrQ4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqWmrQ4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E2B1F00893;
	Wed,  7 Oct 2026 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791386696;
	bh=GHllO92g1vA1pv14+lQkMeSzcxTrttTJ0MK9bMISjS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TqWmrQ4Dn5Vq6CnlziApxUMqEO4zhFe34TG5UeJsq7MI8o9V27RlofEEofV64fLZY
	 HwsjkMntw6uPPetd/SwL0ZWh9WE+OADo5+U24rmD7Zw9OpCVdphwWMjPNBfkx2JDEf
	 U96DNhnWlpIj1+xQeJe78nklJ4LN272jWO3xMynhdTzELkipBnJ9mERD4nBoWIk6bq
	 MLNfpBut0Zb5KvPZJMzjBMoT3zurUiDA86LYJzvDLUKancO0JSyYaJxtyU+v17x18j
	 v03bikJdwIn0siyZCSh6+DX7JWXdOT80G/NXCS53AxQ0V1Guopr0M8MYfqz/tMrV5A
	 QcqTmCzP3+Q+A==
Date: Wed, 7 Oct 2026 17:24:48 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>, Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com, 
	Taniya Das <taniya.das@oss.qualcomm.com>, "Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v3 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur UFS
 controller
Message-ID: <c2b6taguiyyeteizf5ohdsvmeyaybbs5pm5cuv5vqkklswmxv5@5ekurkmzdhjt>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-2-84cf4f861415@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-2-84cf4f861415@oss.qualcomm.com>

On Wed, Oct 07, 2026 at 11:59:35AM +0530, Pradeep P V K wrote:
> Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
> multi-queue command (MCQ) register range in addition to the standard
> one. So, both reg entries are required.
> 
> Acked-by: Martin K. Petersen <mkp@kernel.org>

This was a mistake. You clubbed both UFS controller and PHY patches in a single
series and the UFS maintainer ended up acking the patch assuming dependency
instead of merging the patch.

Please send the PHY and controller patches separately.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
