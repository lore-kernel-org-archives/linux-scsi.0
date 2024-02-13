Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB8F1385;
	Tue, 13 Feb 2024 01:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707789447; cv=none; b=s2wYJjlC1Zqo4N524uCc8bHl8xelOtd/UEE2uPpsbnioKsnx9jIDFtuckJuJ/F9ZzaOYfShUR/UNBIWBWBy9qyQMndo2yZh9NVPfIyDE2N7O6yiA89Tc4OswG/JrxqRYP9uFGJXPeUYbnqKrluCX7U8/2ovNHbRUJvQk4Wesi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707789447; c=relaxed/simple;
	bh=a5yqHZbc/GrGOemVLKPdqs679lt+QCaXY3iHVV+qpcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfJgjd2j+OzbxbLtUj5/Dsr4vGqwjfw+wt14Tx+ahCBRl6465z9/RXvh9eQhVVfcvJcxwsKAjtYJQ0BK77x5oDDzPM2rdiDZDoIG5Ndrzo0lsUH41Jodc9gWBe2U/MqnjNThRBic9tgHbgr0iSuH1LteY1MzoRMK1QLFoUSUxhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jEz9Qc4F; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jEz9Qc4F"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41D1qGt4016532;
	Tue, 13 Feb 2024 01:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=xwHkmHak5wlEGc78J1yvYxxvCkivXANayJ8zzsjkIc8=;
 b=jEz9Qc4FYr6DGeu1I158YuL1laUdit0+uDLnCjw6RRLDCQDKOBIHiiFvoTyQOZb/ldq5
 7QzXkWLDY8rzIQHPDpc0UQ5o9I/9qzUvCO4TgRKcOfGddD2tn1JlcVmlLDvfgAEfulZ4
 SsDtEGsI3H3Sd4jFoEx2/SU849Gtgms2+k4+konmS5BRMQe8PdMprU89zMcubyoNTU9S
 6BpFPypKl+6o8Phcir7nJTcOWAMK7B88vTCTtvwKn8BR9Hh5AqfdhhXoLnpvA3s6RVLj
 p1EYyNkxX9fK1otLONQAoINJlavMTVx9QxwtuIoq+T3wfcN6bSp8Xfdb682SaXedFZx+ WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w7y4rr04j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 01:57:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41D1IviR000608;
	Tue, 13 Feb 2024 01:57:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5yk6ms0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Feb 2024 01:57:20 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41D1vJGE016701;
	Tue, 13 Feb 2024 01:57:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3w5yk6ms05-2;
	Tue, 13 Feb 2024 01:57:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mlombard@redhat.com, d.bogdanov@yadro.com, me@xecycle.info,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] scsi: target: Fix unmap setup during configuration
Date: Mon, 12 Feb 2024 20:57:10 -0500
Message-ID: <170778915958.2192303.12158894712146810239.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240209215247.5213-1-michael.christie@oracle.com>
References: <20240209215247.5213-1-michael.christie@oracle.com>
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
 definitions=2024-02-12_20,2024-02-12_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=793 phishscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402130011
X-Proofpoint-ORIG-GUID: ASnPByo9VY9geFyxGDGpkyxsmO92E4Zp
X-Proofpoint-GUID: ASnPByo9VY9geFyxGDGpkyxsmO92E4Zp

On Fri, 09 Feb 2024 15:52:47 -0600, Mike Christie wrote:

> This issue was found and also debugged by Carl Lei <me@xecycle.info>.
> 
> If the device is not enabled, iblock/file will have not setup their
> se_device to bdev/file mappings. If a user tries to config the unmap
> settings at this time, we will then crash trying to access a NULL
> pointer where the bdev/file should be.
> 
> [...]

Applied to 6.8/scsi-fixes, thanks!

[1/1] scsi: target: Fix unmap setup during configuration
      https://git.kernel.org/mkp/scsi/c/4cbec7e89a41

-- 
Martin K. Petersen	Oracle Linux Engineering
