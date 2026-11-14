Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657375;
	b=emPtVTFYLF1BxpSskFJQKWZRVVk2YOcJG3TZb2XuyojMs8N5B1W25jNGGiwn9z/D94fP
	 O2WqDeBaUn1oEJh2Xt6DgjvzM1dkMAtQpEsDoPNniaN0mOMPdeKyJbaaUa53sA6CE0Z+y
	 ovn/QX9SDLYuZP1jM+ij1t+WSj23vG70DaN9j7UiMI54oWjcLRVB9CDS1jHWY5XP5ARcm
	 UATFaNU/DkOyEx1T9q+qFVhkmibxYqtdZ9B9ezVFnc9sWlIPgIe6xLbXDgfKbrxJxLjjW
	 nYif2pbqPFHZdi9Hb1KJYycRVBSAeq9yU8Fvrp9y2cGBdWezaDZHherSxsiSBS9CE8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657375;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NcP1PmV6mGhZtCh4rVFc9CwPV4PnTiLSoRbNIs253gA=;
	b=D/NXOSqwK2/myEb9NTl6aD9OYAx7bPi5xAra+4AxL+2u5VQ5jg+RLsf9noaqG0lbdS1B
	 PRElQQPlPNPORG2vnuZ3dEIivL4S//6JX1BOziK1u0rBFkOSB16iuJ2BlUmCl9pav2YAm
	 jF05Y1RsF0WantZSi9/fdmoN9p8tPmNss/BvskVFOL78PEIsXby2nPsEGS7gC8hinZvf/
	 panrR4hVF8TTIf0PHNcLfDVzwf70LcF210CebZH4ac+oT7OPj960Z5QHVYWmhww3yWr4T
	 vSL2HVv3S6pnk44s1SwielXA3Tkhd0LgsWTMGqEDKcD8FJ/4gYM9F99lQG8Sh3s3KJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEJrb44x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747C606A323;
	Sat, 14 Nov 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEJrb44x
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657374;
	b=uQI/UmOnKx9tmR5iboF5dkOqDFal3OZ/7S2ysaLE1hi7bPYO2MjxGksAa3GeVvz2ZobA
	 NpJiQBW3H89KxQE1NifgnD1vqMqGzcjTI2uaj99JHPWj7yqA4Dw0X8Cf6vVMhvSH91H08
	 2P4gLlhkCJ48AgXKNFIU83LUdvV3LWhUyQa2Srskiim8FovueFLzXLjlF8eGsdOdreIDS
	 8mHsf/GC+TYWcf0HRcb8eByk5z9EYoaAwHlnicukU+l5D00Evif8wUpns8TuTu9o9bViq
	 fw7DCUojum4Nf5rGWV5Es346jit8952N7uIvpi5/TSd+6955bjIEl1A/816tu5wB0wg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657374;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NcP1PmV6mGhZtCh4rVFc9CwPV4PnTiLSoRbNIs253gA=;
	b=SMJ5qZcfRGEU+uWoIzfLbhjUWB07Salo0EAsl+6dJwSBwR5frphDiU9TcBr2Kc0WQF22
	 O8JovqVNKD0Uqul/uvKXo52lQFoQJi9exjTXj3FCS6P9yP5yGZkqZWFEHFbqmgAEYZNyf
	 KAqUwRMWtmT7BPC2I74GkiXkDSm/bxKjrQNNbHk0j6rH/0XAqf3sFpDuxuy3Z+T+Td9ci
	 8UZBEGDX57FZKxov5VHjoQkSTbn5qz14aVvRpSlj/ZxEQsD/G6kJhwgRy4YgLYXE5DBSp
	 x6xFVsKH2nETZi94HoL2zx4ImCJMVgWrddEmk3vkP+uO14hRFqrmntmfuwbp0yKlA5g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 961E31F000C4;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657374;
	bh=NcP1PmV6mGhZtCh4rVFc9CwPV4PnTiLSoRbNIs253gA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cEJrb44xhT8RjjpqTLUhTVVNhMboeIj8bsO32EwCJFvlHFGDp4wjt4wfcpOmoweVK
	 VyZ7KO84apfOQRbl2p/TIZwsbExcKI92iP7ep0gTnFPjQdYkEjTL8xsSErXzNHlA0M
	 jQFk56/cz95TLphy8Q6fIfj+hEfNb5/hSr7c0tCs0kv3FDpgxAHfB4wfBANDAqbHXv
	 LJpDEv3W8NwQwdyCD2cUmW3bysiqmWxZFhOXmMZm9qPCEMBKYy7t2auI4p0UjZZAUk
	 cbOttQ8mJKLc9TQNnPzlixSsa9tRydRdiqRAAa64vw9nLvJB6wXTsb+KxLxb6x+rjJ
	 MWzJKQrtMFm5A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0A85049D63;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:33 +0100
Subject: [PATCH v11 01/14] ufs: core: Return a negative errno from WLUN
 suspend/resume
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
Message-Id: <20261114-b4-ufs-s32n7-v11-1-dc36e11919d5@oss.nxp.com>
References: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
In-Reply-To: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: devicetree@vger.kernel.org, Ajay Neeli <ajay.neeli@amd.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, linux-arm-msm@vger.kernel.org, 
 Peter Wang <peter.wang@mediatek.com>, linux-kernel@vger.kernel.org, 
 NXP S32 Linux Team <s32@nxp.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
 linux-arm-kernel@lists.infradead.org, Stanley Jhu <stanleyjhu@google.com>, 
 Frank Li <Frank.Li@nxp.com>, imx@lists.linux.dev, 
 linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>, 
 linux-mediatek@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
 Pedro Sousa <pedrom.sousa@synopsys.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, eballetb@redhat.com, 
 Peter Griffin <peter.griffin@linaro.org>, echanude@redhat.com, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, 
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
 Manivannan Sadhasivam <mani@kernel.org>, linux-rockchip@lists.infradead.org, 
 Krzysztof Kozlowski <krzk@kernel.org>, clizzi@redhat.com, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Heiko Stuebner <heiko@sntech.de>, Matthias Brugger <matthias.bgg@gmail.com>, 
 Chunyan Zhang <zhang.lyra@gmail.com>, Can Guo <can.guo@oss.qualcomm.com>, 
 Orson Zhai <orsonzhai@gmail.com>, aruizrui@redhat.com, 
 linux-renesas-soc@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657368; l=1602;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=gmKvJS5ja+qFfQcSHziMGUUrnqG+N63YieA9XdI0orI=;
 b=HCs4+jy1XrgoQCh8b366WKkPe8gX3AlsAHzvlETcaOCoT8Jl17FwbFk48k/kzEr87OXgv1Tgt
 9waeTQiK9kYDGfVKiKX7aDbfrHx3yHQrBatck2GBZU8MmBy9JHfKFbM
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

__ufshcd_wl_suspend() and __ufshcd_wl_resume() may return a positive result
code, e.g. from ufshcd_link_startup() when DME link startup fails while
restoring the link.

The runtime PM core treats any non-zero value as a failure of the WLUN,
but rpm_get_suppliers() only checks for a negative value. The LUs
consuming the WLUN are thus reported as resumed and receive I/O while
the WLUN is still suspended.

Convert positive values to -EIO, as ufshcd_init() already does.
Do the same in __ufshcd_wl_suspend() for consistency, so that callers
always get a negative errno.

Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3c28bc67c65f..a6817e4bd1f8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10553,7 +10553,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_release(hba);
 	}
 	hba->pm_op_in_progress = false;
-	return ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 #ifdef CONFIG_PM
@@ -10654,7 +10654,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
 	hba->pm_op_in_progress = false;
-	return ret;
+	return ret > 0 ? -EIO : ret;
 }
 
 static int ufshcd_wl_runtime_suspend(struct device *dev)

-- 
2.43.0


