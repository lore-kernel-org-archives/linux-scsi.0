Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800805;
	b=kTyieB7IOCkEks4wXI0NGBETK6naDi1yT7B9321nti7fEXklOmEh55IM49n1JTFOzGy1
	 jFoECWf8itxx9FV6eoUrY3xieWwGg4E/jPZbQ9ulCw1kx1Z9wUxC7QpKUFW9JsSUZyfRf
	 fAZb6kh5SpYAVKH4xYMWKe7ei4j8naFfgqprFd/Bl2ZzF1kewE4vT8t4U3hJtGsQub16u
	 k9Hx9wiuv/rg9tRSGF1EQ/4BUoEqjFbVnFR5E2Fb2q4qP7wUVWWYf1b/RdFuhQzeZnChc
	 3IXy75oqVecv1rzJE3urXzIG/fG051E2PqITmVGTwNQdrFtbm2XXmNoIoCGXJDGTFDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800805;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=YJ1mNVMyZabp1br/F4JAZ2tJtuCT1244HZFw9YvsAww=;
	b=K96xYIwnx+6QNQrQK6XIKr4U4/hMIPf0uY/g8+Jhz3iDSTE2VCaEx1jPr0ykSZG0kPAt
	 +Ncx9UWb3st+4zxGh/7AShj0jf6T/iZnUc+gupD6f/SoXPKwFjuM+9HgZ4uJCEqUHyX63
	 55JcLYsPjIYNGHyy5yFI97ZuzIQlyo2TOf+oHEqTmJ/cH5F63FTOGSB91tfT5y2YlZqxO
	 S7Ke7/ofkEbkGO8iixZpKQM90vRkl3fgJQLZuyF2RHnBrv7jtFtaQ/2WyzJEUAnIrLPe8
	 xeENdWINRJvhIJnRGRXfwedzlJ+zvYLXT4Xr4jZyoy4EJADl67QPgGzBWtjfA98czHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kly64OCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933BB606A333;
	Mon, 16 Nov 2026 03:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kly64OCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8589E1F000D4;
	Mon, 16 Nov 2026 03:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794800805;
	bh=YJ1mNVMyZabp1br/F4JAZ2tJtuCT1244HZFw9YvsAww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kly64OCI8u0YOzfJ3KkFUjzjY9/oCCgvs7Qro7mZZqYKTHKpnoC5uGX1Rpwhd+SXf
	 HH1w2qOaZ0hpzL6+qIACz88XVTlmWNI2D7SxKEFXNNyUYgKlxwn1vRMh9lDV8qbjd1
	 WxOI2VSw+JnjDB8nR/RygHvMuGG6Ck6AOZc3f9p28nlOYeTgROpryqfniTAowxI+0c
	 460ZcnvzWcehLit5AZOi9qt86BOPDlMP3YpfZVR3OGii6sq9tvfZ2+bRaYBo3DBAAD
	 Axn27+l7+7ktiBfgk15e98LEXUmWWAp7I+pEgSiLlOZ+MrXeaydJiSNwj6n+hB6hP6
	 rTm4T8YnK1DYQ==
From: Yixun Lan <dlan@kernel.org>
Date: Mon, 16 Nov 2026 03:46:21 +0000
Subject: [PATCH v8 1/2] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-08-k3-ufs-support-v8-1-e3b256972dd4@kernel.org>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
In-Reply-To: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, 
 Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2684; i=dlan@kernel.org;
 h=from:subject:message-id; bh=lq7HN+yl+xEkMLtEEKnMH3G+5GAH8dyxymmhnH9G6cI=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBq+nyT7EcJCAZomdNFEpBFIh5+sKoiEI/dOwtd0
 3hUHV9Bre+JAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCavp8kxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+2a2w//UliqU4JD81DH5VKfrYO2TAaExY2y94lNVWcBZ2STG2SfncFIeet0k
 YRAPb9BlkTz57uluVIJu+NoJMsgjm5U6c8Xlgpvxgif11VRRcMsoSsmNUWgyuu0QgmoQI0W26Nh
 gF4AJIukGct/3kuA9PEFu8Jmolf5dtdBqzcouMZyoyNnyWBn1E3FR2pMFjj/97EE8FpKUyVDBpd
 5GEid2sPRf+tVr0mk0FlUYpNA7sMRjIhKJZwsc3KWjy3vDIbuBJNa+4t9LCLz2okVdLBuDvHJjG
 EffZwh90z8TmZek4/zcvbcIaqClhXH0TUXOBSn/SFGbSxrBLQlkXJ3JNK9CREykfLuzpTUDrnZA
 pjsdKTUbc4gtBZ7iWsJC9ahs8b/ibVbR000eMHWvg3ERgiZHteYP9oIbiq35oDHyoqYvEEKTEOa
 cEczPbApLoc4zZPmCRceFKkBNCwFVz1AI3shdcKzXMjtfmK/KD/HB7FvIWTUukEBjhgRbAMzTnw
 hISNTXDxmv0AXcotpR1QRGY0zFI/li77JKvT9OSHsWC51789esOmexI/fJrpaS9XHy0xSes8WRt
 jRDAJeZpj7DN/pHcBifrtQ8Y71Zt0agS40gC3W8AWshVnfkQuwctmuvjNEaaqWKtBrIP2EWsbJ+
 NY1NIKvmEU+aaxccMhXVNTxhUJWD8A=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

Document the compatible for UFS (Universal Flash Storage) Host Controller
which found in SpacemiT K3 SoC chip. Its features are listed below:

- Compliant with MIPI UniPro v1.61 specification.
- Compliant with M-PHY v3.0 specification.
- Compliant with UFS HCI v2.1 specification.
- Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
- Supports standard low-power hibernate to reduce power consumption.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Yixun Lan <dlan@kernel.org>

---
Changes in v8:
- rename to "ref_clk" clock
  UFS core will search specific "ref_clk" clock, retrieve the frequency,
  and then set bRefClkFreq, see ufshcd_parse_dev_ref_clk_freq() and
  ufshcd_set_dev_ref_clk(). It will also set keep_link_active feature.

  to Krzysztof, please note, I've kept the Reviewed-by in this version
even with clk name change, let me know if you have any objection.
---
 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
new file mode 100644
index 000000000000..2d1b066b4187
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/spacemit,k3-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: SpacemiT K3 SoC UFS Host Controller
+
+maintainers:
+  - Yixun Lan <dlan@kernel.org>
+
+properties:
+  compatible:
+    const: spacemit,k3-ufshc
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: axi
+      - const: ref_clk
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/spacemit,k3-clocks.h>
+    #include <dt-bindings/reset/spacemit,k3-resets.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    ufs@c0e00000 {
+        compatible = "spacemit,k3-ufshc";
+        reg = <0xc0e00000 0x40000>;
+        clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
+                 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
+        clock-names = "axi", "ref_clk";
+        resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
+        interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
+        lanes-per-direction = <2>;
+    };

-- 
2.56.0

