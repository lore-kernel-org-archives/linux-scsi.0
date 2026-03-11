Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFBDEEBB;
	Wed, 11 Mar 2026 02:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194789; cv=none; b=QryK+a49j2MpUFEAnyKFa+1y+EJsr2pe5AH/RXXskgC/EMJ6dXUIvZYrHJACvXwmWe008CSN/5vvV99lpS7dygNfhe7w3dgZ+jO5kEDCF2c7Kptjraqii9C/4KAihbIOVMcnpjiyRpVrYvjIc/8RLcxymW4IOrcrQ7Nt5pNjp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194789; c=relaxed/simple;
	bh=eH84mDzMoUSx+DO97DUiav3cqzdrODjdBjEOUogQdtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZTNSmiVsC5Blu/Rg5aJ3FVxZjnQfiNxXlMoGbYWinZFdbsF6kMt0tqJtTpJFfQ6/dapsQAHuHwe74d/qcl1ZzKH9uN+pL5/aItAAp5LFY1136R14WGkMeQTcppbkKOc4H2G9FgdaTXMLrOfnJQKDakD0yTT9lbU5GRRI/qO2/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aFbrSthJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFbrSthJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJJn6D2773171;
	Wed, 11 Mar 2026 02:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1rLRblBrv1X4dy3lQ9o2dSE3+cTugXmlj4J+7BN0b3A=; b=
	aFbrSthJlzXh0/iNDz/AQcyqgrZFFvnc1AxeRjty+S7UyjVti1IOZTYnU5n0J3vY
	hO5XK7tehAxc3e5bV8Yda/TJhAUBHYaBO1913PQEIr1cYNDkSXaEmPUjx4QAb5sK
	1z7v7/Rp4JCKtfhVLsE5aDAeb0j7X7firVKp56OG3lxbLKgXoPsi+aIgpOx04v29
	/CX1KRNmoS0gUlXFcMcmMj5lKJBRqsVhQ+K+JjU9QGR4+kH9lfkGxLeG+es8TGQN
	op1KH3jp+2giQs9qtdev9xXqGHRqzTEzz1DjW52QznBlJ01l+WUegEPdDVowEb4U
	4WcyQ2awGwg1S+WFDLBN1g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnum3v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B1dfOH020383;
	Wed, 11 Mar 2026 02:06:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafewwjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:22 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B26M5H002770;
	Wed, 11 Mar 2026 02:06:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4crafewwj6-1;
	Wed, 11 Mar 2026 02:06:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
Date: Tue, 10 Mar 2026 22:06:12 -0400
Message-ID: <177289787691.2131580.9670043505735836826.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209212151.342151-1-ipylypiv@google.com>
References: <20260209212151.342151-1-ipylypiv@google.com>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=942 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Proofpoint-GUID: 7Mx2xLVuDMqI0_uvBPQfIO9qzh0DirNl
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69b0ce1f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=cJe_iYIR-Q0b45NhNDEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfXxg+6SP6DiYUn
 r5RiV+1vfX746RK2sOBcBvFNyIAnnz6GZCKI4BjI07h8Yz+s7TkRF8sRIUYLGsZV89pigiOe+Bj
 CfBoRrF1Lmz97uANJI4MeLBQ3MInBRibOsFhvHIqi+JJt1T6SmcsEJW8ubr1+WFEk1Y1DxFpVvw
 9hkffis8//yJ96tBZFBu/bitO2mIAQ0ai7q++ZEMRBg1GFbb4e/Gxv9+NC2rKo2UaFZcu5s1olF
 UioRTthj+zSBiTDheCDGYm9PAgk/+JWLtJLVdZwC3e031s6Fi3krcw4n1b2JWvWtjgMikszamnF
 3cBS8rY+lf4hYnXr9+juvbajAYMdnzApJqbkds2Dgfxxn/x73QTu1QjvatVRfPaeLEz6BJ6p+vB
 FaYq5Q3owUvC8WKU6OTlLhkAjE2DimGf4nEGTskP1da7DUOABxsX5c6dB2GO7xBHu8GLgE0w1Xh
 UlgzZg9gX43iKAxCIgvOZccipvMRENBAqEexW43U=
X-Proofpoint-ORIG-GUID: 7Mx2xLVuDMqI0_uvBPQfIO9qzh0DirNl

On Mon, 09 Feb 2026 13:21:51 -0800, Igor Pylypiv wrote:

> Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> exposes the Unit Serial Number, which is derived from the Device
> Identification Vital Product Data (VPD) page 0x80.
> 
> Whitespace is stripped from the retrieved serial number to handle
> the different alignment (right-aligned for SCSI, potentially
> left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
      https://git.kernel.org/mkp/scsi/c/94c125bafa00

-- 
Martin K. Petersen
