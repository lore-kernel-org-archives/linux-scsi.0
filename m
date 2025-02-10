Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BC585626;
	Mon, 10 Feb 2025 02:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156357; cv=none; b=POzXXx8pi1+h0gthOh/4Av1TGldcBJU5kxaXLSRyc2SqtaS16N+RSjd1zO4/2nXUuuwT/pBCVcGmYQwHNWHiH45wWsQ3Nmd13A4twEBkZtMfUlHl+f73N7G/GAK1G44OCAaYKBWvtIrgRf0u+X3PcEqdHCnGqe7DZoFUPpZ1zIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156357; c=relaxed/simple;
	bh=gfBujoegP+kXg6uQVRe5dzHTK5lDBiUhafwAaO4cZio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrXTldaau/FGxHdndD4neceGTbH+L03Cgz09fWfXQ8CtwUi/ltllrjoDjfab+XInmQptuifsNbtZfG0f3/iBYZ0TXMm8clW4Qp2yeSJbuypO4Jj/ve/6wogsl7hpMsh5eenKg2CuRmAaLlL6nsyIIpYw9xhVB3JQmNwlojs6Mbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mqD8ftBh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mqD8ftBh"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519MPu93029995;
	Mon, 10 Feb 2025 02:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jgGa/LI7CFzUobEkkBBIyQidm/y39vrcJuona1N5w20=; b=
	mqD8ftBhNYTKGfpq3Cy51KvfBPjLRMsxTXn/Gcnpn3VwzU8fPHq1jv1h82ksPHHQ
	llqISBjEuFsZ65XDO501foROg/s0kHzKhYteCc37J1gZveSAhpR+pC+YYdZkVTlm
	TQ/Wom3AezW/3PWs18uTd60sgxnZQMfBLTK2B+Rw2rtfbLmXQZm07QTVfhFc0sLT
	wMHTGPUG/Yp47nfy5jCcGLFvr36OFFkd7uzlxusCK1dHIZ7gt64HNIPQZZ2hUPWr
	ZMnL1t4L1am2HYWS0W4+AmJWsCVAIYnoLuhhLwOwLJA2jPNHNlIkSQ+SQeI3oaZC
	6Wslz/JSsu0oj64n866ZYQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq24wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A23lP0012551;
	Mon, 10 Feb 2025 02:59:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uad5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAX033952;
	Mon, 10 Feb 2025 02:59:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-1;
	Mon, 10 Feb 2025 02:59:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com,
        ukrishn@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: Re: (subset) [PATCH v2 0/2] Remove cxl and cxlflash drivers
Date: Sun,  9 Feb 2025 21:58:23 -0500
Message-ID: <173915612139.10716.387713440778948780.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250203072801.365551-1-ajd@linux.ibm.com>
References: <20250203072801.365551-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=744 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-ORIG-GUID: BfpDD0j-Mm8NjPJHSBTyQeRaORrK113D
X-Proofpoint-GUID: BfpDD0j-Mm8NjPJHSBTyQeRaORrK113D

On Mon, 03 Feb 2025 18:27:58 +1100, Andrew Donnellan wrote:

> This series removes the cxl and cxlflash drivers for IBM CAPI devices.
> 
> CAPI devices have been out of production for some time, and we're not
> aware of any remaining users who are likely to want a modern kernel.
> There's almost certainly some remaining driver bugs and we don't have much
> hardware available to properly test the drivers any more. Removing these
> drivers will also mean we can get rid of a non-trivial amount of support
> code in arch/powerpc.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/2] cxlflash: Remove driver
      https://git.kernel.org/mkp/scsi/c/772ba9b5bd27

-- 
Martin K. Petersen	Oracle Linux Engineering
