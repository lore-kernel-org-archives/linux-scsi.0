Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61923BBDC;
	Mon, 15 Apr 2024 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167666; cv=none; b=cqxgVPwrQ44cDhYHkn+jYSX8uFtNtOpPH48DM08MDH9xCFgNQvVzDhwvA3td7dCgRVwdS+IQm7s7w+EpTE+QZHtrTWvuzIcryGhiyNbrLOD0sdNOWPzOgtEj+pqRtwhUiFscouAykWqOmskWKrUVMVaqDM+G3jGURDcC21nCVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167666; c=relaxed/simple;
	bh=HgBjQFU1dLTjCSok31tMaUY9HeN4cgL2npf8TFFRgPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyU4KfLkwyz8iNYW0xCFNegIoaoCPVCKre/10Axpw+JY9mxHPXo6o+EuqA7YV/Efov+GzhquJt9/sBeGjcjz4uHSmdqXxXYf6p+FacCd5OYLyjxLGNewemvfCj9usEDHUE281MMvBhDcjVb4CxGLcwiNqMd95szW+8nc9eYsE8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=u039gW/F; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="u039gW/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167663;
	bh=HgBjQFU1dLTjCSok31tMaUY9HeN4cgL2npf8TFFRgPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u039gW/Fg76h/Tc8fGyAAZ70T0jMEndj3SeS9WzV/N1/Q/RH02YfeiPwk1jLpnEJr
	 tr/DV4X/rhQOF6G1S5+ooJ+Tp1kTivdGm1Nyrsms7c+bssw5nqYUZ6GFXSevQrshPZ
	 JHCBVc0PyaZ6rmvdEL6wyR+P4NpdUD+0/TZ5DO1cQa2We0t5iOsKoR/CgSDmJUGAgB
	 hJTqhpPqOy6TgJzCfCDegw8r5SaGE46ufAHkBNb0gxg8miRxZxRCAsfD5Rfbj0h/Zy
	 8KoF2ga8OooQ0mb6NBhy0coMJ5Etj8nOIVl+kGUjd1ChTkegi8fY+paNxDvVDKuTrh
	 o4uewjkDywDcw==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 02F803782139;
	Mon, 15 Apr 2024 07:54:21 +0000 (UTC)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: linux-scsi@vger.kernel.org
Cc: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	peter.wang@mediatek.com,
	chu.stanley@gmail.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	lgirdwood@gmail.com,
	broonie@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	stanley.chu@mediatek.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 7/8] dt-bindings: ufs: mediatek,ufs: Document additional clocks
Date: Mon, 15 Apr 2024 09:54:05 +0200
Message-ID: <20240415075406.47543-8-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
References: <20240415075406.47543-1-angelogioacchino.delregno@collabora.com>
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

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml     | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 92d7e48d5d6d..4df2358d440e 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -21,11 +21,24 @@ properties:
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
2.44.0

