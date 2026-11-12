Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794479709;
	b=AycCJlCqV2R3YOiKvEuReR45v1nm0GS4xfTx1kpLUIN/RfDFjPB4lMctfR8vg3cSthYB
	 U9NVJy3+XihrIEA5C5uWWHHPXz08i9sTSJySJBjb9LG5/RK3XQxSyrRYgvKWa2VLZbAut
	 n3942Vczg7KDcuxgV/TmKJufBImR4jZgF69uMroebARFUa7H+kSpbQ4SVc9FGqSBak0Lm
	 LcIrf28qt8gnc7Qmu9l6ERjLKWcWUAiyQkJQeXpP/csALfRHixR8oVW3+76I3Pd4dBrI8
	 xL6603k1vQm8p2qng+SwGLJy95efl3XJv239lLxKpfeypUDOsfIAfgEfPmP+7udaRjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794479709;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ewwaBYICBsG0p5nqJ3R9zI8jsVipLJMbn+FUH/98X3E=;
	b=YU9FDhtADKqVt1Rc2tnazUJ3naDG11wycNGBq0IXEKmmB4HPYSGEudANEasZVie7hml+
	 KyndXR4k9u1OmxjE1VlGzm3n8TdP4qoYz1cWDOZHB/3jHTith98/Gtl/Au982l2/pVHsi
	 wXkOxUGTOYj0YRYbgB0dPrzIapV3Alu48Ybeorokdax96Q7ufLFDEFIOOj5eR6YpvSgn3
	 L3jxQLhbRqFSX7R/SXdPVwGL0wDlpk1Xi7RRgK3gwWnt4yO8oTINd0rg0gHS2U3EueKZJ
	 XijHXK/aHEJsdzK+fuzC4LCL3Q7kQLwAkdzkwEeQIAaLnKHlcJm41mTwN6Gr2pRaP7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M81I7Xtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D5A606A31C;
	Thu, 12 Nov 2026 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M81I7Xtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E931F00A05;
	Thu, 12 Nov 2026 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479709;
	bh=ewwaBYICBsG0p5nqJ3R9zI8jsVipLJMbn+FUH/98X3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M81I7Xtd+G62VdeOad2AYpHmpvh90fXkXDUA/IPoVb1XsJDgDoB0ozVipb/lPfr1i
	 pUFwO50HMHUUaAFRzevAnrozJa4PPBU3Vjf25QqjQ6/ZbZYymvLFA7IUNTNeKkSG/t
	 6VhVsqasM9zVxDetxcluapJgRKNTo2OoUKC672/685XEOqG8wrxwJ+KYCACdIaJH68
	 fuhomVaUay/J5kKXSuY6qbebKFG4tbV1pjHWjRCFZxcicC1rQ9Kmqs2XsTsYcrV6b5
	 aoJqjZEHsRBJ4Cmfph91xrEvX/Ox13+Dt7CRlljF+hyQgpEYGf3+HOpMj8Jpddpq5w
	 ZeJ1cZtbqCf4g==
Date: Thu, 12 Nov 2026 11:35:05 +0100
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
Subject: Re: [PATCH v4 3/3] arm64: dts: qcom: sm8150: use standalone ICE for
 UFS
Message-ID: <20261112-weightless-angelic-anaconda-60740b@quoll>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v4-3-0311eac35609@andrewgigena.dev>
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
In-Reply-To: <20261111-sm8150-ice-rfc-v4-3-0311eac35609@andrewgigena.dev>

On Wed, Nov 11, 2026 at 05:53:23PM +0000, Andrew Gigena wrote:
> Align SM8150 with the standalone ICE representation used on newer
> platforms instead of embedding ICE registers in the UFS node.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  arch/arm64/boot/dts/qcom/sm8150.dtsi | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

