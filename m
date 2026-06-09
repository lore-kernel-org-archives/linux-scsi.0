Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7014349CC5;
	Tue,  9 Jun 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969158; cv=none; b=LgNNVTJQsSpJVlgufoIXkpRRia82BzfC2vg7dso5X1ljXKFnKrIBwlvZkbWoh+AOSbO+LBKlKXlXsUy2QnDRsReJpvcW3s2qteinO98qNw+cykkkrVyREOYOWW4u00FACGalsrjDvvXT929FNQNMaofCvSe2fC1Zb9EHZ6zYcZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969158; c=relaxed/simple;
	bh=fvMCTVcN6KAdLp2AWixciq+uVtvac0zYkxWj+S5hoM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQESuDmOq8FxOZsA/G44kn0U6pL1I3x6SJO/6Bs2HxjVx/ebRjWdblMhVXACA1LRSw7lpydsgc5bCrp5wprTXEMG8qeDpwHmTje09W385jTWiSV/fZXht78R11z/W2tBFE2s48LUToA89G6Zwgbh1njQmBHLLZRU5OezsZnRb6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lb69LlS3; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lb69LlS3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65900LdE2349178;
	Tue, 9 Jun 2026 01:39:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lcl0BstYUxsefBqwipch3xQFnip0+fHwevCBG6NBclQ=; b=
	lb69LlS3m3K2kUUJlfIih7FxdCf1u7hjb1jy22xcv4FSRaeL5QyW7EX3Xsa1SqGR
	NIKkLeOQ5kxcIAVuaSrwB1/w0BcjqOLL275a/T3sdzN3ZYbPU2mOEhGVhsmwIcAN
	LOCfHyZKG+9TRnMSXriulb5AKqX0XwWkDADMtUeDSYCjsx7jVwOMxhf9EhL3K2lF
	fKeIqzNGIFxNEQfL2zxl62pTEru/fVy8p1MzrUwRSDP/UkXJgidjazu2/684eprX
	1c90OMYzJre36nhBzbFEDFh7rUFlrZZ+geebXWVgTQyWbOzqauC/3yZeiqTmPPdE
	2vZiAw1Ep3nAKhXKGVKOTg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emab4kh1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caFP028119;
	Tue, 9 Jun 2026 01:39:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgerw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Ap030153;
	Tue, 9 Jun 2026 01:39:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-7;
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Deepak Ukey <deepak.ukey@microchip.com>, Dan Carpenter <error27@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Radha Ramachandran <radha@google.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Fix error code in non_fatal_log_show()
Date: Mon,  8 Jun 2026 21:39:00 -0400
Message-ID: <178094912085.1810714.11673729902733436074.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ahs-bEsBJH0KhnsX@stanley.mountain>
References: <ahs-bEsBJH0KhnsX@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=810
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Authority-Analysis: v=2.4 cv=cL/QdFeN c=1 sm=1 tr=0 ts=6a276ebe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=7xTS_6aSO5IyjhvCIu4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: STkDJLyVl765nYv7hfLOWN7wb2lwavl6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX2Ac11xUC+G0O
 x4XrHzM1kL3jncpS0+3MUoGWf43ZBFwH7tYEZ6lockGfrYd9Yy397i097gxs3Pk+ya1v6BAalK6
 OaGbh81fmQVtrxC0qWTsLVkus5NNsGZjE7IF4B1kI7Uza294ZcuIUAdFtAO+qilzGAWPSR4lwt5
 CuTMbzCbB+hznM1+Pq21venz5vO6CO749MdawKHr8uIutv5a6sR3BBhoIapsaK3zBi9871H3k0N
 rIaNYWIaG5kQK9uUsRRqXZ0ger+23yXuppsSUFQzCkq4ED6K0z5lVWRmQgYXHhbpT8PcPQyP1ex
 px0DE73e4zmnltJls21bVyFmirSr7HocoWxLey7XDRnn0SEFOZzS4BLyHfWta2DsRwCDptlKxx+
 w0Ww4bXV/k8BFLrkLqyJBGLqj4nbDOf/V80Ig1X5QFrIRcY5x3KhZzZelIYDhsruUz/DOUU+0SK
 +NApLa1ZFfF2TMNi1uziVki6RVI+gdQjAwdc5hJc=
X-Proofpoint-ORIG-GUID: STkDJLyVl765nYv7hfLOWN7wb2lwavl6

On Sat, 30 May 2026 22:45:48 +0300, Dan Carpenter wrote:

> The non_fatal_log_show() function is supposed to return negative
> error codes on failure.  But because the error codes are saved in
> a u32 and then cast to signed long, they end up being high positive
> values instead of negative.  Remove the intermediary u32 variable
> to fix this bug.
> 
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: pm8001: Fix error code in non_fatal_log_show()
      https://git.kernel.org/mkp/scsi/c/1b6f03b7ae9e

-- 
Martin K. Petersen
