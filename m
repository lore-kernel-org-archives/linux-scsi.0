Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CX3chmqV"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EADA19A2
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 18:54:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1hlK0018673;
	Sat, 25 Nov 2023 02:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=py5/2BHN36mvtvppFh6lkNFHerOtQgcPIb7sWY4yLAs=;
 b=CX3chmqVH3qqvIt8F1p/siA6jDDfORWzf5dbtOY5gto8TDwPc5WjOpYzLQqjogV/Qlf4
 4yO/RQQwaFOSaWi7ygDIeed5dOvyayBtBv51AUS+SB84cDGFfuRNmgTcnFy3Fx4beuys
 1sZcLcojL9kvMoTQYv5QfIyiGuMMYqyCXjEoaN3dqzKemEJnxjsKw0TOfYpijbDHa9HB
 SerOH3cCq7vBLIuQt2v8+4lGNa86RxnLDlPICFX5l2WZVyKrLY12Mh7KtIFWUXzI6v88
 qPY+HTuQv/J9M3QjttApRE22TCUfvwyTu4V/yDwHbc64jr4HOUDThwyZx8k1ee8TYsJz Qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7h2g1dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:54:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1Xmu3026961;
	Sat, 25 Nov 2023 02:54:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c99f6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:54:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AP2sRT1011828;
	Sat, 25 Nov 2023 02:54:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uk7c99f5h-7;
	Sat, 25 Nov 2023 02:54:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.16
Date: Fri, 24 Nov 2023 21:54:19 -0500
Message-ID: <170087016629.1036733.10669027755360058266.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
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
 suspectscore=0 spamscore=0 mlxlogscore=906 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311250020
X-Proofpoint-GUID: d1SVnupugrlT5qiY1BC3mZpfdXMHnuU-
X-Proofpoint-ORIG-GUID: d1SVnupugrlT5qiY1BC3mZpfdXMHnuU-

On Tue, 31 Oct 2023 12:12:15 -0700, Justin Tee wrote:

> Update lpfc to revision 14.2.0.16
> 
> This patch set contains a user input range check correction, static code
> analyzer fixes, refactoring of clean up code, and logging enhancements.
> 
> The patches were cut against Martin's 6.7/scsi-queue tree.
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/9] lpfc: Correct maximum PCI function value for RAS fw logging
      https://git.kernel.org/mkp/scsi/c/2fe4b6a67730
[2/9] lpfc: Fix possible file string name overflow when updating firmware
      https://git.kernel.org/mkp/scsi/c/f5779b529240
[3/9] lpfc: Fix list_entry null check warning in lpfc_cmpl_els_plogi
      https://git.kernel.org/mkp/scsi/c/1dec1311b9b6
[4/9] lpfc: Eliminate unnecessary relocking in lpfc_check_nlp_post_devloss
      https://git.kernel.org/mkp/scsi/c/e07ac2d2aa5f
[5/9] lpfc: Return early in lpfc_poll_eratt when the driver is unloading
      https://git.kernel.org/mkp/scsi/c/57ea41eb7fe6
[6/9] lpfc: Refactor and clean up mailbox command memory free
      https://git.kernel.org/mkp/scsi/c/349b1e2c1bda
[7/9] lpfc: Enhance driver logging for selected discovery events
      https://git.kernel.org/mkp/scsi/c/e6af45218755
[8/9] lpfc: Update lpfc version to 14.2.0.16
      https://git.kernel.org/mkp/scsi/c/c855e02b57ed
[9/9] lpfc: Copyright updates for 14.2.0.16 patches
      https://git.kernel.org/mkp/scsi/c/1f86b0d9c76c

-- 
Martin K. Petersen	Oracle Linux Engineering
