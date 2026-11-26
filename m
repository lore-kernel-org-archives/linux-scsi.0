Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795654425;
	b=CKCbbe8woyCI0KQMXQIUyEV+jd9wMKn60jpuLXaGawEU6UPGBYOp6IVDRTreehIz3/b8
	 huH/J/ob/Fn1RyY0gkhMlsZqYs69A5Mds+DmDHls7lHVhMajgKkLBaotdc/AtqnqqK74O
	 C3NZQyCs0aXkdVXWNj+BosN1kfG7WA+YEl4x8BQsoaXIdGW8LiGp9Sg8i4RQyjuxx7ocG
	 LWv6dicL8p28hZfvnkg2BEpAIQGqiMhnuzdR9w6DtA9hIBZL4d56abEXilJpMk9u6P6ek
	 wlihzryOCLJLuLOKJocAWX1BBAy6hgqveIjDg1uWWWN/Dy3zsM/CpG4YUKClfzPV+kA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795654425;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C7fC3wgsum3SPXPZYAvK25HkQx81CPAOUehXA+0wjt0=;
	b=jKyifCvoEYTHCbJRHY3u6fPKtWb8/FipeLd9RJpU8pHR08wqS3BcoA7kTwizDtkMSGQC
	 T9xRG3QDRD7gLHMFhV0bK4DO2VaIGY+dZnRSl0/Z0opaP/0lGI43qibHp9/3IAWa1W41e
	 7AwovxBlFbBxvHDgOCPKINijRPNKjP2iD8csYvzoqoB5aEUIdXJ4F1FEciW8RlIi0M6MY
	 WBH/i1E7W8e1ng72ubA7nbGr3LNCExt30T7CbuHr/webwrFPjTKu7NVFu1vTO+WLGM0ZQ
	 okm8uu72GxGnyMNcqcs8Lt0kduFbFYcSF+bkqV2UJh6OaAsDPFhgAcjwtYvE4QpOgKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVulpL0t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6601C606A331;
	Thu, 26 Nov 2026 00:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVulpL0t
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795654425;
	b=xqOPALzez/kgA7WE7kUsvRcziWj7i6KL/LwywPbFSugjJqKdwsIeJWDi80yTBUtvk7go
	 2w5A2VRyFIjgLhjUM5AXbxcxbQ1xf57ned80oCp4btOQZjCoWAsu12XuIFBQ5k8MUxU0p
	 6/kpPYqgCciyeQO25DtOduEn2f5lwqaBRnYKYvYxvz6NJq8dVN5qhMz/6b8tHHVEpeUYh
	 9ZN/xt9gwS4WiDp/LuJqVo5ECuSE8YZhZrJvUrfy744WvMV1oHAZ0DBemvu/hYDWBU8d5
	 JE5+/HI+VA153s5de4cZ4dlMdoL0gohi+Y3yu1wpRMhtmzFmJ1gMjV9jW18RPKmp+8w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795654425;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=C7fC3wgsum3SPXPZYAvK25HkQx81CPAOUehXA+0wjt0=;
	b=bB81w99L8xb7QQViu7tMdU8OApmep5OSpqbia/+pD9ysp3hVaU/3MGPBZ10hK9NwIpou
	 3RGWd6nSrZV1np1sG9gBQBr9Boe12LswShFGXfPQhPpI3LHvLYEHz3Li82xZZu3PXKSKF
	 kdtwJ/SxpHg+LmbgjmFZh+DC8NCGGZlnA52SxrnkNsEWDWl5uWFhnZ4cuYmK8lpUwrWtT
	 bb4SCjtZZ8JWNI+NVX3SDN0T9mHk9KA4BLjGPeKYzd7smL+et7nv9VRWxCU3eCiKEMLNk
	 7Zc8OIUhd0sCBc/qO3Og4qt6B+Q3zbXhGK8SVBjJbZUk2NIFTHPnWiriBzpEH6v2ADg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 651B41F000C4;
	Thu, 26 Nov 2026 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795654425;
	bh=C7fC3wgsum3SPXPZYAvK25HkQx81CPAOUehXA+0wjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To;
	b=hVulpL0tjmoagAex2Z8QVjTDAZTMiJ7mT2llQFP/yIQtwXPSML9z2n10Dxxs1Buj1
	 WMkoi41xrwyjBww1KvrHPNQxPl/ZuEjsUb5As1CT3aN+eoixkgykYDWz7YXj8nqVN3
	 3/C/nyivp4zODRyukHL+1v+qQyhx6S5iUtVeoR2YgWBQ3MQpdNuIHY7ky2JqAC9FHX
	 qH7t5WrRnUZYlavKZTbIhjxrxTxIPw7d5UsuI/dIez1n2l9G0SMN/5j3/ejZC7NwFp
	 h2NyFVR+gJgXt3MJ+/t34WgaAxnQbW4K0H2sCJQYPx6o0qnpwTAPVymlOHDz8Wbc0S
	 Drie9mEAgXgTA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C84B04D15F;
	Thu, 26 Nov 2026 00:53:30 +0000 (UTC)
From: Ilia Snezhkov via B4 Relay <devnull+iasnezhkov.gmail.com@kernel.org>
To: peter.wang@mediatek.com, stanley.chu@mediatek.com, 
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 louisalexis.eyraud@collabora.com, linux-scsi@vger.kernel.org, 
 linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: ufs: mediatek: round scalable clock bounds to
 clk_round_rate()
Date: Thu, 26 Nov 2026 00:53:32 +0000
Message-Id: <20261126005329.72010-4-iasnezhkov@gmail.com>
In-Reply-To: <20261126005329.72010-1-iasnezhkov@gmail.com>
References: <20261126005329.72010-1-iasnezhkov@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795654409; l=2887;
 i=iasnezhkov@gmail.com; s=mindone2026; h=from:subject:message-id;
 bh=mD8c7Hrg16FM5GVQm6mflwliUTbJKeKdxA7+pMxBwPY=;
 b=icOI0pOOqC02NuGMr9RZfkRCctWnCrr3ty5yflwBN3AYW/idYojMNH1DD9jivfRBx8aAHsB5b
 H99BG076G07ClhinycvRB7CVNxN3BZd/utNVmZvoVj+X10rvIiRZB2Z
X-Developer-Key: i=iasnezhkov@gmail.com; a=ed25519;
 pk=hQgXfiWi4ukk2jh4BHu1vRVhg9BUivo//AFp50AKMag=
X-Endpoint-Received: by B4 Relay for iasnezhkov@gmail.com/mindone2026 with
 auth_id=1643
X-Original-From: Ilia Snezhkov <iasnezhkov@gmail.com>
Reply-To: iasnezhkov@gmail.com
Content-Transfer-Encoding: 7bit

From: Ilia Snezhkov <iasnezhkov@gmail.com>

ufshcd_devfreq_target() determines scale_up via an exact equality check
against clki->max_freq after rounding the target frequency. When a DT
freq-table-hz lists a nominal value that a PLL-derived clock cannot hit
exactly (for example, msdcpll_d2 on MT6789 delivers 191999939 Hz for a
192000000 Hz DT maximum), clk_round_rate() produces a rate that never
equals clki->max_freq, so devfreq scales down once and can never scale
back up.

Round clki->max_freq and clki->min_freq with clk_round_rate() in
ufs_mtk_init_clocks() for ufs_sel (and ufs_fde when present) before
ufshcd_devfreq_init() builds the OPP table from those bounds, keeping
clki->curr_freq synchronized with the rounded bound and skipping the
adjustment if rounding fails, overflows u32, or collapses min >= max.

Found on hardware and drafted with an AI coding assistant.

Fixes: b7dbc686f60b ("scsi: ufs: ufs-mediatek: Support clk-scaling to optimize power consumption")
Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>
---
 drivers/ufs/host/ufs-mediatek.c | 35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 09b7993..b4fa2b9 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -967,6 +967,37 @@ static u32 ufs_mtk_get_ufs_hci_version(struct ufs_hba *hba)
 	return hba->ufs_version;
 }
 
+static void ufs_mtk_round_clk_freq(struct ufs_hba *hba,
+				   struct ufs_clk_info *clki)
+{
+	long max_rounded, min_rounded;
+
+	if (!clki->clk || !clki->max_freq || !clki->min_freq)
+		return;
+
+	max_rounded = clk_round_rate(clki->clk, clki->max_freq);
+	min_rounded = clk_round_rate(clki->clk, clki->min_freq);
+	if (max_rounded <= 0 || min_rounded <= 0 ||
+	    min_rounded >= max_rounded || max_rounded > U32_MAX)
+		return;
+
+	if (max_rounded != clki->max_freq) {
+		dev_dbg(hba->dev, "%s: max_freq %u rounds to %ld\n",
+			clki->name, clki->max_freq, max_rounded);
+		if (clki->curr_freq == clki->max_freq)
+			clki->curr_freq = max_rounded;
+		clki->max_freq = max_rounded;
+	}
+
+	if (min_rounded != clki->min_freq) {
+		dev_dbg(hba->dev, "%s: min_freq %u rounds to %ld\n",
+			clki->name, clki->min_freq, min_rounded);
+		if (clki->curr_freq == clki->min_freq)
+			clki->curr_freq = min_rounded;
+		clki->min_freq = min_rounded;
+	}
+}
+
 /**
  * ufs_mtk_init_clocks - Init mtk driver private clocks
  *
@@ -1022,6 +1053,10 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		return;
 	}
 
+	ufs_mtk_round_clk_freq(hba, host->mclk.ufs_sel_clki);
+	if (host->mclk.ufs_fde_clki)
+		ufs_mtk_round_clk_freq(hba, host->mclk.ufs_fde_clki);
+
 	/*
 	 * Default get vcore if dts have these settings.
 	 * No matter clock scaling support or not. (may disable by customer)
-- 
2.54.0 (Apple Git-157)



