Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795613356;
	b=DVqoESbLnr+yBRKPk1RBN7C/QUK48mwMPJCsMo5CXro/nZkwVgou7viR7dGAyqkOVabU
	 QmbPjMvzKf7lx7jMxkZQuT06zA9tOpHbmTgbOwCQ7xZ2twU1qxVyQIWvnNWJTanr3Rj5p
	 RXjV/BH//hLMHCF3ZPM888DjWsZeNpIrEBI+q2U4DQkzVvCYuJ7OzwzhnELtTUgeoNm2n
	 YduvbBgAYVQAjijNzTO+xiGfxiYf8eSoXujgfGO71JOW5rz9ydLcNIMIULKpEtZuJ0nao
	 0NzUUXbxOo2fT2R4JqDnhfowny40B5rH9ZycXYzxEzzVr7oNv3o9yXSVKb1acFWZJuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795613356;
	h=Received:DKIM-Signature:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer;
	bh=OxIr+TwEl0zxxwb0G7Ei7ghukL2hV6bVQxTMRyMQ1YU=;
	b=mtCmzTKikYty/gDtGp4LB8ZyN7FeDZ8C5wEEDKzbjDea4YrPdW610poIT/Au8M7bJ67E
	 O7mRzeBL/oVxxkRmFnvwupF0qcwLMgZ7/Zpqtx0YBA5sTcLWlWJEpdrg3YTVGAsCcO88y
	 pEc4LtqEzaw69UUaNDO9NlUjd+ULQsgTYEVQh2pYyMrCC/2EwbwQZhv7YvZznKfR3WqSe
	 /by+LO8OuwISvqSwd2qxRpsmq7f2sBeMo75siIY7ZKGBpLDJJAr4vqyqHUl4QJG8EnHyq
	 MWmrCd7+HNXF+u96N9tzdz0KdmIE5fXIWKQHOuImQurG7Up8kULjXVkoV/hK5ncAhhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RpJRSiUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4D7606A31E;
	Wed, 25 Nov 2026 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RpJRSiUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A06F1F000E1;
	Wed, 25 Nov 2026 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613356;
	bh=OxIr+TwEl0zxxwb0G7Ei7ghukL2hV6bVQxTMRyMQ1YU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RpJRSiUzay3ataummkoOho62pyGv83533zrfuDijUhYtiCU/HDfnC96AwLf7F0GEl
	 Ps/4ykkBgxNKT20KTG2qToVXAzKWb+wiKeJKrjdnPe1lOiPpD3E7GFsRvz5xTaXpw1
	 9BjVvH7Y39wkdK/8M8oO0PpnZsg61FhDdiw9sS9g3oA7wo5p1vIh+51/vXn6GsKs2h
	 jKkLGL5b9/72wQ99DQy3XzxnBfid67eb6lInMX7tmbClT7Jyl/Qg3Q2WUM4xicyfA8
	 1pBRPKx4fsgsQX/yRG23I/DwbKqwFHjBbNVixFKAlt5QlH1Lo0LcNOfEylI3Lq/MCf
	 ArvAl6ZlD+qwg==
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
Subject: Re: [PATCH v3 12/14] soc: qcom: socinfo: Add SXR2250P SoC ID
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, 
 linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20261125-halliday-dts-v3-12-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
 <20261125-halliday-dts-v3-12-5c8311c0b70b@gmail.com>
Date: Wed, 25 Nov 2026 14:29:12 +0100
Message-Id: <179561335286.84329.3989958542179455142.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-25 03:43 +0000, Stanislav Aleksandrov wrote:
> Add the SoC ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2).
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  drivers/soc/qcom/socinfo.c       | 1 +
>  include/linux/soc/qcom/socinfo.h | 1 +
>  2 files changed, 2 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

-- 
Krzysztof Kozlowski <krzk@kernel.org>
