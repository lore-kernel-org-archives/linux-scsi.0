Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B411FC3;
	Tue, 26 Aug 2025 02:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756175651; cv=none; b=IbzgimSZMji36ExgXp1Xq+Cq8Qe7+IDcXQ9zWz02TpVU3DiZ3c6+/IdW4HTZ4y0nFqb8oJBVuR02TWr/YPK6hL9teIsGmmCyTJz803S4bPLAuW16HHa8lYMKMRssGImG3/Nb+ifoXsqBbdu0FKDmSGFfiOwljSCouak9RU+PkVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756175651; c=relaxed/simple;
	bh=DZ5xZYLURQq7ymuM/fSbkYpM366kgzLwlt/Hsx+Hsks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pgr5TfXxpFYKi6voGt/YKBEY4SObxJlvkg3ThTIsYez7eKshegR6+X3CmbzLNrNKwH/FcinrVIMCe2IcXvWtbJ1ZxxQz+Lpma9L6yhUNX+BcMDZ2C4lzcoEyQOwRwWEUAuHs6P4rTKpPa48qZLxm92hkTkwIE2t/6ft2jHV+JDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TSbTWkn3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TSbTWkn3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1ChK6019414;
	Tue, 26 Aug 2025 02:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R/WiPdnMXZZLWe0ZOEXjRWzj8txz+VMrrfGtuW5IiI4=; b=
	TSbTWkn3QSoom2fZVZq6I4gbdaV1taqwVZ2oRyMD55B4GIkmNmRD/QoiB2FVc0zY
	GKAQOrm6XRlu1AbkeN2Td8fhSgDdnbI6nnt+6lOmuqSNdjUcAQpCgLN/CyZ5LQH7
	xl4ZFT5h7rM3JWe49gD68BkFyuW1I+Mb+rGPDbzWw2XFZVMEdejF7o6tgQk+oiGA
	OogY2ziAxzygGgNhXTbA9MYcETyX+OJU7MviwoVo1J9ZxX0XJOkatJLs8yxHxibH
	oxcAbDuvxPU3JVGMKS10Dm06oQ044rt+t4/PT4KlTOOiwEBvqSgUZ0J7G+v5fGIB
	5Fp14hC+VsbCqrE0We6duA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678ufg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q11uAs012167;
	Tue, 26 Aug 2025 02:34:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438xc4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:04 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57Q2Y2s6010861;
	Tue, 26 Aug 2025 02:34:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q438xc0n-4;
	Tue, 26 Aug 2025 02:34:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: myrs: Fix dma_alloc_coherent error check
Date: Mon, 25 Aug 2025 22:33:56 -0400
Message-ID: <175613417245.1984137.8175631376985311720.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725083112.43975-2-fourier.thomas@gmail.com>
References: <20250725083112.43975-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=594 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260021
X-Proofpoint-GUID: KeHSuBr1O4cPLA0SLSeuiTxrvH2YIvB0
X-Proofpoint-ORIG-GUID: KeHSuBr1O4cPLA0SLSeuiTxrvH2YIvB0
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68ad1d1d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=V2PXUoC8NQQSPf-sLb8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfXwEgcVR9kjGu7
 jG1332SfUYsMsCmm+0/7pBSQcFDc+FkAF5Z+S1tZl/Cf5SSJVDdH62b5MxLts+5ikOYuWBbCg8Q
 SF9PuWk3wqex4RY9S9xAw4DNcMTwGKHeQFVNGekuWEPGmxjs3espJvpIHI2sGePkGK0mQNw97kW
 msciWgTp+drs5/VLvF61CGq8b72VLdU0Hqa3p6HZVrj6h45GuUdxUHKpQ3j4fky89SrudPCqXAg
 gpO42WotLGqJfsNLSN9YwfhWWay0fqHLULxGmd2p7dN5Ev5v24aNSd2o3cojZAYUhA1Z2TEN6df
 2TuZyQ6Oael6dFPAs/tSUmM64R+9pOyJcAQE9Nn24olWd+CR3HIusFNBweQJ7BVYWjee+zCCbPL
 xqJ5cOBGOsN3FPdb14l0JsLRHDUaFw==

On Fri, 25 Jul 2025 10:31:06 +0200, Thomas Fourier wrote:

> Check for NULL return value with dma_alloc_coherent, because
> DMA address is not always set by dma_alloc_coherent on failure.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: myrs: Fix dma_alloc_coherent error check
      https://git.kernel.org/mkp/scsi/c/edb35b1ffc68

-- 
Martin K. Petersen
