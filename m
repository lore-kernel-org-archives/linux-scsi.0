Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795662626;
	b=nvIS1At31nBKKyTZTGqVGeGdlGtmkgLKwLnixlYNNGjGApUYRoLQfiszrkITmAycvho7
	 PYKxuQPYLp6gT3lMcmD8r2z/26zuxtXyaq/PrB0oil19bPzwS2ruxpSNOMz5XawjwbVs7
	 M0l1w7jfAJC2ya+5fE0GGoovb21h4ayzG4AJjIPIObz68c+qFOQA/DDWApTUylXE1tgm8
	 2CoLtT4gKWzheXYx89dKz//kXUVLiYvFse2o5WxgnAKw+FMQPRFrkEtZVeEV+hhQVmBGB
	 64fnkifOfmtf9S1sefn3yQeGhvOoH+FBzAmBbLOnTS4MdQxdMS4xAG5Jgrcq/Z7k2lQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795662626;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fp47heGyGft53u0FG+oFYxys/HnmByjaFHNX95KFT3s=;
	b=cE7p/Kl/3w9Cvrq7mUNSrEKu+sOpxd+MZYlJwi8V+5+wZi2tMj6nxNlVKgEU5l19aKRi
	 T4vXAZPEo1Q9I+Rm24KbgQYfigcyCk1db8FybOIcOklfGJqW5o55snhvP7228lp8KtmoZ
	 XI++U2fjInnouFGSEJxlBPRg8BUlQW6rJJjbhtfPUV6KwohaYGOMNF1mEsBqmhReFNNTH
	 L2NMhJbSImUaHqAq52YABXv2PxYUBTRtbuZ6xT8CAlifa94wwlEhjzz3H6H6tG2RG9mpO
	 6zZaMgJsgQJdYkrVvSvtRMFB2sAut7pLWR/KKDgHUH/F4KC4ik/Bzvd4r07TqKoPOvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UevJXyRt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF15606A327;
	Thu, 26 Nov 2026 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UevJXyRt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795662626;
	b=QtMi/gYCA1tEAMGrMHNz49LeX8a/qgLypu43NEwRzzbRoG0LoUHmDAd7/qoqikFqw6Y1
	 BWsVW1W/cEWqSkGFlNZTvyyZ0n6Wjdg0y21T4IIq/1F12ZiuK8+FTcqBgQkMyF3bPf1Lm
	 0jgamOY9o5UCUboTlE/oYWK1eHHAT6GNZFdi25dJmU2QNBm1V0chRLEoxFnGgfmjM+39x
	 TC65BJWIcTsZQK+Lw0laTvvh0ljys9SdPdNYGCip9+imE+hi3Dy+//0iAY8spITsCbe1F
	 v3WAeSn1sxthShdTAUNvqndl2BUap6OEOL7HTxXc2L0CkSd4TchHU25dy+arKEoOvZQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795662626;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fp47heGyGft53u0FG+oFYxys/HnmByjaFHNX95KFT3s=;
	b=wNZDC7h/aObDCKURR8DU0Up8ynP8INZaKu5Zkm9yHbzb2G/wzdcpaKffmMThh+Gt+hp8
	 /qMykBUQ962/e5lsDWWzwpXD0F73UyOhxt5sj7j1hx+4tWsUeWaQ7609VKnHdUWcZBySf
	 Rg66jFhqZeJhVWYdM2drigTJY1HIEtdPBkt2zqg8b2vcRlmjFRVnUU2U3mLuLmVMTBcah
	 ZSoJYZcjhjTeq1BQW4hkII6oG/9HGlbX8UKYBwDkSb32utg+s9jxiiLDQJcE+V94hIZRh
	 rXlk7/Y83svQxfMU6uqCoYO2Og5eTebo7X4pg/qtxFfoEFH2FapMTPHJdBXPGo2IXDQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1E5481F000C0;
	Thu, 26 Nov 2026 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795662626;
	bh=Fp47heGyGft53u0FG+oFYxys/HnmByjaFHNX95KFT3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To;
	b=UevJXyRtUp5N8mZEhd3mHwhNU+mcopn5Ndj6PbAw+heKz5d1LASuYUICV/+DNao0a
	 t9hscehwBuSh5P+I1y6yGizjG4Ju4tk3n60HyB86619Teyb7eFN1gPq6l9RllgrYum
	 FoAB12spikjEHMehET4TWslkn20CCR141T+FUVuYb5DFreFn0KJY/gDg9YF/NfBs5n
	 ggjY5QfLv553MXAGgVPWYqAnVFFxlPsCkAQXELB9gaV40WwNrWI1afJ/m88EaCrYpj
	 +gHQl+W0hdKkceHz43FEgTuBjeJ0kjXmR9gmdkXO5XdzZYTKAVHpLg6P1SpPDP3enN
	 2Wg4xXdXFh+nw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9EE864D1ED;
	Thu, 26 Nov 2026 03:10:09 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on
 pre-UniPro-1.8 hosts
Date: Thu, 26 Nov 2026 03:10:09 +0000
Message-Id: <20261126031008.27506-2-iasnezhkov@gmail.com>
In-Reply-To: <20261126031008.27506-1-iasnezhkov@gmail.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
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
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795662608; l=2543;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=YrBMBmuL5NKxL84xOFnaZv26ZBNhisc42ddVi587G/A=;
 b=Z6ARB/7QAgKI8p7XSX+o58Vfecfx+i8gOurM6LZ6lQucWkUyedj8N25BSDpFp+JUSqREl0RxC
 vywAruoAct0Ak0AKKdKfz3tVkaWOOu/jxXinlpWEMpaC5SGer+CIOnV
X-Developer-Key: i=iasnezhkov@gmail.com; a=ed25519;
 pk=hQgXfiWi4ukk2jh4BHu1vRVhg9BUivo//AFp50AKMag=
X-Endpoint-Received: by B4 Relay for iasnezhkov@gmail.com/mindone2026 with
 auth_id=1643
X-Original-From: Ilia Snezhkov <iasnezhkov@gmail.com>
Reply-To: iasnezhkov@gmail.com
Content-Transfer-Encoding: 7bit

From: Ilia Snezhkov <iasnezhkov@gmail.com>

ufs_mtk_pre_pwr_change() calls ufshcd_dme_configure_adapt() on every
power mode change, which writes PA_TXHSADAPTTYPE (0x15d4) even when
passing PA_NO_ADAPT. PA_TXHSADAPTTYPE was introduced in UniPro 1.8, and
ufs_mtk_get_controller_version() sets host->hw_ver.major = 3 only when
PA_LOCALVERINFO >= UFS_UNIPRO_VER_1_8 (leaving older hosts at major = 2).

On pre-UniPro-1.8 MediaTek hosts such as MT6789 (UFS 2.2, HS-G3 rate B),
the DME write fails on every gear change with
"dme-set: attr-id 0x15d4 val 0x3 failed 0 retries". While mainline
ufshcd_change_power_mode() ignores the PRE_CHANGE return value after
commit d3eba21c7170 ("scsi: ufs: core: Introduce a new ufshcd vops
negotiate_pwr_mode()"), older stable kernels still discard the
negotiated parameters on PRE_CHANGE failure, and mainline still emits
spurious DME-SET errors on every power-mode transition.

Return early from ufs_mtk_pre_pwr_change() when host->hw_ver.major < 3
so pre-UniPro-1.8 hosts do not write PA_TXHSADAPTTYPE, and simplify the
remaining major >= 3 branch.

Fixes: 7212d624f863 ("scsi: ufs: host: mediatek: Fix PWM mode switch issue")
Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
---
Changes since v1:
- Corrected Fixes tag from e1e25d1b8996 to 7212d624f863.
- Updated commit description for mainline post-d3eba21c7170 behavior.
- Found on hardware and drafted with an AI coding assistant.

 drivers/ufs/host/ufs-mediatek.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 7691349..38d05ac 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1468,21 +1468,18 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		return ret;
 	}
 
+	if (host->hw_ver.major < 3)
+		return ret;
+
 	if (dev_req_params->pwr_rx == FAST_MODE ||
 	    dev_req_params->pwr_rx == FASTAUTO_MODE) {
-		if (host->hw_ver.major >= 3) {
-			ret = ufshcd_dme_configure_adapt(hba,
-						   dev_req_params->gear_tx,
-						   PA_INITIAL_ADAPT);
-		} else {
-			ret = ufshcd_dme_configure_adapt(hba,
-				   dev_req_params->gear_tx,
-				   PA_NO_ADAPT);
-		}
+		ret = ufshcd_dme_configure_adapt(hba,
+						 dev_req_params->gear_tx,
+						 PA_INITIAL_ADAPT);
 	} else {
 		ret = ufshcd_dme_configure_adapt(hba,
-			   dev_req_params->gear_tx,
-			   PA_NO_ADAPT);
+						 dev_req_params->gear_tx,
+						 PA_NO_ADAPT);
 	}
 
 	return ret;
-- 
2.54.0 (Apple Git-157)


