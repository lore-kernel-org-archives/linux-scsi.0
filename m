Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435639;
	b=KVdCnOHM6OYw2bvNwxHkLT0ud0BVz+XhV1LILafiPVGy/UA+mhJXcEVzdKus64jPeN8t
	 4I/7g4bJwBm7M1j841dUJTKozoA4bTRidIUzN5UD1Eb6I4mm7F2Eo4XN9+YR+6aXbvDR6
	 imnSCxrF2FJ0auYRLMBMGrXTa+9HM1mJgrhJE4hlsitdsBesSBhBm965uxJi8XAibLJeW
	 9bWaGKrFLpiFG0aPSn5FWyH1aeXf7O3wFwt6azQwSQUL7D2zuGKfJGmLxuZT9A1Tepwlf
	 maFwS9hFWjxR8gZZwZf8g+S/WFG/gb7Ueja2Xk6/ByV7cFEw2xV4omzXBmNaHAXMJEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435639;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9J9fJaDjY0Dts4Gsqz0quMcF3tDemSYv7SGUwNXF9Fc=;
	b=KDcpJyjhJ7wjZZWLHuvIP7j//Uj3cuL8e4BN4EHBg2kDFWcoywAqOYeMrqVyLBPXbGMt
	 QNdIBRs3NqfrcxmL7bKnoJKD6l5ig/l2L7SC1395l2b3fwLjO15OLZQcxPKeHb7DNcWME
	 9sS3IBA1qwUnljLlcdtGzKrv4g6Qr87zfHNNDcWOfoZQMfXI164Nr9fcudLqtnuV4/UMH
	 UB84YuXTnBvd28bDO855GWqpLXNvhv7SflN8xnwqvPZblKK93UQyOOelf2+OTc3Wvdgt1
	 kYVNakfpVIV1t0FVqnVSHEuKI4ktLVOE4PzP+5yJJ1AZB2F9DVJmoOCxb6QrS+CKzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a76zrBzx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E48606A31A;
	Mon, 23 Nov 2026 12:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a76zrBzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EF81F000C4;
	Mon, 23 Nov 2026 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435638;
	bh=9J9fJaDjY0Dts4Gsqz0quMcF3tDemSYv7SGUwNXF9Fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a76zrBzxzVcVrcVb6wqriWop3Tks1ZkXJEWtW97ujks72eIwypE0kA8khu3rIUQUm
	 SBXpVyG3dQKRUXSpOVjQ0W5LzdM/kXVLAeqHg8yOvX7Z6M3JbUTRPdypva+/0Iwwwn
	 ek3ZfLn4Oj3of+oTswT0+9gnynzmjzMeZvNy7E7PAv+iv3mJdZGsZna1YULbhhKA40
	 54LlYlecfXdOkq0U9pBXD+litSzI9wpA6eoHF3Mkqii7I3/KjbCz/l0AxN+CYAT3wH
	 1Ja9p4SrK5Utb9EgOW8JfOyCC7XpyGDjizRpeXMHN08Rr5LXARmAN9yi8g9L5LEqbY
	 jBc0ohLZIF6YA==
Date: Mon, 23 Nov 2026 13:07:15 +0100
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
Subject: Re: [PATCH v2 07/16] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 Add Halliday
Message-ID: <20261123-thistle-gaur-of-sufficiency-7ced66@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-7-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-7-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:23PM +0000, Stanislav Aleksandrov wrote:
> Document the QMP UFS PHY on the Qualcomm Halliday SoC, which is
> compatible with the SM8450 one.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

