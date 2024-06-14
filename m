Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833A514532B;
	Fri, 14 Jun 2024 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331895; cv=none; b=kxFDdsMAoD0ZuOETKkGm3lMTgX3w8ObOk8KBOIQ4w+yaxwi2wizS/Nmu36Zifz1Gk+xXjzr1Vxfl7DAxHX0673AkaTZfHEkN23+H9pDaXv2mU0PKkdBlV7MeCAb8fFAGgzOw6KjiVPDs/7c70U5EwcQ9pU59G2r3wUBrw6t5MB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331895; c=relaxed/simple;
	bh=ytMZoWlY3T6/1y4PZKJPCyJB9wfqD73M1b9fAST+Qj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGox4qx55usvFDu5eALkAWG/q12pvLZISaUMpcM3q92qZRgDUNi0/DxLROLjli92JJqb/fJOzWUYKktdCO8aKG9xNd+HfQOt3Nud+yjqEvCO3cb6mvX8hEVWtLVGUwhWDt7RLLVGliQOSyUiaqLgyphhmBQC/y36XHtbWx/1ikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T+K02XZr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T+K02XZr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fTHS022852;
	Fri, 14 Jun 2024 02:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=XrfRu0md5jJhhvMuPZJR9e3AV5ULPx1ilpLbNcmqO3Y=; b=
	T+K02XZrtCGpUc1KGgq1YxzQiqb35Uip9zG6ujKMV+sd2fPo3XWA5/kensfV1xuX
	+YIjItNgQTStyBPIs30tbzPAryHnHWa+5JW78wYcF3Q96F1yIf6RmaIGpfc/gFvn
	R+pddzjcICOslcbW/5nyjxxyfeo8Yzay45xttuLIw/hlp3voUyk5Vz8jCsxcyaAL
	kdMweBEEV6Zpqro4U2k4wfjCm+lL6MZoa7NWwtHuzbwKtVMJ+caUtzVDP0d9ZBxJ
	5mXMVMUzY9nFUVPIiiubJst83gDrmwNssy+li4f5dhgM85NggjU/F+5dNCkqo/en
	F2tWhMrAp3vqqrRfJEXXHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dttbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:24:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E2IZuB012523;
	Fri, 14 Jun 2024 02:24:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1vs2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:24:35 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45E2OY1g011090;
	Fri, 14 Jun 2024 02:24:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynca1vs1v-1;
	Fri, 14 Jun 2024 02:24:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] scsi: add missing MODULE_DESCRIPTION() macros
Date: Thu, 13 Jun 2024 22:23:58 -0400
Message-ID: <171833163028.268988.11962134341142261590.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240610-md-drivers-scsi-v3-1-055da78d66b2@quicinc.com>
References: <20240610-md-drivers-scsi-v3-1-055da78d66b2@quicinc.com>
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
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140014
X-Proofpoint-GUID: weQJtNGLWCFQrvm7HXFkpHw9QzmCh-v5
X-Proofpoint-ORIG-GUID: weQJtNGLWCFQrvm7HXFkpHw9QzmCh-v5

On Mon, 10 Jun 2024 09:16:15 -0700, Jeff Johnson wrote:

> On x86, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aha1740.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/elx/efct.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: add missing MODULE_DESCRIPTION() macros
      https://git.kernel.org/mkp/scsi/c/95f8bf932b46

-- 
Martin K. Petersen	Oracle Linux Engineering
