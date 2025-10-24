Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941F28314A;
	Fri, 24 Oct 2025 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328326; cv=pass; b=UU1CEjqDLfLyNBtvYvuuevzMzQPhGRxxhOr7KXl9z0D+ISY8ZV51ZwRhIuPWO6SfsK9ywxV7+3jEZb4BfzC1lPz6q6uugyGDhVmqKDfNOwkef4rUbaa+qUUQsmD0+o9Fmdx7/TNDYPbjD+7T615GOABpARGFH7u8IUwb6fBV6Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328326; c=relaxed/simple;
	bh=E4AmDFRM7F5PSBy6yLUtj3LAsj32f1PjzdGf0UHDo+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CX+iFOETp20R17cLJGQeWq6nKbMbeLv3lvnxZviJwiHpdY+osb39yv1MBrFEeCweufh8cC50aakad8tiY2CVdBYfpmL/7ig/kVuh8wvzF1nsd4AFcO4eQP3w3S2+E0eSl7uph/yXbX3/w1Gdz1IMszbfBXfgiu10NnfBCCmp66o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=ZKb2rdBf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="ZKb2rdBf"
ARC-Seal: i=1; a=rsa-sha256; t=1761328287; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DiUyK8tdAupooswC4Sh2gsaGJwEarJ2aZRUjtIhDMxmxjnPCwSJRknW6FK7e104M3g/ENmJma3JrEma6BSWM8iTXHD3hRonO4QsrI45TwsKHlCiM2j5zsjTAMxTG2UycJQA8ITep5QRzANzyo1CGE3vSPesoum/GwvGkgdodCVw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761328287; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=sCRi+ao+Y0H2VTsuR8VLPC8s6tkLiQZtynG9CySW2MU=; 
	b=RThPz6TkUJ2jhE7s8OufEirmiTtnvWIxDI0UBi+jed1zfOjgC7eRCNTISyyxzyX62b8PwegmUaIsDgWYJT725GLk4M5aLHylcuWtS7dXik1RTvVlYTWOBI6CqtxT3bz9VYRimiKSd2TbHgmqc4Q6v+RECoH2PcPIlsnlozP48qY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761328287;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=sCRi+ao+Y0H2VTsuR8VLPC8s6tkLiQZtynG9CySW2MU=;
	b=ZKb2rdBffh4am/tRZLfrrSU3VWPizGpeEqiF3S7so4peQ3+FCRThFZJdvv8pSRFn
	F0ikOoMjV24bWKPNFk4CoB5X+7yzxzwNZRWepd08Gj1lW5Su8OBONpJbXcc0s8JHWrY
	yAaoi+kd4UPzNeYm8j+C5+cIzhfvtYqsBkAwnI2Y=
Received: by mx.zohomail.com with SMTPS id 1761328284052701.9623815285279;
	Fri, 24 Oct 2025 10:51:24 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: Conor Dooley <conor@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, kernel@collabora.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject:
 Re: [PATCH v3 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196 variant
Date: Fri, 24 Oct 2025 19:51:11 +0200
Message-ID: <5617400.31r3eYUQgx@workhorse>
In-Reply-To: <20251024-thrash-amid-d5af186c4319@spud>
References:
 <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
 <20251023-mt8196-ufs-v3-3-0f04b4a795ff@collabora.com>
 <20251024-thrash-amid-d5af186c4319@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Friday, 24 October 2025 19:13:36 Central European Summer Time Conor Dooley wrote:
> On Thu, Oct 23, 2025 at 09:49:21PM +0200, Nicolas Frattaroli wrote:
> 
> >      };
> > +  - |
> > +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    ufshci@16810000 {
> > +        compatible = "mediatek,mt8196-ufshci";
> > +        reg = <0x16810000 0x2a00>;
> > +        interrupts = <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>;
> > +
> > +        clocks = <&ufs_ao_clk 6>,
> > +                 <&ufs_ao_clk 7>,
> > +                 <&clk26m>,
> > +                 <&ufs_ao_clk 3>,
> > +                 <&clk26m>,
> > +                 <&ufs_ao_clk 4>,
> > +                 <&ufs_ao_clk 0>,
> > +                 <&topckgen 7>,
> > +                 <&topckgen 41>,
> > +                 <&topckgen 105>,
> > +                 <&topckgen 83>,
> > +                 <&ufs_ao_clk 1>,
> > +                 <&ufs_ao_clk 2>,
> > +                 <&topckgen 42>,
> > +                 <&topckgen 84>,
> > +                 <&topckgen 102>;
> 
> This is absolutely a nitpick thing, but if you end up resubmitting, can
> you pick a consistent format between the two examples your series adds
> for the clocks/clock names?

No problem, will do. IIRC I kept them as a list like this so I could
easily reorder things, but now that I'm fairly sure this order is the
correct one, it's probably best to make this more compact.

Also sorry for the numbers as clock IDs, but MediaTek clock headers
have conflicting symbols and the dt schema example extractor dumps
all examples into one dts file. :(

Since this has bugged me in the past, and many schemas may rely on
the concat behaviour now: would a patch in the distant future that
prefixes all MediaTek clock binding headers with the SoC name be
acceptable if it keeps the old names intact as aliases to them with
a #ifndef guard?

I should also think about some way we can avoid similar bindings
symbol naming mishaps in the future.

Thank you for pointing me in the right direction with regards to
the binding!

Kind regards,
Nicolas Frattaroli

> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> pw-bot: not-applicable
> 
> > +        clock-names = "ufs",
> > +                      "ufs_aes",
> > +                      "ufs_tick",
> > +                      "unipro_sysclk",
> > +                      "unipro_tick",
> > +                      "unipro_mp_bclk",
> > +                      "ufs_tx_symbol",
> > +                      "ufs_mem_sub",
> > +                      "crypt_mux",
> > +                      "crypt_lp",
> > +                      "crypt_perf",
> > +                      "ufs_rx_symbol0",
> > +                      "ufs_rx_symbol1",
> > +                      "ufs_sel",
> > +                      "ufs_sel_min_src",
> > +                      "ufs_sel_max_src";
> > +
> > +        operating-points-v2 = <&ufs_opp_table>;
> > +
> > +        phys = <&ufsphy>;
> > +
> > +        avdd09-supply = <&mt6363_vsram_modem>;
> > +        vcc-supply = <&mt6363_vemc>;
> > +        vcc-supply-1p8;
> > +        vccq-supply = <&mt6363_va12_2>;
> > +        vccq2-supply = <&mt6363_vufs12>;
> > +
> > +        resets = <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
> > +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
> > +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
> > +        reset-names = "unipro", "crypto", "hci";
> > +        mediatek,ufs-disable-mcq;
> > +    };
> > 
> 




