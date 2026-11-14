Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657378;
	b=0rO2SsibxQR6NiVMxFL1NMYZLjMJDs7BSw+IbBxjFYAVISEOCX1xV6l5YjEK5jJW9d7M
	 VcElAYroYMRvjZ9JdYTJCoO15P/uYpULBrZPhjE5jfApmfRld0JZBXnGSby1yLEhKbKm0
	 vbIVVqf2kGM2dZWMagSG4jPUoGsfxGvPphs0AyDVLy6uXpv0h4JxzqWVwSvfbCox+8ewp
	 x3DZPyswx1mZYUGGtnNcZPDye/8qHUGOhpvEi6IrkdwbW5opZCZnKdmtn0Ty9gt46tNUO
	 1lYolRb1pl2wmgWWIeG8olCGfCCssIPYfkNGJJp1VpCmmoEP2+t3q88ClBOCFb2TLqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657378;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gvxclcujdulxuOzNB06B2gMDxqEIGkemCRahDgIKSr4=;
	b=W01NyCKievKT2itQeO4N/OoRHlIGzPhrdYPfltykh/CRW8NjMphaw/DGotM4Gg/aR5Io
	 sggQbLJl8qVqE0Yf1XOVx2YrTLdZhSPBobpA1+5Lq2mgnAoEPmKH9JwDxmhE5YzkG2Wnb
	 jM4iAKKOrJtabW0WIoUpgwPdaQq+8w5pm1MgiHXoe4MPQWikLiywacnrq8HoppfSLIQU+
	 2PaNqC5rWXEQVC7l3wsRQoToUeKLpvcoXzf4YQkDxaHAaMhjDygk9vJ0JwbWALx6QcK9z
	 TFwDMj85H3Aw4aUh5PtlqHR1SIW4VTtLDAM2UaU6hTzexJNn2EPbCsT58tSbSPNb/Sg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DndSCsDd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E4A60A381C;
	Sat, 14 Nov 2026 11:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DndSCsDd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657378;
	b=hlUhCOnHgqcY4WKXOD4XVbL9eU1DNO6P8gxly4BO4hWme0mp9pNnj29C/fXqzLcJ49DH
	 Ck3vBPLXB84gvq1LL11GTOgGrAwUQXiu+9vsFwIXo3rAa1nbuuphuFxlHD4LkGDusUfmg
	 Mx6qJybFaD+NwtXC8yEUf/i68FF1Fp8qUf/B8wM19sK4bJjL1a+FT8LKiiCBhh7vFL9nK
	 kpQP4AWetwgUgnF6K+CNrsQOa5yKO7Hhm6Ee3Y8H5KWHk6vwhT/7+9rL+cPpHGMNt/t/+
	 LA6w2ZHnPBpWRdvhlbPtx8j1I1QqXMQAMaH7ovm9qEek1sb+mUsPx6v6EjAzg4q75RQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gvxclcujdulxuOzNB06B2gMDxqEIGkemCRahDgIKSr4=;
	b=EPoZQZ3pm+6rpVMSPttFOPhxaxLcBsC8bIsGKOLkmXzC8xnWfv+yRN3Y/VE/RoKF09hh
	 OfsCewj/RjTYGg1vByOu7X6NkT6pQuNVVW4BWOjeqagmpP/F/8N4GH940PzVXjFp5wXDO
	 OsRjd/9gBuh03e4Nu+ZErWNuN38/2LtDM1AzjOLLvKm41A2Dv4bttvPSckxe5D78FWR4L
	 WsuTFQqac+WS9LbIHMoztRfBSkkqdgqzNrnxD9FconGDqmllbGp2Nwmf6n+TubPMWJ1ww
	 Di3UvFYUsbNrPw2q7UFACQK8KgH3cUdBxyl59hFVBSbF+F0rvOUx5HOg2rx7MkLWNJQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3092A1F00923;
	Sat, 14 Nov 2026 11:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657378;
	bh=gvxclcujdulxuOzNB06B2gMDxqEIGkemCRahDgIKSr4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DndSCsDdYMMbjVHc4XfUyFbQJGkH/34L/Wj+VDDb/K0f17GcO5JMup4rZ7v/IU1Bv
	 8tLcK+rA6RWg/60SrxCY8O1S6fIHhcAGekMyOwNCdyzTWesIkdQYN55Eh6rY1ZUk2N
	 GiWLulgEaUjfhS4wXbVHkdAB50OS9eBkNV5/WDvncM7YYvZ7Jd+ie7UIg1w/Kn0MLR
	 kjqBKyzLxiCioLq9Z2H8XhSuGrHqE592NddehPddv1ZRbDsxL7UmrMuSYfs+/sFfcG
	 +0XuvUSb0+rRB6+vOyIqTdjuGurgybSzhDzxbx4+KBat7DrqOcXqFeqtyrc9ByicjA
	 dNaDR8yovkOvg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0FFBB49D91;
	Sat, 14 Nov 2026 11:56:14 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:44 +0100
Subject: [PATCH v11 12/14] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
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
Message-Id: <20261114-b4-ufs-s32n7-v11-12-dc36e11919d5@oss.nxp.com>
References: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
In-Reply-To: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: devicetree@vger.kernel.org, Ajay Neeli <ajay.neeli@amd.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, linux-arm-msm@vger.kernel.org, 
 Peter Wang <peter.wang@mediatek.com>, linux-kernel@vger.kernel.org, 
 NXP S32 Linux Team <s32@nxp.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
 linux-arm-kernel@lists.infradead.org, Stanley Jhu <stanleyjhu@google.com>, 
 Frank Li <Frank.Li@nxp.com>, imx@lists.linux.dev, 
 linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>, 
 linux-mediatek@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
 Pedro Sousa <pedrom.sousa@synopsys.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, eballetb@redhat.com, 
 Peter Griffin <peter.griffin@linaro.org>, echanude@redhat.com, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, 
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
 Manivannan Sadhasivam <mani@kernel.org>, linux-rockchip@lists.infradead.org, 
 Krzysztof Kozlowski <krzk@kernel.org>, clizzi@redhat.com, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Heiko Stuebner <heiko@sntech.de>, Matthias Brugger <matthias.bgg@gmail.com>, 
 Chunyan Zhang <zhang.lyra@gmail.com>, Can Guo <can.guo@oss.qualcomm.com>, 
 Orson Zhai <orsonzhai@gmail.com>, aruizrui@redhat.com, 
 linux-renesas-soc@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657370; l=2031;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=YYl3EEWAWWlWf9vgv8+hTMcxMkUxXw0sNyAAv7y+7v8=;
 b=grj4bxHay3UiQwY3Y+llZRPNOlqdy8VVUdF16qhNA9OBB9J1gnpkTxGSpk2iFsF/YT5/poww7
 UeW88SqJX0DCQwKl1+ROR3qJEHpBDKFlw3Jdzl21NOrxH1i0nkoCzJv
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

Document the UFS host controller on the NXP S32N79 SoC.

The S32N79 M-PHY has two data lanes per direction, so restrict
lanes-per-direction to 2.

The controller has a single functional clock, "core", whose rate is set
by the clock provider and is not scaled.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 .../devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml  | 58 ++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..ffd8ab98e9cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP S32N79 Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Larisa Grigore <larisa.grigore@oss.nxp.com>
+
+properties:
+  compatible:
+    const: nxp,s32n79-ufshc
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: System Control Module registers
+
+  reg-names:
+    items:
+      - const: ufshc
+      - const: scm
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: core
+
+  lanes-per-direction:
+    const: 2
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+        clock-names = "core";
+    };

-- 
2.43.0


