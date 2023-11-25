Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YDRQYaYm"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6DE19A6
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 18:54:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1Zn04015880;
	Sat, 25 Nov 2023 02:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=h9f3o5jrgKLLjPQdmghts344TU4HJfntHIfBtXgpOec=;
 b=YDRQYaYmr6RiN8crGt17APIWz6tvHOmBHt3IxGrlJ8C7bsY3aKkDEerPezGgPo5JsMoY
 f9fxjEO74GWUDDPS74extJyj2guxho1W9aEX2T34mtsSdcv3FpOE3S/lSSKkEOu/qwON
 1ybGu69vIhyOWpajoCPQvanfpKx8WVIEKNTZQRl7tqZLABxkYro5r6GlQBI7mjNWJ8xA
 Ob6sQn/VBc0T5AqHg++KLmOqXIRxcahS7Z3Pv2VfIAaLE3J5d7TMaHHA55r77/XBZ+cJ
 SQ06JKGGFCzsXHcRYrhZYeYOvYNSvJc0k6508oGQLLrEpOy4DplunKUIgYCd9aMWHPqj EQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uentvm17d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:54:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1Xm0e026991;
	Sat, 25 Nov 2023 02:54:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c99f6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:54:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AP2sRT5011828;
	Sat, 25 Nov 2023 02:54:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uk7c99f5h-9;
	Sat, 25 Nov 2023 02:54:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH v2] mpt3sas: suppress a warning in debug kernel
Date: Fri, 24 Nov 2023 21:54:21 -0500
Message-ID: <170087016635.1036733.5703735671985019205.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231019153706.7967-1-thenzl@redhat.com>
References: <20231019153706.7967-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-25_01,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=884 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311250020
X-Proofpoint-ORIG-GUID: heUScldVCmlzcxQjxbVmJ0XeV7mPQqQb
X-Proofpoint-GUID: heUScldVCmlzcxQjxbVmJ0XeV7mPQqQb

On Thu, 19 Oct 2023 17:37:06 +0200, Tomas Henzl wrote:

> The mpt3sas_ctl_exit should be called after communication
> with the controller stops but in currently  it may cause
> false warnings about not released memory.
> Fix it by leaving mpt3sas_ctl_exit handle misc driver release
> per driver and release DMA in mpt3sas_ctl_release per ioc.
> 
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/1] mpt3sas: suppress a warning in debug kernel
      https://git.kernel.org/mkp/scsi/c/6a965ee1892a

-- 
Martin K. Petersen	Oracle Linux Engineering
