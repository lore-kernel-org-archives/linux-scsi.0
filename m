Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9363CB;
	Wed, 18 Mar 2026 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773792521; cv=none; b=HdTOEp2H3fPmzcEIIhRSzi5GrV8ndCqv/KRblJdXeZpVFgSODLM02l+BhmBArXAe1LvltLuCmgiUWOG5cRYCRAhkQBVINfKDzfkuA0LzeNhzd3ErYXo+7UrTovUMnI4q9zpUest22j0gsShL6ubUtP7Cocuy3XRjQpZpozD1sy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773792521; c=relaxed/simple;
	bh=D1D/7ldl9hLSp78iQ6WgbBNELMb7wmGvz53rwt7WaEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxJjq9q3HmSv2U0ltiVb7ElUaXyuXltlHGEiFbVCrwjRXsbGgmInLhgSC9DJ5Tle3gvf6Vs8tIzlQzs+EjU3fulslYS74gYPlJkf1helRXc9hxgXtx8b9pDQV/nXbgHLlsHlG0I+Q2471OUYB98dOS7ZqtpoLFuR4TIMHBGmebI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4TtEpuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4TtEpuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9F3C19425;
	Wed, 18 Mar 2026 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773792521;
	bh=D1D/7ldl9hLSp78iQ6WgbBNELMb7wmGvz53rwt7WaEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N4TtEpuj2ofpYYk614ICJN/q/4cwIC81dgWQ31X3yLNCti+3QoqhZM0r8zR5rIf9M
	 t7lZCqMWE5kEnZNPdemPxbCW8s7TWlN++s2eLVs4j19SHDykH3XmCoQK8dICIhrs12
	 4Hno4caRMYbSYYGI34r65e3k7DCErH/eUDaQxo1OZ/cLhM0LWBt/R6Ds9ZdQPZZKZt
	 H/9YX1l79o6IxDlL4SG4B3WHft/1wgmCeCyqZUCv+u110APJZ76fDP+YvD8DuYm7xC
	 4h9FFiEAcgzGl3j6zj76uHKrfPMWUIZudEi0e5bWkdd4FTwZ9Td5lIEgbwv8KJkEfn
	 WJK12HSUQwc4g==
Date: Wed, 18 Mar 2026 08:08:39 +0800
From: Yixun Lan <dlan@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-can@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org,
	spacemit@lists.linux.dev, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 phy-next 06/24] phy: spacemit: include missing
 <linux/phy/phy.h>
Message-ID: <20260318000839-GKB453922@kernel.org>
References: <20260317230500.2056077-1-vladimir.oltean@nxp.com>
 <20260317230500.2056077-7-vladimir.oltean@nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317230500.2056077-7-vladimir.oltean@nxp.com>

Hi Vladimir, 

On 01:04 Wed 18 Mar     , Vladimir Oltean wrote:
> This driver relies on a transitive inclusion of the PHY API header
> through the USB headers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>

> ---
> Cc: Yixun Lan <dlan@kernel.org>
> 
> v1->v4: none
> ---
>  drivers/phy/spacemit/phy-k1-usb2.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/phy/spacemit/phy-k1-usb2.c b/drivers/phy/spacemit/phy-k1-usb2.c
> index 342061380012..14a02f554810 100644
> --- a/drivers/phy/spacemit/phy-k1-usb2.c
> +++ b/drivers/phy/spacemit/phy-k1-usb2.c
> @@ -9,6 +9,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/clk.h>
>  #include <linux/iopoll.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/usb/of.h>
> -- 
> 2.43.0
> 

-- 
Yixun Lan (dlan)
