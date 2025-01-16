Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1F31D7E33;
	Thu, 16 Jan 2025 09:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018812; cv=none; b=t7YV4flh6maXN/BF/baJtwORHo0z50TPYKa1WXvwhRCQziBkdiOrZQpfVnPVOg8q24ObwPPJR4LPw7yJqgcFX+yTOl+/JBGwwFW9Ekbs/nMfBVIY7hUTB8p21E3K0+dk6UzpG3o7YDicisr4izcoCYaG++TClfgl2HqpeyNN4Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018812; c=relaxed/simple;
	bh=3lcDN2UcKO8odxa+r4DkSBUk9QkkIQMK5fPGvbQzChs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rZ8AUFPYtVaWcUMNsMAIf6MecJZNp1tt6KXvLklirlEV/jg/ByjK8vIEzpX2kFFE6dIzTU3xr6+DYt+XNgCL5sXvGrOLkkhSFuFG8LqERypdlN1o85Yj7YPvOlWbDSaezXG6FfaCvUgdRLUh80FvIYk4/CeNWv177CF3uvo29ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=a/qCpBr9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="a/qCpBr9"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G62hKv015767;
	Thu, 16 Jan 2025 09:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=2M2e6Vi0e1/
	zDx95xfB65wwKEFc/+Mq8y+FtiL2leHc=; b=a/qCpBr9YRBgkq46Cq+EypPrC/z
	KTkpnq80G+g/GiIhFLFbiR5TgxZIMCAtwozsh9m11SxtudxgrXmEB24c953PV4X7
	0x3jYvcma8qYUoNo+7+YwJu7cnFpbj6M97ThVa4SN7SZHrllHQm5oztuV2Cn3kXh
	r3FyXgL2yiL/kEddoNDaO8gVIa9QbEYaqKUDOPKmV8W4ETTA7NcrBzaDIVxorh5Y
	gmjp5oK+x6pfYgkLfFUQfgK6tcGHTyx+qXAYG1FpPRnn67v6qBd0hUB6dSI089VS
	vwTUbkOMcqTOV7VUpqzIayasN7xorTL3EPUNY0IzMEtlq6SmoaOR0eC81vg==
Received: from aptaippmta02.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com [103.229.16.4])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 446vge8f5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:13:04 +0000 (GMT)
Received: from pps.filterd (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G9CTlj032044;
	Thu, 16 Jan 2025 09:12:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 4442bf51sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:59 +0000
Received: from APTAIPPMTA02.qualcomm.com (APTAIPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50G9CxQ8032546;
	Thu, 16 Jan 2025 09:12:59 GMT
Received: from cbsp-sh-gv.ap.qualcomm.com (CBSP-SH-gv.ap.qualcomm.com [10.231.249.68])
	by APTAIPPMTA02.qualcomm.com (PPS) with ESMTPS id 50G9Cw0d032544
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 09:12:59 +0000
Received: by cbsp-sh-gv.ap.qualcomm.com (Postfix, from userid 393357)
	id A3F2140BF9; Thu, 16 Jan 2025 17:12:57 +0800 (CST)
From: Ziqi Chen <quic_ziqichen@quicinc.com>
To: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, quic_ziqichen@quicinc.com,
        quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
        quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/8] scsi: ufs: core: Enable multi-level gear scaling
Date: Thu, 16 Jan 2025 17:11:46 +0800
Message-Id: <20250116091150.1167739-6-quic_ziqichen@quicinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: zyYgvNIvq4B9tDFGomsczJLdjsBKQlYy
X-Proofpoint-GUID: zyYgvNIvq4B9tDFGomsczJLdjsBKQlYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_03,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160067

From: Can Guo <quic_cang@quicinc.com>

With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
plans. However, the gear speed is only toggled between min and max during
clock scaling. Enable multi-level gear scaling by mapping clock frequencies
to gear speeds, so that when devfreq scales clock frequencies we can put
the UFS link at the appropraite gear speeds accordingly.

Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 46 ++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8d295cc827cc..839bc23aeda0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1308,16 +1308,28 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
+ * @target_gear: target gear to scale to
  * @scale_up: True for scaling up gear and false for scaling down
  *
  * Return: 0 for success; -EBUSY if scaling can't happen at this time;
  * non-zero for any other errors.
  */
-static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
+static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up)
 {
 	int ret = 0;
 	struct ufs_pa_layer_attr new_pwr_info;
 
+	if (target_gear) {
+		memcpy(&new_pwr_info, &hba->pwr_info,
+		       sizeof(struct ufs_pa_layer_attr));
+
+		new_pwr_info.gear_tx = target_gear;
+		new_pwr_info.gear_rx = target_gear;
+
+		goto do_pmc;
+	}
+
+	/* Legacy gear scaling, in case vops_freq_to_gear_speed() is not implemented */
 	if (scale_up) {
 		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info,
 		       sizeof(struct ufs_pa_layer_attr));
@@ -1338,6 +1350,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
+do_pmc:
 	/* check if the power mode needs to be changed or not? */
 	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
 	if (ret)
@@ -1408,15 +1421,19 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
 				bool scale_up)
 {
+	u32 old_gear = hba->pwr_info.gear_rx;
+	u32 new_gear = 0;
 	int ret = 0;
 
+	ufshcd_vops_freq_to_gear_speed(hba, freq, &new_gear);
+
 	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
 	/* scale down the gear before scaling down clocks */
 	if (!scale_up) {
-		ret = ufshcd_scale_gear(hba, false);
+		ret = ufshcd_scale_gear(hba, new_gear, false);
 		if (ret)
 			goto out_unprepare;
 	}
@@ -1424,13 +1441,13 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
 	ret = ufshcd_scale_clks(hba, freq, scale_up);
 	if (ret) {
 		if (!scale_up)
-			ufshcd_scale_gear(hba, true);
+			ufshcd_scale_gear(hba, old_gear, true);
 		goto out_unprepare;
 	}
 
 	/* scale up the gear after scaling up clocks */
 	if (scale_up) {
-		ret = ufshcd_scale_gear(hba, true);
+		ret = ufshcd_scale_gear(hba, new_gear, true);
 		if (ret) {
 			ufshcd_scale_clks(hba, hba->devfreq->previous_freq,
 					  false);
@@ -1723,6 +1740,8 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_clk_info *clki;
+	unsigned long freq;
 	u32 value;
 	int err = 0;
 
@@ -1746,14 +1765,21 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
-	} else {
-		ufshcd_suspend_clkscaling(hba);
-		err = ufshcd_devfreq_scale(hba, ULONG_MAX, true);
-		if (err)
-			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
-					__func__, err);
+		goto out_rel;
 	}
 
+	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
+	freq = clki->max_freq;
+
+	ufshcd_suspend_clkscaling(hba);
+	err = ufshcd_devfreq_scale(hba, freq, true);
+	if (err)
+		dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
+				__func__, err);
+	else
+		hba->clk_scaling.target_freq = freq;
+
+out_rel:
 	ufshcd_release(hba);
 	ufshcd_rpm_put_sync(hba);
 out:
-- 
2.34.1

