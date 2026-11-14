Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657374;
	b=etUtORNW1IM50O8nIdaNyHVMBPRxOiQ184nIYApH7PJi5Vt7pvo1LQfp+9Gn8EtI5HBx
	 73Bq+eD41/yg6zsfy2wFQwv8nKKZr1EhFBbiHia/vB+AidmZp1IGFRjU+3RP6jLT4mueW
	 aE1BMjYHYmG6Bc+bcxT6khcVoix9gWe7hqbaIrkhomPW5ek4gewhcvPqgYXqcqrctPTg2
	 bhlk/arvvCkBxnND1oxG32zh4PF+KfxZCtSHHZp2Xejuf6EpEYGak0lAB9RREvLwQOpfI
	 DO3qfoQW8m7GkyAvNLIkkFr/BU/1EJ/mAfsxPMFjhx0qo0DbKjC2KywcAz3AdVNhUYA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657374;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=773JKNN2vNOYbMzmNERDyAma8a9RNQ26ZOx7oBBfnT4=;
	b=M03EQA1Yop8P1oZOhDXJSvRywXWQOq0rhXjN5Q4HK7YVGzDELeHSeGBUxWBluokYa2mj
	 /GFFpRJJH/ufPvtEjVeiWqm9i1uB6Hny/+T/AHi7jmNewDEvZF/BSNbj5K+pfrNWIaDr4
	 3D+VCjIU4su52tFfRAKwJsZPDChX9TScSlIVcf4RUQAfxCJKVSr6iFHubhBKWBgWkKp1K
	 any0mMriwNPQ0/YZ0PqTmGL9YjtB9y0KtdYQZDQ4cW6d/OQmDVWyshzmVVYIoMnLlPPv4
	 MfEhvBlaYVLYppehKXVV6Y6AqgK5L+n/DCWtwUO9wa4xaAUcCIhl1eXiFXjH5B/lXBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRqz+ung;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972F606A327;
	Sat, 14 Nov 2026 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRqz+ung
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657374;
	b=kjKEasGcdTNh7VSEwAObGNBviP7aRYjYynphthA3+Ker5OujAKRPm30c/j+ThSYWsPar
	 7TeKFHZCmh0CnyKFvuDnzFbWPfq8dS5WMn4dUIDK5qwmM46N7UDDIwK829YQ8sp1fiUB7
	 FqOYmokMxzHrZOuWhloKoGX9VQ+ZeRAB7c6fyzFS5qxKRuQ1qgw2cStgYWAKPKU/crBSM
	 Tv7EWS69fIZ3u9CsVfIfUbJWc9tn05NsSAt7ygoPqJXDeGFl1Atuj3YV4RqlT3IaYmhon
	 12Fqh6/qM0GVn0nqpDoctoDzE+if+A2GkMgPLzKO2BXX2VGbkuDxccul9N8pDARAqSg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657374;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=773JKNN2vNOYbMzmNERDyAma8a9RNQ26ZOx7oBBfnT4=;
	b=PbFKtAg86rcrwttbfH6qR+VqaEHDN5Mg/wooLqzZm/HhARWTmEG5VK6AkWYimGWRvOV1
	 V4wmhLC853rs18nOApEVQZ138ce1L29pfpBnEJxpiuSltcxJKPNGag87hjJhlRksL+Vbo
	 Pc8Mmf5fq572NknvCnIXqAihMeGxSwsHfh/QD/q0+A1IL1KTd2u2ItmSFMrD8Bt87eVxS
	 6INprpBZfN5m1LGcWx7J9UVLoRc/7MBCpxxcVf7TAwueXsBvlgefAv5rBp9MgnYvdGA6G
	 atWGvUkLc69ge+I2o80s+XZk9zoy5J6yBiPYxM8hT7/iwNSE+u4E/4spph2KQwUVx1A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9CFBB1F000C6;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657374;
	bh=773JKNN2vNOYbMzmNERDyAma8a9RNQ26ZOx7oBBfnT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bRqz+ung8qG5uXqmbdZGVrXnQ8zzozXnisEWAZGuCSQvddWV2D+P0mrGw93k0PBVa
	 L6gIS5l9K2+7xOdQBdeb7B1XJeNClCgnUw/5hrwqVYQDNyEg8xXFTwEAdDqJmuqaLM
	 wjALHILiFyFqsMlEd1go900W6zxedV6E6IPQGMNUj9oa6QMH24DvaE03Ywg4IBB1Ra
	 Pxu1D7WUCbSOZfMo6WkKrphRC0ZYZBnyh6vvNtfvT+483R8DUtStsLv8O3z6cD38VJ
	 ILKlsGJBbm+zWZXMM5AOixntUYL0TLS9tczhbuGaon2AZyBTmmMVkpKB8Tp42S2zSO
	 L72Pe0tg1bCrA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 235A249D6B;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:34 +0100
Subject: [PATCH v11 02/14] ufs: dwc: Return a negative error if the link is
 down
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
Message-Id: <20261114-b4-ufs-s32n7-v11-2-dc36e11919d5@oss.nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657369; l=1730;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=3iqhyDqtSmMHTy7iRVwvJKugbIlnKe/5rACzitf/+kM=;
 b=twhUWaDvF4XRpCAXaEcnsk66UdpAgd8BMuYReTg38acmFePjqlIoEFHfYDYERoCr380D/B/re
 dBCVArbMAOdBUnwNx3jbF0JhmoSMQiBFpEdHtyv/hTsR0hINYgtGcf0
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up, and it
ignores the return value of ufshcd_dme_get(), so a failed read of
VS_POWERSTATE is also reported as "link down" with the value 1.

A subsequent patch exports this helper for use by other DWC glue
drivers. Before doing so, make it follow the usual kernel convention:
return -ENOLINK when the link is down, and report a failed
ufshcd_dme_get() as a negative errno instead of its positive UIC result.
Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..71433b4d04aa 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
-	int dme_result = 0;
+	u32 dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret > 0 ? -EIO : ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**

-- 
2.43.0


