Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E1613632B;
	Wed, 16 Oct 2024 02:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046455; cv=none; b=chr8NfHlp4N0F3Wbo76HxC2L1Au9Q7ux3tIh9UFeJhZjxXfV5dYwDDij+9pWBIrm/EvSrVPHI/fRYl8CksKqkFn1M2ndyLBNH0ib/0Dj/llmJF4LigXQRPs50TN1IPzttyFl7sga3V84pE3fz+lqmvoUf/UthjDDAYq3KAidSqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046455; c=relaxed/simple;
	bh=dos+hc0W4S35iHy7p0Pu9U5NVKEmIuU3OGJnn47lmMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdkjY/CPd8zvz96qt813/y7Rzgpn0kK8Xhc0qYad/FpYT8/WfaT973m+KH27g2yr/85sz7fHQZtxSF6jwwPCZTPxWN01Bo/O/aLM/Y0HWMAoYq6iJaD54v0hMVo3OtJHevjVYAb0XZcezGelM1asUNg8Qobu3LKbTm61SjfKCwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E7YG7N7v; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E7YG7N7v"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2Mb9P010285;
	Wed, 16 Oct 2024 02:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8RybGAs5L6x+eIvjjeRRFAKBG3ys27coEoOqzNz/v8w=; b=
	E7YG7N7vWslJ/y0+AeIJ+nGcYG/gNriFFn6Ee3wQrvgLM7U6QUOEpqDATFxxZ8jo
	h2uSsYaGyhbHvTeAZ1j5zK5tzmBpQ3B0Y6Uf1NqySzhTVaEc9N+QDq0u9zql43hZ
	Q/vghjnXNeKg+QH2lV799CYYjLjHjPMlxjU3faSUwALXQuhrEKu2ZjL8ER9vj/0v
	fFtSQh1RxrkDYF+vWJO0r7wpAHlojd6MhWNhq8eQeKBoi1k5DJ1VUbPV79iqQ3PK
	E5BdC31SQSt54midANNlbYaDL9aFaljTbt/k3/TBZxUrdlU2jAAh185DSDXg5qIS
	rBG0b+VbOAv7V7w0aOqRBA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt2nc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2TBN9027154;
	Wed, 16 Oct 2024 02:40:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjesxyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:48 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2elg3001510;
	Wed, 16 Oct 2024 02:40:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjesxyf-3;
	Wed, 16 Oct 2024 02:40:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: aacraid@microsemi.com, James.Bottomley@HansenPartnership.com,
        linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: Remove unused aac_check_health
Date: Tue, 15 Oct 2024 22:40:04 -0400
Message-ID: <172852338081.715793.1995047409349459596.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240920202304.333108-1-linux@treblig.org>
References: <20240920202304.333108-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=725 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160016
X-Proofpoint-GUID: ZoF_z17aFqiRSQtJf_Wa48GQ213LdGyQ
X-Proofpoint-ORIG-GUID: ZoF_z17aFqiRSQtJf_Wa48GQ213LdGyQ

On Fri, 20 Sep 2024 21:23:04 +0100, linux@treblig.org wrote:

> aac_check_health has been unused since commit
>   9473ddb2b037 ("scsi: aacraid: Use correct function to get ctrl health")
> 
> Remove it.
> 
> (I don't have the hardware to test this, build and booted only)
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: aacraid: Remove unused aac_check_health
      https://git.kernel.org/mkp/scsi/c/5a66581a1af5

-- 
Martin K. Petersen	Oracle Linux Engineering
