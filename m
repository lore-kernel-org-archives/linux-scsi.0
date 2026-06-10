Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79151E5B63;
	Wed, 10 Jun 2026 07:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075817; cv=none; b=lC88Eo1J9gr/57D63Q9W4xvgPRCOHi1wZSBNkjJyQt+920G6umiWahsGrtCWFxcPQBegk8mLbptQ78nBDglXinQOwoPW8u/SeHcgjHWs8bQs+2IbjB8944L5+YscRLF1KoPdf8T9Y+2gXu00ZbUxZlKDNKwWMkoI2yOnl2pqC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075817; c=relaxed/simple;
	bh=CZzFBUaFmBb/pAj2jzEQO9qbPsZRelUw2xAiLSl2Iv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=akMONOTYEgsMBmQ8P2ZXUpG/LBvSLHqHemUpYmABDfgTU9Sn2wjiUTbpdjE3jVhelHiRR2LnisLxZo2J97jE5AkYx51TOFWJiIocBp3QcoMD0jfoJQ9MOfV72nQ/iyGeLYUunr83xT3Vf4uK8EVPvxJmJwMiNPJ3M5AZkUuR08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YDV6s6q+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YDV6s6q+"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2ej9B4061054;
	Wed, 10 Jun 2026 07:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=4O/YasIoNYi
	i+/J4m14X4tfl6j4zGgzz1LfTlngQT1U=; b=YDV6s6q+WuylEctvvV0m+1V7VFJ
	gGOUzk4WDjPZmK4l/7xxJA4Pc+DsriM8lRf35FNxQljeMkWo0sGAmyeYX/bk3tOw
	ScgNnPXWKc9e1O+Khy5X8F7/BDdrDVYOz/hFh3k86/YhlEaI2NnwYJNiRXGGKFqJ
	2byZe+ID07SzzoQCXRp7Jh068eoiS4yrltSNCILgc2UKpLJS2/2X4jsBhp9wjIY5
	FoRygcXcen/ljnGkzzLhOFdi8ns4I4XA08nt4sEY0Phr8gY42NwbG1nvzGz1h25e
	OJAzOQbUdRWn1WToPxqLsvmsPtPk6dDSujOErHltr6l/KkA0RbQhD+mbk/A==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epwnh18jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:26 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65A7FP5h006139;
	Wed, 10 Jun 2026 07:15:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4epg0b31gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:25 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65A7D3j2001676;
	Wed, 10 Jun 2026 07:15:24 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 65A7FNs2006125
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:24 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id AD834619; Wed, 10 Jun 2026 00:15:23 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Wed, 10 Jun 2026 00:15:14 -0700
Message-Id: <20260610071516.3763916-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA2NyBTYWx0ZWRfX3jc3lGX51mJD
 WOgWqEbZAIiMY3lTEs95txhXkuQycjIkknH83a0tYLcHe/oPQ6Zh2VUwfg793cj2SDynqMq3ghW
 EkfZ0ZZU3R7o9DNyG/Kf9qyGfPVm3stOORnjE4/BUz7X6isfh/lASNLqtB093iXQHw4QgHvITXn
 73p+8RPmq12H9Y0HneCSEWDsxl+I1gJQ0u5rAEYsBauGxtgjqWPtTkc2w59aMCb8JrQZM1OYQbM
 NgNvQ0Mh2qsqDOrfHfhoxKmrTgYCIkYE4E3bvTPuKhl4i+qYoizSTaWNNe+ONahG0Y+T0MwZZPN
 RKQXuAqsrC8rBljFKSSN2TReo7nhZUQW27yBMGErQqsYKoU4bU2fBJB/hHfP18zj41ffA59qleQ
 LBSrciq223uku18Ho5QRMmrfko7zmP0s0Kj1Ye3RX/ybv++grLLkmr6qVBpD/G8qZYPEQqmQjko
 5Lykmgzl7rgeqmcdh9w==
X-Authority-Analysis: v=2.4 cv=Xce5Co55 c=1 sm=1 tr=0 ts=6a290f0e cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=oqE_bcgN3C4SX9KZjo4A:9
X-Proofpoint-ORIG-GUID: gEM9LW4Nj-13qksCsuCRjQ7IORem_vrM
X-Proofpoint-GUID: gEM9LW4Nj-13qksCsuCRjQ7IORem_vrM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100067

UFS v5.0/UFSHCI v5.0 add HS-G6 support via UniPro v3.0 and M-PHY v6.0.
These specs define TX Equalization for all High Speed Gears, and HS-G6 may
also require TX precode depending on channel characteristics.

Document vendor-neutral DT properties in ufs-common.yaml:

- patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
- tx-precode-g6-host-lanes
- tx-precode-g6-device-lanes

txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] accept per-lane tuples:
<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

PreShoot and DeEmphasis values are 0..7 and accept 2 or 4 values for x1/x2
lane configurations.

tx-precode-g6-host-lanes and tx-precode-g6-device-lanes list lane indices
where precode is enabled on host and device sides.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/ufs-common.yaml   | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..2d53bbbe5865 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,67 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+  tx-precode-g6-host-lanes:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 2
+    uniqueItems: true
+    items:
+      minimum: 0
+      maximum: 1
+    description: |
+      Lane indices for static Host-side TX precode enable settings for HS-G6
+      only. Listed lanes have precode enabled; unlisted lanes are disabled.
+
+  tx-precode-g6-device-lanes:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 2
+    uniqueItems: true
+    items:
+      minimum: 0
+      maximum: 1
+    description: |
+      Lane indices for static Device-side TX precode enable settings for HS-G6
+      only. Listed lanes have precode enabled; unlisted lanes are disabled.
+
+patternProperties:
+  "^txeq-preshoot-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    oneOf:
+      - minItems: 2
+        maxItems: 2
+      - minItems: 4
+        maxItems: 4
+    items:
+      minimum: 0
+      maximum: 7
+    description: |
+      Static TX Equalization PreShoot settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a Pre-Shoot level as defined
+      by the MIPI M-PHY specification (TX_HS_PreShoot_Setting).
+      Values are specified as per-lane tuples:
+      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
+
+  "^txeq-deemphasis-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    oneOf:
+      - minItems: 2
+        maxItems: 2
+      - minItems: 4
+        maxItems: 4
+    items:
+      minimum: 0
+      maximum: 7
+    description: |
+      Static TX Equalization DeEmphasis settings for High Speed Gears. These
+      values are programmed to the corresponding UniPro PA layer attribute
+      PA_TxEQG[1-6]Setting. Each value selects a De-Emphasis level as defined
+      by the MIPI M-PHY specification (TX_HS_DeEmphasis_Setting).
+      Values are specified as per-lane tuples:
+      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1

