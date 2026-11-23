Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435738;
	b=oD91+1yU7uY5FiYEVM/yoFofJxChfLPf+biOO2+ZFxcZ3MVAvAsRvv0ie5WXINGPvAEH
	 9ha6QPm79Jh6JtCJMRWANt9nbQfZDQhjkI3q+w1Y+EFJglclsh8/T9nChAFILhpKfU4Z5
	 bJfogqkC5aNtlLwpIo/d6KxDoYEVQFm+2F/E9jhXOJS8+3v85r3DRlSFtVs8pVyqdWLVp
	 F9aygx7y4FtFj6TvH1e3GVTIqfiU2gDXgEqQYudjEkEJfnwoAA4flr0V5ySZs0vjvYAjd
	 DfY+hj1FMIWDgaRRki0LNowgNqL6fhZdPV97166YvFBj3CsXL2+LoqL1dtT6Ky16gyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435738;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VRuIav6YHmvsMLh7gooEE44y2XxBVR4YlFmEfHcC8FI=;
	b=JwDdPKGn6uwIbnKRujucYgdZ5jzIxEveZGd+ZcHOlD54Zte3bEYwKBXiOFJq1PlVxzY7
	 jBKlE732nSw675OYoz7sMDdFOFRRd7aSIOGHi5QIF/WokRbBMZWvRXpArjw4c6ZF9jhb0
	 7WQoOB0cxj3FCWXussjhBvK4kVyvWvNa51kvy6FeGg+CPpjiJz1ab7GDc67rvI20LYm9i
	 QVWrDFbouhjIxe+QSKmWD+ALQKY3JdNaeT0KIxpBGL0LWfaK2/8JAEwKJjsbqNTeKtRzB
	 pmYVEVKNqqocIml8s9lZ0AvfcOT9aLs7PDZSjUw5Byiy2rgnc8QjF4IjgsjYkWDL0iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cu5iR40U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B4E606A334;
	Mon, 23 Nov 2026 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cu5iR40U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9EC1F000D0;
	Mon, 23 Nov 2026 12:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435738;
	bh=VRuIav6YHmvsMLh7gooEE44y2XxBVR4YlFmEfHcC8FI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cu5iR40UMCTAEJ2wd+p/QNZOSHA0mxj629+dI25oJd65SS6aiEUmMtuSP+EfqBpzw
	 P4bLrKFTX+y+WWgpS+CeXywKXfqZeHWEzvyA5bfU5ZnxkvF+yZwvF+G0+lnZi0a8c9
	 tIPT2c6albgAONuFapnuKdUFG9SEC6xbweoTze+swOQyd3lctsBOYmzEacZe9CdUMk
	 YHIg5fEmkMer30U7Cl+qQNqfsvmpbupBrp0Jfu+IqXUOfj8wp6ISR41AL2a27PuMQu
	 smXmYbXn9HrsGtjA/oFOXfqLbcRWx1prekSdgW57mJpiqDPNjsGwqlYVgE2by/qhRx
	 fRE4ldhhSfcJA==
Date: Mon, 23 Nov 2026 13:08:55 +0100
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
Subject: Re: [PATCH v2 10/16] dt-bindings: thermal: qcom-tsens: Document the
 Halliday Temperature Sensor
Message-ID: <20261123-calculating-auspicious-terrier-0bf9fa@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-10-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-10-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:26PM +0000, Stanislav Aleksandrov wrote:
> Document the Temperature Sensor (TSENS) on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

