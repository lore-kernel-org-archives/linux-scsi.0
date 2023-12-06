Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XJhYDXEj"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5011B1
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 19:16:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xo5s030190;
	Wed, 6 Dec 2023 03:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=gih6VplaBwgPmDYm56961vYKZDdSCGMuSXmBTkqn9ZE=;
 b=XJhYDXEjynTE3/86d1KQ+wHlefWw7BDqwqFG25Ui7/fXVcTS+guhcWDJw+KaBz6fCU7c
 TlbTPTbwwWTOSaVSUirphWjQo7FkU04ApxA0I6M2+OLtYw6q4Pm1AcKWVe9fxz1YyVLU
 RvJ5y21n2f71oW92nYXTaaFZOsGqCfvnBczwvrGOCVqDSrt7iHkJA50AD90gZE8fi04k
 pVWvXqpy70dsZ6M5qnsFER4pC0KOjHyCblyYjmvwbuVNDR0/Z1KQt0Uv+tfa6yA1J5ep
 h8W6jtRgAqPv6NdRRmqR3V28/WtdoOKy1PhnpEtBDlJ/s4kJe7I1KVHzqRQv7UHFHYJw 8w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdda07eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62KTqk035510;
	Wed, 6 Dec 2023 03:16:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan9685k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:14 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B63GCYR014062;
	Wed, 6 Dec 2023 03:16:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3utan9684d-5;
	Wed, 06 Dec 2023 03:16:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        chandrakanth.patil@broadcom.com, ranjan.kumar@broadcom.com
Subject: Re: [PATCH 0/5] mpi3mr: Add support for Broadcom SAS5116 IO/RAID controllers
Date: Tue,  5 Dec 2023 22:16:02 -0500
Message-ID: <170182644881.1446429.11619807517697303708.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231123160132.4155-1-sumit.saxena@broadcom.com>
References: <20231123160132.4155-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=871 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060026
X-Proofpoint-GUID: bep0BefBHjZuIE_Y4clUAlROz24CW9qd
X-Proofpoint-ORIG-GUID: bep0BefBHjZuIE_Y4clUAlROz24CW9qd

On Thu, 23 Nov 2023 21:31:27 +0530, Sumit Saxena wrote:

> These patches add support for Broadcom's SAS5116 IO/RAID controllers
> in mpi3mr driver.
> 
> Sumit Saxena (5):
>   mpi3mr: Add support for SAS5116 PCI IDs
>   mpi3mr: Add PCI checks where SAS5116 diverges from SAS4116
>   mpi3mr: Increase maximum number of PHYs to 64 from 32
>   mpi3mr: Add support for status reply descriptor
>   mpi3mr: driver version upgrade to 8.5.0.0.50
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/5] mpi3mr: Add support for SAS5116 PCI IDs
      https://git.kernel.org/mkp/scsi/c/6fa21eab82be
[2/5] mpi3mr: Add PCI checks where SAS5116 diverges from SAS4116
      https://git.kernel.org/mkp/scsi/c/c9260ff28ee5
[3/5] mpi3mr: Increase maximum number of PHYs to 64 from 32
      https://git.kernel.org/mkp/scsi/c/cb5b60894602
[4/5] mpi3mr: Add support for status reply descriptor
      https://git.kernel.org/mkp/scsi/c/1193a89d2b6d
[5/5] mpi3mr: driver version upgrade to 8.5.0.0.50
      https://git.kernel.org/mkp/scsi/c/b4d94164ff32

-- 
Martin K. Petersen	Oracle Linux Engineering
