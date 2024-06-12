Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BDB16C451;
	Wed, 12 Jun 2024 07:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178207; cv=none; b=Iua7hh1QvQ2zajlenQ74jMC58vuznaUk+6oWSRsk8fE1ubu49SQbFcCTtoay/0+BwyQAV44isbPekhNRp/7B8GWQbr0MUmlKh/qL9ZNgR71ywjgkZX/2h0wQRTfdJbKXT8qFUXFRiTR/G1pcJnlzcxRkLaR4DVDpSo2J6enYv70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178207; c=relaxed/simple;
	bh=6lsXc7rT10Ac9XA0NZVkBiPzRFq97QkmLLktkh5oOi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPCguzVHVRoI8l5ajjb42767zo9R2fELo6syuUY5PswMjZjZj/NT/MDBQ28MTM6uQgclmjvcGyOdah0LDm28++HP0GBNG7G93nMaSSEKcIFRDajaBVRVUgOwrdZ/ZpQ/wNMc8so0Rp0nG6H/XbheT12dEuCQNULNjubxCHxYy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=geZhYr5Q; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="geZhYr5Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1718178204;
	bh=6lsXc7rT10Ac9XA0NZVkBiPzRFq97QkmLLktkh5oOi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geZhYr5QvEFA+deCcJn5kv2L7dxx0xl4Q7/ztkSlnQc0OfrjoCcsFonA6YuWE6uC+
	 01wxJsriWa8BtIwB+C0XAjCAaOa5yXuS4+wCcZWtq3b9ssXcnlJkXPZL8snyl1B9i4
	 /GtFfo9kitkIiQje2NSd+PuFYuf66Jl/ybbFkdXnW5g+eHTcXnnYdJQmRzVaHYenkU
	 o+/oTnJFlgSBrTbCnA2eJyGsd2agQW2uIBP2g+51zUHi970XMA8vLG6tfV1rhY11aP
	 tcTQG6LOZFSwxebLj08iOZUpdVtBjgajo68Mmg57HPhAKDxQt9+JVlh6WUfzEAh/b5
	 U6ACclK17pNzA==
Received: from IcarusMOD.eternityproject.eu (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id A811C378216D;
	Wed, 12 Jun 2024 07:43:23 +0000 (UTC)
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
	michael@walle.cc
Subject: [PATCH v5 2/8] scsi: ufs: ufs-mediatek: Fix property name for crypt boost voltage
Date: Wed, 12 Jun 2024 09:43:03 +0200
Message-ID: <20240612074309.50278-3-angelogioacchino.delregno@collabora.com>
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

Rename "boost-crypt-vcore-min" to "mediatek,boost-crypt-microvolt":
this is a vendor specific property and needs the "mediatek," prefix,
moreover, this is not defining a minimum voltage per-se;

Even if technically a call to regulator_set_voltage() does indeed
internally set a VMIN for a regulator, the API also supports other
calls to set VMIN-VMAX constraints, so this "vcore-min"->"microvolt"
rename is performed in order to avoid confusion, other than adding
the "microvolt" suffix to it (as this does take microvolts!).

Fixes: 590b0d2372fe ("scsi: ufs-mediatek: Support performance mode for inline encryption engine")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 47c7d34b9be9..23271eb1a244 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -596,9 +596,9 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 		goto disable_caps;
 	}
 
-	if (of_property_read_u32(dev->of_node, "boost-crypt-vcore-min",
+	if (of_property_read_u32(dev->of_node, "mediatek,boost-crypt-microvolt",
 				 &volt)) {
-		dev_info(dev, "failed to get boost-crypt-vcore-min");
+		dev_info(dev, "failed to get mediatek,boost-crypt-microvolt");
 		goto disable_caps;
 	}
 
-- 
2.45.2

