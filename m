Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA51CAB5;
	Tue, 26 Mar 2024 01:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416132; cv=none; b=Uj2+X2wXxwzoZ/ikMnYQPLGn4v2Uh15AHUO7ZUxPOpBagbo93pozKNusG7Gmv4Bo/DcfjSVLUS4vA1aJCpAnAUTdcf1VSUtJ/DBUhT68IVq9UvzzLqYV128rIxaxFux7tC0+g7uZQU+ap0CN20TziYqYn7R3iCmUnJc2LbL1m58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416132; c=relaxed/simple;
	bh=4XSd/tlkp5bT25mBRHc8fLWCqme9Aehc6yCLwTubQyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKMiCeTCWF/glf3caFMjqegCW/DW3qsWHvyogQyFcjy5/xOte6XKKlKCEbLBbxeaDJmjl9yBBq3uJjbI5ian0+Q0beEbvoJaHpCuyrznvTMrgH5Q7pihEsl/NUxHEwJwtSCKLdKMdQU0LSWdMcbWrDLjhU0p3uy6SnAfOF7eJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=II3jnrpr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="II3jnrpr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFxRh019802;
	Tue, 26 Mar 2024 01:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=uf8qlRFcdfQXnPK9jBM1dDuz81qD4PJoWRemv9hrg5U=;
 b=II3jnrpruXGw3qy7BiE6EYfJAxdPU27DdsQcJn5BLJIP0XqzrgmBjG0f4dqyZ9L7c158
 xkUe2abanNifEiTDUqNDktG5bW6JkhnVQH6qymC0gI6a/VVBCBNRqB6xvzNdE5+m9hVu
 FhfuxKsfBbmVnRGY/HRL8jzHTdo2dPshqwpAMW0mxTbwBCR2nROu8dSLmktsupiRPKLw
 2Gz9K1UCd12iJvVvGUtstKa0fnKBIbQx+zOim1v7+QcknhrrB7ItWK7znwJwRaf+aas8
 6ydg2k3PhFW6uUaAkgNgzsv/WW5oiOM5ae1B+uiG1ADcxCuIAIyCFO4hwLLFmV6roW4p 1Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct3881-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q13Uur024409;
	Tue, 26 Mar 2024 01:22:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6hfq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:00 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q1Lx48002449;
	Tue, 26 Mar 2024 01:21:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh6hfkw-1;
	Tue, 26 Mar 2024 01:21:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dgilbert@interlog.com, Alexander Wetzel <Alexander@wetzel-home.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sg: Avoid sg device teardown race
Date: Mon, 25 Mar 2024 21:21:43 -0400
Message-ID: <171141606207.2006662.7712975500483077316.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240320213032.18221-1-Alexander@wetzel-home.de>
References: <20240320110809.12901-1-Alexander@wetzel-home.de> <20240320213032.18221-1-Alexander@wetzel-home.de>
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
 definitions=2024-03-25_26,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=610 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260007
X-Proofpoint-GUID: HdaWtE8v9OXv-L899ktkoHTypj2r4ypa
X-Proofpoint-ORIG-GUID: HdaWtE8v9OXv-L899ktkoHTypj2r4ypa

On Wed, 20 Mar 2024 22:30:32 +0100, Alexander Wetzel wrote:

> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
> calling scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi device request_queue.
> Which will already be set to NULL when the preceding call to
> scsi_device_put() removed the last reference to the parent scsi device.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] scsi: sg: Avoid sg device teardown race
      https://git.kernel.org/mkp/scsi/c/27f58c04a8f4

-- 
Martin K. Petersen	Oracle Linux Engineering
