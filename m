Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F435241E7;
	Fri,  4 Oct 2024 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007739; cv=none; b=NyfNqN/A8WIml4I1lEkw9NIcm5DnL6KXzGLlCsd0zDLJjuC/YaF4peCP9GqGSZTxP+2cA+/clnGNjv0rSnEFX9RzkVv7rDFjGYxmGUmg9l1Dq5LKmYB1/ndqcoYNfP0VVxGwyUuCnIDTzvH256okBKJXGJwICGCvoG9nnsTigfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007739; c=relaxed/simple;
	bh=Pa7h51ZuIAZ85G0lqTJND6ua+oBMQex+ghL0S3JOBMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lan0hQc9xTKXVH76IOzWvUyTP+HCWmgTVvnFAAgL/hPOK5j4GZy7joJBoFmjs4nJzO2e5DKgcj1EqbzVc7BZlQxEgu91Fn5Txr75ePfYlMX0RRbVNJlwr+Ik+A3BmL4dG87wtTpmzr0tqtcC652V8HAsrMyjRgbh7BQEfMdocD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=krIQcdki; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="krIQcdki"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940te4H007648;
	Fri, 4 Oct 2024 02:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=TSYp3uNp/5P9hOjRNQSyP5XupqoeJyPR79IIIZQyRBg=; b=
	krIQcdkinhku7IuQBT23pu0CO1fqCIZQDlDd34hFbNKNnnlCbfCrAdDPR2QzTXEP
	EsFUd0+llMXR4GIG800p9zHlg1YUBoeZ3ySfVyUdQ27fv5wgAFfOb3FLeKSSHKPv
	vlJEdP7C+JwH0WWlLpZm+HoJX1vbitNHpnxlzPdOAV63D++da0yainWhz7WDnjN1
	+K/Zb8eG7LCmuVz2aR6PYHCrAiJcioEed8pRmZ+N+/dNQIK7Ig3Yl3mcnKPMq2zr
	+QQar26dRfWbT+ezvVpMphErzR/kxa9OqZphFkGJ8OnlXOjxPB6zcKWkiZGvsy/2
	WKgRwyfmsBSbr+LBSPN74g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220498p44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940NUSB038380;
	Fri, 4 Oct 2024 02:08:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054pb2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49427bli036075;
	Fri, 4 Oct 2024 02:08:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 422054pb11-4;
	Fri, 04 Oct 2024 02:08:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>, Petr Mladek <pmladek@suse.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: move flush_work initialization out of if block
Date: Thu,  3 Oct 2024 22:08:09 -0400
Message-ID: <172800766873.2547528.18433845515105510650.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240930133014.71615-1-mwilck@suse.com>
References: <20240930133014.71615-1-mwilck@suse.com>
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
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040014
X-Proofpoint-ORIG-GUID: Lo_UB6J59lPBgPtQsrsSXKeviUAMkUPJ
X-Proofpoint-GUID: Lo_UB6J59lPBgPtQsrsSXKeviUAMkUPJ

On Mon, 30 Sep 2024 15:30:14 +0200, Martin Wilck wrote:

> (resending, sorry - I'd forgotten to add the mailing list)
> 
> After commit 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a work
> queue"), it can happen that a work item is sent to an uninitialized work
> queue.  This may has the effect that the item being queued is never
> actually queued, and any further actions depending on it will not proceed.
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: fnic: move flush_work initialization out of if block
      https://git.kernel.org/mkp/scsi/c/f30e5f77d2f2

-- 
Martin K. Petersen	Oracle Linux Engineering
