Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794398131;
	b=DfQlpyEEwTAcAVx0UeMc2PAXxk2ersEaHr5iscZqueYBYkFaNFXEdnc3Mf/NS2WQrz+J
	 LpC+rQ0gYA+AX8NYpZlc+Edwax1Bz/KlndmJlOZ4JwDM68ToAVN86AIf3fRxLsXVUZ8to
	 BQh3HGD2lZ7VUauLnCt6XE2JBfPPakOGB0xLxAwYcIq+epiSwOgnoTZjdA2SL6w7tyy9p
	 wNZXuzv2c27tPm0Laytg3oxoNRtQQlQy95x80awDGZGjf4+PZLK0cleXbC3v9jcogCABu
	 RzBkh7z/HALky6jP48G8SeJLl+kRpPwRlejb9cd8vxUIV5rjv773g3bYj/U4LK0nmEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794398131;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PGvsu9/JZQ+N/QI6/3pmeeJRuhLul8XtmywqRM3J3ew=;
	b=b07+nzpzfoEmQ09WJqyYYjENASAqlVNYqXfs4dMYTlQUkV6TADtRNb7K/mcdAZqPBkmx
	 78OiEtPtt9ngPtXaotORXmK7c1r+aKrt9XK3TjiPS7dXtlQVJak3lv5eFdqk/iZt6yiVU
	 nBOuCq8ZWGZSnjmNNWigB7Ff8WodTsei+cig/Olj8nrfOB7wCQsVuVc0J2H3oXVQnugZf
	 Y2+3c5J5CMAjF3L6kJBsm80+veP7W70aXtApbtSmpfsjny1B6le9F6zdCryqwnqBOj2td
	 odpnJVUIHpbnxTfkbtoQedGrXigkZkPjWfAxvZJeZdKGO+/JXniV/EGZMNOywYQReIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClQVkByF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9406606A31C;
	Wed, 11 Nov 2026 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClQVkByF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671581F00A05;
	Wed, 11 Nov 2026 11:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794398131;
	bh=PGvsu9/JZQ+N/QI6/3pmeeJRuhLul8XtmywqRM3J3ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClQVkByFnAQxI3or7r/1Y1iRok8udc9O8ftg6U6iSV7IiA4SNGG5pF7v7RWDt3YBT
	 yH8w3XspXdBTHltg3x3yt5qRf8cJSo83a60FFQ/EXOfUggwoYw6/HBXEZpIiUzCLoH
	 E9MFZe0PTyLsKQMKaPkK7PacASg6ah5lSrc84ba0Hh3kq0fuVo0hdCp4RKSnOA0Lga
	 Rf7GDQ8TMQCw9tOsBL2R8tbsbSJC18qQKr002cuYty843vd8AMxp+WUzIFMFqKiPp3
	 Tpd/0cCB7so+2QP0oD1tAflANGGoOZWSO4Jgq71EAP+WjtX05koa7cC5BXvtEZSucu
	 0MlQ4SRKE/X9A==
Date: Wed, 11 Nov 2026 12:55:27 +0100
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
Subject: Re: [PATCH v3 2/3] dt-bindings: ufs: qcom: classify sm8150-ufshc as
 standalone ICE
Message-ID: <20261111-capable-violet-degu-e764f8@quoll>
References: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v3-2-f9d5a806fc95@andrewgigena.dev>
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
In-Reply-To: <20261111-sm8150-ice-rfc-v3-2-f9d5a806fc95@andrewgigena.dev>

On Wed, Nov 11, 2026 at 04:17:50AM +0000, Andrew Gigena wrote:
> SM8150 UFS uses a standalone ICE node, so its compatible belongs to the
> standalone-ICE binding rather than the embedded-ICE one.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |  2 ++
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml          | 11 ++++-------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 

This introduces new dtbs_check warning, which is fine but should be
explained that it has no practical impact.

Best regards,
Krzysztof

