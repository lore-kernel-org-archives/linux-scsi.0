Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8689C16D33D;
	Wed, 12 Jun 2024 07:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178212; cv=none; b=HaXCYy4XsuPaVMphhziqtz1c8wlIDfdBCVSl9iPLx3WPJnqH1o9Qs1cn+5nTM0qt2yX1AVlaMx/idfszri5H2R88c9hmy5Q06vguhaMJfN8Lbr2avc1iChgOwZ2g8AcEc3lGYZrh/LO8103L5vqN/f2u7RVHzODMix+CoEVZKB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178212; c=relaxed/simple;
	bh=K3rrJEbp/p/hbKG0ZLHrE2fpo1wxhHU8XVuRFaDmjOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX+ED+IT3x+cpfvqU7Hkhotx2JCXTFebJ40VZ3VnQj2H28t0C2Bo7lfl6pYhxiVe2CT1n4ScRuiljuAfOXdbF3QdncxP4W0ASOWLsKAL+5H/rVACilZx4ZJusA8O7spvONm2U/ChVx1VIru4Yup3uC5GJiANz3Kg1rGr8yaMmiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=I3OdBZ2w; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="I3OdBZ2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178208;
	bh=K3rrJEbp/p/hbKG0ZLHrE2fpo1wxhHU8XVuRFaDmjOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3OdBZ2w/fBbDobKQTv1ae1lqa+mQz8L/SUhkySAJAy8RsWFdCKI8pDAAsDfsRaws
	 rXgNa69ya52w59XML8sVH5uCNkN3Fa+aCa4JxiCZD0quikLsXqfsb8wTGseHgltn63
	 2biAdVUJxNfAVSAEOYDFi9afgOwJeGsHAYFnsyR0tgyQK4Vnc2MvCw3ddeROsyrLdz
	 sRU5anUYuzeNzLmMpvjnK3QY9u9dB0h90uHjMuQ3NqwII+oQz3n2/J5o2uwB57Ibgx
	 O7+lH+icpWBTMwa5zg+K8ZKacs/kxF0ER3kOL48FazOTtHivXhgJYETjkY6LXeb/FN
	 N3Y/Agoe/sI8A==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id B2D3B378219E;
	Wed, 12 Jun 2024 07:43:27 +0000 (UTC)
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
Subject: [PATCH v5 5/8] dt-bindings: ufs: mediatek,ufs: Document MT8192 compatible with MT8183
Date: Wed, 12 Jun 2024 09:43:06 +0200
Message-ID: <20240612074309.50278-6-angelogioacchino.delregno@collabora.com>
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

The MT8192 UFS controller is compatible with the MT8183 one:
document this by allowing to assign both compatible strings
"mediatek,mt8192-ufshci", "mediatek,mt8183-ufshci" to the UFSHCI node.

Moreover, since no MT8192 devicetree ever declared any UFSHCI node,
disallow specifying only the MT8192 compatible.

In preparation for adding MT8195 to the mix, the MT8192 compatible
was added as enum instead of const.

Also, while at it, replace Stanley Chu with me in the maintainers
field, as he is unreachable and his email isn't active anymore.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../devicetree/bindings/ufs/mediatek,ufs.yaml         | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 32fd535a514a..f14887ea6fdc 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -7,16 +7,19 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Mediatek Universal Flash Storage (UFS) Controller
 
 maintainers:
-  - Stanley Chu <stanley.chu@mediatek.com>
+  - AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
 
 allOf:
   - $ref: ufs-common.yaml
 
 properties:
   compatible:
-    enum:
-      - mediatek,mt8183-ufshci
-      - mediatek,mt8192-ufshci
+    oneOf:
+      - const: mediatek,mt8183-ufshci
+      - items:
+          - enum:
+              - mediatek,mt8192-ufshci
+          - const: mediatek,mt8183-ufshci
 
   clocks:
     maxItems: 1
-- 
2.45.2

