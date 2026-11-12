Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523160;
	b=Xbk1jgRG6JlTfThHVUy8qoboG59gaVUWXotFIobRyKM4KBK5ZBUWYjduP542uZQboURg
	 k942DyqaT6lNU83nGfB0abeU+ahfNtnh6yMETIOdKvypRpWUB4WhvEl72I/dGp5LLwDFv
	 SRa954RTIXAWvdsS3b8uoYllGUyV8bNfzg05fRNGhIDCfaXhCzJDNg1T4w4e5ya5qA6Be
	 uhs8dARE5lO1hiRe8mC2+dgl/3HKwGogXSSpcWhGAv7EjelNBiNp3fnw9+KtWwKCjyELX
	 iywQ0e6NfhY9c//o4vttEFJa1p9mttjye7PRZvN5O0n0jD7ozE7oRat/JvJzqOvQuGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523160;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
	b=4a0H7yq6Rtv5PHKjotyUx9RWcdATuSQWjlqwCrPk3re2oWju/mzjSlKqgULBKysp21/r
	 do35CEOoZS9u2PpGiTXLGb+4B6Yefxum4flKrrXxhPVlBvyF7e74DNgK0we7FSoI1XgtU
	 BxM88V9SqUB0eb6G1lVkrnMEDuRrXCpYir57Uc5CSIXrL33ujMzQFs1w1QKjJMFssl30Y
	 Z2LLzcbYsHuWGRsjM5bxI3qpcXUzQbkt3BUJ/b7oMTC+H4D/Bc0P5dyn4AmD+D3p74Ttq
	 5ssgRnS/I1Vxx9jGqIQxilWEBChF7LcHqMoiBxDUmWEN+jmS6VQHFntLKDfqFvDtU/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lFdGgymK;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TkFMentW;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FB0606A331
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47FB0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=lFdGgymK;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TkFMentW
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZdkW1690736
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=; b=lFdGgymK7lNB1gPh
	AqCApXcN1v0eRiuoeCk8jkwYRPAMOH+R/tnOJkFWb2e4+GFm/Oop4e+gixzbAZTo
	cedgeE2GpVV82a93MUYgS2PQhqo9C1E7hfZybw/FnR6gIWsiR90PuJnoCcH7sWQW
	8yTlHJpzQwJWD5yVIwlGBXuRi/XinY9mn+c++FBTnnGP4NrUwAL86uuA98c+ZF+O
	HsfbKNALYAvIkHwHddd8BDY4Eiqm7HmZxtjTzDIZrwsUvfJxvyISVqkhI4TifYHE
	4NdxFdpEo0O8ALPBRq55+DCi/M9Yib8K4z2K8GNEnF1WNcpQYYGP/JIAWCTUwsY0
	XvQvXQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwkgw8hrx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:19 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1383723dfddso295598c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 14:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523158; x=1795127958; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
        b=TkFMentWElLK0LJH5w9orkjubExaybeGzMhto7e6iFW4iF751KLUlR5ufm3JUbACNG
         Khn2QUbFUV595/I91Ax/ftCm3s6QWqn5olnthw49JSL1ApBGCOfvkVwjaS2bNcp1MacN
         CNlyfZZsCIrcKg2/XC3f57V/NzobSFo7Sxk49bAFHo8WK6QZ37GlKG96AwSWNL5Y8zp3
         hGwTqHx6vQaE86snsqgnqJPzNCvi3G73c0B25bx2PCEXAUTZeX1J+K6xSjWMmMkhfMQg
         DmckrYWIDTqvRw2hJ1S14TNLJ9dN4xyH6WDW9ooKhKRVuZ/pIY2B93/OCRluBRkK5+/v
         3Yyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523158; x=1795127958;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sGGcy2KQT/yHVLFw/oNaZ5cTVhBQ4bGJXIg4frh5/9o=;
        b=sy+lX46q+7+pPcVCc+ouz5qMcQPMX5GisL7w4hKFRELp+esMam0QPpLE/RHDdcPFbH
         I+jnA9v9ZH79p499xsI3LpdpV0wl75eeblB1gEdFpNqBCneAKF37wfhXAZvFjmy71UyQ
         GmCei0eb6C4Amcu1Q6c2VsCBnV7BJ+Wi1BPCtpMNpzQJUgmNihkIZRB0m/LAz3mbcuoQ
         cMZ9vo/hLqW7daQz0BCsP+iXLI4wVWzGtYnkc/Ywut8SdITg4hoEJiBxBMUXxylRntBa
         dO/tL1Ix2j4MEBoWELCsOoBtT4aRAyeDkCF4lJRabYXI3xnotT6nxUA3CQeOTL/ZcjSq
         QtyA==
X-Forwarded-Encrypted: i=1; AL+hErHFkTAYO39l4zlPq4nxRTFrdxFbxBlio723+KcTY2ZqAyoFDKEPB8yn3cw2nI45ckNYCyuc+lXb1ZG7@vger.kernel.org
X-Gm-Message-State: APuU4Z9XiTtgR2ZVt8F1kkvd+lThM5r/PXYsHjJIq+qgk+VnPVxSssyG
	lQaMcVVesD9BYFeJwmA+hNkkxrDVofzBbW3vWPWsoMC5cQ0AkkC0uz4ycrOtVOqfj+bUX8nuDXB
	peHaAQPlOpgOkJP3tVPGBdKLyv0g72GSH+fIs5+CgcdmCWSdvqWBlPk/XETITjGgp
X-Gm-Gg: AYBFou1kCFAxeur1aGpkeYylCeO3i8Wtrmi+fiePzA/LNH1lTqO/WqTTGcpxYyn9eRV
	7k6qwlZ9yONZPkzF5p6UXrsCSgbZjraHVVZf1iornwOA1V2P9Bm52GVv8jQmdM0ck8suEHa9SGs
	cwtzCPrp5WC7NER6e1u4l3Qzanl+O039ExMhx1vPRfdqkU4DRX9j2WD0c8fs/IJKfVb/R1ICypm
	GooNAcWJc/0ghoG7aEb+z0h9BermJnMn970lVq65xqWhuxDYhyhYBNty11K24RtJWrQkyrMfMrX
	NpB1NenElfz63ZwAG/TjKx0l+uRs6qcRdmfHVXKBSJ2AIlwi755PztXlw6oCol1B+Io9EjNu9Ex
	1ybxTnlBrCcqTwaYS+8rIRgPlQ88HnwTH0hI/KpD5vlHn/r8xrI69pDYUdFmvQ2MPaFA2LFHvkn
	dMfwDDVfHkYQ==
X-Received: by 2002:a05:701b:240b:b0:1b2:6cba:7f88 with SMTP id a92af1059eb24-1b503169447mr760681c88.44.1794523158302;
        Thu, 12 Nov 2026 14:39:18 -0800 (PST)
X-Received: by 2002:a05:701b:240b:b0:1b2:6cba:7f88 with SMTP id a92af1059eb24-1b503169447mr760641c88.44.1794523157705;
        Thu, 12 Nov 2026 14:39:17 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:17 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:27 +0530
Subject: [PATCH v13 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-enable-ice-clock-scaling-v13-1-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=DNgacCNb c=1 sm=1 tr=0 ts=6af64017 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=Ncwwxt0CvNVXG9qWacgA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: wVvrRQEh-G98Zu-kefE6M_O6w9q5BiuE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfXx7wb35HibXi7
 5MBrnhwwpzq73FuSTNV3W8sDTugcUBqqZx4wvjITz67Uca7oW+4ly4oMwerl87ALUJzYxA0jcFb
 VeQFKdUlowP/OO61lBBETPFZI8ZKVLjKF63udF/QfRZN7yXaaamtpKxSHwdb4ztXKyepp586Kwg
 M8cORzZw///VCMrO/3NSbj2gJpv3HZsxOHBGXvA1qOh6AeKhYy0DOw0hB7cGDXvY2Zz3NUL4oKr
 e47hTVr5kcR7ykfb7iXwxMRckXax17hbVHoEyxdPGtfnHa4egffzc1bbaAp5odAoQODI64NvUyV
 ktNTJmMUO3ls4OvBMJ2sFk1/sV1EsmLnRkf7vaqHle9CyFkRlSXFUOOzrro1/bwbImVC97SFINd
 NieFGGqb9sV6n9Yt7skafcNZLYkILd1L49t+yL77HXlsknxU9amojQQVlPrJMnz3HeSpKTrZdCe
 EWlWhv5Rkqp4+6V/FTw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX/F4owwE1/6tO
 owLTadsfyN0kXJsV9WyQOoc+OmAEQTkepVwPq8/CNJ/sVEu/k2pjx9JPguxoWPYAQ1C7nb1eG3i
 UHUyd6VQBLShuKReeZ/7Xd5hmiNzfqk=
X-Proofpoint-GUID: wVvrRQEh-G98Zu-kefE6M_O6w9q5BiuE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Register optional operation-points-v2 table for ICE device
during device probe. Attach the OPP-table with only the ICE
core clock. Since, dtbinding is on a transition phase to include
iface clock and clock-names, attaching the opp-table to core clock
remains optional such that it does not cause probe failures.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use round_ceil passed to decide on the
rounding of the clock freq against OPP-table. Clock scaling is
disabled when a valid OPP-table is not registered.

This ensures when an ICE-device specific OPP table is available,
use the PM OPP framework to manage frequency scaling and maintain
proper power-domain constraints.

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 77 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index f9ac45505908fc175f87098e9807c4642c3df321..2259dbecb8b513ff9f2731a969e126118dfb9b1c 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/xarray.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -113,6 +114,7 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	bool has_opp;
 };
 
 static DEFINE_XARRAY(ice_handles);
@@ -560,6 +562,50 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+/**
+ * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
+ * @ice: ICE driver data
+ * @target_freq: requested frequency in Hz
+ * @round_ceil: when true, selects nearest freq >= @target_freq;
+ *              otherwise, selects nearest freq <= @target_freq
+ *
+ * Selects an OPP frequency based on @target_freq and the rounding direction
+ * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(),
+ * including any voltage or power-domain transitions handled by the OPP
+ * framework.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; or errno from
+ *         dev_pm_opp_set_rate()/OPP lookup.
+ */
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil)
+{
+	unsigned long ice_freq = target_freq;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	if (!ice->has_opp)
+		return -EOPNOTSUPP;
+
+	if (round_ceil)
+		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
+	else
+		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
+
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+	dev_pm_opp_put(opp);
+
+	ret = dev_pm_opp_set_rate(ice->dev, ice_freq);
+	if (ret) {
+		dev_err(ice->dev, "Unable to scale ICE clock rate\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
@@ -738,6 +784,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 	unsigned long phandle = pdev->dev.of_node->phandle;
 	struct qcom_ice *engine;
 	void __iomem *base;
+	int err;
 
 	guard(mutex)(&ice_mutex);
 
@@ -756,6 +803,34 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(engine);
 	}
 
+	err = devm_pm_opp_set_clkname(&pdev->dev, "core");
+	if (err && err != -ENOENT) {
+		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
+		return err;
+	}
+
+	/* OPP table is optional */
+	err = devm_pm_opp_of_add_table(&pdev->dev);
+	if (err && err != -ENODEV) {
+		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
+		return err;
+	}
+
+	/*
+	 * The OPP table is optional. devm_pm_opp_of_add_table() returns
+	 * -ENODEV when no OPP table is present in DT, which is not treated
+	 * as an error. Therefore, track successful OPP registration only
+	 * when err is not -ENODEV.
+	 */
+	if (err == -ENODEV)
+		dev_dbg(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
+	else
+		engine->has_opp = true;
+
 	xa_store(&ice_handles, phandle, engine, GFP_KERNEL);
 
 	return 0;
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..4eb58a264d416e71228ed4b13e7f53c549261fdc 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -30,5 +30,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			const u8 *raw_key, size_t raw_key_size,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

