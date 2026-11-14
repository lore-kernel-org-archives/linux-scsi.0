Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657379;
	b=IJQTJk0y1fwHjJCtEzYqjbeMctEw3RS9EJ1nFgSUUAbqmnFH/UqxBokkJDqfd3UXLLwY
	 P0aHrnm3QI2kXKIm71uSGLKBmwXGtxgsTWFSbt29zuqYF0EaMPmSziBu1OQhI5uQK+u3w
	 0pKTJTPAPqDyrTp7cs8wJwvwuUlQp1NMxn/KVGMirOIrHe2qofiquDzMsRjHMwBuxQdUV
	 5vpin8twEhGsJhHE/qF/sVEIT0bLE8/nuG1sHsnT7VeK0YrDTYX98wrhZtyxxLqm21kOn
	 S6mmZv4ZIDkQ3URi+TzRarghgi4LTz4SCNz4xB8n+znFMjyfONgQANtsyZmjcdQSVmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657379;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KgJ0Pm3uUKFfqIYROp0Tn0x08IPuOauF02gVYJBPO9c=;
	b=l9K1+K5G4Psh0sXYPDD2gFTGQok8gEO4e/0WzLRYsTzq5v8gM8zeBgMMghx41avNxHMu
	 w5nzjuhfMBBkt7vT9oEsFFR/TcJQFo/VZXjWTbPjoSpxYXXlb2/KNtV03llFUuUi0sO48
	 2If5mRhEHVGt4ZmfYlPhXrt5f6y9xfSrj+lHyyyk4aX8QBaxu+SbNiKCuFkjU7RBamWVv
	 Jzje4OIZIlKP8ewCTDeQCTbzrVm4G5ApunbeYcHYaYoxyj/levSAgkIZCuZRstkFC/UBF
	 11/11u/bdnGOdbPSuL9O4N+F2/Wm1/e4huMpev+nVrdHUexncaB0Nupemjt44im7WMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VdovlbP9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056C560A3838;
	Sat, 14 Nov 2026 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VdovlbP9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657378;
	b=FCo08ZgTPylmzl+2jrW9romfGO1AQKu52luceHBEUuq5rbRK+O1fJFCuwKtJe4f9WydD
	 pZhBZCd3nX/EbBNy1gn2l8rHdugxwFGLi2wwG+MzbcQ02+Tr2jTCTBbQ//F65bd1lm0+h
	 8/NhZAr1W+gE+hQu5nbux3EdbVRitABai9U8ph3OQ3cGeGQkkD12nBm4d/+ZnYRl5xdVy
	 as/WEwjaSHhMDbjJZMdQv+cVcAjoivKKt0yr3XWDov9PNKOebJqF4OfIHnjIGiaeCYX2R
	 NqmbAyLemr9Y5kc4X4mh6lp7De/kKSxIBfsSeWHfzSuRU2FE+cKHQ/547NScUGcx6PA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KgJ0Pm3uUKFfqIYROp0Tn0x08IPuOauF02gVYJBPO9c=;
	b=ztChbI3baXm0XMh6tiIdiwuxiU8cw5ZG+fpfP6uiAYnl3cnvuNF7ylKC5kVUpiDETyGl
	 +qt/6jdMrfYd5d8Mzi/h0LhAsZZXyGXPNSnoKADph+DYNhIpOJMvT7ZqblPLNiux+BLlx
	 pR2r8x6A9DLQnYup+B9VemmcQhYN41DM7rE0zha+rkLMpq+85gY6EPDymC36iSCNpAy9c
	 v3yUxJ5czA7YipGYb/GmCnjAuTLqaqSE17M7PTXPZeS520Af7a88DvPsID2duUEr8w/5c
	 udn6LbM0m7xoFburYklyey0ZIQLrzLzus6gVedqJUMFJOxNmBUYEe2jNXTewK/XrqvA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2E9B41F000C5;
	Sat, 14 Nov 2026 11:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657378;
	bh=KgJ0Pm3uUKFfqIYROp0Tn0x08IPuOauF02gVYJBPO9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VdovlbP9SZTqXTWcko84tZwYRN1zQ1U9Zt2VkD3dWthdidtTvqlHfMSPMvC/I+tkr
	 xNhrLeP/8u3iMotTV+0puHxLf39YvKu6myK6AEYmYDrjNGWzvhnzEci6HVXzEiOWdv
	 7nCzVLt2ky2pCNWsWFDm4QzVlaTyLMlrA3LSq/EMX4dwtjvoUS11UWU0Dz0POMrMfE
	 zdNV5XUcfu5v8tKfjJcU3tQPWL5lIqnUnn8SIWGeORcn9A97KUCzfxRSvZNTACCu3p
	 TCJhYX22GeUeRhqsRNAafg/mF7AxP20Lu/BiF2Ecoxfih4Z9TQDB5Q4uzMaMKuegBJ
	 nAspvriAvkstg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3CCFB49D99;
	Sat, 14 Nov 2026 11:56:14 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:46 +0100
Subject: [PATCH v11 14/14] MAINTAINERS: Add NXP S32N7 UFS host controller
 entry
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
Message-Id: <20261114-b4-ufs-s32n7-v11-14-dc36e11919d5@oss.nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657371; l=855;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=q5fZZi6nGFZkAZqMhOp7pecYYzCKqjcJFotJcqJPipY=;
 b=XTzPlY0kewuUk2HgpvABviMk35KnNXD6c7hF6CM4XR3AqV60Kh5fBHv7SebJgKCtDnOBfXZjh
 Ah0PN2vBsktB8yOmeXgs+wwMJMDppf1WrA/lXBTM+2uNzhE22ypoAvd
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 056408bc086e..dad017aa9d81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28862,6 +28862,15 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	imx@lists.linux.dev
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org

-- 
2.43.0


