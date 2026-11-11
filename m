Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794370674;
	b=oZs4zQ7Fgoq5uTUaabpYdBKFHwWZOtU4ZaXgpOOLzlDrjypEAN6kmLjc3pV6sanaz0C+
	 IRXMi08WWy5G+Bb4BIcMTYeX/81KrPYYK2qYekzoRDir/3eUyzbpLEywxibLGPC20nk7b
	 3SSiBRai+NVtz7viLcHg1XPmWSlp0Io1WmhBVdInVXL4tL3UVdhF16pMhHOmGO4EOHOnT
	 2Z3Qb+Xl14qNa7CIqSD9mqNS7R85wC+0r4IMsx6Rv4si6yeUwvdffUbqixB05nDKDvvei
	 HWd7wf4nzK0EzlWFNuig/3VYnJsMHoy7ZtDE3M3QO9zC6gPPUSa0i7iwVQQSyIu8IAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794370674;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	b=CNXLEfnjd9zJIdweiVZMQ4E8w6lnuB21jenLX882E1/AR0iFBkJbC41Y4zwy1BA1A2jm
	 4vCApw+6DSlT8PM1qxWPlcd3Bb6le9tcE1MmPURryc+zr86wAWof/IoS7v8tjcV1/VYBm
	 NCSHaB5ucKd4+fSgTiGmrPg2LVsfOGoWHH3XoZ9e1nri2VLjb7DdLf0B9FCiljvApm18T
	 N1T+NpKNyU/W575OBuLt8CYzPraDKh6QJKFrLTJeon+dn69iL9l+2FTmX0sUd2+ITQVD/
	 c4NJOZm6nV6a59KiqJ8mXpVrNV5xFpYJs5F3JVWkIxGze2C7OmoE7nV6HGX2Dg1VH/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCAfuxm6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53033606A32D;
	Wed, 11 Nov 2026 04:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCAfuxm6
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794370674;
	b=oyuHYYaNq0y2eAeq3NQEI9MOObmgu3/ZjGnHpXXKO3Qa/vSGcXbu8e6prwqxkPxKRvWz
	 jm/uOPSsfP9m5m/upxpaQcmmS2Qy++lYevUEW5rmWPRy4AaOzCzlD9yCSKxV1w5FuDAo9
	 YheuYWKfhmMNkRRMX4fAPThFQ1MHu4cJy/r76x/zFbKAeM/evTSOPBEU3yUINiqXBPSee
	 GC7Kg+IplkCI2crTSiAJ1GGEfuNUW52bl517TPU3VM5/YGBkjHWvEXdMddOtQkq81T6qm
	 NZo2WTU52L6hk6doXIvBrgrBnmir6S1pEzQ4IWM4R3PCoPBL5v1wQ5jrR+WaTYHKjIg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794370674;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	b=LSrp3uhUA+dYfycAlkRt108kpTfd+6UAB91XoIsrOXBzN09kMSv7j/HvTk4DW6YAfWqA
	 crtw7YYJplvSoot1Qv3fX9M9AXurK3/2n/DtfPxAI6dWrQpS6Rwix7comC2bIKYIVlgLq
	 5tVM6SU7dTxDSDRBi/bEG3eV3+1jo0cW1loPlnJ1WVzKV6mhmVo9vfA3G14uGPi2xQkhS
	 kUuQTrLimZv0e4OQwRgBcEo9xSzb3pO/tWkPek7by1bzxwtF3niJFLxDShFf+r4MOA9yn
	 WQSEIRES6AZzWCOyS7fe1N7Oby14rJOYsiLys8YB21hJxGYcNJF+ah+g1iXdnfTg4XA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 307121F00A03;
	Wed, 11 Nov 2026 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794370674;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VCAfuxm6eIeGSd68SugJrU8z6gZaBE9THS0xUJhjiByYhJtjSfw3HVosDWrzZaeZW
	 vuU5Ly0yHKxcZCov0iTeWGYuJOkIMa+gdR7rWu9bEXxrtjISz8dw5NZTM5lNP5s6/o
	 COABjdQh3bu3CpAO/1ze8U0Q10zKoc26qwodAFzLF5VdXwRAtBWBuBsbhQ3xZiogUM
	 mw1xSs8OEPnbM5FrnTVr8EOo6K2RAL8Vk6iZN/FzOpSC7QMXJG97Vlr1T4Xy0kDAR5
	 ABRbJk9b2ulTMvZP6QdI+/tNDsyE+sO9l2rQy1hYZ2VA7qxnd1hVjX1Yi1uq11KzM/
	 imghhKGiVBy4g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B03C048D7C;
	Wed, 11 Nov 2026 04:17:52 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 04:17:51 +0000
Subject: [PATCH v3 3/3] arm64: dts: qcom: sm8150: use standalone ICE for
 UFS
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261111-sm8150-ice-rfc-v3-3-f9d5a806fc95@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
In-Reply-To: <20261111-sm8150-ice-rfc-v3-0-f9d5a806fc95@andrewgigena.dev>
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794370671; l=2347;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=5ojOLo8hWLDK0hV2yglUJhrUv/sb3CLr9di70RGzFCA=;
 b=fYh/wnOjTAhn9em3DNVhlUH56Virjz5sZPm4HyxwD2C0/aw3IssZBPyFgRnsaQITow4T7Ovq8
 3+M+kZvHIPjCyalquq6BFaIzxHn8MJ6Hzp0XNvakSNUYBWfy2DrPmIG
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

Align SM8150 with the standalone ICE representation used on newer
platforms instead of embedding ICE registers in the UFS node.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 293fcbacff34..b3d6f3d92395 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2071,9 +2071,7 @@ pcie1_phy: phy@1c0e000 {
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sm8150-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
-			reg = <0 0x01d84000 0 0x2500>,
-			      <0 0x01d90000 0 0x8000>;
-			reg-names = "std", "ice";
+			reg = <0 0x01d84000 0 0x2500>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
@@ -2092,8 +2090,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				"ref_clk",
 				"tx_lane0_sync_clk",
 				"rx_lane0_sync_clk",
-				"rx_lane1_sync_clk",
-				"ice_core_clk";
+				"rx_lane1_sync_clk";
 			clocks =
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -2102,8 +2099,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
-				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
-				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
 			freq-table-hz =
 				<37500000 300000000>,
 				<0 0>,
@@ -2112,8 +2108,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 0>,
-				<0 300000000>;
+				<0 0>;
+			qcom,ice = <&ice>;
 
 			status = "disabled";
 		};
@@ -2139,6 +2135,17 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 		};
 
+		ice: crypto@1d90000 {
+			compatible = "qcom,sm8150-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d90000 0 0x8000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0 0x01dc4000 0 0x24000>;

-- 
2.56.0


