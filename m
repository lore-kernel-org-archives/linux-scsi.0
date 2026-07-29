Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E501D388E6E;
	Wed, 29 Jul 2026 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293800; cv=none; b=kVK/8kjNo4wywpufPuREBUO8nnmWRTod6IbAxvLYry2n1avOfu7mALnbQd73v+b9gzJC94wdpb3CVUvhH/duCoMgpTvP6ld0EM40fRj+Mw5XaM8sb/0Pa1kTYt6evRIR70cHJImlLDXDU4WVow9tdFXpnP4tglJTsnScjnNTLb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293800; c=relaxed/simple;
	bh=ORykuup+IZnrVf9GNo/PcG4oQzd4oKF7ldTe5RwxrNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HfW/vu8Cm4zVHwKjdBrHSb6rslV76XN9qu9PVWMSqqqg3sv0k5mbZkQ418dl80h0VanhKxL0Q4EASHgDNRd84i/TBZWuZSczPso2W4Pk/Mp4ca9kDiTLcoceCw5EiKG4KWlM7r5Uiklg4G6WR0zu8jjV7nGxxLOkIyFxOwL6a+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dw6EfuIS; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dw6EfuIS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItprZ2091565;
	Wed, 29 Jul 2026 02:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pM6DxPNxLsvU8LY22sGlKV29CpKm/ebW0ywIEzn/ZV8=; b=
	Dw6EfuISxIF7NXRJy4ID8DqsTcw/j9MfTZRCDEF7hlqY9AslvA3ucRqbXwfxiVyp
	CBn9KWfpMh+UeS6k4IxOMwMOzKI4bsMzhpMBhKPBXaSpumGOZvtmHmH+xd7rm0Zx
	rCihaON4GpZzRvmeK4AnMMdAYtJ7npmXzQ9yLeRk0Ys6WjxBGg9ULzGMrZIDm60C
	kzDwAQozlQuf0nKdWgYwljIXuMtMxH6+9+AJKqvcZYXGTZHKmqJa7sibYRdU6SX3
	q3bFAIm0uu5PwNs2n8SOr3/bsjuAAwNaiQx8L8y9lU3qMRO3C/814YwV+wiaZKrV
	32pEZRZaX2mGaAU1JMvl+w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyd852-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oZaN034681;
	Wed, 29 Jul 2026 02:56:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:23 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uM9t006812;
	Wed, 29 Jul 2026 02:56:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-1;
	Wed, 29 Jul 2026 02:56:22 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: beanhuo@iokpp.de, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        peter.wang@mediatek.com, can.guo@oss.qualcomm.com,
        Ao Sun <ao.sun@transsion.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyan Xia <hongyan.xia@transsion.com>,
        Jiazi Li <jiazi.li@transsion.com>
Subject: Re: [PATCH] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
Date: Tue, 28 Jul 2026 22:56:08 -0400
Message-ID: <178529373879.132455.5533663384919370035.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723034440.217-1-ao.sun@transsion.com>
References: <20260723034440.217-1-ao.sun@transsion.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=642 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXxW/Ik6Kp4MR7
 d3Q798XKNkMrwGN0wSaSPwihHp7MNk3sH3QxGgejYuqwK/YGEuJ3xFkqGT/RDL4thJz+h1ntuug
 i0JgScq+onLV+yaYxALhEk7FeRl9Ty+Stui0LrT+qoCxeot/A49D
X-Proofpoint-GUID: -6WCjGLZ0qJjzF_SVMo1woqVaErOXm9w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX5TubIzx6Ubw2
 u78NVVL+PNG2dlIcuBV5HWIAjPCgCJbqB5BvC2biNbdQYadQNMtIVokbocgnt1cfvJ2nUEqAlcB
 12YHn/MM/TaFVSF1FDvpIaWE9sHJ8/eYw53KPqev/gxfbaSeIG1b/HzpFk0+e+Ukk8HEICEr5eR
 v6LMH9e/pParM9rlOOWSLQKcOL7Hz6Mw4GI/I0fvUYOOGksol1kA/tWFhtKq9DvZmsFzxqO5qK3
 EMR2uuoUqT4Q2qmFEn2VwEbBn2p9ifHmRjAkcXUW/KjHYZ1/xxZ1so1xsp4vjbz0VuOM+6LLoY1
 E4OLZermKtcZ89dTntAf0a0DyxxWsjyq8Gn9cJgBT6oMXLyUB/6EWM+838rdzMOWJtT+EtfMel9
 wfp0hhafNLelYtQz53qXnBZP+odRYlB7zUj35/fEz292Gj+EsH3eWSi5qekcBAzY6QiSxXD62HH
 EizWqIv+460uKJ/eSzbi+ptUdO1/ZazrOhr6uEkg=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a696bd7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=rNmoWWMpYImIKKn0FjAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: -6WCjGLZ0qJjzF_SVMo1woqVaErOXm9w

On Thu, 23 Jul 2026 03:45:30 +0000, Ao Sun wrote:

> Initialize the hba->rpmbs list in ufshcd_alloc_host() to prevent NULL
> pointer dereference in the device teardown path if ufs_rpmb_probe()
> fails.
> 
> 

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Initialize hba->rpmbs list in ufshcd
      https://git.kernel.org/mkp/scsi/c/0279fd451a99

-- 
Martin K. Petersen
