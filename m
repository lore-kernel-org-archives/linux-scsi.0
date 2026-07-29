Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502039659A;
	Wed, 29 Jul 2026 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293800; cv=none; b=TFqCdCERpdt+YKNyA0AH4dHWTb4dMC/OD0zgtDbNviYoDuXDy2Y0/5hJ25mu4pO+thsqgatrpn119oWTwWMvVwlBRbgsGamkPgzcykXjZn/7Tf5HDE005oGpm1a6sciotfQ1/i7VM/SXtzvlZ2m9u90uj4rxqBXaEqH5lVxQG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293800; c=relaxed/simple;
	bh=HeDG8zxBtRfgKpJEIIAzqHrB1eVnlJnTJ0uTG5kWf+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=abxBZMUWQ7GuKgZEKyGJQ+AoM145xBlt4Foz8YZTKz/PsKzVDjmcYbQMM2SECUwpr8neFcj3JhKIrDMoxgKB4csmBr9SG/ZfGDe79UvkaH671IfrOVy7kZ4QYTn76nBLPLnzySJr+Hi5HBNb2PlaeOTx3NjaCLARQXCUkxghNNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ILX9ygqH; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ILX9ygqH"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYIk1094343;
	Wed, 29 Jul 2026 02:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m5fUU2sK1VnSiUr+PG3BaHBxWiKTdn/SyMV4j3dspGM=; b=
	ILX9ygqH7vbwUYhJEKArR4HeCn75pkvMQSo8xbAQ7N4NEwkCAf/aDbHWn2JkDPB9
	peTHtyuHt7bgWagenQIkvFOTQ4qsj4nEa2GwVCN5aJGectG8Q0aTUJUmnFebtHB0
	er1FuK4MNRbQeWqWY1IPkwH7sT0B7kTLaE3j1LZHyq/NoG3EYbIeUbiZ5YXX70rO
	Jqv4/XaJQKsLfxgDr6xL3gg9J3jIahjQc971DpESgwtWa4d4uzEXhkVQ+iRQojyX
	y0qqmalgKfXnbyGGQFfKJEXKIQukVebIsJM+ypBXgZGxqtOTBxnnwlKybUKvgoEh
	+fgP6/OafgjZEdr1O/OANw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym540y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYOo034630;
	Wed, 29 Jul 2026 02:56:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMAF006812;
	Wed, 29 Jul 2026 02:56:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-11;
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Anjana Hari <anjana.hari@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc
Date: Tue, 28 Jul 2026 22:56:18 -0400
Message-ID: <178529373848.132455.4656284480950878568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
References: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=751 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX4PHP6cXExD26
 0vlE1iF3JvYYpwDhJAayFkK3iAhg/ZRR4FbUA3IeDqRsVAHPzah88DKT7dYBzZ1Gn/57d/YCS0/
 enOpUHFg55tG/CEQT6+y4rMX2OjK9yIDGfJgPKR934d6NDLNays2
X-Proofpoint-ORIG-GUID: J_RdDsVaafSjPxHFtYLGqxD4uqqYk7hH
X-Proofpoint-GUID: J_RdDsVaafSjPxHFtYLGqxD4uqqYk7hH
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a696bdc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=WfiShAZ5_vkT_QGmtBIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX8N+UnrQW0HCF
 k1lPixeEhcy0sJS3dBAhJajzpYMeR6lh0I/eZ+QJkBsQ9Ok8qLBS+P3GAcfofyANHIpGY5B0BNY
 W78mr9ZiMcgZkShB/lVgwgvN6JKq8Q3jJ5bL+2g6Dx6qsVm4mm358l0HmIA0ScJgLKHOuL0xeQy
 0MWQPNcpgdMJRANAWW5/QPKeBcbA/e0LRnYwYrqGPljVy+goi2PrfJk0b/x0IUwhDvPbP6gKbmU
 7X+CRRbZIEDTb5Rb31yOJHN7NUaTjhT6991No7mLMkQGm05v+2u6RX01pYnZi0mCBQrR0mwuXF+
 U9EO/WVG6BZxJmK180HHPuT8eY5sCIQn0rQnkhE4dN7IRhRMsTOFdhx9gcMd0LARwaOLxGdgSAh
 g+aGAAoZEYQDpfEkXtdGjzHbp0FjCA59+iMKWW7x7c8/9dI+im150E38a+ncutbgK9gQYqUPpky
 82J8pY5DngZz/GN1xM2IMZNpsG6qzFCWfbVo6ByQ=

On Mon, 20 Jul 2026 10:35:52 +0800, Shawn Guo wrote:

> Qualcomm UFS controller found on SoCs SA8255P/SA8797P has a MCQ I/O
> address space. It should be defined in the bindings even though Linux
> driver currently doesn't utilize it. Fix the binding before it gets
> adopted by DTS.
> 
> 

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc
      https://git.kernel.org/mkp/scsi/c/4d5282c06ca1

-- 
Martin K. Petersen
