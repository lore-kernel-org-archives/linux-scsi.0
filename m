Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793817506;
	b=08oT4Pdq7tlmwnQ1L0/kdOQJcl11vfEADBhecNxVLsNIngFC/kJ+dKd9vrFGjU9XMN2d
	 YrH6oQ3+k0OoqUvyL8lBD2q9usA8URBUWjJQ9PeNHA8QiP5aV1s9m4hyNFx5GLm4wJaWB
	 /LrkjV8yEOXeAkE7b0cT+C4KAlQt5mpL221btEogV3DB8fzHeiPCZMElW7GVOixjrZwqD
	 pnkZ7k1YVMi/oC4xAuOLnfV6W/QuhzrUJLRwLPkeEqEQiZsc/CJirlAcZ4NYG3pg4Dl7M
	 EfWCr1Cc0Ie1b14vbx+SXITEOEK2m5Shr47FbC6BGX/kJCaYsJ/CQpEAEhurpSfQWXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817506;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	b=bEv2BQT3jMJ6Qje95V/bIXS02+spIut/n2ILNhUCNRpNpDqoF7hVF5t7iEyEKksrIG6D
	 tpA7n+SltRTj7Xu5ijwik/b0akMpYRYL31OC/MjnJVieTek+uFRsIjnvPJbnoDxpOB098
	 thzXIWf/WtOKHW26gKUTtKlIkqLdUkJp8sOPkRFMCDnoxWam+GVRRxI7yn8hj1KF/pZes
	 GVXFFc8J21JhWo46COnRr5KhJYMe0jr+RKQvmi8kQeF/Piu0GaeQNjaOvyCHzozbcF2nN
	 gujFdhtSy0pfewz02hAhIsT6MWxAkQ6C1PTO5yL7jFWjEhC4Sbk02pZa9jUPMAYOLhA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J1z2Zdym;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8E606D807;
	Wed,  4 Nov 2026 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J1z2Zdym
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793817505;
	b=2WlrUGWLX2hNH65K7YthcoxV+Zh7hXLszky5EhmOPm+E71BnTrbiCdgZZ/Isa9A1PI+f
	 nONUU17PHq19TVUjg2cfvSG5VDBIlWh9WI5sCgWmaEMjLOWCyFF0T66xhE7bD/1t66gW0
	 zRclbiJlUgqbRVI02CEXlFzwya/toQuNv0nM+3upKKzx/EQ+k8dOpfols1UBzi6VnwXrn
	 i9BvfL3nxrBcjqBZLxAZX14SwCKjWdlN+yQb/xAkQvUiVMFbLwXBmVbV7KKRRItXA8iSM
	 Zoz6WD3nvlHLb2M14yMtQItL015pOyVsnjKSzovsgCyKvInwXlMY3DZw2IhpdMBSBfg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793817505;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	b=Z2x+dY9aOxhYdP1+YGwVPfSWqcpH2pX4cf1ZdSa/LScNCyXUMLa1ponjet/1CqjJVXiR
	 3+UrFZVq5IItbb6PRxEiS6u5feViVfus2LFGG70Y1Ydpil/b6qjn6v9pxL+3oBWHKYONE
	 A4jXhv3rZajK4/jQtKk1IKX4TPaBGkK+Calf4j+B5E1tjhzCzoEWujJtnMdGywQ0M40Dl
	 owhgkKPWA27N91jfkGuodykPOX3YOAE1+WRb8fkjJcclOBp+vsupEUbJIalsykTlMSdup
	 RdW93O14EiSGQvZ/qklPPq6zTjnOT0NSWqqxKRpkMSGQFx6YDhO4zxawA+yBWlU0g4A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 617D61F00A02;
	Wed,  4 Nov 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817505;
	bh=+fWCJpxvs/WHtsgs/r3petCvfOvEf8z0Ly2akQxeGoU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=J1z2ZdymJAm7O9H82oRBDHjt825AiuIMD0LZ9Cp/mkA5Znk6Mkvg2damHEHZOFJgK
	 85VGK+SnHutKxQNIgCCGz1umItGm2rxJVWYwQTgRibvGyphmdUosYpDj1OtpTYlQ5V
	 jWEuduLWQZSqdGNR9Fpmco9orocXha0mSvnda/lCobQxcGToEYAHoxcRrwPYZDWCCU
	 wcqL1pXCWejpCQ2CniZpZ/l/xqRmH9KOwFtmmRRHkPfny0oiVAj+dbtuAr9MU/RKAt
	 sXsY/Roeia26CVO2sayR352OsMdHDw6KIMgHnOzPy5u7z1tlg2kJ8Aoa08DO1UmQNn
	 w1my1WQjOFqqw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D985D46F38;
	Wed,  4 Nov 2026 18:38:23 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Date: Wed, 04 Nov 2026 18:38:13 +0000
Subject: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
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
Message-Id: <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
In-Reply-To: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793817503; l=2613;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=WlKNWLgTKrbe/21NLFWi4EX5Ly7RQNJI7RvyIEWjaMI=;
 b=a1nAxirKiAJiQ/12HZ3XDuVxxAvfW9Z8hM8ms+EoxVWLhaCPZPHg43hXKoKNt4udsKIMN2QpI
 w8Km050FwcaBD9DXTuzim5qYMjdt9khW9TidgKjwro6cV5u9sGV+VTB
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev
Content-Transfer-Encoding: 7bit

From: Andrew Gigena <mail@andrewgigena.dev>

Convert SM8150 UFS to use a standalone ICE node.

Move the ICE register region and clock from the UFS controller node
into a dedicated ICE node. Reference the new node from the UFS
controller using the qcom,ice property.

This brings the SM8150 device tree in line with the standalone ICE
representation used on newer Qualcomm platforms.

Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
Tested-by: Andrew Gigena <mail@andrewgigena.dev>
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


