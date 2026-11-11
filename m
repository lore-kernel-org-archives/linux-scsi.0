Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794397848;
	b=UxGejGmE93yFS/9ITNOdeQwlWYK4+ma43ngFLu6UyNOSSf4HvL1p4h+BQt6W1Atkmi1y
	 ZtVNuvYWgIoYj3KTXimVaJbcjlHBckmO/06j+C06cRQMC2C97atJgGMGrb+VNbhMAs/vt
	 so+WnkaUANEp8LySAF3eqa0QMOBYGi5iECzJurR0PBMCIV9nxfyhwSsHdibTnbL4YfDvK
	 RjdIFVScYcy9z9AWq3TMMlfDkgehaovq4pENYPbfkh8TWrKC8VxH4PT1TlUwh0o+Y3TNP
	 iJbfV8CGehky7b5PbtZoKw3LStvl3jvM0UtZBrY15ta6Tvp8fMmqyxAy0pD0dO6vRuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794397848;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5O6uEkwqbq2fchp+ArnsCj3nowVYo7bwCNAKKZU//mM=;
	b=dVUXNMI9ZZaPSaOg4F60Yd6DEyQXfscBZ0rvsEoozyunUvqSvGZgUTwQ+L4PGunytIfU
	 Y6YkK5+RtsSs8wZV9mfRR4fJYrynWd76WqXexHXgQG2vo1A6BXQqw0E+KzSymx8GDDfDW
	 S0Sabm9b2BEYQ7Etj5Hm6+H5wbM6+gV1DE2TcV02dJupOafQSpcQmiy9R+LKebpqLEo5h
	 JuMORbYknqlUXEC/V1uFr1zYYizsdXDw5SW6X4zu90w/J15nhzEv6V/azNTeDx5HANw6L
	 mESGV99DYp04Cd1O2qAemm9AACzeeOcl+wA68QQcF8snmI2jHtQLIU4FHHIQ/EbwbOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UA0wSpox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E96606A330;
	Wed, 11 Nov 2026 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UA0wSpox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CC1F00A07;
	Wed, 11 Nov 2026 11:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794397847;
	bh=5O6uEkwqbq2fchp+ArnsCj3nowVYo7bwCNAKKZU//mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UA0wSpoxfq/dvcDQg24p5m5S4alowT3RFr4O6tm68vpQ4Yj7rXqC3hm4865svhD0R
	 xLHzAcoC3mCC1ObXBo4wJmnc+Q1SzG/jVZiI3/0dtPrZbKfw7HDpf0xshk/uq0sgXp
	 X34Jo0jJz9y6h9TF6lcRk0BHWijerMJHYdVNGn2Zg6maMWyO6Ram0sAnOtIQTg3h8y
	 XOap1jDwBlxhRll61ShkGe0TaEvscSGHWS/00cdrSXmYcX0DZUqn1HpHD2jXTerusd
	 zUJ8NSwvxJt8qZZDWq6uthszRnqDf9Wott8njcrSfEIUfXVsO+oLO+aNfEY05ZiVt1
	 ii4HvwQ47FD3A==
Date: Wed, 11 Nov 2026 12:50:44 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt-bindings: crypto: ice: document sm8150
 compatible
Message-ID: <20261111-blue-barnacle-of-awe-2d9a9d@quoll>
References: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v3-1-f9d5a806fc95@andrewgigena.dev>
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
In-Reply-To: <20261111-sm8150-ice-rfc-v3-1-f9d5a806fc95@andrewgigena.dev>

On Wed, Nov 11, 2026 at 04:17:49AM +0000, Andrew Gigena wrote:
> SM8150 uses a standalone ICE node, so its compatible must be listed.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

