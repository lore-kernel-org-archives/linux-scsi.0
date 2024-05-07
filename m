Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1D94436;
	Tue,  7 May 2024 02:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047306; cv=none; b=uNHb9igTtTfalRJfH+BowcuGWPfKdcro5kWzraOkXfw972QLj1wAitLKrIThsh7Rb8rhcjyLmwTb2TsGG2u3mVd7iZy1NooIe+uQyu8EkyWo+/YM6BhOi4WY8DDhbIDa3VJo3SVRpE0ggGpDe29ZqOnNu55TMEV1ONhUpF4pWPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047306; c=relaxed/simple;
	bh=qMt7sU3ZWyHxeJUaorFvVIZh1bjYtjLVJT4/fbpZrTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dKPq2hiOqAFJbNPkvKVzsekyfIYTszQ4uI43SS8jgnZ67TM77kAozt4FG3ebjNjCatB8dUhNdnPhYt8/QVd4oj1bkqgw7IcHetdtBOZdSW0f3mIdVoWN0z7jx709Olt101rj9UtHD3lwRN75CRZ2rbmtupehqslOVuBILWLICqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eCLduM+B; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eCLduM+B"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqL7w031193;
	Tue, 7 May 2024 02:01:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=3yCBnT8Rhyu+4Pc9Jt7MvgGt0OJJp1+pnGM6iurVjXA=;
 b=eCLduM+BjTejLRUo8jl8FNB8idnm6u9go8EVRjp4gAyiMK4yNqaIYMUecXKiZkdWuFam
 lbyDOBosXAr1HLmz0fXsF2osjCDIbl9LmnuXN7J2T43fdV6hokvrr3QRqBAcFClM/joz
 nHmBIXp7OmFQzuGKltOqzTPF/AjnAn5Scad0uBZphhxaCON2i996ApvN06XpaYOkR+hA
 BFjLs4wcoByZm2dTzgXRm/h/yoKFexRJNqSB710xcw+BLCT9nkYYGm8Qg1f3bUn3hNhy
 9W4f0F4yHUciUPxbJhr5lwick+UJLHUnwdsUtSbIOmll2OBZUdwnDMvZ4nE0EEW7fd9F 5w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuuuw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4470HWtG006969;
	Tue, 7 May 2024 02:01:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dc1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721EmC034149;
	Tue, 7 May 2024 02:01:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-8;
	Tue, 07 May 2024 02:01:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com,
        damien.lemoal@opensource.wdc.com, Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
Subject: Re: [PATCH v6 0/4] scsi: libsas: Fix the failure of adding phy with zero-address to port
Date: Mon,  6 May 2024 21:59:55 -0400
Message-ID: <171504445049.1494912.3512778899419716186.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240312141103.31358-1-yangxingui@huawei.com>
References: <20240312141103.31358-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=725
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-ORIG-GUID: K5q5vtK6tmk4AX-nkFAd-wO04F1iyFhW
X-Proofpoint-GUID: K5q5vtK6tmk4AX-nkFAd-wO04F1iyFhW

On Tue, 12 Mar 2024 14:10:59 +0000, Xingui Yang wrote:

> This series is to solve the problem of a BUG() when adding phy with zero
> address to a new port.
> 
> v5 -> v6
> 1. rename sas_add_parent_port() to sas_ex_add_parent_port() based on
>    John's suggestion.
> 2. Distill port settings into a single patch.
> 3. Update comments information.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/4] scsi: libsas: Add helper for port add ex_phy
      https://git.kernel.org/mkp/scsi/c/888ea1b12b06
[2/4] scsi: libsas: Move sas_add_parent_port() to sas_expander.c
      https://git.kernel.org/mkp/scsi/c/48032c0be6c7
[3/4] scsi: libsas: Set port when ex_phy is added or deleted
      https://git.kernel.org/mkp/scsi/c/7a165a81d55f
[4/4] scsi: libsas: Fix the failure of adding phy with zero-address to port
      https://git.kernel.org/mkp/scsi/c/06036a0a5db3

-- 
Martin K. Petersen	Oracle Linux Engineering
