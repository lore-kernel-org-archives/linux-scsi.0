Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565125;
	b=sZAAa+yeGvKMotwaBCmdty6wFzmj/fsSH7DJzK6m+F28Bh5FH+QlbdVi+grJ3mh71c7i
	 8VNrF+9ZUf68oaKkSEYC/tz9xVZgtSo86uHo8G274GyWr/dMPjytkFa1/KycQn03s9IQM
	 CeLvlHsy+5ToN74RTpfvTuamYejXC0rJ83HNDJ0Oe+hT3GePHj4sfnq8n8Auh0YnCmMxd
	 R2+6jHC4aOfdOLMub8YJSzqvmmqWeLW3Srn8PnI7Em4d3R7y6h14BSG82xLP7z55dp4QB
	 OgCvO78VotSKSgVkQDgekO4k7kFMhZteONOErYUHVzzOlyhGpSbASNvdRSAJ9yVkicQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565125;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XTQp8SKrmmjGdaoj3cLoQpYxyDLtluff/URZttFHqVM=;
	b=YH65eDMXtqStgDZ+oDywfAn2Fk89PYVPJdeXPhRME083BvYFwEFwRg+3WpltkgtKNnEX
	 Nz7Okh/ZdIVsVm968ymHHnuiimYBvdw04RhWrqywNoaQNG6dXaj1zb6cbnRLkC9kMgV5V
	 10+IRdZcHs2c76n3Nh70BYLzDduTECxU4XUZYGtKuWiczSK82Bu2GdrZHUxQVah7wRI0V
	 u7HXLVgARbJNHt12W4TF8/yaREiIIj9gFEXbxHN8UrItLCOsk5ydfEXD3+l9GHKyMHF/C
	 5auF3rlVIWG+NlK0AegDtbZ8a4o9b3zou/cCEqhvcNUP8unMj2NNCvAMMiHVY0HXBQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLe85MkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBAC606A323;
	Fri, 13 Nov 2026 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLe85MkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB741F000C4;
	Fri, 13 Nov 2026 10:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565125;
	bh=XTQp8SKrmmjGdaoj3cLoQpYxyDLtluff/URZttFHqVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iLe85MkDwoT4kspMx2Xssew/DsC5s1mT3SeGP5/ZXBUTBs9e8mrQT2op29NIWNVT0
	 sTmqKZeiq+pYwGCwkQJIqVUmVIkhUHRJwXoTXU+ShAQ8UybboJW4PPkxBtkZRzVYPP
	 6dJ87JrYw5MC9q6qk63RPSXXrreyR6zFCC3bpLFZrUI9//O1kZeMcj9XhaUEVEhaek
	 9ZECLY9buqOwwVW4j58jUXyuImWDrrVyamx91aqdw+vweHvzVf7Dt6GgKxd/xLDWOx
	 XH4mH76ngEt7jxj2G5IZdXXdk4l08sJvCK0p1OQBdDB3DA+6FMEjIuS6QhYyBS1bKH
	 j0DKveJvrz0uA==
Date: Fri, 13 Nov 2026 11:18:42 +0100
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
Subject: Re: [PATCH 03/17] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
Message-ID: <20261113-accomplished-impressive-pillbug-c0811f@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-3-289114ab8197@gmail.com>
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
In-Reply-To: <20261109-halliday-dts-v1-3-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:15AM +0000, Stanislav Aleksandrov wrote:
> Document the Power Domain Controller on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

