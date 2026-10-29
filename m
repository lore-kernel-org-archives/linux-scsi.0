Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239399;
	b=w5ldjQbWnF2WfaAwvO75GYGkrI5TNQ2sXTdxEpHD48ALiYADsjow0+UBcJj7WSmJq7oW
	 s7sXMmYOtC6KSAK4HTNdwYByYr6moDfuJ679aHYxGnYXDW2JomeF1Dsjilodakb6jFqHf
	 ZHpusJxnD2Qgcn851y8Hm8JE/B8IQ3JlFqGXz97V51kNHWhq/m2uUP7C0UqyCyHjifUTn
	 yNKD/sb+6jZ6Hr8DStwRBmvrJQxY2pXLMXM1XIR8ZciUCuKWTqRyYddrYBcYcK+U5p5eF
	 E/8C8pwptGpvFAoU5STclKcNSp70UoiBL0kntZ/th7lJc1UFQsM4e9bMW2t/T29s7lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nloenklXV41sAe2Qb7vhaRtqVy0cuZ6og1wsgUkifo8=;
	b=F1jahqplbNwZV1PRC+SxOdfrSWq1PwEH8lEFhPAQsgijEOdyuzWalcDv2Qai4hXKvTzk
	 OL4A8Bi/GHhqTz4g8qfp3cvsrjMjd9FEYwXspgasgsNRTSXSbxmw0Eh1z6Iuk3uC4faVh
	 o4clxYjYnzuXXxp9ErAdymqDOxDQahFxYU5t2xUNPCUYN8eMAX9ndiMWLH8jfPXgd7Bfa
	 QJbqmJ4oTRrgBcoKYeiGUZ59vyJgTeLLIqLV7qTKHXeZqKCgeVLl5vzvbLqPYSD2vvicX
	 kiqw2OaII+XBeG68r9bRwV8stFyly9SdrY07DocE46QE5uIiVLc1OHHZQ80qU25vzEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m83POaf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF9606A333;
	Thu, 29 Oct 2026 02:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m83POaf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9831F031E1;
	Thu, 29 Oct 2026 02:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239398;
	bh=nloenklXV41sAe2Qb7vhaRtqVy0cuZ6og1wsgUkifo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m83POaf7re5Zyzk+EeIRf6CNfBQGKJpLVAoF8xJIHQN9JDiW0D9fjZU7YBAW72NsV
	 Mf15bPfZsiqJdZ84gE+LdFaY/GAN0O967KVIUJTbKdFtnXOx9U+N35dOVOVO99mtcB
	 ILIi2uLSepVaDzr8r+svuNto9o5Wt5fzD3R2cKlcpbDdkUYpEeJADrJK6PvRSgGd+t
	 F8O2Z0PFzxY3tyNA4CfX+ZWGm8qGLgfmFhP0fqJD3kASmqisQn1gxum/pNhDjkc5e7
	 0oInenXHvpordn0mMjbKhL6GgoiLFBL6R6UNOxdU3DZ7rBkpdI7dudrL7uNFxUxD5d
	 c3aUxStiHTn5Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	gopikrishna.garmidi@oss.qualcomm.com,
	jagadeesh.kona@oss.qualcomm.com,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Abel Vesa <abelvesa@kernel.org>,
	Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	nitin.rawat@oss.qualcomm.com,
	sibi.sankar@oss.qualcomm.com,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v4 0/5] Add UFS support for Glymur Qualcomm SoC
Date: Wed, 28 Oct 2026 22:02:53 -0400
Message-ID: <179323465371.491807.4239694363801616676.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
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

On Fri, 09 Oct 2026 16:05:52 +0530, Pradeep P V K wrote:

> This series adds the DT bindings, device tree support for the UFS PHY
> and UFS Host Controller, along with the required PHY driver updates to
> enable UFS support on the Glymur Qualcomm platform.

Applied to 7.4/scsi-queue, thanks!

[1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document Glymur QMP UFS PHY
      https://git.kernel.org/mkp/scsi/c/e6c68aac2f7a
[2/5] scsi: ufs: qcom: dt-bindings: Document Glymur UFS controller
      https://git.kernel.org/mkp/scsi/c/7cd44f40fe19

-- 
Martin K. Petersen
