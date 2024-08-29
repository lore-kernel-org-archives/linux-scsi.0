Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08DD49634;
	Thu, 29 Aug 2024 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899893; cv=none; b=JEowW8hU0ylJwCfPWDItoOoebrufVgh9aWfKNamP5oi0FtDUIxzo88Y5PYT7al1BdOZaq8NjVfjoLDLuen4BgWo74k/aTdjW1azr38YfWyleX2mWHdPVJ+Ev1F94SwBHN89CdxLxTMOawwmjdLC+yNprOJ4sM9Y66XKYAfw6wcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899893; c=relaxed/simple;
	bh=+u1mD/GNcOvBp7Or6Rq8lskpdUt6C4ZFcwxI4h2WsKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UrMIkz3trsqwtxEBn1Swxxg+HvWd1l0k/gFpxFkj2mWLnnDnZ6kMcW3idHE5R0ZmfZGeR/XIBn0n8MA3RmlcvzB5keV3nyhZFAS1y0Pm4rgEh+HIFVNZcWN2Mwcsjx4xA9kp7mPmQETtD8ybVMmeM7+YCF3lTvuv/otgAKS/sBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JwFCz/yv; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JwFCz/yv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fbeD005695;
	Thu, 29 Aug 2024 02:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=aXqT3MQg0aTXbnTc4l5s7y27eLcWSg7gQ0UluBV+c7U=; b=
	JwFCz/yvbLFLj4BTpy3VGlZ7yNQ0g904JWYzD68xwGg+3Zajiek/6XXo4aRkY0PF
	hOvP4IM4vRPT4unJi/7eOefdQQOrJUbE2AGr+6YERjBI9xDXY5H25uRl3Ok7svBB
	p4hS9wEaOS2p09syWdWn/XE+4Ndzqy+xmsT2GCTUXnDA53R+zwNWg+Zc+wQKSSUn
	LHsLpD5f07NKu4wN7+EyaOIY4rxCjIk12UY98qnBsdd+6AudNMm9Cyt2z3RhtUfX
	I+VyvuYAbctFszbADd9Rn9Sakxod+Ad8+9e61hW3iEX2Lf3UUU919AxFwbuNDAeW
	da6JQMayUNVbaU6JN17RcQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwyu4wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNFwSO010448;
	Thu, 29 Aug 2024 02:51:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q4qm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47T2pKYo013333;
	Thu, 29 Aug 2024 02:51:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41894q4qje-3;
	Thu, 29 Aug 2024 02:51:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Smart <jsmart2021@gmail.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: potential use after free in efc_nport_vport_del()
Date: Wed, 28 Aug 2024 22:50:44 -0400
Message-ID: <172489245035.551134.9407681936193800615.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain>
References: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=603 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290020
X-Proofpoint-ORIG-GUID: lsGmAbYZ7XUXIOfa-hJw4li39Vm2d5_e
X-Proofpoint-GUID: lsGmAbYZ7XUXIOfa-hJw4li39Vm2d5_e

On Thu, 15 Aug 2024 14:29:05 +0300, Dan Carpenter wrote:

> The kref_put() function will call nport->release if the refcount drops
> to zero.  The nport->release release function is _efc_nport_free() which
> frees "nport".  But then we dereference "nport" on the next line which
> is a use after free.  Re-order these lines to avoid the use after free.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: elx: libefc: potential use after free in efc_nport_vport_del()
      https://git.kernel.org/mkp/scsi/c/2e4b02fad094

-- 
Martin K. Petersen	Oracle Linux Engineering
