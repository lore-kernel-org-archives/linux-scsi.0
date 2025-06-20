Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CBF819;
	Fri, 20 Jun 2025 03:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389555; cv=none; b=fZOlpGA3SIs997nPuCvj3AuZM3G3uEnogiIie92ExIkyWp3mGFupPnK4lcB/mBEjt/e2PRUBJTx/CgxV7GJf0vPRGl3gKemBQU+26zdDsUQm+7+u5Klf7FK8/JJTRm3E4hALBsVSLOr511/G647FjErb5zfuiUN040EfJGMZiZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389555; c=relaxed/simple;
	bh=6gV8habQmR0l6If/rs0foeRnxovKTYC+lqCqNtVkGmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsljQDb6Yo2FvcoDU01ZFJLECCcPSZer8JfdcMTDMBlPYow6Ki6fEghEuQdniiEQGDZufdcI7m1OBSQxNp+yA/2bc4IIuD6VpUaxU/C6HLgl/b8gHGwfNCMNrZ7uQNbQtTHlQLd7GBUa8ocdaMD9XB74dJ5MNC/df4ccokBIoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fni2me07; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fni2me07"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2uMCh024699;
	Fri, 20 Jun 2025 03:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sx2W30y7IcvUbZ8WFzozp7FEIX7ST5hgLzGKaMt8dQY=; b=
	fni2me07PC11YxvKbd/o/jG2Rp3+jWFnnQD6HPD7xnfCguxsIEkQzqyAAKR2s4sm
	JvWOgVVdDlD5TX6J3whZAvo7Fm/GmlTSUuhwqDdpIKPYSuuXkKVYJNtp+mm/a4oA
	cx1jJaiPAmSO4QJx8xru7FxT60zh8cMGTBpTYb1yB9vFTBSyxEOgPN4TBieZONhq
	ODIVocmv9sjDkXNcKy2W0zBz08B86TH+VwRD0dqxPkZoqZs7bF0A1mf0dJqLKlWV
	/1onVA2W7zDq8B2nwbhoxtTSRKibmCQMrkkQpObsUqMyJ6221/RT0caixLAdjzJN
	54Q0B5UV9kAEO56Wa5+ZTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47b23xxcvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K0tqpL009613;
	Fri, 20 Jun 2025 03:19:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhjydgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:08 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55K3J7oL002814;
	Fri, 20 Jun 2025 03:19:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yhjydgj-1;
	Fri, 20 Jun 2025 03:19:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: drop unused variable in mpt3sas_send_mctp_passthru_req()
Date: Thu, 19 Jun 2025 23:18:36 -0400
Message-ID: <175038845866.1665414.11772889532990101516.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250606-mpt3sas-v1-1-906ffe49fb6b@linaro.org>
References: <20250606-mpt3sas-v1-1-906ffe49fb6b@linaro.org>
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
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=803 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyNCBTYWx0ZWRfX427KdcHu6g5I +Uy9SA1BPwryqccBnoDowiERLpqJnY6sAG44vxJ+3/SUITR0x5xSFJRCu/oRo9ZiY911JxMy/lv xrPuqocdByjbN8XzCfyYP1WBeE8QHQgZFJiybO6fjtKidBZ1O11TOCnl29P/8Nl49wy+tVB/mFI
 gvtuW0CwAVDyfYUTwl4J9ekzEUCiYy3IA3aVsEO8ixFnsDbcBMYvha3qpbAf40NjGrqGIT6A9zs SVLflgJSDUMBCBNQcW8eGZ12UaaS/l7vaWmEtwlQT0sjhQ00o4RGFIp+O/XKeHClvKZgQoQADT9 yu7nFTy6r0frUQcwGSZ4ua++JrdTWDbw9qcIGTkNo2/Mzoi5ITpJv0J3QrBHBTpF/W5bxYYuAJM
 BzHkGmLmDGX3XvRcKXJOd7FIQZPxrUid7+z4PwzK+vfBfrbXN5AFkzfbj3Z+H6uP4M5qIM2Y
X-Authority-Analysis: v=2.4 cv=DM2P4zNb c=1 sm=1 tr=0 ts=6854d32d b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=Vf5sxtAR7XJVazzEulMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:14714
X-Proofpoint-GUID: 251hHccgLfcV_4aGpoyIE34iJZbktUPs
X-Proofpoint-ORIG-GUID: 251hHccgLfcV_4aGpoyIE34iJZbktUPs

On Fri, 06 Jun 2025 16:29:43 +0100, André Draszik wrote:

> With W=1, gcc complains correctly:
> 
>     mpt3sas_ctl.c: In function ‘mpt3sas_send_mctp_passthru_req’:
>     mpt3sas_ctl.c:2917:29: error: variable ‘mpi_reply’ set but not used [-Werror=unused-but-set-variable]
>      2917 |         MPI2DefaultReply_t *mpi_reply;
>           |                             ^~~~~~~~~
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: mpt3sas: drop unused variable in mpt3sas_send_mctp_passthru_req()
      https://git.kernel.org/mkp/scsi/c/0ec996edf4fd

-- 
Martin K. Petersen	Oracle Linux Engineering
