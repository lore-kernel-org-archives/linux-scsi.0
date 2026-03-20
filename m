Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF11229B12;
	Fri, 20 Mar 2026 02:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974214; cv=none; b=Bw80DcSLALMPqdII7EhXGGwaH+Z+Nahq+Q2AIRV7ydWt4D36tEd421ON+GbGF0Zh5Tkx8ecgUpEA5HN5VCmZ7PVex2Xa505OpQujQVOHBChZvNhklUDR64fwlcEzoKZDBPB/ewW6ul03u8IZ0+meFHPSTz6YeSb/wjQ64MBKdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974214; c=relaxed/simple;
	bh=QvD24xrW6XsNCfohBkSUAkLfVS9Y4DL0WSF9zNCjAag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXazp+cs0T5ix+NCUSufuSJCVnF/23ZmYaDDyPG11oFYFgwM9fBxcY8tywCqCuL3WroFZj8CDu8MmvHKIgJ6/qjxeifYNHYMDHf4xDMMxuSEFDGkxODZqRIy3j9fNje2CM28hpbIwSnwj+McDbX/qJaH6bollPH/BFAMoKRxezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U7BIXB1B; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U7BIXB1B"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62K0xker536248;
	Fri, 20 Mar 2026 02:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MqXfRDBGG87/SrtLAFzhwTQX9IwNVcNXwmFPCp3BRPI=; b=
	U7BIXB1BCDeOOrd0ASDnLAtkDAVrPAnv2IzQmBIXuGGAhZ1RjITy112dlJjrXtBN
	r8ecnRI96TKVcdAZTCQDdmN7A9FZVVbffIQxtjvphDrycHgPZo93uXwiG6ox3BI7
	5G1/G8Hc5pYMUrIpdhv+LyHjAO6IRfCVjWwfjslFmkXH2wYyKsiihApLcQ/IUOVC
	d2LDYaVRmLt2aAG8+zLM/EzJThLtM/YeMH6yRa3qcK5tWNS3Ja5SfQjIjFfOutQd
	bSKFqhtQVGVV/X+si9eW1Ia8/cN8Czet18gEYb1tZGzldCfpIwVpIjYKuAt2LjEm
	BOLHXf3U4lEVR6vfW0E8Gw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqc0v54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K0GBZk014272;
	Fri, 20 Mar 2026 02:36:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dnkfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:35 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aIsL027944;
	Fri, 20 Mar 2026 02:36:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dnkeh-2;
	Fri, 20 Mar 2026 02:36:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Heiko Stuebner <heiko@sntech.de>, Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item
Date: Thu, 19 Mar 2026 22:36:31 -0400
Message-ID: <177397022246.2845275.8137897176689873586.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>
References: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=984 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603200019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfX/qgaAJtOaN03
 jC14RcM1IXiaqoxIasGPyIwXgKR7YLYx9YIMTh4W7/pc5LgFxz8F1/kvh4MuAdA6fLNNs83cmK8
 uOTCRmvB2ULRoJSKmvSVgkdY+vSCZ4tVu0MzPJexd7BAH+9oTm8XWNlZnN4jYvE8VQYDSXtF3yK
 cNKpJEyUZHVPBLpWqKyGIiwL5ECoBYhi9Xl5Q7wWFZ1O4eTDmIvTYOo5wEqwq5FyxJgynWHS5KA
 74dLFcBhfI0lzuCrbn/StaF1BT7F0f0Aj9IEdFtdsXm7Qa/29E4aQxjNdFIdRHCqNa1np1akczU
 UCgjsN9g94jPPk8B3Xh/Q33RGFlrrihFohtO1acjcaQS2bbEV5Ktu0MGscm6Nz492YkMURkNV/W
 PyaIh/Yy/cXPYaL5u8RcyGqzEK3wGS7uuosT3o/6yssR+jGW2+355wTBiQJBSeLDvxI0YrYPemd
 CVb6+e0mlQsbwgrwNlA==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bcb2b4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=g6HomjI_0XDERytIjeEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uUqhXOy5OC20BEI76Y1a1ynCUPQ1vyUV
X-Proofpoint-ORIG-GUID: uUqhXOy5OC20BEI76Y1a1ynCUPQ1vyUV

On Fri, 13 Mar 2026 10:21:07 +0800, Shawn Lin wrote:

> Add the mphy reset property to the devicetree bindings for the Rockchip
> RK3576 UFS host controller. The mphy reset signal is used to reset the
> physical adapter. Resetting other components while leaving the mphy
> unreset may occasionally prevent the UFS controller from successfully
> linking up with the device.
> 
> This addresses an intermittent hardware bug where the UFS link fails to
> establish under specific timing conditions with certain chips. While
> difficult to reproduce initially, this issue was consistently observed in
> downstream testing and requires explicit mphy reset control for full
> stability.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add new mphy reset item
      https://git.kernel.org/mkp/scsi/c/bdce3a69c578

-- 
Martin K. Petersen
