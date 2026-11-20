Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168419;
	b=YJz1aZbO4lJHA4giU8AGj55pb2dUUxL4oX4dVEHhBckiXQatZzBkwvoMqcvRZBPhTj1N
	 CvKVHQ1XYh6peKI3ORWHhHvRfYRlKGVQclR8MuFY2ZwzCUZ2zm+7rqF5utZCTKXwsOgH8
	 TCE+eY1dMDvtJ+hAuVwqvDRevcRUvxBzWhCimqAyxboEs3FtSWhLMZ3h6a85Jzzit1KJR
	 foaNVGP/nFeORWd6Joqucq4dQGdZVDcq1JEMpSZosvmFN7ItjuOgvqIR92AKLjakobWKb
	 E0+JsNOIlQenE7TnOMEBWE7jzN6ZYR8vqZVUL9tDn+WfM3K5P9D6qM0/I6GUYpE4LxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168419;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2byWnC76isCs4cT22MWKTLO0lb0D1/ZneG1MUnYIDh4=;
	b=sSgALl5TvM7BqR5ej55ggnHCbymVqN/l9XiVF7CxRfTXX5fhK+PiFUDGaocuVmJ3Uv1i
	 TJEwFyP7e6bdupQvlc4a6xYdyKGdlXUfAru0Bc30QshxVufPF6+gKq32RVO77um1eI2Et
	 nDWhgpvOgL8SZXzelpJqIeuhMchDvtHkDH993Ufl4fgbi6h2gp0+mNHVogiA9UbSAEQXK
	 R1kAcVabbmcoSgfw4U+5a9GjUVCIYdSk7rPmombiX1SB7UXMyCnIkUwok9oBGV5vBATzK
	 igeXmR8dIKfLvYLKdfuLVCpyR3ublTxQjWBACaCgW/cnr8NKrYq0MdiITBKwyupmdOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=E+OjnCrP;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A64260A2600;
	Fri, 20 Nov 2026 09:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A64260A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=E+OjnCrP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2byWnC76isCs4cT22MWKTLO0lb0D1/ZneG1MUnYIDh4=; 
	b=E+OjnCrPuiP7LU7YdQ9NxWOY8UKFqA6JOACVMMopCa+2wpFYvzGp8sT9K3wby5u+fPSOCQjvE8J
	Yy4KVME5SM06915STXG0ty/BYC7wSToTNZ1eHHYKCGoiNxb/tOIASeVNCI2ytTaF8YS87iWJVXZ2/
	yaR0B8S8Rljhr7CggKy7jidW2otfKjgBc+aD+oYJv5pO6tPm9MbMknjazvjulwq+IwzqiicP8lSqW
	82XWePLdTuYRApr5H6gWWq7fjOvPjxZlD+QC8yxUhHhEHT4a6RiLiE3jSYnSRysBo9nj/Byz7fa9w
	1XUUpLjCtUJ2JqEvg9OccUJyCSqCOS50ekOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULJA-0000000HYfs-3Cwt;
	Fri, 20 Nov 2026 17:53:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:53:28 +0800
Date: Fri, 20 Nov 2026 17:53:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mail@andrewgigena.dev
Cc: Abel Vesa <abelvesa@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: crypto: ice: document sm8150
 compatible
Message-ID: <awAYmFxtWpAaFhhC@gondor.apana.org.au>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
 <20261111-sm8150-ice-rfc-v4-1-0311eac35609@andrewgigena.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-sm8150-ice-rfc-v4-1-0311eac35609@andrewgigena.dev>

On Wed, Nov 11, 2026 at 05:53:21PM +0000, Andrew Gigena via B4 Relay wrote:
> From: Andrew Gigena <mail@andrewgigena.dev>
> 
> SM8150 uses a standalone ICE node, so its compatible must be listed.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
