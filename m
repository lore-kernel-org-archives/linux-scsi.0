Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794657378;
	b=TRKl4J7NPz+zd6gD7qQpLo/T9jaRB0ao9A80XEC4rKupfV5ab9+TLHoVi4G71EX68av1
	 hqb59q5nlw/MMEX4o0fgEPrhHFa4ANPZ6ZahrIPdYRxzvozKVZzrOicb2GlqWDYYM1IP3
	 0/XYaQND0tCmHefXw3CIol0vWgdZnpIE6KvR2EdJKj3gi1z9mZCaaJr8Pcwc2Csd+0tkL
	 7bTPLASkSnAdZ4d0YRdiSAhShCKMixRuhcrv30Rr3FecRgSQjvaK0H8UfFwhCe2SVwhLy
	 JYSI0bX5XUkAMBarkYBMy6qmIwzsIuUFRsDMe7boHNJ3aL8wdyXUi+eSX7YDbApoNdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657378;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9OQmEHykAQ2R39AIIxgEl7/iSUIXzW+Cm4JhQ4PShDs=;
	b=IxjFaE5F6eJjxaaNtVamUyBba4igcnEIkDnvWicnNxdQN78OrEo1ysIwSiBIFKr7TZRL
	 rC4tLZGMYTpD6h1TL8og+5LlVG1F0Az0h29d/O7Gdczzc/nsdWtYbUhrpy7Zd9OaizJZ1
	 Sr+HaE4keq3ze3gsImiC9YMRtNLpLg//fenybWeZWX7bbcOkZCLOHGgtIwGx9WCZrluLH
	 hJ0pJc69/7i4zQ8LJFAQyw4O8LCGNmbdsscdjKMHEOXbAdVCI/EXeG66c+md4v1vywhgM
	 vdGKUD7BIzUv1HbNZWqORL1uqWNfNL7mVBgVEopOwwzkUhJxmCd6BvEGBQ9OYUd5XjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=On+uf3D0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BC60A3807;
	Sat, 14 Nov 2026 11:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=On+uf3D0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794657378;
	b=lvKPgFV5ItIaG+qLmKOoiGYm0ln+Zos8uKaPSjuXdZNZp0IqfCVPAto4bf5Tea2LD5vg
	 wo8Yw7c/3TaQ8LrfWQxqWtNiYNOZYGShODzNzaLeJb2Kmv8YyTHHuPKF6GpDvj/CwoVXa
	 PHOz5r/SAiO4/LMD/jkAk+VTJcjGQkegwJpIKyT4AGNv3LqfHrdYRj5Cp2MWWzqUSYV+9
	 joC3CFBWczb/E4hWFETM7++/XvvyN2m2eufQc3k+kI8n/Lc9wxxAxuAKZdsSlUq2u/NeK
	 kv8swLcgvrFhtk2MwV995eH4c/O5ZasBlGcc1KfgG0M5ufKolwCpxdul5dr+KB6xnKA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794657378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9OQmEHykAQ2R39AIIxgEl7/iSUIXzW+Cm4JhQ4PShDs=;
	b=h7uyCaYRI2kUAvzSyAHE7ZkfxT6Rg8O96K+QP9nDk0cnCIgKxXmfZrCGBVNPviqwJVsG
	 8nLSy0cnsG1EGM3b9oU/8DL6jA1mL3dCyicRJcRrIiJCQ1pOCwXb9EcZr4TlxjgGW0qja
	 El+RXJ0whPQblYZybLZI4b6oUVeiFO7criY//j0ErvHtos9aqFYsMBCCr04PDqjvqaIeQ
	 qu4IpdIouJr2uqWweoA/cDG4e5OKr2UMLYWR1Z7PH7l5WcwKEWZxw5kynyMBlrBQMuq6p
	 +QCJwFkyaN3E56HDjdboSwK6Xv7K0lRDWzG7VtSUTokOwjD/NtknrLK9GDRwisSO5IA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E7E851F000D2;
	Sat, 14 Nov 2026 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657378;
	bh=9OQmEHykAQ2R39AIIxgEl7/iSUIXzW+Cm4JhQ4PShDs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=On+uf3D0eMfvLrgxgjrVgsHPqB0XWWCtVKkj03Q/0BH+q/CV0vkmm4lzbdM5J/hgl
	 xXkQUyskVpxGkIF83MOuGm0FV16d0frXwIc2Gz6HnvxViwq9eEthPdtCoULH+eKmdu
	 dEX0u6i0mjPXv0iWL+zSlRUlLS5dZZ3UXU+rgattk4MAs2wfiuEwTn24H56Y+Mk5Is
	 c68il4MwURZDDoGmkdKBJsXKdF/ht6CiBeB3UiHgxN3M4KyjcD4e53f9KZPYEROhY6
	 vJepK/XD12GVV/8n/IKbyIIWZHaMKCVO54aTlxUDJ+UlzBS26o64lXdEm4pU5+B6li
	 Is/xiduCPl46A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D6E3349D89;
	Sat, 14 Nov 2026 11:56:13 +0000 (UTC)
From: Larisa Grigore via B4 Relay <devnull+larisa.grigore.oss.nxp.com@kernel.org>
Date: Sat, 14 Nov 2026 12:55:42 +0100
Subject: [PATCH v11 10/14] ufs: pltfrm: Add a flags argument to
 ufshcd_pltfrm_init()
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
Message-Id: <20261114-b4-ufs-s32n7-v11-10-dc36e11919d5@oss.nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794657370; l=7753;
 i=larisa.grigore@oss.nxp.com; s=20261114; h=from:subject:message-id;
 bh=uqwIomSzy0PEvlFV96Px59Ss9lbqTn7kBdME7ujSvaY=;
 b=whX7ZIwJN+OZzdu4rmY09TRleffoMpPhI7rIA8tJWx2+DRO8Gmg9KRRXSF/y/PY+j8hr72525
 ldG1FaMSFdRCUCBfN3mC6WO4GyGpdibAJ9AYzSNbEc+FRutle4ZWGev
X-Developer-Key: i=larisa.grigore@oss.nxp.com; a=ed25519;
 pk=Jpt52sb6ETKTtvWjUzhz5Sv5FjB9AEg9QKCcbpWFx3w=
X-Endpoint-Received: by B4 Relay for larisa.grigore@oss.nxp.com/20261114
 with auth_id=1522
X-Original-From: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reply-To: larisa.grigore@oss.nxp.com
Content-Transfer-Encoding: 7bit

From: Larisa Grigore <larisa.grigore@oss.nxp.com>

Add a flags argument to ufshcd_pltfrm_init() so that glue drivers can
request optional behavior from the common platform code without
affecting the other users of the helper.

No flags are defined yet, so all callers pass 0. No functional change.

Assisted-by: LLM
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/cdns-pltfrm.c        | 2 +-
 drivers/ufs/host/tc-dwc-g210-pltfrm.c | 2 +-
 drivers/ufs/host/ufs-amd-versal2.c    | 2 +-
 drivers/ufs/host/ufs-exynos.c         | 2 +-
 drivers/ufs/host/ufs-hisi.c           | 2 +-
 drivers/ufs/host/ufs-mediatek.c       | 2 +-
 drivers/ufs/host/ufs-qcom.c           | 2 +-
 drivers/ufs/host/ufs-renesas.c        | 2 +-
 drivers/ufs/host/ufs-rockchip.c       | 2 +-
 drivers/ufs/host/ufs-sprd.c           | 2 +-
 drivers/ufs/host/ufshcd-pltfrm.c      | 4 +++-
 drivers/ufs/host/ufshcd-pltfrm.h      | 3 ++-
 12 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index 3ef62acb04fa..f6a19a5d7f14 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -292,7 +292,7 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
 	vops = (struct ufs_hba_variant_ops *)of_id->data;
 
 	/* Perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, vops);
+	err = ufshcd_pltfrm_init(pdev, vops, 0);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/ufs/host/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
index 454ac88c357d..5ac1bc8ee7ce 100644
--- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
+++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
@@ -62,7 +62,7 @@ static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
 	vops = (struct ufs_hba_variant_ops *)of_id->data;
 
 	/* Perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, vops);
+	err = ufshcd_pltfrm_init(pdev, vops, 0);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index dcca6be5dad0..061666125fa3 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -444,7 +444,7 @@ static int ufs_versal2_probe(struct platform_device *pdev)
 	int ret;
 
 	/* Perform generic probe */
-	ret = ufshcd_pltfrm_init(pdev, &ufs_versal2_hba_vops);
+	ret = ufshcd_pltfrm_init(pdev, &ufs_versal2_hba_vops, 0);
 	if (ret)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", ret);
 
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 265e01467a9b..c96ebf12c218 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -2137,7 +2137,7 @@ static int exynos_ufs_probe(struct platform_device *pdev)
 	if (drv_data && drv_data->vops)
 		vops = drv_data->vops;
 
-	err = ufshcd_pltfrm_init(pdev, vops);
+	err = ufshcd_pltfrm_init(pdev, vops, 0);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 5217e2e294f8..8537602a594a 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -528,7 +528,7 @@ static int ufs_hisi_probe(struct platform_device *pdev)
 
 	of_id = of_match_node(ufs_hisi_of_match, pdev->dev.of_node);
 
-	return ufshcd_pltfrm_init(pdev, of_id->data);
+	return ufshcd_pltfrm_init(pdev, of_id->data, 0);
 }
 
 static void ufs_hisi_remove(struct platform_device *pdev)
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 7691349c502a..2e1992e0125a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2438,7 +2438,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 
 skip_phy:
 	/* perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
+	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops, 0);
 	if (err) {
 		dev_err(dev, "probe failed %d\n", err);
 		goto out;
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 979d223230a6..301dbf4f5d88 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2974,7 +2974,7 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 		vops = &ufs_hba_qcom_vops;
 
 	/* Perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, vops);
+	err = ufshcd_pltfrm_init(pdev, vops, 0);
 	if (err)
 		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
 
diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index e418c5878038..4267202185d8 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -535,7 +535,7 @@ MODULE_DEVICE_TABLE(of, ufs_renesas_of_match);
 
 static int ufs_renesas_probe(struct platform_device *pdev)
 {
-	return ufshcd_pltfrm_init(pdev, &ufs_renesas_vops);
+	return ufshcd_pltfrm_init(pdev, &ufs_renesas_vops, 0);
 }
 
 static void ufs_renesas_remove(struct platform_device *pdev)
diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 8ce6534a73de..600460aa118f 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -253,7 +253,7 @@ static int ufs_rockchip_probe(struct platform_device *pdev)
 	if (!vops)
 		return dev_err_probe(dev, -ENODATA, "ufs_hba_variant_ops not defined.\n");
 
-	err = ufshcd_pltfrm_init(pdev, vops);
+	err = ufshcd_pltfrm_init(pdev, vops, 0);
 	if (err)
 		return dev_err_probe(dev, err, "ufshcd_pltfrm_init failed\n");
 
diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
index 8c0a13e95556..fbd53cc4d3c8 100644
--- a/drivers/ufs/host/ufs-sprd.c
+++ b/drivers/ufs/host/ufs-sprd.c
@@ -415,7 +415,7 @@ static int ufs_sprd_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 
 	of_id = of_match_node(ufs_sprd_of_match, dev->of_node);
-	err = ufshcd_pltfrm_init(pdev, of_id->data);
+	err = ufshcd_pltfrm_init(pdev, of_id->data, 0);
 	if (err)
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
 
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c238f6073ad0..f8b2d64b6b4b 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -641,11 +641,13 @@ EXPORT_SYMBOL_GPL(ufshcd_init_host_params);
  * ufshcd_pltfrm_init - probe routine of the driver
  * @pdev: pointer to Platform device handle
  * @vops: pointer to variant ops
+ * @flags: bitmask of UFSHCD_PLTFRM_* flags
  *
  * Return: 0 on success, non-zero value on failure.
  */
 int ufshcd_pltfrm_init(struct platform_device *pdev,
-		       const struct ufs_hba_variant_ops *vops)
+		       const struct ufs_hba_variant_ops *vops,
+		       unsigned int flags)
 {
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index 0a18a8aed94d..0dc48c8d89d5 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -31,7 +31,8 @@ int ufshcd_negotiate_pwr_params(const struct ufs_host_params *host_params,
 void ufshcd_init_host_params(struct ufs_host_params *host_params);
 void ufshcd_parse_gear_limits(struct ufs_hba *hba, struct ufs_host_params *host_params);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
-		       const struct ufs_hba_variant_ops *vops);
+		       const struct ufs_hba_variant_ops *vops,
+		       unsigned int flags);
 void ufshcd_pltfrm_remove(struct platform_device *pdev);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
 			 struct ufs_vreg **out_vreg, bool skip_current);

-- 
2.43.0


