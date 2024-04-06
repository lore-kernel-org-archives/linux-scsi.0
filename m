Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E771A716;
	Sat,  6 Apr 2024 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712368780; cv=none; b=mVjKt+D8/P4Cs2JEl4fNQ5GacFKrJvXFcZSAxQLjYZTGMIt84rnvwfdW1Y/VeFXnreOsuLxX/lu7yM+jjHHujVjCXvblTrQ+pT/00gkLiMggr5WuFB6+AAmpUGJ5wTzQ4QuC34KIdZuhNw8re/qL7Ix5xr5BrvxCuzuFgIouquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712368780; c=relaxed/simple;
	bh=FyL8tu93bQa+tUnv5VehlK5yQiuu6PMdhbT+kkBL+rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OcLt4t6A/a9NrjeiUf8/8XF3zd2MfiGG5xDQ7NTrqD9ibLLTDPnYjfMqbJ8v98dNf6KmocItaGI2cljRDmef2C+8gjuxgoF5e0hBQAdXuaCVlB1Y2XTzc35idvmEHrBNuKJ04Jb3HNi3AC+5SLpcV+pltza2oTAKjaBcIfPZivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b63C3zjQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b63C3zjQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4361PGr9029826;
	Sat, 6 Apr 2024 01:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=Ymt66t5+YIavFVv0FGiiBYsKSl9/10gOmRtAWtzKMyE=;
 b=b63C3zjQrQRovzPL7PwlvrUh1+OjEgWop3dtkvor+1TRNM+FnUhgTs9zHUcSJjG/Dj6d
 CQIKra1dAW3SbaHriBFuWMjc0/v2kGjlRwQgszcl8fvZtyn79PBo6I4Xrw4tAVNuayqZ
 49VLEQlqKsZ139V6Nx0/XfnSn/N8WM8zT3FWbmbEDhAp+1psj5H3oQLDaqmwt7295+J7
 nqXay+1Zg9meQHmvytz5lnw+VFs5sAVLGyFri8BalR1pBaKrAbZ1bPxHmmsWlv9+MDd1
 nyFySHEFVhJq49vUaVRnpnZHpNJ5o8ISEapNfNld9JcYOXvN6GnUalN3lB+3oVSUBDDN MA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9f8pcjgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:59:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4361XVc7032539;
	Sat, 6 Apr 2024 01:58:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu3req8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Apr 2024 01:58:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4361wqvX000912;
	Sat, 6 Apr 2024 01:58:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xavu3repx-1;
	Sat, 06 Apr 2024 01:58:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dgilbert@interlog.com, Alexander Wetzel <Alexander@wetzel-home.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org, sachinp@linux.ibm.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sg: Avoid race in error handling & drop bogus warn
Date: Fri,  5 Apr 2024 21:58:31 -0400
Message-ID: <171236847468.2627662.5342437444989311589.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401191038.18359-1-Alexander@wetzel-home.de>
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com> <20240401191038.18359-1-Alexander@wetzel-home.de>
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
 definitions=2024-04-06_01,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=910 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404060013
X-Proofpoint-GUID: WOkGEMOPl6xZ0LzTGvGh84Dz-bTeT92j
X-Proofpoint-ORIG-GUID: WOkGEMOPl6xZ0LzTGvGh84Dz-bTeT92j

On Mon, 01 Apr 2024 21:10:38 +0200, Alexander Wetzel wrote:

> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> introduced an incorrect WARN_ON_ONCE() and missed a sequence where
> sg_device_destroy() was used after scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi_device request_queue which
> will already be set to NULL when the preceding call to scsi_device_put()
> removed the last reference to the parent scsi_device.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] scsi: sg: Avoid race in error handling & drop bogus warn
      https://git.kernel.org/mkp/scsi/c/d4e655c49f47

-- 
Martin K. Petersen	Oracle Linux Engineering
