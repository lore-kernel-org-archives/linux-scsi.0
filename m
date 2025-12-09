Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A28C28032D;
	Tue,  9 Dec 2025 03:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250496; cv=none; b=ZWhmFEA73gVMjWwait/szeEhWTqTN/p4K6WTYdKAPpDfrzMYS4Lflqg2MMTGr3ZEyWGPvib9LxixeS2y9SZNYQvdhhx7E/KZtZ6a8E52EKCWcT1jcYDeKgzgt9RPvWydZGtwdacDc3dZMxVbFCI4SvPwUNE1qmtVai4ljIfFznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250496; c=relaxed/simple;
	bh=d/XXNB65sLUucTftMIwCISB+YHYSN429PZ3+LoxT/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyTX9JK2xsBuIPc66EnDQ2Ew2kK0zCkpTXivoYEzmKMfnb/urtNcvg1TQCtPVERvWOtzR1x41ArUUgp4OZCJgQQ53Ul0KL7/tJFgLOLpYg6ZAv/5SuB7s67RNqKath85gjHbDtebPhKtkFc0pjd8MDqv4prphvZa0MzzyDdewWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qZ9ML4Td; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qZ9ML4Td"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92vS1B3948020;
	Tue, 9 Dec 2025 03:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=weEy+S0Z1lyyGzWU3jLBh93PVSw121M5tITOKAeNa5E=; b=
	qZ9ML4Td48t8wOGwHWGgIXPmogyF/msUDUD8HCoCYPGOtFMo4PASdOpUtVklDNpd
	v0q+8RnJh1r6vlTsEZr1djCluijz1vwnpXE8kvAgIQOpuKPFZy9/7yKROEkXwGQ1
	j+PIOQ60QlApljGdl0zslJ+Vxb5To/AjXuJ+CGPB0wcb0an0Faz6VaqaiQCH+Iiq
	NO0AxI9bf/O9rZQME0pyuAw/gLlqnH5umAbtt3aFT85i5OS1P2MS9RUajuz1lu25
	VTEUQ87RP+2OjLIe+zZMcCNC1CGWShYNckaaBNaq/xcEjZ1iGn9f9UNr39+nWllq
	NtszIJO7Gk0rPB4l0BynyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbe6r0hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B90fD0T038173;
	Tue, 9 Dec 2025 03:21:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j00b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:16 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4FO022652;
	Tue, 9 Dec 2025 03:21:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-1;
	Tue, 09 Dec 2025 03:21:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, avri.altman@sandisk.com, bvanassche@acm.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, can.guo@oss.qualcomm.com,
        ulf.hansson@linaro.org, beanhuo@micron.com, jens.wiklander@linaro.org,
        arnd@arndb.de, Bean Huo <beanhuo@iokpp.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig dependencies
Date: Mon,  8 Dec 2025 22:21:00 -0500
Message-ID: <176524933142.418581.1268132604546675930.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251202155138.2607210-1-beanhuo@iokpp.de>
References: <20251202155138.2607210-1-beanhuo@iokpp.de>
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
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=974 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX81FLlEGNNDSp
 8y00bPFA1fLYNSm+PGNZ74L1EizIZkfDVDzA0FMU0BAx8pcc+CSVfVhJUqskEeWqXQj0SxDYPAj
 9jeOMc3jVAU1VCI+57NTemigaPGP3CRckvuelJ+CF8O/SDJB/qEzzXGsnPwPTLXAwgz9bQT81qJ
 6TZfvRXmQMHjYp0eTzWfzkA3YWTmoljjzHfHQhdxUzOFF/sa2jOYwGTfrxMFT+B+XbTdrW+4D7b
 iC5woJMgyTOY9NODVi4Ou7MMoAmid3d9C/qa3ox7J1Hxf5Ft4zVUMAhTCEd9x6oXi+Qd7k0JSE0
 KmVHcU2YidnAGT0b4hdY/0stSZW5RzC5FS9QGNR/Kn6nGVOxIS6s0kExTv3c1Pzq3IHIO/VlYcv
 ivtz/2y/2PUfRDbsksV/zMx3GPygjg==
X-Proofpoint-ORIG-GUID: E3917LQcxe6Zvp8AfeQ2BTeHvWOSrcE6
X-Authority-Analysis: v=2.4 cv=dpvWylg4 c=1 sm=1 tr=0 ts=693795ad b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=AvJvqw9DESsLYVOFgXMA:9 a=QEXdDO2ut3YA:10 a=0lgtpPvCYYIA:10
X-Proofpoint-GUID: E3917LQcxe6Zvp8AfeQ2BTeHvWOSrcE6

On Tue, 02 Dec 2025 16:51:38 +0100, Bean Huo wrote:

> When CONFIG_SCSI_UFSHCD=y and CONFIG_RPMB=m, the kernel fails to link
> with undefined references to ufs_rpmb_probe() and ufs_rpmb_remove():
> 
> ld: drivers/ufs/core/ufshcd.c:8950: undefined reference to `ufs_rpmb_probe'
> ld: drivers/ufs/core/ufshcd.c:10505: undefined reference to `ufs_rpmb_remove'
> 
> The issue is that RPMB depends on its consumers (MMC, UFS) in Kconfig, which
> is backwards. This prevents proper module dependency handling when the library
> is modular but consumers are built-in.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: ufs: Fix RPMB link error by reversing Kconfig dependencies
      https://git.kernel.org/mkp/scsi/c/d98b4d52bff0

-- 
Martin K. Petersen
