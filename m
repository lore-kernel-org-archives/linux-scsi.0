Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B911A38EC;
	Tue, 10 Dec 2024 02:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798190; cv=none; b=H8Xm9sq/TuwAqkez2FoATZkTJAPxgyn4P9Hai1OJhz8AJrpn2Zez/Tjjy0NAHbRHgnGSk8yxyjVPIxQzh7AyQ8jido+3WZR/qGTTRNToCY2uxXPvFY8NOxKlVJ+kwjx5aoxvld7oXEc9MYezO4t17q3+qlOp1Tsmy05ok7vqj7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798190; c=relaxed/simple;
	bh=pBHDWDtv/KON9HnyBcwoqiUQtrMK7jjHJUoxeRFCOm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p2pfSSYZion4MnWR03EQoyPob4eCKZmEZ37//DzdbVEETu0MeHh2guHdFl5IwS83t9uZW3i6G9SLlkRJDd43aGKWWVl0z+5iKxdifrnQcy38mk8H/ytk6VFaMO5IlF8VnmeqIILvwQLjK7KVe8XERAZIHnawfwTikT0K5bFweKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RPA+c50U; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPA+c50U"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1Br8x015769;
	Tue, 10 Dec 2024 02:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=C3olmAPu+fdbPHIFcO9VF7oU/i0y2ToLKE1X/q1s8us=; b=
	RPA+c50UsmAbLKeSptKzTowSfacbOhJ+eilnqX5xTuGX0Pn1pfDqdGWHki6lSyTX
	offQqixDOg6v6wFXzgc2xG4SoVuFO46tqdkgNqoPwEUBlWzm7lmafims7Wey1Ydf
	Jrbdx0sYuKqOzQDGAnVJmJExYTdGnMTu8xXpyQMAce7AW/Bi08uRv632cjdsqCNJ
	CJt4MnEFcsVyVTYyQ5kSb9YiXxFeJPZ0GpqbKSgTFhJNt9KFleegyb01SkgnqMIp
	j119pYxpQ3Rl4RM8Nu5zYuWDzbTY5HtTDACRGk8Sef3k3Ax+V3b0ejldVvSj3iJg
	QnO4Hdnz0HpbfQ9PZc40Ug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cedc4qky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA0LERu035674;
	Tue, 10 Dec 2024 02:36:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIut010256;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-6;
	Tue, 10 Dec 2024 02:36:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        TJ Adams <tadamsjr@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Do not use libsas port id
Date: Mon,  9 Dec 2024 21:35:37 -0500
Message-ID: <173379777410.2787035.11214603534500531629.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241121194915.3039073-1-tadamsjr@google.com>
References: <20241121194915.3039073-1-tadamsjr@google.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=624 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: BwlAVO5z5pR3GxxPcoDq88oAvyGzZ5Oc
X-Proofpoint-GUID: BwlAVO5z5pR3GxxPcoDq88oAvyGzZ5Oc

On Thu, 21 Nov 2024 11:49:15 -0800, TJ Adams wrote:

> libsas port ids can differ from the controller's port ids.
> Using libsas port id to index pm8001_ha->port array is a bug.
> 
> Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
> to get the port id.
> 
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: pm80xx: Do not use libsas port id
      https://git.kernel.org/mkp/scsi/c/0f630c58e31a

-- 
Martin K. Petersen	Oracle Linux Engineering
