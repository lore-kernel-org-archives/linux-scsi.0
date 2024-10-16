Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68168154C08;
	Wed, 16 Oct 2024 02:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046391; cv=none; b=GWso0W/rOGJzrDBNOFTLlukC3VK6l5pOjPQC32Qu3bwpUq0fUl9nrfTne4FIjTCQUSHot9uH/qOXoTKhP3uh1VSKiTXyib0tOZ4nc563of+LjZ3audfH9uw71GDA8TU74Pi3T/RjSOXKGX5xB8CnXzc8UmhH9JrQiz7ZIN+r5Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046391; c=relaxed/simple;
	bh=8ZmQFqkl/RbOyR2nQXhjIuZ/KP97SoLv32JYtQwgHMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1DyQV1THTnr0DunJneNj7FPgtUutM9FwVxditiEau+GcGjiPOwmJttsakIUkERrGZhScCsvnxIdXbq0RUCXXUQwR+GhSxB8+xazHul98EcJF1Dzge5KoBhE6ffHqFSwfT0nhV0d9jepJL/9GlFqIvmwNYviEUn6zQCl72cDScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DJq/BtyH; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DJq/BtyH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2MeV7020049;
	Wed, 16 Oct 2024 02:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DM7Vm8wZmOwLJmtQOHFJI0MUgywhFGds7HRJjXFSb2Q=; b=
	DJq/BtyHUzkjxAU4wC3jdMAi/XDZYz7SWqIxj9jLTY6pcw7FLsfeAG8/ATJ+S/qc
	TsGzfpZhS6AbHMWkqCQbBmwiY6z1PbcUzn6mmllOGJlT/MzrxLbksTXfiRQo2VUi
	Tw3OR7CRbV3Ln4edCbXw023LNAvdgbtZD+UWtbkRFrdYZbmJi+bRSP62k80fZ4FF
	lKn7/qFYDFhL+HvuqPOEf8A3RAA5Foc1q+WCPq5U0SZW3zbx6jLC3yqgGAkuxIEn
	tIvzh6Wr03vDlAJ1gFqcORz4hCT3WQqLUTicr3YXeVqCHIhRFmLgTUSmc0y98lgm
	TOPa4kQST8inU9tDazIOog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09j6x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G1h4hQ036622;
	Wed, 16 Oct 2024 02:39:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjem1uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2bkUf023540;
	Wed, 16 Oct 2024 02:39:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjem1uj-2;
	Wed, 16 Oct 2024 02:39:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com, thenzl@redhat.com, mav@ixsystems.com,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mpi3mr: Validating SAS port assignments
Date: Tue, 15 Oct 2024 22:39:00 -0400
Message-ID: <172904632510.1112721.9960192265513151218.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241008074353.200379-1-ranjan.kumar@broadcom.com>
References: <20241008074353.200379-1-ranjan.kumar@broadcom.com>
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
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=975 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160016
X-Proofpoint-GUID: rjvpHtA5ZFVjzSGJY0-JEBGewsNmlQtW
X-Proofpoint-ORIG-GUID: rjvpHtA5ZFVjzSGJY0-JEBGewsNmlQtW

On Tue, 08 Oct 2024 13:13:53 +0530, Ranjan Kumar wrote:

> Sanity on phy_mask was added by Tomas through [1].
> It causes warning messages when >64 phys are
> detected (expander can have >64 phys) and devices
> connected to phys greater than 64 are dropped.
> phy_mask bitmap is only needed for controller
> phys(not required for expander phys).Controller phys
> can go maximum up to 64 and u64 is good enough to contain phy_mask bitmap.
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] mpi3mr: Validating SAS port assignments
      https://git.kernel.org/mkp/scsi/c/b9e63d6c7c0e

-- 
Martin K. Petersen	Oracle Linux Engineering
