Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0B635C183;
	Mon, 15 Jun 2026 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530142; cv=none; b=FycUeJFG/n/t3PhswHUCc3gs991IFdBTno45d2NAR1ZSHuMX8imk548gJY0qT0lI5ebDOBAAL2kFq4XJnuN58QfqmHQJDSBTmaJHnzkL0dL8dtPWkp61ndWUKupkb/q5Z9XA9A5+TmBP6q5dNL72y3xea55CFuqekxf2NbljdQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530142; c=relaxed/simple;
	bh=4A5MXxBe64SU2Q/pU/QWy+zuGR7sLDnGfGi2RLbiZfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FapmkuEgH80ge6DL8Zw+IkFThyOVgEip2WojqWbMGC0W3HvxYnPguztjPtZUs02A8Nq2D3/VXLAZKIFo1e0Nbwjas98V703wb1QoiiZQ1pzeEzlhwcUGRftRkSD0AKkiQT70Okz6cuY2AaOrijrVMGGfV0S4QLaPBjs8HBuiX8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pLw77lHY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pLw77lHY"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FCZGSY008857;
	Mon, 15 Jun 2026 13:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=+jESVR0qtzp
	SLFMsdQCxMK6niFde+uXzx6UmA6k+Udk=; b=pLw77lHYUe9ngXMzvXKatFOdvYA
	UkxnM4a1uvLnfY0gJ2+1l7H1YItnBuDbnDAdqOX5XNyKHpkaVjulgtpolsLF2BL7
	AOjUVcDu4PvGYA5iDecAYYj5FPtmvtgmPNPhZbobu4EAzqyCAJAoct4Jyy/6KT0W
	mWW6ULL+WxZilyFyB/gIfWDHE6mkXUnDLQ5CwbFS68aFRKt5M+YMtoF6GUp3S+Lo
	W63zcLNqZTbSYk/b62EFUZB+LS9EjtP1K1nshF34F92v9YLhBaRviE+ty8IqPTsv
	QqmjzfeyY9SxUL650M1ePViXLQofUD58fv4OpsmbdibUU90WrODJWLiEsDg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eteyd8u92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:40 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FDRgDi002734;
	Mon, 15 Jun 2026 13:28:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4et6php7j3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:39 +0000 (GMT)
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65FDSd54003748;
	Mon, 15 Jun 2026 13:28:39 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 65FDSdKq003746
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:39 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 439EF657; Mon, 15 Jun 2026 06:28:39 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v9 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Mon, 15 Jun 2026 06:28:33 -0700
Message-Id: <20260615132834.2985346-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: RHZHH0R7KiBqv3JMcLfBZUuBmD-J09fN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE0MiBTYWx0ZWRfX2gsTWhQe8u52
 BJcgRA8G2PJrfAtFBkBPtzdVrpGmhmmfJkwu6+tU+TRGxTYyVphls4sMyrd+ErN8o/9EmHGxj39
 S/eCIpujSLbzc4L5XAcaSHmhq4G1IGw=
X-Authority-Analysis: v=2.4 cv=QrJuG1yd c=1 sm=1 tr=0 ts=6a2ffe08 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=O1bjOzfcQfNXtJdNm1oA:9
X-Proofpoint-ORIG-GUID: RHZHH0R7KiBqv3JMcLfBZUuBmD-J09fN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE0MiBTYWx0ZWRfX6TUd/WvX2qss
 HgEOJQxZ+JCxJ92F95Wub7cbmHCOnPGDQRElriRVB1iCV+wLfQpA2P4OfmvhqtsXmYP/3bPCNC9
 06TteXxizK/4dvaIjaFoRs2DpOY73e13hE9x5uWLYJFZDs7B4BSf/19/zxXDfzY5uqaQu5+sPGZ
 34kDKueTce7XB1Q4aRfd0cZj6z4JlWixyOBRhLUzGJviOmMkOaef8/rkktUTxeozB7wx8RKdnOu
 jdcYA9vnWJ95CT282qiJLx7Dzf15BS35g/XwEWoIR+Q/UFOOsrOubO8yxZ3jkSM1B1Dhg+XPpfV
 4jIkVjmzUD3NWuS9opGyFGoTdz7GqPDxp2ZfRNPziCL1vFpH/GbatVdjVMzlUJCtGozsZ1wVqir
 ca9Rf9OzdjKrIGxgTC4UqxxY/36Yrz2ay7wNWqQF2mXryC3EO1z3W+AtNiqwwIZJ4nc4SigySG8
 EhUkvlKZPap6sGqCH8A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150142

UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro
v3.0 and M-PHY v6.0. These specs define TX Equalization for all
High-Speed Gears (not only HS-G6) to compensate channel loss and
improve signal integrity at high speed.

For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
required depending on channel characteristics.

Document vendor-neutral properties in ufs-common.yaml:
- txeq-preshoot-g[1-6]
- txeq-deemphasis-g[1-6]
- tx-precode-enable-g6

Values are per-lane Host/Device tuples (2 values for x1, 4 values for
x2). PreShoot/DeEmphasis range from 0..7, and Precode is 0/1.

These are board-specific signal-integrity tuning values. They depend on
channel SI/PHY characterization and validation (host PHY, device PHY,
package, and board routing), and are determined by HW/PHY designers.

Although UFSHCI v5.0 supports TX Equalization Training via UniPro v3.0,
which allows host software to determine optimal TX Equalization at
runtime, static board-specific TX Equalization settings in the Device
Tree are still necessary because:
- TX Equalization Training is not supported for HS-G3 and below
- TX Equalization Training is disabled on some platforms

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..cc32e1189d50 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,64 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+  tx-precode-enable-g6:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 precode
+            enum: [0, 1]
+          - description: Device_Lane0 precode
+            enum: [0, 1]
+      - items:
+          - description: Host_Lane1 precode
+            enum: [0, 1]
+          - description: Device_Lane1 precode
+            enum: [0, 1]
+    description:
+      Static TX Precode enable values for HS-G6 only.
+
+patternProperties:
+  "^txeq-preshoot-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane0 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+      - items:
+          - description: Host_Lane1 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane1 Preshoot value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+    description: |
+      Static TX Equalization PreShoot settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a Pre-Shoot level as defined
+      by the MIPI M-PHY specification (TX_HS_PreShoot_Setting).
+
+  "^txeq-deemphasis-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+    minItems: 1
+    items:
+      - items:
+          - description: Host_Lane0 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane0 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+      - items:
+          - description: Host_Lane1 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+          - description: Device_Lane1 DeEmphasis value
+            enum: [0, 1, 2, 3, 4, 5, 6, 7]
+    description: |
+      Static TX Equalization DeEmphasis settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a De-Emphasis level as defined
+      by the MIPI M-PHY specification (TX_HS_DeEmphasis_Setting).
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1

