Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AA36C9EE;
	Sat, 23 May 2026 13:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779544064; cv=none; b=ojA5XHmVZzlEh62cCo/hlMWttJdVOYggW6qxayDNQI42dcDa1NuKYOMQouhMe0pnlTkEY8NF1uabgdl0ovs2ALmIMQRDGcHClU/eRVhYtDVTOuGkdf+y2yL4oE6qYrA4rtnp5n41Uz1pm33AdDlddg4F+lTVPck7QSr478EPXAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779544064; c=relaxed/simple;
	bh=B4gm9pP+88IyVqw9AfTTIVVlGJusAq/2/0b2EiHNMzQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V4kF0Rbwz7yJCm9WDYXDtf1YjeVfHqY44DgwYzDcNebxRJOlGJtrXCPvwGD1zCAGIJblF977qRTZwWiql0TVSwRFNy9cM3P8wBGdoffLLSvPfMSs/bwHUkE7/lcIiySb9GziLu6nv6NZ/R2/S155ldosNcnBxOMuml8d6SpmD1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EkwcMPf6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EkwcMPf6"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N51oPk492201;
	Sat, 23 May 2026 13:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QDmQ9U+JNxb
	EO0gcsaYLF8lGo8oTH0HPmPD+4YMUfCY=; b=EkwcMPf6inEwYbaKvwtbOgVAWUb
	eBBck14FEaoSpeCmbbXR9dPmL16JJF9PfdERjXJItlLRhQLpSUo/cP3MakT55jTa
	/QSP25cHUJWScHywQROaaCCRnKn79B1pLZYv3xI5K2hWgT6O+s9jGKCpjvvZ4eWn
	KXPdlpdmQN9r7ZxZP14lX1vruAkmuzGkLeNu8fgfGzC73gDWrjbcWQtb7JZ920WW
	+9UaWmmGpAcHdCUJAJIsl39DkI1SR6twqxwoOfdONXpmeOHGLpLFKmljYujCFepP
	OefCqJqHqyfnJ6gN21CYDYx3BE+KBNj3a1GVbIXvlLQwj9Ix2yF4ARDOLNg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4ass1je-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:20 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64NDlJ3m026938;
	Sat, 23 May 2026 13:47:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4eb5ahjyvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:19 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64NDlI9I026932;
	Sat, 23 May 2026 13:47:18 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 64NDlIik026931
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:18 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 9B90C61F; Sat, 23 May 2026 06:47:18 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo <zhml@posteo.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] dt-bindings: ufs: Document static TX Equalization settings properties
Date: Sat, 23 May 2026 06:47:10 -0700
Message-Id: <20260523134711.323425-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
References: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDE0MSBTYWx0ZWRfX60Tww3EPf5nK
 pBkG40fRZWFFV+gWKH3kk5V0A5V0T5zqSlqu6Tw67Ow2Ehtp0UVCwJ67ZbUdR5Fds0c3GN272uC
 l0bOxxg57SRQ3QMYnhK46SgtS7+6RRHwAa9tw8NzMcIabFAbECniwj0NUwfTd+7OTvP06zinZ5N
 a1CfBZWqhcLEz8+RQlQ1xhgTjyoFcOwV244qCh22DzsOjfXORz34RfFHv5TQluUUJ2SToJOzcbK
 vyEq1LoYpxIMmbmLp7FRYwFhKN2/+qspgFeL5ZsNdoR16ZtqFT1PAbzCqCafmA7q7oLSQUCJuSi
 HroObotGwLG0oV4EoSYL93sC+9ezDTdQbgdfSobfHZgoCXEi0SrLYkamhU9UQGOqmngYzb2t/pZ
 bfjL7GXSVeAPJOqKdZZN4vX+f+iU+ouh8DAg0/QdELWggZQE/Tw7s6rH4inByE3v4l5UpMMzjnn
 oEPkTKx4c+Wz4ZlqG0g==
X-Proofpoint-ORIG-GUID: OAzdKCJNzJU62l1N5GPqv1UiaZ7C_VYA
X-Proofpoint-GUID: OAzdKCJNzJU62l1N5GPqv1UiaZ7C_VYA
X-Authority-Analysis: v=2.4 cv=c6ebhx9l c=1 sm=1 tr=0 ts=6a11afe8 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=I_qBOUeEE_endWPDY1kA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605230141

UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
and M-PHY v6.0. In these specs, TX Equalization is defined for all High
Speed Gears (not only HS-G6) to compensate channel loss and improve signal
integrity at high speed operation.

For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
required depending on channel characteristics.

Add vendor-neutral DT patternProperties:
txeq-settings-g[1-6]

Each property is a uint32 array of per-lane tuples:
(PreShoot, DeEmphasis, PrecodeEn)

Tuple order is:
Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1]

Accept 2..4 tuples (6..12 u32 values) to cover x1/x2 lane configs. These
patternProperties carry board-level SI characterization data used as
static TX Equalization settings for each High Speed Gear.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/ufs-common.yaml | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
index ed97f5682509..bc83948fc168 100644
--- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
+++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
@@ -105,6 +105,17 @@ properties:
       Restricts the UFS controller to rate-a or rate-b for both TX and
       RX directions.
 
+patternProperties:
+  "^txeq-settings-g[1-6]$":
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 6
+    maxItems: 12
+    description: |
+      Static TX Equalization settings for High Speed (HS) gears.
+      The settings are specified as an array of tuples (PreShoot, DeEmphasis, PrecodeEn).
+      The array must contain these tuples in the following order:
+      Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1].
+
 dependencies:
   freq-table-hz: [ clocks ]
   operating-points-v2: [ clocks, clock-names ]
-- 
2.34.1

