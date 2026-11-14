Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657378;
	b=NBr6D6FSZSe557ZxHX53wyrFDyg4Wy4TBEbqrDzTf78TOJ3PzIgafz2FKXshUd2gPGtz
	 dIjusLoAa17+3Vu1+auWT+3UVgvmrIdrrHgXyD2sQrQ+ZP/ElKw7nzN434l4K5PtKE3L3
	 eiVk7f5HpcRLqCoHdT9lDPq8xhhNYfbdU1NykNdqIK7tdbhmDgNOKG8YnDdguAmxsPikD
	 joWmTKtiqrD11eoxA+tejPO9qHX25vsQx+NoUE3a/yGMNQvuoZmNQMv0SLsHfnTb0+wOV
	 3aGx1toYOudfn0Xrlj9Fi5yc7FbpwxfJADEMSCSxd+NEmAmCzOmsL1lKCQujJFUEjbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657378;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/2hjrB65D30vCvt5YWlJ2EoRPo0VzzXwxqoyF2Wo8n8=;
	b=zUPvCsBJAOEqn8P6INUdvc+sN0+i6t1W22/yr9O4SkmO2uWevBhuVde8ZC9BWqlXNyec
	 O9uFTVPVVrnS0boQwUncWDX3SAJW3a60zVpV+psH69IaC71G5YMiQtiumuNmea5k+tZLF
	 2TsuOQA+8KY/GRH7gcB/r0hY10h4K0evTGlkGoj4VKqRQ4hIWJBmg65gaXD/f3dJZrKtz
	 bXr7RKLB8bu110OSm/XWQNcD4feApxMrejVhLkObIoM+98DS9mjB/q19bpTOdDwQvJBWC
	 Upj1TKVLU+h5u8JF0zP3SXt1nMHYfY9KzrTX6QWj2UWGuFXtS+co7O+D1el0KW3gKcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRJKy710;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F060A262C;
	Sat, 14 Nov 2026 11:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRJKy710
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657377;
	b=X9w88yv2cVMn690pprbfKgcB9kiPM2Qca4FoSCLjUwAYACkYc9YRwIIlhwo6WTHLkA2g
	 tXG6e2wHbVs1fQ372uo5z4rPhRLObHef5hDFWnuQTAC4CkmkyObcAtciaVes9A3uWFpVh
	 RPRuIhAtx61qkdp92Eyecj0QlZNmqrheUBswdwpZ1h6vHF5l757FrKXJ17NF2yyZsCiJq
	 Sv7F2NhF50UfPtT4p2NcH7S8/xO9f0BJtLq5bfDzgS93PtyMbrCK6N08PjB/WGM96LKdZ
	 O3MswlYuHqNPdrr9MhHY8zHXV/dcmuwmdg2c3/mqHld5v7zq6C+/90EUi+o6c/5c7Ew==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657377;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/2hjrB65D30vCvt5YWlJ2EoRPo0VzzXwxqoyF2Wo8n8=;
	b=QeIutcXurMmZcBtNSScXag3uEh5ChX0W0EeGopFM8IFWYPmjF/DCcNjTwJ/NBNkR+pnz
	 +SLs1LsJKo9NOlT/uo+IYDFs+9cZA5Po078NvLzSrB5t1KTOsQEqtcaEVCu3yYmYyTWJ8
	 vCATrBCK6sGc7cuP359M04tw9v68RQnGh1K1oHET3IJp0zf6ac51mE++9rVVOvqIFTe6N
	 swBFlI40/F6BZhfxGs9NW/LOc8t3Y+PsxGdr2s7z1OE0WomO+Lh/b9OAX364LY1keNAvG
	 tFXYgdk+PlVzP4eXkwAv0FgYBlV3qOXyIljhbXXK4fMas9VxBAycpIWizoBR3e88Ntg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 91FF31F000CC;
	Sat, 14 Nov 2026 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657377;
	bh=/2hjrB65D30vCvt5YWlJ2EoRPo0VzzXwxqoyF2Wo8n8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XRJKy710p3Q3Vy9N2rLX7+O0oSzynf3BvVGFFPy1/U8mHEqxZjqyaW+lXtNO9+tgG
	 msFXEkXuPEnDE/2K9JbBeSEQhYvIzyuh4x6RtAdn8ihXZaschKQ4nMRUA1N+Fnff3Z
	 Fc7iFRWdCLY2ZVA5uQGKhqoHhSuKwILrk/Ko3D3ZNscLe+PiiDCEZ2s49QkMMCa0Y0
	 qwaIlswDHZLPmcmvOBnDeQ83nm+evqH/lTusGpPcGwt293V4rTHXYz/KgxSFjllvhH
	 oabXXb2NMLhZ0tAC5eGBxFyr/MSg/2wUPqrX9/sLZbNfNqZOUDhjC++n+BXg85VrJ2
	 bXptoHXs6WTUA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A895849D82;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:40 +0100
Subject: [PATCH v11 08/14] ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by
 offset
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
Message-Id: <20261114-b4-ufs-s32n7-v11-8-dc36e11919d5@oss.nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657370; l=1160;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=jFPb09TEw+o0co3IKimWFQwdujSqoSGN2BKqE5DQhEI=;
 b=ixpsDc5UGD5DMWn3XWZWIo71JIdLStTqgwVuwD42MliFUu4v4d8dPwsTNw9xryPPVqxhBXeFW
 B+Cnmgy6MATB1HDgNV7Osmu4wXB0v9u16j7fle2yFFwau9gIp59++8f
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
CBCRCTRL (0x811F) were placed at the top out of order. Move them down
into their sorted position next to the other CBCREG* attributes.

Pure cleanup, no functional change.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 53b523ef59df..1abf2b1deac4 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,6 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,6 +22,8 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 

-- 
2.43.0


