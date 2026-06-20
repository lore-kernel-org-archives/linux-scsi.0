Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B931A3166;
	Sat, 20 Jun 2026 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781942643; cv=none; b=Y8s67HgQ/zLFfS8kzpOAGLcUzPnqsq5DGWbyM77oGUasxBdIgHG6JAaEjmYl8R38LFeiMITGaso/0/2dds/03ALWE0GLWt1HqWMjPglWejMZhDytjB77YklYrFZUfQ+0zveYwycKRmgcBPE3uvZCgpMz7STURVUFW0cFabliKXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781942643; c=relaxed/simple;
	bh=56ugeAM+ygx6RwrquE4Gog8b9/6bRnJt/77t+trZcUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sU5J6e8/vTTR5out4By1lxOsvuLyCWEYQxDUOHDPVdaKAu8GmaR+wi4HZNut/IzrbTcHO7jPy7Akt30jmEeHpZZsksbLUdTj/vqjHuolbZTk50NVI1Zyvwe5M5iHH1rJTE5LX0+X0pFmuqbhXOeRer9LCo3k8wszgm6Er3aEMp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZLJUzMf3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZLJUzMf3"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K3Q64i2624029;
	Sat, 20 Jun 2026 08:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=sOwTTE55txL
	zBjxXsArfhzeS23qcTuea09i2PLihOds=; b=ZLJUzMf3Dopi6u6QrrcdonN/ZXS
	SPKP9EKHN22QLxv8yDjRL8lTAFIuE19zxVerB5TljdFIt7OVQHcvqXEbESlD8kcQ
	GooeJQmey+Ct6yqU5/Ktqi+GAdFPIuDYiWEtwJHXTQDOTcDf5p8KBY5eOFctmeUU
	sqF9yR6Tb9hb5GORtiZa6JHFtVWTdflz2mHSqCo85dLTfTURb7BCCBakSYmte3dB
	GazRnAjzicfPVtRscmqiT/mUL8HgYcJhGa3rN0OHrjadD/7UuwYkp+k/YM5IP5YT
	qvhvXzgc62Z8GZoXVjEw7KYWGS9YVNUEgWPuiIlJmDJR1qKPf8dtu0Cg5KA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ewjxu8fbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:49 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65K83mZ3015942;
	Sat, 20 Jun 2026 08:03:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4ewkxj15yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:48 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65K83mCw015934;
	Sat, 20 Jun 2026 08:03:48 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 65K83mBP015933
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 20 Jun 2026 08:03:48 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 188E9644; Sat, 20 Jun 2026 01:03:48 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE notify
Date: Sat, 20 Jun 2026 01:03:22 -0700
Message-Id: <20260620080322.3765210-4-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDA3NyBTYWx0ZWRfX3NgTYzxcK0yg
 JXc1KMP6YxGzw1B0GxAopDq045YvfSXrmT9wu4la9MOi3NvJKbE+uNsR02GFCoLbXbrTKEeJ1hz
 8jvj0Ya982kXmoKjXvLkeNJhCDaJl+g=
X-Authority-Analysis: v=2.4 cv=G/ws1dk5 c=1 sm=1 tr=0 ts=6a364965 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=BjR8uUe7zAXe8M9JyJQA:9
X-Proofpoint-ORIG-GUID: vXsgk1PAJbr-UAQ2-w04FhvuTJ6lhXJ0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDA3NyBTYWx0ZWRfXztAONMjmyaml
 M2pdHICJ4Dl0McfpFktbywrkgc/IZuOaRckiUIlCib2nj7ySUYNpuHeMv14bBdw/XnUjYa3Uzvr
 CAtwPIH3JyRvFK7i/3L5YdVk8IiAlbr54KWByKTiWCvGeOnAjcxMJQqR2hLTepgtN42uusg6Uy7
 JBrQTVc6LRxeutiZ9J+KO3gFYOXAfpjcNre6rUbNE9N1CnC6xvc8g7FXfhjtBDrC3FNWcrmcM09
 MR4vKyHOb/8pcNfW8lC4wywgm0fl7q0slBshXhY1N9/YlnNUujjR0jN2oo5TArX4VXuUfJobtYd
 zXeN/WcBDSS86CpNP+vWVM/hwJ4HXgrg17BfW1MkZjNnCDJb33GTyEbUaehdlZApLTWaZaYbvKJ
 replYIqa4YtvZWbAXjkzuJlxxEKNPLooUSRSYvwUwxDYgYivniy7G9ZTm6YIAlL9Q0Kc5maZEE1
 AswpwX8mdprAw/M2BUg==
X-Proofpoint-GUID: vXsgk1PAJbr-UAQ2-w04FhvuTJ6lhXJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-20_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606200077

ufshcd_tx_eqtr() skips POST_CHANGE notify when __ufshcd_tx_eqtr()
fails. That can leave variant cleanup incomplete when PRE_CHANGE saved
temporary state that POST_CHANGE is expected to restore.

Always call POST_CHANGE once PRE_CHANGE has succeeded. Keep the TX EQTR
result as the primary return value, and only propagate POST_CHANGE
failure when TX EQTR itself succeeded.

Log PRE_CHANGE and POST_CHANGE notify failures to make variant callback
failures visible in TX EQTR error paths.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 23a12e221d31..c39a623b4fe1 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1224,6 +1224,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 {
 	struct ufs_pa_layer_attr old_pwr_info;
 	unsigned int noio_flag;
+	int notify_ret;
 	int ret;
 
 	/*
@@ -1253,14 +1254,19 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 	}
 
 	ret = ufshcd_vops_tx_eqtr_notify(hba, PRE_CHANGE, pwr_mode);
-	if (ret)
+	if (ret) {
+		dev_err(hba->dev, "TX EQTR PRE_CHANGE notify failed: %d\n", ret);
 		goto out;
+	}
 
 	ret = __ufshcd_tx_eqtr(hba, params, pwr_mode);
-	if (ret)
-		goto out;
 
-	ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
+	notify_ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
+	if (notify_ret)
+		dev_err(hba->dev, "TX EQTR POST_CHANGE notify failed: %d\n", notify_ret);
+
+	if (!ret)
+		ret = notify_ret;
 
 out:
 	if (ret)
-- 
2.34.1

