Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cZvBKj9c"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B002811B
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:29:30 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0UA4t030590;
	Thu, 14 Dec 2023 04:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=gP3DXWD6QdggBVzKa005GLDHutej+QJ0RAo+hlBMfnw=;
 b=cZvBKj9chXIHXvxlxy6bad2Q2h+pzyT2AKoKfFdYEqclrk84XMQ482YggEUsb8bEX0KI
 00iUAjMF8ZGCVW0KtWWK/g57/l+dzSp8ZvEm4WbeVgquZTHLk4k6qVbypDO06inVEeJa
 qKD9vIzIyIXIDL3/Th8X5dJ3+U4Aq4UZ7sDvrduYAjABvZbCOrmkwSgb9RPuJWZwjwkC
 ADil4HXqVEfRzIBlIJXLBByghQfLh43CIa4rqVrJQfjZBxCDZtg6vQNEEWgFIOlbWbpD
 Oi0o8RywxNONloT1/cGrc5RvKmG06OEpF1kFnZxTk1UkAmUjA+U1ytX5K5YfCVqs6yAU YQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvfuu9u2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE2cxgO009747;
	Thu, 14 Dec 2023 04:29:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQMA035965;
	Thu, 14 Dec 2023 04:29:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-4;
	Thu, 14 Dec 2023 04:29:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com,
        prayas.patel@broadcom.com,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] mpi3mr: Bug fixes
Date: Wed, 13 Dec 2023 23:29:09 -0500
Message-ID: <170205513110.1790765.6945418995151770144.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231126053134.10133-1-chandrakanth.patil@broadcom.com>
References: <20231126053134.10133-1-chandrakanth.patil@broadcom.com>
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
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=584 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: LK2uIuLJbDKhIBjBVnv1riH_bnW8DlKe
X-Proofpoint-ORIG-GUID: LK2uIuLJbDKhIBjBVnv1riH_bnW8DlKe

On Sun, 26 Nov 2023 11:01:30 +0530, Chandrakanth patil wrote:

> This patchset contains critical bug fixes
> 
> Chandrakanth patil (4):
>   mpi3mr: Refresh sdev queue depth after controller reset
>   mpi3mr: Cleanup block devices post controller reset
>   mpi3mr: Block PEL Enable Command on Controller Reset and Unrecoverable
>     State
>   mpi3mr: Fetch correct device dev handle for status reply descriptor
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/4] mpi3mr: Refresh sdev queue depth after controller reset
      https://git.kernel.org/mkp/scsi/c/e5aab848dfdf
[2/4] mpi3mr: Cleanup block devices post controller reset
      https://git.kernel.org/mkp/scsi/c/c01d515687e3
[3/4] mpi3mr: Block PEL Enable Command on Controller Reset and Unrecoverable State
      https://git.kernel.org/mkp/scsi/c/f8fb3f39148e
[4/4] mpi3mr: Fetch correct device dev handle for status reply descriptor
      https://git.kernel.org/mkp/scsi/c/07ac6adda4d3

-- 
Martin K. Petersen	Oracle Linux Engineering
