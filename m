Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F9B1386A2;
	Thu, 15 Feb 2024 20:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708029577; cv=none; b=S0m9w5VI6YRt8qgCXJ8sHRfLWZAI0QJueBgHEgButrlJrY78RTB9FJv1FaPBXc8AmJVOg0W8DjYz/xmYXEPVF27JceQ33zULFxbxCKCHyze4G+1fZiyeiQMCQDAL96BAJf0zW6VYpf/1IHgjOPwIyWMOF6cap94kYESeAMNP0Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708029577; c=relaxed/simple;
	bh=lKD/Uwq8GCZgGAzYXOWUCtOltk7Lco8tbLX0Ks0Ulbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7lIMKs5jKuti0Rupim15iM9KCbjl2tEnM0eCV1rrzoqj7dW/TTKKF+jvs/vgSfr3GZ5ZRoUG+u7VYhGHUsQPmXXZo6SEHbFicfzlQxjUPaYqRME4SWSYPuPxATi15Ns7mZMZxT1umjsxy+HTmmIrl0zzSpU0C+Evdh3f8Ss/cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HB/a4R6H; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HB/a4R6H"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFSu5E031021;
	Thu, 15 Feb 2024 20:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=GBG9OM/k6Eu3/bIZsw+RWlnfwczffNveuamtisM2TXU=;
 b=HB/a4R6HSeuuPlhbNtK+SqnOhKaqzr5JgO9orST/MLttwCfhdSLv2AmCLJO5UNKMJa/s
 JwBs/xqwUbix90t+YzkQ7Vjuyjbh+c2inpc3sQkn38R7f/ghsCYK1mUaDXpCiTGUke3W
 uqlSVMyGn0il5Sd4oWR30zkzxxXeQvugK+GOe2LiHi7vbz3fhnejUEpHtwwclw1OHSB0
 H+zYf8fj04EjoYM/LUnGfA0a4CW51KYss3nIYr/VOqnYw/6iv+erTFgptsz47A9Bb4Nh
 afj+SXkvawAcskGPg+rXPZt/Lov3cSbjf+7jhD3rrq7NzaK5Jbh9JNfNZ9FXboGXc4xB dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301k7rs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 20:39:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FJlFrx014954;
	Thu, 15 Feb 2024 20:39:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykats4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 20:39:33 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FKdVPN012444;
	Thu, 15 Feb 2024 20:39:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5ykats32-2;
	Thu, 15 Feb 2024 20:39:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: pscsi: fix bio_put for error case
Date: Thu, 15 Feb 2024 15:39:23 -0500
Message-ID: <170802930853.3317154.11654161867497729133.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240214144356.101814-1-naohiro.aota@wdc.com>
References: <20240214144356.101814-1-naohiro.aota@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_19,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=954 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150166
X-Proofpoint-GUID: iBzn9VNMg96asBU5Kow05qrlZTCHvH6p
X-Proofpoint-ORIG-GUID: iBzn9VNMg96asBU5Kow05qrlZTCHvH6p

On Wed, 14 Feb 2024 23:43:56 +0900, Naohiro Aota wrote:

> As of commit 066ff571011d ("block: turn bio_kmalloc into a simple kmalloc
> wrapper"), a bio allocated by bio_kmalloc() must be freed by bio_uninit()
> and kfree(). That is not done properly for the error case, hitting WARN and
> NULL pointer dereference in bio_free().
> 
> 

Applied to 6.8/scsi-fixes, thanks!

[1/1] scsi: target: pscsi: fix bio_put for error case
      https://git.kernel.org/mkp/scsi/c/de959094eb21

-- 
Martin K. Petersen	Oracle Linux Engineering
