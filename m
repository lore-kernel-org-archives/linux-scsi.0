Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3CB36AF5;
	Mon, 15 Apr 2024 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167664; cv=none; b=NjRf1mL08z8R+nm8crDhIS+QfQdxwh03ecWMAFT9bY7vqtEgSwJzJlukDCp09g9tfJOBim3vhjng8IAglisOuiNLNTupILUfJIojhELJLCawIzRlnoD/1dwox1OqmIo/WT2zYWUH3yONNKJJQBeR8a3iCk7ldigi2g4x3EVwQMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167664; c=relaxed/simple;
	bh=q+2QfLmc4hWTBhWiZECk9yzd7B5W4CyU9F/byVeWFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGy1Qlmvl3F4Wul+DJUpWCu3mTFnSUoj5vZmBoJuflRcpECm6g86FgJZIsv3T5nnEwZMOIXtgHH7JLi+y/KBPnAH0t/ON9QwpaoS/XbrR/RDNoekhS4yaVYQZXAlenNwCU73REb6IuRUfZLjJPg5NUDLHkgKsUfeEUm4M3IT0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=pJD55ocy; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="pJD55ocy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167661;
	bh=q+2QfLmc4hWTBhWiZECk9yzd7B5W4CyU9F/byVeWFuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJD55ocyShC5HkBmDuCivtbpCco+DUG9fTD51ju8QPtC2BbML1ftrWykX0qh8Dpc8
	 3D+plA0jHO0fsyhNcQHq0SfA7pYaxjgJRfbMXulzegGOK9g9NNIR8IzsvG880Wp5K7
	 ttbLl4xaYLbu7+CHd4O7o6xISu5x67EkKVCD+xbb766v84G+HoZCiNQAu4F6QmQqNd
	 dJDxEiG3/AHCS4BYOdOvmHnT1HqbeNvRPFGdbPHs6ns0+p0TvZ42Y77igEuW3sm4Zc
	 tPAhhTntaIV8CnsaI+AHOGspo1+6X46Eehy49vcYZYVdqA2iwkd7Qf+0gYEiFiXYx8
	 t6rI+ovj6M82g==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 1931B37820F3;
	Mon, 15 Apr 2024 07:54:20 +0000 (UTC)
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
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 6/8] dt-bindings: ufs: mediatek,ufs: Document MT8195 compatible
Date: Mon, 15 Apr 2024 09:54:04 +0200
Message-ID: <20240415075406.47543-7-angelogioacchino.delregno@collabora.com>
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

Add the new mediatek,mt8195-ufshci string.
This SoC's UFSHCI controller is compatible with MT8183.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 2f4b0a40bd5e..92d7e48d5d6d 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -17,6 +17,7 @@ properties:
     items:
       - enum:
           - mediatek,mt8192-ufshci
+          - mediatek,mt8195-ufshci
       - const: mediatek,mt8183-ufshci
 
   clocks:
-- 
2.44.0

