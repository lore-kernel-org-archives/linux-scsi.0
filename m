Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E910A16D4E2;
	Wed, 12 Jun 2024 07:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178213; cv=none; b=TAO3KZyoxTGIP4CU/prAhN/fWCCpvLrGSg9+kGduVo5hslpJyDjR7AiYmcWRD+ejaoYBqlYiM1XxjNwKNEbXodnX3AQFAI28cNfVJs40FejBvSVmgAW1RptaoqT6KdKacTMYSXz191R7PjR3zHw0OCrBhExzOkQr2935NZBbSLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178213; c=relaxed/simple;
	bh=wZcU/FXZehoC+lJtazGBLsIeGgfB53r6HFIFrqTzF24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGL1LdSZgmILSPA6ooQU0xjmsuLfq0qBzpqnVN8r77RWWtXbFuz8HVutuyyD39T2MJ8k8a59NnvQg15pDe7L/1UFlJYhUW3uEL796ODHPSSpI74nSBfn9UECbBEAfmZSHiV9Eg4GvwQl5wSmElbKw4jzM5iRryesrd7Uy3KSLGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=SShfAm4C; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="SShfAm4C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178210;
	bh=wZcU/FXZehoC+lJtazGBLsIeGgfB53r6HFIFrqTzF24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SShfAm4CoYKyVm0t5LhyWvvmUPhukqX1sldqdTI1lFe29jLgV/c7TpAOANcGlHWUg
	 qqMpau0QIPMm4MODw3DRvOMM5KWam0GZaj7l69gwcR9hpdJ6tQ5RojT+ErAiXo5Zgf
	 Ji/DEJl2XkRArxNhoCQibwydpfiZpLJ+2ulw1FpqI9IuZRYvkTmaFlzNzTNHWmZms7
	 JFo1W3tCLd+pV9EjIcopi0d9lVZl4YcBj/oAE2LZB7fMuc/Qr/zLPOzf80feYe2aki
	 I+D+If4y1qt9g4zkbY01Wsy5bZob9XtWapAkEF6jcojJxmvP5hRHStHhxGQHEWYAUo
	 nm7ow5+awGg2w==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 2420D378219F;
	Wed, 12 Jun 2024 07:43:29 +0000 (UTC)
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
Subject: [PATCH v5 6/8] dt-bindings: ufs: mediatek,ufs: Document MT8195 compatible
Date: Wed, 12 Jun 2024 09:43:07 +0200
Message-ID: <20240612074309.50278-7-angelogioacchino.delregno@collabora.com>
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

Add the new mediatek,mt8195-ufshci string.
This SoC's UFSHCI controller is compatible with MT8183.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index f14887ea6fdc..5728e750761f 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -19,6 +19,7 @@ properties:
       - items:
           - enum:
               - mediatek,mt8192-ufshci
+              - mediatek,mt8195-ufshci
           - const: mediatek,mt8183-ufshci
 
   clocks:
-- 
2.45.2

