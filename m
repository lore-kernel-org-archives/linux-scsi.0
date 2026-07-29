Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF1F396D38;
	Wed, 29 Jul 2026 02:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293738; cv=none; b=hNb1KusX/P+oSdGaRzDQIyyLpiDagzYz1J0RqYJf9J+KWg+8nZoWNf+XtzOtvZNptgujoGUhmCwJ48OtC7JQbM8Es/nZm4sJ5qglttRk+191Gdm6rW7zSPyEV8KgEeO904kiB/sfMkGiuMvyWXBarzoeoL5SnCso2FoOfzPkwpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293738; c=relaxed/simple;
	bh=qoUrKcKxay5OyFXhx2vGmf9vwNZhvNnIs5C+ot3zxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cELELouE7VqELfiLPWNuLlGnksUO1RGg2ZvcXJhOrShhXQMewsCGqhTK/SRO3oeNM+2sECF2MsDE3RiIIylTVKQaAFtHfnsrYTTerWZNDPe1uVh4Wq7fXJAhMsVsvkG/or++mi7tYTd3BgfOyl8YIU/GJS5gYk4xNyUi5ggkLUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gy3jfk4/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gy3jfk4/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYuZ1122259;
	Wed, 29 Jul 2026 02:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qN0YCKc+7qB7/7KidrtFUlXGoCGoZC9xob17VxT50KA=; b=
	gy3jfk4/NeNEodvshIIS/CpXulNKrIBkwZovnMI0VzXtw5d4hrzMloxepRJSS5eu
	zDAK5o5+ZUWKOfAAx0UXqF7fczlNQGV5l2vWui2Z2xnipSK6jAirHJqINJg8jg5i
	Kit6iNWKQ7CBanhQFt9xPn7Dv0JX6o82Ig2Mspi8eeoQIlt8MpuzkeAZaX/m3D8P
	1VEjho80A8z56xyjExyruPgN4naA/E8kmMSFq18XYkNQFRWyKbIguPugwzupwe0F
	C8XeWJaxQb3izCZn1GE5MHftDJrKu9CpWrqa/cZCUahYbl1GLPoqzOnVlQMU0LjZ
	1ZnbXb6PIz1Ri8UDOEcuwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xw7gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o6Km001436;
	Wed, 29 Jul 2026 02:55:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:17 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jX012133;
	Wed, 29 Jul 2026 02:55:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-7;
	Wed, 29 Jul 2026 02:55:16 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        prime.zeng@hisilicon.com
Subject: Re: [PATCH] MAINTAINERS: Update HiSilicon hisi_sas driver maintainer to Xingui Yang
Date: Tue, 28 Jul 2026 22:55:01 -0400
Message-ID: <178508193493.4027291.7324626207020209146.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260616032051.1268608-1-liyihang9@huawei.com>
References: <20260616032051.1268608-1-liyihang9@huawei.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=537
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-ORIG-GUID: NPbpz1_TvJ30HaxLzZ2B6LvhLMYDZbzX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX6sLTaCRDGd+5
 n8L5aB/2enMQp6MMr44WeW9kzLGeVkvtxuMyiJLxlvT2n/p1o2n13fYWzJdNeT+EXH164WWrZIV
 8LZNx3MuDzzEk5u7ZkI3AI9e/5kGi27lBvNsmzPlFAkpctGYMQ4/pOzEYNHHGYRO8P3K5ZQYtV6
 c02MayOfk3JY3S1twe5MXkvNyzo64Ddhs3Go37eHwrN65SulydNSFg12cBbGpcQ+seAIrx8qC7Y
 zAoyhqiPNHYcDimAV5AKlF8ThZTBQ2TcrVDga7C92iElua+02u/sTcfDvt6vcIiF7Nr4GrtZL2w
 kQskJNsFRBAEiRMDp39PJdaGoU6YARci3gdmva88/O7eZMiU1QlP9RRS23ksbIZCwEy/Wn0uvu1
 0U+ht4J/Y7H9i9CRPw45e3fDZkLlLyhOqnxaj2jGFm68CVxbMjzc0ihcVQ/oIBEdhLUST6IZqDo
 MfSHk/eV9lNwY/MXeuw==
X-Proofpoint-GUID: NPbpz1_TvJ30HaxLzZ2B6LvhLMYDZbzX
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a696b95 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=B8jG436Dnn5JbpuQ7LwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXzGg5wkjI5R93
 Q/i7NVUzdhhkE648b09SHkakXYnplxiNuyCDe24gTR8XdB36VJW7VmuiAJ80EvLAT4+9FkTczyz
 bi1z/7jBc0GZDdQneIPXSO11mFCQMEdXpb0de7bCl9qi1+PMTJoR

On Tue, 16 Jun 2026 11:20:51 +0800, Yihang Li wrote:

> Replace myself with Xingui Yang who is very familiar with the HiSilicon
> hisi_sas drivers.
> 
> 

Applied to 7.3/scsi-queue, thanks!

[1/1] MAINTAINERS: Update HiSilicon hisi_sas driver maintainer to Xingui Yang
      https://git.kernel.org/mkp/scsi/c/53b056ef7f7c

-- 
Martin K. Petersen
