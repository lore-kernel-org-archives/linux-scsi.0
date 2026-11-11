Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794419698;
	b=rnsj2WsQafPolUVgh+tPHG7NgjczTnm5NenL5EveQlurEEHqr4Jk2pp08TDC3OEyuSF3
	 QDgatqTuOQ0WvM6e4avX9rmD7GQpr3ogUw1ERML5KXlbXjoPBnkFFOcc8sy5sKxAGuAmr
	 Lj0dk4CweOq2OEotz9ibSQVg74oZF1WTwHlRgK2c965n5ClfNilBkeFM4px/Xtsz9NQ2G
	 XJtmjFwsV+qQVdjlqTRJXYKXvdt0/65UPGB0+ExDVETsGRcn6Kh40z20BhWGR5A1x1fGb
	 z8P5gMNvAohmXC4bxdH0gZe15DPV65e7oSVPJAy5SRXWtNV8ymAERsbF2z+lRaQcNcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419698;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	b=LfHxhuFOT/ApLDYkMCuOIZbliqbbj8H4xVIjFaS5JH2M0NrCsTbjwoylSTiONytJqvht
	 dPQfXO+Q6BJHDoehmKaeSKQ/1K1gn9au26XqAymb5/pM8qBnVfaZfKJotXx1kxl8cAd/u
	 hxHlNz5a7VGAFLYzA5hPwQPHVLWZd6Tsv9IVaGjfqiozRrQD7iy1YWwC0GWt9In8VhyYv
	 2NPfF9QeLxP6L4ys5KVIPUB1x0NAA+H4+6XwOUx9EdhxRX3ThOKEtIVhueaGYkEZMFECT
	 Aei1oj06etJETOz/gM/+WwXhLc/3c4N4DTzJDc1RBVjezeqbxNmmWMDdlNWNdNUPPUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gpbhYaYC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A5C606A33D;
	Wed, 11 Nov 2026 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gpbhYaYC
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794419698;
	b=sRKJwe23YYFWmTkwqZbnd3sCWDfJbC2jwa8owLYpIrNYjKx2bbrCxvqIe9ZCVuwqX/EZ
	 YkaEDyMLwjsUWpZFw9KDhAOnM98hFOX3a1Iz1u5nWBEwsM/EJi27uQPe6LAiNft05pdUZ
	 ugjH0/hvBqQbuUOhapv3gpVjjLD+CqJiAzAeW1rIJQfejsWPFbgIsO8jUrAl5Q/bgTXDi
	 C7JwdCcWpCUg9iC5M/b+CAahG+PBYIFQYMO5QuEGLHs8HiZyj5GMNv0owiv9fJcTjOpox
	 HpkaNZjQARr/nB3yd78TJ1GQKLej7cdQfdD0UYpybe7nmX6q8djnssdeM6FdpfUqwKQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794419698;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	b=ax+hzk3JEtaprB/Pm7wd7fxxnklDcutHKbcsWO/u0pdmaJOB2tSBfyVj20weC/DEYvHA
	 BcLdLgwwJiP86FcW/d7q3jw1vNju+F+Q4mxVGwIgITzclK5lN2DoHyR9dwYiBIm9vX+Wk
	 nxIzxfE/4QxGW33OTGyMWtbLSiXELQBX7WkTphSU7kfxU9t8XzaS6wcqSvRQxYT9fV5tv
	 5Uk3vHZoqxq+MzFd5+Z3a+5+FyRH39Wo7a5pBP9nMac7e2h4DAgRM711nzIICrokwZJaZ
	 9I8UIQbtsG7LOfRD+mcwjf9tJpXwW0nZ8vbpoM1Jxyc1uzFClMJEPt3apHf1q9G5hkA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BCC9E1F00A08;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794419698;
	bh=NuefdyGrdEGI4G6kB8HaGwrhpuI/tyFukRQfwK0mqeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=gpbhYaYClxRXSjZRv5FnFgevcMc4SxnhtxHRgi02h9THAqKzLyt5uxNYhUH7uAhLe
	 qxe+fp5oaG0hrX7zSMQd1Ff39ta74bEpyvHV1GRVjNm7OossufRhH3uDQktLoPFWCY
	 zGV4ZuQoboG3r4cU+HsRWauE80Xg9sAraineYF7nqsEUGmHlEr1CthyyIh/eWUKCSN
	 SMnCPq6OsyOXTxSfp9Cm1G5TZDwt44cxy0I5U4hyFRwHg/h6AnnFOyM75CffwRcb5a
	 iTWeOmHwqY8k2AovjemxcDl+c7TY1odQRog0G9MGR/jXQYXAocco6c+vUlVrHTAqJt
	 3cVlAFkynCJDg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 416554907E;
	Wed, 11 Nov 2026 17:54:57 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 11 Nov 2026 17:53:23 +0000
Subject: [PATCH v4 3/3] arm64: dts: qcom: sm8150: use standalone ICE for
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
Message-Id: <20261111-sm8150-ice-rfc-v4-3-0311eac35609@andrewgigena.dev>
References: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
In-Reply-To: <20261111-sm8150-ice-rfc-v4-0-0311eac35609@andrewgigena.dev>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419696; l=2347;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=5ojOLo8hWLDK0hV2yglUJhrUv/sb3CLr9di70RGzFCA=;
 b=bAwBBdu9JMvmNabnEDVyXMeyhN7JwGVt3GX5ECEqowubBcL6QLE6oqUfVaLsbk2VfFDZEo76W
 CEersWwrsTuD9hMcEqClkKWlmLDY11pdCteuW+1EgrdTaxZJmSPrQMX
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


