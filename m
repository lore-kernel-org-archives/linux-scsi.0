Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795779831;
	b=lPJsGzh5FM0/2XIFnY8DTnIlmO5WwGX+7JTPRzRVoOQt2/CCn5mNYJn0WshqTzB13MhU
	 Cpviu3J/fHOk24xFq+iKcyL8jUmgnbozOrt7ggttETysjBDaOvpRkEJXq28oIDtK1krfg
	 mBqzfe3VhKsCTL0Wv7GMvBWhrQpyA1uRzvX4l2UpyfxTIKkfikyJG8couhAEoqMoBOHIm
	 cr5l+wUtZClFe0Gl/y2jvvBoPVVnJS5FTH2dCOdjuwtRvNUMptUslDUa0T94YgrcCaaFN
	 nqGK8tlsTYcxA9Cp7Ajkn638tQuJJzWDP2IeNyMGm18LGR5FoPhv4OPbmsshfQVbQAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779831;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=2FWKC11Q8JRJxyS1O2rUXDgWS3Xb/e6DBSv/HHDpm2M=;
	b=3eJ1Q5bjGIbDy1QdG5EdATSFQH3SwvMwZcg2vlXwkZtjMIjUpcSRA1bNU/QtT9DZN6AI
	 gEyqOQQebA5T3h6ZvJJUPTlyKQ8uA+D9vfL4am4/3h9M3as5WRJXvINVByLSc/4ac+pHz
	 sNbu4YROTGQ1PS6hTaNB0bfsjj1VacptejmUhgT1iV9FZV5MIQPga7ZYplzSJ9PcKAxm5
	 4RaaExueYuvovGWXEyNvnEWM2Wid/wEito9Vpf+2HhTCFNP222blgmmD08hgQHX2fps9A
	 51+gDZD53aOE+6yeeoHRpiU+eI+LhU/YdhC9KPffuhEoa+lumvD3TJFrNLkPFBQ00Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V00wB9Zs;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VdsMifOn;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04262606A321
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 11:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04262606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V00wB9Zs;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VdsMifOn
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARApYZk1685697
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 11:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=2FWKC11Q8JRJxyS1O2rUXD
	gWS3Xb/e6DBSv/HHDpm2M=; b=V00wB9ZsquyiB/MvUSl0UpAYI3bR6YQ6VMUBCJ
	yDy8BYmFR5LXnM/kw+FUplzcR4vnTzVbLYSQDPGK0GIcj+0b5l02NtDWAoYO8ZkG
	H2T8p77B1P98DC2krk8XDcdaYQTTbm8e+Hu9YKcO23DzE6XSMUO0hF3KgD8kzW+x
	Ya8BJT5eLQ7zz7GS7ZcAXIji9jWC5MUhWaNddOehzBpskjwnni/wEUqBT5S88K4c
	aGN7Fj9Ludv2CP8BH9Vh6PZmTTea9IqxVIiW9JuEHFr9YoRys9+fZrmZh1MpbE8C
	ChE7FA+ySIoIrBuKlmZm5wS1BU2XxDmnLvC5D+N2R+1L5ldg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j756k9316-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 11:43:49 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-94960bd17b5so1251324685a.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 03:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795779829; x=1796384629; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2FWKC11Q8JRJxyS1O2rUXDgWS3Xb/e6DBSv/HHDpm2M=;
        b=VdsMifOnsnMJUEnemlJjRXf6LYQkmbusjz302sgni+NA97LOsu5hR//KhDHfYVAG+b
         lsrYceUmR9ITSyniB58dXsqhNTJKP/yFfG1vfUWlojchLs3pfSZ+ykXwThZ+zQxSeEt5
         /oAuYV+NFMgkfCgEF4CdeH/WahOSuRkm/djF5mfleJp/dNn9taGel0W0SbBNJFrGaKOL
         OLvy7a6NveNMktDsB988QDqd4NuKl1U6sCm7k9XemCs8D2FDLZ4iDHrHc9VXGmfgGly9
         YWoRSYC56pI1qdxy2UMNqXgOmQ6esCD56i4V7Ijxh/svwiMl2IwZChPynW20N+KGCsMA
         oiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795779829; x=1796384629;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2FWKC11Q8JRJxyS1O2rUXDgWS3Xb/e6DBSv/HHDpm2M=;
        b=QPq813fJ38E5RgkxTj5FVBV8ghnFk/42/jg6qoa+hIjYwovnVsrYoeoBZmD+7QDVzc
         /3vySGs3JpFWRlB0ASNpVKGoCJev3ulX4O3qG2LXMmGE3M0oTH4qEG2UpoLz1nXScm+Y
         6Axc8kg2Q+VBiUtF/Fs+ceextYKwgJ0wgxs1sMx/iN6qJb2GAnSCQYRp8NPJLQ1BAliF
         oDqNvQ6Qs7FQBwBSg2ONuurhdPDaGTVWRiEbdaeoG1Mi87LrhvbwdZsgHepNJayed/M+
         lW6nC7tm+H6OiYDOg4kDNU45NovmEEhT/AhadKbE7CXbLufmWso3jt8iZeBqGV7CYu+K
         hzvQ==
X-Forwarded-Encrypted: i=1; AL+hErEkSmkXs1ZPKDD+QI1wQmMM2kHQh7xordbEXbIOHcHolWF6J8iAkBfE7nEBbJZMBYoDCJHhQwjkSRpi@vger.kernel.org
X-Gm-Message-State: APuU4Z/dQ4PU9hgyXdpNHjze4b0/8lvsPEmklbAqXS7gT+KQe3NgrLKb
	zGM86MZl7g6R0hm4kDuiuvbFLstjWFws8llsU3gnyeFV5NV5MPKUoV8CrPiLRrRRdbjfXpcjfvb
	MnrqvgBxHQPxH79NYas5kSxy2XaLisd5qRS8Fhygi0L7R8Rok4+EvwbZgxoIGRxitD7f6n+rX
X-Gm-Gg: AZFdTZe5pYEt5LeOPHFPnqN2KpmTgwgVSFgCreR2FxhUvs82ZHG4oUpukdqawpkYm8r
	p9bO/9N4KI6Gwax/9IGxTzHwhbbPlMg4BVSmFRih21r8V27y5t0UHrbQpgtk8JePSFIfHjBDlTP
	TVNXanfTZhrXApurqZck4gLYPiAGzjjXra7IejFW+nIWQ6MOQuqfn0qyoTK2pZPWLA3qcGfFGsc
	QtKH+N0eOgta+0/yKgRnzq22YezrM1O3CGABYKPohi9kGhA/cZZrsX+H4rTi2q24X+BDH0V5xos
	TxgFIogT7b1skCsj222hs8IXsQzyIc8ftuCGQYQzgjJI4tVWkvNVEmCDfkvQ77a+X4CvAYl8uVa
	3DA9LaSAKQamnzlv1mCXg4uPE6B89rt8eL9GLEASkT3aJa8rEYAhFxg6nWkasZyGecz/gvmvk9K
	DvqSGCuqFbFVfPl07LwC6v/trYPZLO3tQaQ4aNxmuVCUPwKa3IgeBIdRFFsgOMOLI=
X-Received: by 2002:a05:620a:46a9:b0:949:730b:53e9 with SMTP id af79cd13be357-949ba98d292mr4242565885a.31.1795779829388;
        Fri, 27 Nov 2026 03:43:49 -0800 (PST)
X-Received: by 2002:a05:620a:46a9:b0:949:730b:53e9 with SMTP id af79cd13be357-949ba98d292mr4242562185a.31.1795779829004;
        Fri, 27 Nov 2026 03:43:49 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110ba3sm38340537f8f.35.2026.11.27.03.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 03:43:48 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 12:43:46 +0100
Subject: [PATCH] scsi: ufs: qcom: dt-bindings: document the Seca UFS
 controller
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
Message-Id: <20261127-seca-scsi-ufs-v1-1-4af7bb40c4aa@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAPFsCWsC/x3MQQqAIBBA0avErBtQiayuEi1Mx5qNhUMRSHdPW
 r7F/wWEMpPA1BTIdLPwkSp024DfXdoIOVSDUabX2lgU8g7FC+MVBV1cwzBGtdrOQW3OTJGf/zc
 v7/sBPCqFvl8AAAA=
X-Change-ID: 20261127-seca-scsi-ufs-afbd89f0b74a
To: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1523;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=fIatVXM2YMo39/HpbLiSCfTsiSk6gCOVc/Kg3EAaVIo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBrCWzz3ZCSNuHPktUMQlOMNuBxnVZpxVX8rpwUZ
 +QSWQaLzL6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCawls8wAKCRAFnS7L/zaE
 wxarD/4h62VN0p6xtqzVT30rV0ZldJpxzPlhGL+ar5plW0Nxj6Jj/oquKk3A5U4d8X9qmZsRX/B
 x8b6e+eD1vBxVbi9ynXsSwf2meZXDUSL2InmBVBrzBSfSJkotelAoEC9/Nzxxhxd8TBEu54rlRM
 p4oRjlHF+z5oBb7PnvzUka0hH4y1nvYmmoGP0zuypnDk1DFsXFXQe12foqv+/n3qYYZY0i3j15O
 o/7EyR3Yv4BM3Bbi+wSBwLT4mizoxkhv2gGtBoGxBBym205Z2aK9ZepaPN/k1g6vG9qn3Ej3ur7
 7LTmdEB1+tkJS471QY1bvPTwmnFuIUyD56A/VWX2BHcol12v5+5fViV7uItodKuZ5S3jK246bNO
 l4hSbPOdlt3ScpaAKc4Omxuq0Oi8jHBns3JyygOfE1QldLeGXQnH0+Kh0z/TI/iy203Z0ivqG7p
 KFMFDqHlgJYeMY9d+j3y59rRw3Tyeb7z8ThwnpyiGhXXhQi2vnQNBFlECG11OX2SIKbx7H5H0MF
 Vn65KZHdfO197guJ6rxxKnhpLQoDOn2VC9oUm0gh3Fh071mkx+kmZO4T+ui6Kzgyb1aZCD01zxW
 NOqytgtsf096E8am8R97JYjib/gIvKFWEsWpxEHcAdmjzgERDQt7cqzGbP2WcnnfqZZU51PZre5
 AYb70ucF1bbxa3Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA0NiBTYWx0ZWRfXzHDzDqO0Dx4K
 rwtVF795mND/D4H9t2ySQLW+q43ZFkeOSork8w7sd7U/NRhT/A9b93chYKABpKLOb24I/fG3rD4
 h7//AHBgUqv3MCUuRbHsvQ2aKVFdHYYU0qVtvA6ii+vncNOQciBMCa9AxwkjsLC9J0q0FP8lGNH
 Ig6YX5a7Ok7skHPM0E2yMJQnnsGLnJjByjjnKGlWTa3HMaUcf+ErdYm39y5M59nVtfUwloWnEOq
 As3L9o7O4+jdgwl+N/QzmAB32Q1RsFJA+JIqvO+1vqlcf+tYb7GgOqUWjxU8fAUjR5tkf2Do2mU
 kO88mqcv8sZ5zpB1ClegLn+eZ15ENeWstjWmBLEFp4eEGRICFVbm6s5YBwxv6zNDnUblk698u/0
 +pAXrjGH7VH8FDXcP9R9lByH4xx6QksnSsrhcplG9bHNWZlohhb0e61z40MY+X9qnemedyVZCZH
 fLRrZ1+nRyGVgHCGEqw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA0NiBTYWx0ZWRfX3ZMam5VMsaA3
 n0cKfua+q5ruqNsRbYBLidbitMWuqSAX/mJgJ6b29KkwW3oY//5Y1vqtgq2CIS4ukHgvzZAxjUH
 y1Bb8WJur6+4DPFtbUW8G83/2pUuD+k=
X-Authority-Analysis: v=2.4 cv=ebWo7LEH c=1 sm=1 tr=0 ts=6b096cf6 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=dQ21c57GlSjXnCoPd7EA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: bAV2L3c5qDblQliBGkOwa0rB04dENjvm
X-Proofpoint-ORIG-GUID: bAV2L3c5qDblQliBGkOwa0rB04dENjvm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270046

Document the UFS Host controller on Seca SoC. Seca uses the same
IP as Nord.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index f132b1a9ebc28165ebf3f3b74c7b110f5bddeca5..511de834e1c7bef2ccb7f49e0ea193353cb9dd92 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -21,6 +21,7 @@ select:
           - qcom,kaanapali-ufshc
           - qcom,maili-ufshc
           - qcom,nord-ufshc
+          - qcom,seca-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
   required:
@@ -36,6 +37,7 @@ properties:
           - qcom,kaanapali-ufshc
           - qcom,maili-ufshc
           - qcom,nord-ufshc
+          - qcom,seca-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
       - const: qcom,ufshc
@@ -85,6 +87,7 @@ allOf:
               - qcom,glymur-ufshc
               - qcom,maili-ufshc
               - qcom,nord-ufshc
+              - qcom,seca-ufshc
     then:
       properties:
         reg:

---
base-commit: a9c48428cbd8d96b26f92631d0db6f8519c5fcc5
change-id: 20261127-seca-scsi-ufs-afbd89f0b74a

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

