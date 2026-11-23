Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435725;
	b=YVy8hpFwqFduOL5K+odycGkElA2yoZBgnNZk3jkzykAPTquhc2jzDA+x6RHVPyG8ED7Y
	 RdhrhmePmO5RLEzb/UYHupGwXfkJD3089kHGOaXXzrq1KQ3P2QtvjApnzRwG+ewiiQkti
	 gG0Opo68yPlW/ZkEi7qkuIl6FBHdgO/DZrX+kfYdefXlbmgEZ1blSqH04NLY+i81/R4bv
	 w40jcVLaazEe1W+fyNDE7Wvqpd3leK/5azjJ8BvUnw25QI085Yc23Q4u6oiBudwJa8Srt
	 ZtFzy09qBQM86NPi+EFNih67MWOPYB+tF0PlSSEhOIAikvJlBGpUNdmzkx7t7TUMJdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435725;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QoJ4Xq4bbotqRlRBmRGFkZqtRmHf0IUlXgXbSKcoZCM=;
	b=Ta4TaQlNXif4YzP2V6Jqyjh6xrpVinmXemdvk2fJ5ajpBY7lEtBaaVvCHvJXwQwtFRvo
	 V+7aGxc1EqhKY7AoaHmsUH5QKzA3eR/8E8T5Ckvy7QhG1C5hjmv/iqY3yIVQ37d4AaNAy
	 goVmGM3KyYY9cHhBOt0vlW2p2N4SYPz7LQPsBhyvFxFzUe7etmXUtWn6RezxCqOzqIyaD
	 dtDvo2VFewyjCdHa5EipHzcfEwRwLY6HMG5qR+FBCo3RmEE0V/VjIIW2Uod88M9S0EbTZ
	 NYoY4Iv+iufhssJ0/Z4DLWO6ONHJnBRN9VsaYAHTJ1cqzHuB9FZn31LV54gOxs26/eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI4h0EX2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68E606A31E;
	Mon, 23 Nov 2026 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VI4h0EX2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A3F1F000D1;
	Mon, 23 Nov 2026 12:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435724;
	bh=QoJ4Xq4bbotqRlRBmRGFkZqtRmHf0IUlXgXbSKcoZCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VI4h0EX2zMESKfxT5HyyD4XZpBvRl71BIfZClZvArXxLh6RBZ2If41FHtgIANdRbU
	 ro7LbpU+VuRcZHHGcmOlLVdrtjgP7H4n7n2gVeLAxzt7nMZpGZTe0ADOXEbzEBwGd8
	 aXqGvvIq9t2SxKBQg+Bp+PovANJOr/Cc0JJxzMZK/ksWt74tecdThRI4OxbNE//BE+
	 MoSm1tyP/FT6C7AGrENVymLAK36lp96zTh50ZFsUKlSKvB2+GqZS500kXSAfX88Tkd
	 upDx+rbkC9Yf/H3+WQdB+nc2hQ4s6n2yh7o6ml+Kb3JNUDz1Vt+k16S9yx3lyw6lXN
	 oSJvkTsmgDM1A==
Date: Mon, 23 Nov 2026 13:08:40 +0100
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
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 08/16] dt-bindings: ufs: qcom,sc7180-ufshc: Add
 Halliday UFS
Message-ID: <20261123-cryptic-skunk-from-neptune-0a3f1a@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-8-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-8-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:24PM +0000, Stanislav Aleksandrov wrote:
> Document the UFS host controller on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

