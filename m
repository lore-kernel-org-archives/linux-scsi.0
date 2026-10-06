Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A962AE76;
	Tue,  6 Oct 2026 02:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791253005; cv=none; b=XULsw9eRxytqZ/8Az+8CfOBmBLFPsoeFhqcBbwxvG2YB9Cc4y8QDlQd6AE22BOFJHm+YzBj7Z4TNDb1giU5le7N74ss8qNk7ljwcSqyVEEb6J+/IoPKOEutWxN6Bm1U3JDK9oSPlxhEh4+Qu67yZbwtQpBbD8cWm+dJJN6EUe5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791253005; c=relaxed/simple;
	bh=jSYE88wLn66iR5hFP9HJQ+rfaTS2/NYX8H7us8pkt5U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=QPQhdEr4YUO230QPNr7Lwz+NIeS84qL/QMLt+Pq6s0wlkug3B7OTNn3n0X1HYpCV7OOQplE6/YLSp7DWt3hwrNrPfMsu2yCGqkUGDrSt+CxIEinEpXOl5MJ7Prz43tMMK46AS1YIgV4icvxEU92C0XXlq7zjgzULO7Z/HU1Snfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1rwPqJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1rwPqJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144631F000FF;
	Tue,  6 Oct 2026 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791253004;
	bh=y9NDiOhAYDgjP3iEQSHrcfPuJD6ND8q3oVJJO/o+fHo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=n1rwPqJj9m1VZT6XQmeuFyRnuHa2mAYnSdvUtXXOdXxeNHqfB+vUolI1o0JWhjlrb
	 1uyF6sqYRlYErLUdgGrosrq769XIZk7kxRqB++IATxIPfp96icJEpv8Utb6t2GjLWA
	 1gYMrcA0yPvzMVNhSRRG2inHOPw0z2ELGDheYetAbKxnFGAuIyUBYr76v3OFw1ZZyh
	 e+suSzZDcuI+goKBgzh5Sq4R7+Qr+NwXADM09blRYiD4kfNFF0f3q9zJkJH9ibM3cZ
	 mv7PLV2+PTpaKc+IfpYakJOooyGrg+9YV93loM87IzaiuKtgtL09wdMYbLhT3M/WMA
	 R9fah0DKO31iQ==
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>,  Neil Armstrong
 <neil.armstrong@linaro.org>,  Manivannan Sadhasivam <mani@kernel.org>,
  Rob Herring <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,
  Conor Dooley <conor+dt@kernel.org>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Avri Altman <avri.altman@sandisk.com>,  Bart
 Van Assche <bvanassche@acm.org>,  Bjorn Andersson <andersson@kernel.org>,
  Konrad Dybcio <konradybcio@kernel.org>,  Dmitry Baryshkov
 <dmitry.baryshkov@oss.qualcomm.com>,
  gopikrishna.garmidi@oss.qualcomm.com,  jagadeesh.kona@oss.qualcomm.com,
  Abel Vesa <abel.vesa@oss.qualcomm.com>,  linux-arm-msm@vger.kernel.org,
  linux-phy@lists.infradead.org,  devicetree@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-scsi@vger.kernel.org,
  nitin.rawat@oss.qualcomm.com,  sibi.sankar@oss.qualcomm.com,  Taniya Das
 <taniya.das@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur
 UFS controller
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260918-glymur_ufs_qcb_enablement-v2-2-16619f7e36a6@oss.qualcomm.com>
Message-ID: <yq1y0cbinf1.fsf@mail.kernel.org>
References: <20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com>
	<20260918-glymur_ufs_qcb_enablement-v2-2-16619f7e36a6@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 22:16:43 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Pradeep,

> Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
> multi-queue command (MCQ) register range in addition to the standard
> one. So, both reg entries are required.

Acked-by: Martin K. Petersen <mkp@kernel.org>

-- 
Martin K. Petersen
