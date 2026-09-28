Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B953D9535;
	Mon, 28 Sep 2026 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623845; cv=none; b=V0c1M6f7IbWZT/4HiQdXO6GkkhAGsECpiVstmAFZ+/lFL+RAyJHf6sAYX1W4ncdJBC5h8VSoTswiM/26IKq9Q0xWlzygc/YuTr85zfIGYJAL1qwTnIxN4IyJUF8+PZjtDuNpIiqe/ABuDto/4DzVKmunMB+mtZ/R+H2gEQWlrVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623845; c=relaxed/simple;
	bh=a5Uq0dt2ZNlHp0o1YciKbI5+uacDl4pEJqxhhzE5DPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxqUiRw+MQwjZPlrJD7d2k8SuinYpbMgCPviP3nZsb/GfezaZvp/TFg8ffIf5N3etZV3IomK3cQJxdkdK3fU2wQOJ7R0HJNvvU4Tug7fpoy3nUv+K0Sl+tE4zmBPu0PUt0DdyAFFUupsEhtNR9dHNJ4TEm0p5q5MTGxLfkdc+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4byGoJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4byGoJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5451D1F000FF;
	Mon, 28 Sep 2026 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623844;
	bh=kbsKQrsCbe+ud+MT/y3GQQRG2PEPjbBeZzhKMXzRQr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V4byGoJQ8LdQDjF6zB9FXT423NjL7dhDTPfrbb5RHZZLp0kcpL0CvtGY+NIVUaN51
	 zbC4i7hu2fr2rq1PWjIWibfx1VOvg5QWJzLQQ/qxSY1aNBUJ/XwYZfsQZCZ+HzAqTG
	 Zody2woW8dADOgEZia5YRTuH1u9sQ8eloGTOj4k4QoGRGcXLw7UyV2EdP+d8FmHk1p
	 CkiWTJEGOa4rTQqSm5hGUEpZBZkS1nCTqLLLPXJRpvjii09G0mnUTTMEdf7WHuTA8N
	 KP0bUqu+k7lUAmoZONPmxEZGTF7ez8c334TdqKUXn7OY/9UcnkxDtsXFXILf8B5+A1
	 NAY3LcPd5tW6Q==
Date: Mon, 28 Sep 2026 14:30:42 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>,
	sibi.sankar@oss.qualcomm.com, devicetree@vger.kernel.org,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	linux-phy@lists.infradead.org,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	nitin.rawat@oss.qualcomm.com,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	gopikrishna.garmidi@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, Avri Altman <avri.altman@sandisk.com>,
	jagadeesh.kona@oss.qualcomm.com, linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v2 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur UFS
 controller
Message-ID: <179062384199.404752.1741796801810335971.robh@kernel.org>
References: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
 <20260918-glymur_ufs_qcb_enablement-v2-2-16619f7e36a6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-glymur_ufs_qcb_enablement-v2-2-16619f7e36a6@oss.qualcomm.com>


On Fri, 18 Sep 2026 16:09:08 +0530, Pradeep P V K wrote:
> Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
> multi-queue command (MCQ) register range in addition to the standard
> one. So, both reg entries are required.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

