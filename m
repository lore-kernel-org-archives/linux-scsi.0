Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E029936E494;
	Thu,  9 Apr 2026 02:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702622; cv=none; b=aEjpK0sYauA55vxiGyw7nq5p3WcQavvqfAqPQaLvbIc3Mj2qvzzusZ+Cdj49kyEW1W+N2aElEaSYTrY60aF9SsEP/PjkbqYSjaeNTiU2XflH6kgo56Q4uzQy+7TEN03XDvwFRnSGr5g5fkQ4tnwCNKSAb9TmJGs0Sg5A5UvUZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702622; c=relaxed/simple;
	bh=4L3G3CTLMBhQS2Nvxi+v4k0Qt58kOe04fDUTJtD6HXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hB96UK4YGjcZ3J3WhgjCEsM+FpwIEEXk/Lb7Rgpvb++CCg88OyS5M7SEw0+cQysmawXkFr0MGPl+Rjkj3GxW1jcyjxMzRtoRem4k1rmnHkEu0J9iPZhjbacvbksTx1lofQqMiiRygTXioYWo96nri3tOIRxJ5IpRTxuFZv0oXoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WhuOHHTC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WhuOHHTC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtaPx1191005;
	Thu, 9 Apr 2026 02:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E48yepu0gImOFl3SQLdLwtXTeCoGXAqP9lmTmgK1BOE=; b=
	WhuOHHTCeTZjGqLP9IcHHqxVqBggLEn9MDsGGTSseQnhTvpqXKzfwnfgpL7J2Xpu
	BhwMMGntVQv6arqoEgMzm7wEzFYf+E04wUliOqe7R2RGW08NtIDZN4xUB6cYiJ31
	UCCOEXtA7MzoPvzP7FTirUkDlyozFvFGH42zNZ9oSyaMetvoPZPvGDsqbISWmsu7
	TiBulm1J/MdxqztXSIe7stpOydJociFvwLicuVBECCSL53+ufJDE1fo53i/kR+DE
	e2/XBVq4opjCVOERHV1DTZZxnFla9bdGv0Cjiend9KSDwqNW+DObaGBDt+gl4O9P
	JhdHTy50o7Ba4TTG/jXzTg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavx6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6390v1Cj003435;
	Thu, 9 Apr 2026 02:43:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5xhrbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6392hSUv031599;
	Thu, 9 Apr 2026 02:43:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5xhr6t-5;
	Thu, 09 Apr 2026 02:43:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: don.brace@microchip.com, James.Bottomley@HansenPartnership.com,
        Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, kevin.barnett@pmcs.com,
        thenzl@redhat.com, scott.teel@pmcs.com, hare@Suse.de,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers
Date: Wed,  8 Apr 2026 22:43:01 -0400
Message-ID: <177569866585.3870441.12256409459304830257.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401120552.78541-1-pengpeng@iscas.ac.cn>
References: <20260401120552.78541-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=736 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfXyp99VEgmJ4SO
 eshD5l7pqSS9sXOtwEVzOdkve21ApbMUVlThn+zy21EswuieJma1YjXFH2dg0BYlxuLDESFo8nr
 ISpcmvxKcf4Ix8QmlFtlWPzSOHLdQUGaFR/lF1kJYFdKOwCTUU+aXvjDH9wZ5W9m+yQ6jmBBGEJ
 bk3PQI9tkwxBpHbXuxT0uOcKcF3YwAYe2Qo43KLYc2bSkJoUeB3cKhK2uliFC5Ml4xg7rG24tVu
 3cu8zQw/x2e6Knqz/IvyFsnMFPqh6k4zR2/m14Y8v+6gHlEJFfSLFYQjSd9Wdf6zz+IGHgiZP17
 jezyGBHBH3s04zM3iL8abSF7IdQMUOfma76lzoac7DdgJXRkf9GQeLY0b2BDkQjO5epg6U9XwuW
 1cdibcLi3KOenSoS/qI/eBIHu+kMEdqFshhSx1Tb3aOBAfkcU5cckRqmDmYk8xVHsFTuLW60dVU
 O9hGxdnyE83jqZmF/EoviSPnBjLvlFLZDlosTq2U=
X-Proofpoint-GUID: 2Da6whTBoL6F7npZGPQ2CLwd3H3Eog-R
X-Authority-Analysis: v=2.4 cv=Oux/DS/t c=1 sm=1 tr=0 ts=69d71254 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=N0M2C8ydvfr2mGhdlfAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: 2Da6whTBoL6F7npZGPQ2CLwd3H3Eog-R

On Wed, 01 Apr 2026 20:05:52 +0800, Pengpeng Hou wrote:

> hpsa formats the controller name into h->devname[8] and derives
> interrupt names from it in h->intrname[][16]. Once host_no reaches four
> digits, "hpsa%d" no longer fits in devname, and the derived IRQ names
> can then overrun the interrupt-name buffers as well.
> 
> The previous fix switched these builders to bounded formatting, but that
> would truncate user-visible controller and IRQ names. Keep the existing
> names intact instead by enlarging the fixed buffers to cover the current
> formatted strings.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: hpsa: enlarge controller and IRQ name buffers
      https://git.kernel.org/mkp/scsi/c/8e8cb6f39930

-- 
Martin K. Petersen
