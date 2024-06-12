Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3546316D9AA;
	Wed, 12 Jun 2024 07:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178214; cv=none; b=pitdHOuNSsiQetG7R2MtsWCsz8V/rEkQML1JHH3R2IT8Kvl9VUm7cPje/qVekNm58RCdIvFkq8lB08uMUT7tUUgw+v3eTMrWshQacmkRUVm2bpBmfzOVI5lDYTnnKSY4dx9AIFfeUGTr5fJ07+Bx7+CRG5AyNGXQg+EjgM2hmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178214; c=relaxed/simple;
	bh=TLELbug1XiDukFE3ghBiM2MHhoU3imk1/7ngSSox3e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlsUTLFhj0FMp1zyjHdk1Csq89/elpEEyFnr1gwAyVyF8WTovEkN8X42MMu1IHVGffCYa9CToUzYDBhhve3lmZ+f/BCIUPIZ3rPddZxxDoUVuRoKCAab7/9Nv2sEt6n4WU6VcTsNHHARo4WafcW/6VT2e+GN/24vE3JFjZcsuEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=crdOBphH; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="crdOBphH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178211;
	bh=TLELbug1XiDukFE3ghBiM2MHhoU3imk1/7ngSSox3e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crdOBphHW1I1MSSEvItDPGKYnqKmhVSresrVQRvPCzFKRubdocG1dgao4P/A2ny1k
	 vXepq99nP+SEGpD7u4Qe6ULgbJ65lPxx2kzIiwzlSeOLggycIyHHKIm60x9R2oN+8l
	 Y1LIUyK4x1gK1VfoaS9C+BwpymsXZLDQdsqc55muwpFMjDJLhhflA9wbUCZgtbV9ch
	 tUX/fiR9oCg4OeDMxloh6NL4bJ0Y5Dd3Wv2WjoaHfMHYEeFgSjvH11Z/fOrLPwcBqy
	 RMGjrvraJLszwuX+cpDJzGtMon/AnmNN4Edi1x0sjUlYFo+RBGrQ4XZS9zjrk5IzyG
	 3pYC5M9LxIMew==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 878EF37821A0;
	Wed, 12 Jun 2024 07:43:30 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	wenst@chromium.org,
	michael@walle.cc,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v5 7/8] dt-bindings: ufs: mediatek,ufs: Document additional clocks
Date: Wed, 12 Jun 2024 09:43:08 +0200
Message-ID: <20240612074309.50278-8-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add additional clocks, used on all MediaTek SoCs' UFSHCI controllers:
some of these clocks are optional and used only for scaling purposes
to save power, or to improve performance in the case of the crypt
clocks.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml     | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 5728e750761f..1df8779ee902 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -23,11 +23,24 @@ properties:
           - const: mediatek,mt8183-ufshci
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 12
 
   clock-names:
+    minItems: 1
     items:
       - const: ufs
+      - const: ufs-aes
+      - const: ufs-tick
+      - const: unipro-sys
+      - const: unipro-tick
+      - const: ufs-sap
+      - const: ufs-tx-symbol
+      - const: ufs-rx-symbol
+      - const: ufs-mem
+      - const: crypt-mux
+      - const: crypt-lp
+      - const: crypt-perf
 
   phys:
     maxItems: 1
-- 
2.45.2

