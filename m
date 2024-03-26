Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85611BF58;
	Tue, 26 Mar 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416156; cv=none; b=ikkXb7hPhynqcc4IRFWoviloograo/AJkNPQ3kSLxhVPl13hHiCEMsMr/s0yYz4diWRxBXtbR22xOdqjP0RbiIPCg56HXElUmvRvLpZSu28i3LX+QgHdMyh6rla+FzI9AF4iIRcOMF83aRilWKgkxdwuhMrKmkCSZitj2rSEN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416156; c=relaxed/simple;
	bh=/zvy1BaXy0FsVN/a8po256aR+SnO3OH7+CH31z0vBiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLYQ8oBRhaeAHCWnSIcMaXE1Ar4ADVucM2+VR5jmsb7Q8dDhvNe8Te3EZ5cVEb7iHUI38WbxS1+04vzEPBOfcnXoe73K2p3O4cs0i6yegDPy/s7WisBh9KCUCwPUaL3pWS3aOTR7lHh2l8MabNex0N6h/lMBBJR48OE3Cvr9Ikw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HdRwkKoK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HdRwkKoK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG26f002315;
	Tue, 26 Mar 2024 01:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=N/KeRr2q9pvDKKuCTTv7AYS0SB+2Dro+WiEupeavjcA=;
 b=HdRwkKoKIMr4kaSKtJeivc3TKl13flQwP6RAsm6Ty0dA7Gmc7sfdZ+P1IfZ0WFU13I8L
 qIy6uED2WSdX07bldU20Da2t4kTG+wAJTwm4WSnDZbQpEyN7gBlj5L5OLOQDttcNjTpx
 AYQagGkkG3F9Rrj81nB7KsKLQq4UN7Zl+C8GX6eFpo9+BqdUnQ63iffeIfObTpWMIqZA
 zC2o55KwfJGTUaMKsXuVROxK5zHoa+uW1CJqruC8NyJBi6dIvE+GfCrwav2pkf+ObYtN
 7czY577tUi3XHSLagTT5hD8ilLAfb1QX+RfXKUUIDKlr0Fl4zBW1ok9nyi251evCVbpZ Ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2c0bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q140is024714;
	Tue, 26 Mar 2024 01:22:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6hfs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:03 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q1Lx4C002449;
	Tue, 26 Mar 2024 01:22:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh6hfkw-3;
	Tue, 26 Mar 2024 01:22:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jejb@linux.ibm.com,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, kernel-dev@igalia.com,
        kernel@gpiccoli.net,
        syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.g.garry@oracle.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] scsi: core: Fix unremoved procfs host directory regression
Date: Mon, 25 Mar 2024 21:21:45 -0400
Message-ID: <171141606218.2006662.11145964739643960309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240313113006.2834799-1-gpiccoli@igalia.com>
References: <20240313113006.2834799-1-gpiccoli@igalia.com>
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
 suspectscore=0 mlxlogscore=843 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260007
X-Proofpoint-GUID: PeMcQ7PkllAYRKy9EnMQNAsITpGP4uuC
X-Proofpoint-ORIG-GUID: PeMcQ7PkllAYRKy9EnMQNAsITpGP4uuC

On Wed, 13 Mar 2024 08:21:20 -0300, Guilherme G. Piccoli wrote:

> Commit fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} directory
> earlier") fixed a bug related to modules loading/unloading, by adding a
> call to scsi_proc_hostdir_rm() on scsi_remove_host(). But that led to a
> potential duplicate call to the hostdir_rm() routine, since it's also
> called from scsi_host_dev_release(). That triggered a regression report,
> which was then fixed by commit be03df3d4bfe ("scsi: core: Fix a procfs host
> directory removal regression"). The fix just dropped the hostdir_rm() call
> from dev_release().
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] scsi: core: Fix unremoved procfs host directory regression
      https://git.kernel.org/mkp/scsi/c/f23a4d6e0757

-- 
Martin K. Petersen	Oracle Linux Engineering
