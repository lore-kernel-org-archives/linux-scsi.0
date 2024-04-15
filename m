Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACD936120;
	Mon, 15 Apr 2024 07:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713167663; cv=none; b=O6g+VCbH7Tg/VTHhiJrhGZIJTDSS6d8tY4nHcoeXDvfmUwxaQIJEH1GWh52cIVGHr9afLX4mab0F33QqCpWQvxXbi46WDbZVhzLMSDA6486a1ydXjgVKjyTVEzhzKGDE5tmvoTB2HrqYUj/uocymUAMec2Bqsgvv3xOiva9rlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713167663; c=relaxed/simple;
	bh=CqzKZd4vjnj7h8MQHLZ+d4uf+/wUuKKChJa/MWda7XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYk6kDsKVBBUXaK25HV39A925sQGQt+e2bku5b/i/uI5DkoQZ+4pO6yh8s6X/ylpmrjds7FrI5IM5s9W2EzuwJ3mif2UqRBgLx4UHtbKD8udCq6EZOl7S8xvqZpfcTK3ku127nQ4Rtu/1g4t5ZJzMlD25XpHmO9/le7OwsI90OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=onc2rJxj; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="onc2rJxj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1713167659;
	bh=CqzKZd4vjnj7h8MQHLZ+d4uf+/wUuKKChJa/MWda7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onc2rJxjkWbPZah2WuFKV0fdhQWeh+XGcbfkjKJMUGgt2370dHgdH8uecgoPrixB/
	 /KNmvHqpqOjekfJ7XV3YGnX4ubynn670NnqR8qsOpIoHfZFwacNNCZJKoF4yEsK7q3
	 uUE/F9VgalZqSN5dhdcZynOhuJ4dRhbtVXRmM90gRlIyoC/6McBzipMWPkHYnsUtM1
	 By8t/a45kugn3BnPmJRaNmQhufgprNNNjm0pUKAY+PRl9ufQ0VhFqA3mEedSP6Y5CI
	 pjAXyasKqX1ZHeZjq/dqb9GTUgkK9sWCttGKxfLuJatuePYSf5mfRJYRSEM3+XOdyE
	 IAsSVnBAcw82Q==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 83A3937820EF;
	Mon, 15 Apr 2024 07:54:18 +0000 (UTC)
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
Subject: [PATCH v3 5/8] dt-bindings: ufs: mediatek,ufs: Document MT8192 compatible with MT8183
Date: Mon, 15 Apr 2024 09:54:03 +0200
Message-ID: <20240415075406.47543-6-angelogioacchino.delregno@collabora.com>
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

The MT8192 UFS controller is compatible with the MT8183 one:
document this by allowing to assign both compatible strings
"mediatek,mt8192-ufshci", "mediatek,mt8183-ufshci" to the UFSHCI node.

Moreover, since no MT8192 devicetree ever declared any UFSHCI node,
disallow specifying only the MT8192 compatible.

In preparation for adding MT8195 to the mix, the MT8192 compatible
was added as enum instead of const.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 32fd535a514a..2f4b0a40bd5e 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -14,9 +14,10 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - mediatek,mt8183-ufshci
-      - mediatek,mt8192-ufshci
+    items:
+      - enum:
+          - mediatek,mt8192-ufshci
+      - const: mediatek,mt8183-ufshci
 
   clocks:
     maxItems: 1
-- 
2.44.0

