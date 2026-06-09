Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD3B3438B3;
	Tue,  9 Jun 2026 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969164; cv=none; b=TXo4DSfCCheDLfGptSWnho1zWjIOgeO7rTRtWBcuosISSHE11vkiBShrfUD0xmW62g3yZCYHolUD1hyNsykq9bfkePx5jcmIEhQY0aQvXopLyeKD+0fHhZ1ZTHNzC5UO/kiDb0lW0mY67oep7nfc841o3/Rl/tadYVCYP+x1Z+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969164; c=relaxed/simple;
	bh=WqDPfOZCVtP0ATJufQEmaRo25lejofWet84gEh8Qlrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1roE1S9I1oH/t87347k6FC24b+YYBu9VyL2OOEmeKxLWv/oQF/OsfVxAG+iHStSaJ9TorMFxubxpLu7V2dvRk1oFB6pozgg03duESQnnIyR3SbW3DUSOnjcEFO8L8pBlb0peNUTVfRblWN0Ym0cpFbyuYOUJQ/KExIzwOjy8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qokAQ8sh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qokAQ8sh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HScFi1242881;
	Tue, 9 Jun 2026 01:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iV0uCMZkXF6OhjYYry3Oa2FHRgSKA4kLEebc1CgScqY=; b=
	qokAQ8shmimXxU32J1WZgkN9ASnLKMbcqTraEQLLUtwINKJiU93WP/W/ftTPV/Se
	4d7bMv/T3jmJY5ZDPC7TzpoKZDwAWB5y4jVrlSA9Mq6dyOmJFtXVbf7PIXAYy7sB
	/oelFmI7MyrsIbICkb1aV2i8kgCdneOzFNVcF1L1cWKhr+zDarXWn7Iz5tLKVyg5
	g5cZFV1m1u80feAIa89Jsk86FLqyLHQOjVRzrnJUcQd4MQF9bFruJYVYNBwuxUCZ
	osIXzr3wZZi6HDu2iRsUjn2eYMxTyv/NGa5XcZHuFm+R6TA24gYnb8E7FrTRSjiN
	pe1gItC4F+3fF6vFtY4G3g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybbg8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caO7028063;
	Tue, 9 Jun 2026 01:39:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgerb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Al030153;
	Tue, 9 Jun 2026 01:39:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-5;
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        vamshigajjela@google.com, alok.a.tiwari@oracle.com, beanhuo@micron.com,
        can.guo@oss.qualcomm.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Lee <cw9316.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix NULL pointer dereference in scsi_cmd_priv() calls
Date: Mon,  8 Jun 2026 21:38:58 -0400
Message-ID: <178094912094.1810714.6243928327478753156.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529010739.295391-1-cw9316.lee@samsung.com>
References: <CGME20260529010749epcas1p2bf38209e55149f0681550c220e541e92@epcas1p2.samsung.com> <20260529010739.295391-1-cw9316.lee@samsung.com>
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
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=930
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX+VXZ5xss0Zj+
 N1ueifsb7fu0KQzVvYDxiquC9dDwwzP4PYuBk7wsW3lfqHeH0C7CI9P7L0ShauHRVd3RXjOyx7H
 w9bCNomIZ58AMOQUGC0Adbcf+FiUSg5FIYVsHgSX54NIUNbAoFraE1swyBIJ9HRy8CEIsaNNORi
 od4QY1dBc8g4fvzXgX5dhJSBIbjp5L7KcdbicRhphXRbfztzgWK3zod+qrJu7ULacCjYDYAENMs
 GxeC2gvrQZb/xu7m6zkUEy13/WE76ApuIKYAdDF478CV0a1PhEFuE/+eNAwMPsRxOcjXCzJodcQ
 5VsjxrlWC2R53DvwyZxUHErd/oT63P/ZoNmrmz/GFf2r71Y+B935h/TiBOfYAVgAGEOBII17ITY
 EIK+qoXWEcARtqUT3+iVESkcDoVsdVJAU+kkrwERzVanapYDUKfLZhrhejtC7KbJ/dK6958cLz+
 QUsnv7NtozR3JbGha1y1cl1mObet9Cf5lukXrU0Q=
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a276ebd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=2xjKSZke_Td3YuyFDg4A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: vp1FF6IMvVfwb9_4Ep8EqXRsacCtxCTj
X-Proofpoint-ORIG-GUID: vp1FF6IMvVfwb9_4Ep8EqXRsacCtxCTj

On Fri, 29 May 2026 10:07:39 +0900, Chanwoo Lee wrote:

> ufshcd_tag_to_cmd() may return NULL if no command is associated with
> the given tag. However, several callers dereference the returned cmd
> pointer via scsi_cmd_priv() without checking for NULL first, leading
> to a potential NULL pointer dereference.
> 
> Fix this by adding NULL checks for cmd before calling scsi_cmd_priv()
> and moving the lrbp initialization after the NULL check.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix NULL pointer dereference in scsi_cmd_priv() calls
      https://git.kernel.org/mkp/scsi/c/4cf752f6b99a

-- 
Martin K. Petersen
