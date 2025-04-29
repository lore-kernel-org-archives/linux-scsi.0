Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C16253338;
	Tue, 29 Apr 2025 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892574; cv=none; b=uN+ch4YiKXez24ZgbacfQZ/tlm6ZMVCY5jWUGColWa+i7oVkPwaIlCQ1+wdH8Sxz5PbVMm1JhbuHIFw8H88oxqiyH6xY9Q0kZXnpd1uZhSF1RQaGEMnOltDDBNPskjCI6ucTlJWbRsuDkUOKqeNzjHHuZyzbKPGCdVC+GN32hvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892574; c=relaxed/simple;
	bh=MjsQw46l/Aicchhv0IyU4jGOmquUzEyvyv2OLlOtjNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlYFwzjN4bXjkM4SZ59ZIR8n1TI6I5euF1CqCl5pB2Ie1dJZwswzUcvbUadpQsrWPDM2KSm938hbxF1EZlQfFLoA68VH4C32CDJUENJ5EN+yUyn6cc+/Eb27WZn/vw7kOpZDamLIySwOW1s+rentepnSLZG8TMA3uum8fTGqWqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jtQGav4j; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtQGav4j"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1qZiF004767;
	Tue, 29 Apr 2025 02:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9As1MshhuIxPvvqnk8VDaT7KNdZdBmlY53Q2FtxefyM=; b=
	jtQGav4jpZkHblKuZW76W9MQ/MTdmOtWlDCFJbEWVOtCCaii6ydGpOzfMMEZTXaL
	UbGRTWxOvx4UPMPGBBmejNXxdqUndOMhDNs7xAGBJpMcSw8uEgR3XpjNe7ckUMOc
	6WFgWTs8qj2JCnahRtiJhHGJ0YXZvqOv9td3NMMcXJYm4D091mlaoWQTLSaV2pyy
	XetSl1tY4viw5k7xo4E+ZMCQAyL5qSSzRk4Q2D3OqDf6ObFHtYbMXafkAzc5zUSP
	c0uj8dnJMOz+JmpwzQZRCBabCXnDn6RV2GxMA4ZZUlzfYvngovIk4+7VZyhVBjja
	wYaOcHuTAzWZaBzLBJt0/g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ang3r0pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0b3vn001357;
	Tue, 29 Apr 2025 02:09:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx97247-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53T29OCU020520;
	Tue, 29 Apr 2025 02:09:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 468nx9723t-3;
	Tue, 29 Apr 2025 02:09:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] scsi: qla2xxx deadcoding
Date: Mon, 28 Apr 2025 22:08:53 -0400
Message-ID: <174588857930.3470741.15590902721543464963.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=670 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290015
X-Proofpoint-ORIG-GUID: 5bF7Aa_K0hiJ4hHWXYQ_zi0IhztBmB_a
X-Proofpoint-GUID: 5bF7Aa_K0hiJ4hHWXYQ_zi0IhztBmB_a
X-Authority-Analysis: v=2.4 cv=EKAG00ZC c=1 sm=1 tr=0 ts=681034d7 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=9N_kNC4nTBuAy_ESYVYA:9 a=QEXdDO2ut3YA:10
 a=1cNuO-ABBywtgFSQhe9S:22 cc=ntf awl=host:13129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfXxaEz+2rw4gnZ NdUrjTz9uLKobDSmqWc2EbJaqgkT9OAjqgcdyzpiy9JqsqJSGcZdaEs86Z7AihoT4nGXBKkOlEt 00vUB2XWP234kuj9ssDthLbpj9BXb9LxP7fmI57FayQHBygz4MTlhW5zsfAIh2MfW39+IoNE75G
 QHs1trEVoZiM+JHpq+A9CrsxDiAWsws7lkGssNvXCPNGXT79P0zvSyMKSC8gjDmTbnUlA4f2Qi3 CNUiVb4XvcUftu0O3PF7hMEgIyOTtVJupzz4NIZWjaR2AtocUbJx6xzO2srHX203n2JWD3zldiN E0gOafhFgFqzsYjAHjTl1tdD77gcdUUBEZch5mBfPNkuDs4rKu89i8L7eBNTGxe0MjU2W9PfB0i xH1BRRWo

On Tue, 15 Apr 2025 01:27:55 +0100, linux@treblig.org wrote:

>   This is a batch of deadcoding on the qla2xxx driver.
> Note the last patch removes two unused module
> parameters, so I guess if anyone has that in some configs
> somewhere that might surprise them.
> 
> Other than that, it's all simple function deletion.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/8] scsi: qla2xxx: Remove unused qlt_free_qfull_cmds
      https://git.kernel.org/mkp/scsi/c/ae7a08bee82b
[2/8] scsi: qla2xxx: Remove unused qlt_fc_port_deleted
      https://git.kernel.org/mkp/scsi/c/cbb2a2ef5801
[3/8] scsi: qla2xxx: Remove unused qlt_83xx_iospace_config
      https://git.kernel.org/mkp/scsi/c/91453ebecccc
[4/8] scsi: qla2xxx: Remove unused qla82xx_pci_region_offset
      https://git.kernel.org/mkp/scsi/c/89981b47f6fc
[5/8] scsi: qla2xxx: Remove unused qla82xx_wait_for_state_change
      https://git.kernel.org/mkp/scsi/c/2a2f3168c510
[6/8] scsi: qla2xxx: Remove unused ql_log_qp
      https://git.kernel.org/mkp/scsi/c/33f44a50ca61
[7/8] scsi: qla2xxx: Remove unused qla2x00_gpsc
      https://git.kernel.org/mkp/scsi/c/45838d3db750
[8/8] scsi: qla2xxx: Remove unused module parameters
      https://git.kernel.org/mkp/scsi/c/3a37ab0827fd

-- 
Martin K. Petersen	Oracle Linux Engineering
