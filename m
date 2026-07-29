Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7F38B158;
	Wed, 29 Jul 2026 02:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293735; cv=none; b=ScwzJwDWclFG2yB8Cs/ErviEuV0dYt3cHlRYIKJXieNCs658z13/FGhRB0PtkzyZyZPmQE67tvhD+EOja2qmWAGZpFLxjym0JgBaQGuaF55pD5kN3uIEH3WFRmQ6Hmvla8QZSN/aLXLT17W+KUlhGyXlX0ZVsnWgeKFDQIdTBBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293735; c=relaxed/simple;
	bh=73mMcVQDsLn/lOkrzEeV1LRdCA9zREFvfwV2u8PvQcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CldCPqct/2xMYeyASKOwW3MZLSpNUrWB4tx2Aro/Xpz7KAnRIdNHkmhI84bjY2m7V4j9P4aT3Axcvvb2z0J8pVwPDA0nvnxY/FMD2fOkXnHFxCy9napDFyX/wo2Tlb8PYAvZzMI8ej+ekgynvKgMQ1/ptbEGW6bui/Km+3rqUAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y5PlLKvL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y5PlLKvL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItWOA1074550;
	Wed, 29 Jul 2026 02:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ttRUh5nIaeIp2rvd9XCooqqac775ABZb/37BEj85wic=; b=
	Y5PlLKvLWfXFYI1s+HJHjrXjZuoNrsZXJDHhIDZexLApVc00F1rLnFCOdAGsrckM
	znPsR+qYRj4WK6iUnUs2i373ZnHdNXRYNA4eoOQSoO9eqGNBbO4ngJ9ISm/wQ5Xq
	PF9lCy/AyrnOBNbzipynSgxO7+dqbkEjB3Hni/cI0dNGVg0OguieOvzWPU7oL1ij
	OzYPEvupp+Xt0jk/j6O50Dzs9QkLZ28telmahEc/u3GQa5pl1xz7RVY1smcolyZl
	dQfVA3XS6UlcJ9wo9ZwMolnpc7noDuVX9mYYlMDsoLI5JW3CrMGah9fh77gZ/XvF
	k181QXzfSLHp225ZfCWk3Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq5477-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o65H001634;
	Wed, 29 Jul 2026 02:55:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:12 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jR012133;
	Wed, 29 Jul 2026 02:55:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-4;
	Wed, 29 Jul 2026 02:55:11 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        mani@kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org, Avri Altman <avri.altman@sandisk.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context
Date: Tue, 28 Jul 2026 22:54:58 -0400
Message-ID: <178508193499.4027291.4053528994945733332.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=876
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXz959B5EHxWnd
 AkoSOEmx3ZrAd1zG5UxLrfnOXGw+c3x6O1LmKQzFe68POG5x0y4a8p7J+AD4T5nw95k+LpXiY3A
 UQz7C41pqC/ezT0o2DfwbCUDpM7YpD+nDDU9c119UX5Ilx/cHFCcOJ8J1R3BxP4O/rJaEuqf3GC
 s4jfQKxihsWifcZfF9rKF7nQmFABkrHKg24TplDNifg3Jug8/A4rVqLJqS6SYcaoujqx79nHs8z
 RBL6gNieENxwp3ZJVNHq2pMrt/8MXRGXGXaAq/EyKgJRjPhbvXSIMd042oeNL0kjTDe8jZlbTLV
 TlKRiu5l0jWY9LJn/SPoe6ZzSQflnn4oprcpBWOv3lj+v2NwY2M77BLryjMOAfxCqkHH2OoW+fo
 d+Ybky+3GSQkpCuerumGtgYh/83jLtRBXte7IYcuF4HxLqUdXsMACKmjbKhU3TZkFA6JHlxH/Wq
 eIbCJgifCRKw0jI2qgg==
X-Proofpoint-GUID: 5A68H_O6VhYXyzXGZik3AvRrp_11cYPU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXzH6o0z6bl+Gf
 n54m3vKjWlYI1AGX46e3aMxNFgtDsp3UrORA9uhZbJHxUTAd1VVzA1Z6esHF40I4osiIgnRUb/w
 NankJwQtfk5WQJj0g0BQCPIWNRKXiY3PftHfoReaAthcFNFfUiqv
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a696b91 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=AwNr2LastR9-7KJSE-EA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: 5A68H_O6VhYXyzXGZik3AvRrp_11cYPU

On Thu, 18 Jun 2026 07:09:29 -0700, Can Guo wrote:

> TX EQTR may run while devfreq gear scaling has quiesced the UFS tagset. In
> that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr() and
> ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct reclaim
> is triggered, reclaim/writeback can depend on I/O to UFS device. Because
> the queue is quiesced, this can cause deadlock.
> 
> Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
> allocations in the TX EQTR call tree, including:
> - params->eqtr_record in ufshcd_tx_eqtr()
> - eqtr_data in __ufshcd_tx_eqtr()
> - params in ufs_qcom_get_rx_fom()
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context
      https://git.kernel.org/mkp/scsi/c/760fc6f0e25a

-- 
Martin K. Petersen
