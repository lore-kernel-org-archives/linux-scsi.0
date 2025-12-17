Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B931DE4CD;
	Wed, 17 Dec 2025 01:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765933275; cv=none; b=av4wIJ+liy75PlrYty/gidXcKkhHuFLleuLnTJ5UujIJN8fAcbuTGBfetMdRmpVt65YVqKF/0UO2uJR2+SySYGwBmWGBzcnn7HNzSE8QT61a/m/RU5ZuKHArkbS1VbM9IpWj3+u4Mki9RglaBQs5T0td5gFX7Dto/1pgzjhqcrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765933275; c=relaxed/simple;
	bh=eCZc+AI1SHQOR9B8MjXmdS2q6dvuT9izP1Xdrs6hgTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDrpXJNKwvRwzHGTTJcBpkQcFzRKmpGoxxNvfsMAwGcnuogFGJ1UNFfEPitKpyk0chwOc4qz75PhjytDNCGLhKtpsLPPD//RyrAI1jOR8KuP9zr6ur1VqTZ8+42hW1UE1rnJH5muvzegubE+yaMRho+kWVpMZVS3WD2uaB+TJ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAhidXfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAhidXfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8752C4CEF1;
	Wed, 17 Dec 2025 01:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765933275;
	bh=eCZc+AI1SHQOR9B8MjXmdS2q6dvuT9izP1Xdrs6hgTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAhidXfBGD3pbpFIkeCEqkz00emteCMQbLAUFyQ4kKfaa3vo+YwQ/yKlOjG5axvkG
	 hmA2YVKdjwC3xKnTGTGWzRMvvViElWckB0U7kmRDhGXWL04MM0MRnFkLGv7jAIWtLG
	 tlv7En9U1nJQ15NXo/vJGX8ZgcyPThT0+Gu2oa+cE31SFaUZkkbWM01vTP+MUr0x04
	 MLuOqrEEfUnAJTJxZLY/xKTQJ2OhjURWIMhRb1h+/RiUoWajD9av9y6W0lnuyF+k1B
	 6j/8A8qaDG2agEmaF9YiCrRzjilxun0qG+DtlmUQL0n0PWUOx0cGGmXUjcbv2UFREY
	 pRjl6vIB/DftQ==
Date: Tue, 16 Dec 2025 19:01:12 -0600
From: Rob Herring <robh@kernel.org>
To: Zhaoming Luo <zhml@posteo.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: ufs: Fix a grammar error
Message-ID: <20251217010112.GA3464453-robh@kernel.org>
References: <20251213-fix-minor-grammar-err-v2-1-b32be57caa13@posteo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213-fix-minor-grammar-err-v2-1-b32be57caa13@posteo.com>

On Sat, Dec 13, 2025 at 11:04:11PM +0800, Zhaoming Luo wrote:
> Fix a minor grammar error.
> 
> Signed-off-by: Zhaoming Luo <zhml@posteo.com>
> ---
> Changes from v1[0]:
> - The subject prefixes match the subsystem as suggested in the
>   documentation[1].
> - The necessary To/Cc entries are included.
> 
> Thanks to Krzysztof Kozlowski for pointing out the errors and providing
> helpful information about how to fix them.
> 
> [0]: https://lore.kernel.org/linux-scsi/20251212131112.5516-1-zhml@posteo.com/
> [1]: https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html#i-for-patch-submitters
> ---
>  Documentation/devicetree/bindings/ufs/ufs-common.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> index 9f04f34d8..efeae8f3d 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -48,7 +48,7 @@ properties:
>      enum: [1, 2]
>      default: 2
>      description:
> -      Number of lanes available per direction.  Note that it is assume same
> +      Number of lanes available per direction.  Note that it is assumed same

...it is assumed that the same number of lanes are used in both 
directions at once.

>        number of lanes is used both directions at once.
>  
>    vdd-hba-supply:
> 
> ---
> base-commit: 9d9c1cfec01cdbf24bd9322ed555713a20422115
> change-id: 20251213-fix-minor-grammar-err-67d10cf2fd9d
> 
> Best regards,
> -- 
> Zhaoming Luo <zhml@posteo.com>
> 
