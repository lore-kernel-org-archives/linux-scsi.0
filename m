Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65172877F2;
	Mon,  3 Nov 2025 03:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762140567; cv=none; b=MipA6IRqmMnYHM+qluY7o6zwVopLqJXkkEiixlhP2es0GUibM9uArbAPWqwt+aEvwi8DsjOzA5cPuXgiNIQuOlt6G0kbURoubgyUaDPRV/ORsLTVbp87oTufb45F2eEM7agrYzTGREBnl8lx4JgltdUkhe4pnirPdvfnO8uQ6sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762140567; c=relaxed/simple;
	bh=zpycrsUMNzTebiN1tnAQRjsi/DtYH677l3bvR9KCA4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDJfyvkxMjVTy0sEg43MKN/CtHQ/02abJiszeXMy30hPf1kDt/BhogzPI9S4cmYXdUoKa/T4O0ybC9iRsKp2nOt+YmBF86pwj675eWMJ9d9a0x61tdigExpFxDJPfQ0W+pZEYPLetloSHQIK5f+2+Xh9x2wtN1q9wvwCU/dg75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M3gfTRHI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3gfTRHI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A33F5eZ010921;
	Mon, 3 Nov 2025 03:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Qgly8A/dLXmhgP+e15Z2m3GsTokIMedwfFkWKwDr3I4=; b=
	M3gfTRHI5wh+jgcRJWUFc+cTCH7nXJ7gcwWSk7AeJq+p0HzUqIeWw9vVd4xSqGzQ
	5t2vj7NvOJ+NhBoh4pHYByYr1fMbJrP7eRXKBd4X9+qfxH2uzNfo4SK0y6KZbPEY
	h6WekWVbUo5psKT1SYk9/GMPe79GC/MK4Y3XOiiaoOJI+nYBQZ4SXxFaVj1PS9HJ
	zBUywbM1+8aBVwSHZ2QO9kodSLwx0nX1rVl/zOFjvdtzaXXm7nZaZvCwbalYmlzB
	UizQxeevRDehv1pFvGnEEt27OH0AE48bfXN+zTHMDk6D38r+xMiaIMYVtvRPvx19
	u+RhMaa+NRLpDlHQd0VNBQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6mahg0kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 03:29:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2MXj0F016143;
	Mon, 3 Nov 2025 03:29:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n7av7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 03:29:13 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A33TCcp011931;
	Mon, 3 Nov 2025 03:29:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a58n7av6s-1;
	Mon, 03 Nov 2025 03:29:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, pedrom.sousa@synopsys.com,
        Ajay Neeli <ajay.neeli@amd.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, git@amd.com,
        michal.simek@amd.com, srinivas.goud@amd.com,
        radhey.shyam.pandey@amd.com
Subject: Re: [PATCH v2 0/4] ufs: Add support for AMD Versal Gen2 UFS
Date: Sun,  2 Nov 2025 22:29:06 -0500
Message-ID: <176213716989.2123602.10337247781222345446.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021113003.13650-1-ajay.neeli@amd.com>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=725 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030029
X-Proofpoint-ORIG-GUID: ZUXgNiq0VfNQJ13CVzwDbVsz-Rdys7LA
X-Proofpoint-GUID: ZUXgNiq0VfNQJ13CVzwDbVsz-Rdys7LA
X-Authority-Analysis: v=2.4 cv=Fa46BZ+6 c=1 sm=1 tr=0 ts=69082189 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pQfcJMmlV1QRne_P_tYA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyOCBTYWx0ZWRfX6fsmS+TQkWDp
 SlPsJh5SGp3+rbEFBValRe/R4S/JVviOnLwMQcwOfudhSzBL8No3tnaY0z4Ttp8uBYQRpwXGv4M
 DIbOockExooMWdbqlzyhE6v0aMgAfrrRFVWtivySEwFNcasXEk8X6qxoz35Sc29ZonSjv+g6vp5
 rwRzSbuSpN7m9N1RdSQ/E7M7zQodIegJfwGpJuNo3RfzZLlv6vft4zc6xvCarAb4jx/iKsNgFib
 TSu0By3Iqw2nfEBTRcUTO92UVB5LhrfYnRO707AFNTJtnwJxVKFK6BlTPJ9imNePkS2DT3f3SQv
 1Vx8sgIOtpRUG6th7XV6qr256hbErSE85lYGTRaE/ThLVd+2Oy1XCw/VCeVKqameRwxjqEE37dh
 8GEGf+AppHoA7cQlw5wfxsOdThfh+Q==

On Tue, 21 Oct 2025 16:59:59 +0530, Ajay Neeli wrote:

> This patch series adds support for the UFS driver on the AMD Versal Gen 2 SoC.
> It includes:
> - Device tree bindings and driver implementation.
> - Secure read support for the secure retrieval of UFS calibration values.
> 
> The UFS host driver is based upon the Synopsis DesignWare (DWC) UFS architecture,
> utilizing the existing UFSHCD_DWC and UFSHCD_PLATFORM drivers.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/4] dt-bindings: ufs: amd-versal2: Add UFS Host Controller for AMD Versal Gen 2 SoC
      https://git.kernel.org/mkp/scsi/c/754c6f539eff
[2/4] firmware: xilinx: Add support for secure read/write ioctl interface
      https://git.kernel.org/mkp/scsi/c/00b3e8480be7
[3/4] firmware: xilinx: Add APIs for UFS PHY initialization
      https://git.kernel.org/mkp/scsi/c/0e4d26f79a74
[4/4] ufs: amd-versal2: Add UFS support for AMD Versal Gen 2 SoC
      https://git.kernel.org/mkp/scsi/c/769b8b2ffded

-- 
Martin K. Petersen
