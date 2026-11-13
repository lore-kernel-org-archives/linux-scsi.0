Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565745;
	b=uPLMH9/E9h/umB/D8ty/8GTslYkW/7sXQc/nf46Y4+yp3TcBjoc9k1IfpYYqNB/Kvnhe
	 R1tYXPbA1CWR8Ua4F8QbHfM8EBNEdO1xl8qfxaQ4E8TzsUEjG+JjFJ8iShf7zGcBbpinX
	 PiOly6kVEbeIc7/dYLo1qjCVKLqcUkqHkOBOZAl6fGizbLpo/8Ntz6Q8bgwietQKHbaSO
	 t3mMIbM3Ez8t4zijVye75VVrJFIS3HUZ4+eRA3sou1rx61GCa4QgUKl6c10SQeroAXCpL
	 aZAfeyhZPO2TW4pwcjYyflEfHOPMkJveWAIsQT9Owx1rCQq7qDh4oDpOCkvpI6Q1vBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565745;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2VlHcIVlZZPb1dKLE+NitYN2zgg0+WkasLdpA/Aa5UY=;
	b=VuEIx0jHphOzh1ABt3Rk9daiCXXHv+C2oyXW6CQFosL4WJPd4tqDmpuVyQEPeQ6cO980
	 zMbSNE0eHDeVZiibVgv/wwhWY99uqt3ZS3IPkV1b060sAoGlViI1dI3/i6Q7uW4qPVP3W
	 KSD007xfqaIx3KUo1yKNzDcfws4nFee04+K4NEDyoVFPoBAw0JQrwT1oYwC7Y/AEJ8Tad
	 i6ffO5fKcAbyyY8j3ZrSTPCB05YKKJbsSiGpfdWmtHSXcRq5ZURbDOmAaNesDkKC+bbZY
	 7xVE9wbSCxHiwhMDn+qyK2U0u9xEUsh3Ctr9V0Dc3PV6wvStSY0B/u5U4YEq+LVjGhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZNsxKEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9C3606A327;
	Fri, 13 Nov 2026 10:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZNsxKEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EDD1F000C5;
	Fri, 13 Nov 2026 10:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565744;
	bh=2VlHcIVlZZPb1dKLE+NitYN2zgg0+WkasLdpA/Aa5UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MZNsxKEmYGHH+Fxv7YUDO4n6WwledjMk8ShFPN5VTLJqx+QwIYK6OteOVT9MtMRyt
	 HZqF72CO5iXpA9DOPsk43UWfkh2QsLDZWKf3UJGiGy763ZsYzpCiaiD99u6d2Wgbar
	 e3Oxq8D6Ax3eKHviF4mad34+RMQ7+tlF8Jr6nxCVgg81KygZUoWBgULspW/SwrpoLT
	 ih2Bst8gCZYky7kjv0+ZwvadHeP9B2jpwG5eYs8/pLqsSo9S64mN9qcGzNhSQ+tbP0
	 IKnZn+o6FxsxjiQhlJYP2etWWglBjSh4aAzfLtimKwwpoiA09++0WIyPkQZNc1YxHP
	 pSpBNcSQ18JrA==
Date: Fri, 13 Nov 2026 11:29:00 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Robert Marko <robimarko@gmail.com>, Guru Das Srinagesh <linux@gurudas.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mfd@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 06/17] dt-bindings: arm-smmu: Add Halliday SMMU
Message-ID: <20261113-inquisitive-spiffy-chimpanzee-d25ec3@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-6-289114ab8197@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261109-halliday-dts-v1-6-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:18AM +0000, Stanislav Aleksandrov wrote:
> Document the SMMU-500 on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

