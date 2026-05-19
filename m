Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6163F1A9FA4;
	Tue, 19 May 2026 06:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779170714; cv=none; b=AAAlrcjX68LAL1laKRYSocZMnNUXESmuLE8b6GiXqUr8vczwubmbfHqUz2QydAiV+ETt0hYmOFdNXx2kLD01FEYC6xa+2VgsDFF81pVfqwV/heZwmGwtaOHPhRIrOj2LrrCw8Q5/6EmS7XNkZLxdhXwOFIHpnVzFTajt13htHV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779170714; c=relaxed/simple;
	bh=lczLOxMIWKK6GHmklTus7Q/fRlQn4JanaG5BYdRUsMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQJBXIHhTcgKuj7kjwGzJv0svYGc0Gylo135lpOc541TNuLrfDA+BmFQBZpxyuyInP5Tmq0+JMr6BeHkllslmARXFQdvWyR05b98fp9Z/IXyGoiu66oj994b9zQMsL+of4XoAgNSANwDNcUyl37T9nw1Agn4njIZsTbhX5V3bng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNbOhucQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNbOhucQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F33BC2BCB3;
	Tue, 19 May 2026 06:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779170714;
	bh=lczLOxMIWKK6GHmklTus7Q/fRlQn4JanaG5BYdRUsMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XNbOhucQ/V+Bq0jrFmZCOIED4FwQPSs2O+8YeMm3ybxraUO1p0FY65YCv4j/4Q9Qm
	 tig9RyDKDPcN4GXQyzpesz1c7b2PX4gqY/k1Fvqt53397QJoVL6IFRWGYe6nLjSE4U
	 WE1vu7fRRZfUKOSSw6Nw1I+cIH2pkpNeDgChi8AKno4pasQr3i86unib0js31YNw47
	 OL62ityi6Zjly4WKJ9cju2NBVMBdL5uYnFRNUPPPJ0qR6Knvgr3hCFm/Zt02nftGhD
	 KGGyEFpmjcm1riESLa6Eg7vxevvfQrQW1MraafGit0FPsg/8i4v5QoQoHxpEKkPjPs
	 3EttKjy2i12Jg==
Date: Tue, 19 May 2026 11:35:04 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, alim.akhtar@samsung.com, 
	avri.altman@wdc.com, bvanassche@acm.org, andersson@kernel.org, 
	dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V1 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Hawi UFS PHY compatible
Message-ID: <uut3u6djc2dc23aznjxdqvkehpx3ooa7eknzjzubnlmylwvxxb@aow3lpjurhnt>
References: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
 <20260518165346.1732548-2-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260518165346.1732548-2-palash.kambar@oss.qualcomm.com>

On Mon, May 18, 2026 at 10:23:44PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Document QMP UFS PHY compatible for Hawi SoC.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml       | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> index 9616c736b6d4..2326dcf38a46 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
> @@ -37,6 +37,7 @@ properties:
>                - qcom,kaanapali-qmp-ufs-phy
>            - const: qcom,sm8750-qmp-ufs-phy
>        - enum:
> +          - qcom,hawi-qmp-ufs-phy

Don't you need to add the Hawi compatible to the below check for clocks?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
