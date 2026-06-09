Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648A23264C8;
	Tue,  9 Jun 2026 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969164; cv=none; b=bLwmtt/AiisMoQUPQf1rv9bJoxUlQAGl6/RSST0N+T6Lc9MhuWni8HZevqiJM7a1Ww4xtGReFqT5PJB5oidKXB81iQgG38NXVA634nLWspygGvdQvD7Q70EHK5y3UUDoq8Wca/+kJTV65Apguv4f2g071ft/aYKQFZ8K6pgZd9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969164; c=relaxed/simple;
	bh=mc+Bb6rfZS6EOKIIjXeo9QpX4yFLN+sGrFwjH7WuwUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebA7jDLz9x0aI08cKbuBohGWf75pjNgFycBw1Plle4aLw+NVsMP9fesPVVcUkkKgDose6ezVwaiA10bTMH3AmDCuIhVEoVZpzZGog3fOeq1/AbEmWphf6/UrULBFOF8xTY/z12mXTjrJp3vUlwoH9WbRXwhCuOnmZjHoI7KGU3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZQEHjvvT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZQEHjvvT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSi7h3977686;
	Tue, 9 Jun 2026 01:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mydQD02UmcsRVK29fqE06Hp20RIXuzc/oRdwuMlt5r0=; b=
	ZQEHjvvTXhayJrzPBIb/gUx4V4hinZBHe6S1FHRAT8DTrW2eMme0KAAOfKlxsF9n
	Wl/lkIEUiHHpD9W4kuUhT46J2WA8YrKmKT1nSWvo0GyJA32PB3Gjgkz+UQ448cOP
	k98kXw6HVN1516rDlGvK//Tqb+77CSSr3bZ9yocOrWqjRUdvnXLtzIM7C+gKndtN
	GT3/SrbRjLwQcOxR23zXv+cRg9nmEQ+N0BvTU0+ndtQJ3WMN7TYBnGHWmdzpFFVE
	9jTf9PzHu+yFZek9q1+/s8G5Pf1S+xSGQ0wK37Cwqd55q4wcXybB9v9Lz/isvFDZ
	yHYhpgLmztT+53fbrlI/Fg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjbg62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591cZrZ028056;
	Tue, 9 Jun 2026 01:39:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgeqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:07 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Af030153;
	Tue, 9 Jun 2026 01:39:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-2;
	Tue, 09 Jun 2026 01:39:06 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Lee <cw9316.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Fix wrong value printed in unexpected UPIU response case
Date: Mon,  8 Jun 2026 21:38:55 -0400
Message-ID: <178094912094.1810714.8904739851367417954.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527092134.275887-1-cw9316.lee@samsung.com>
References: <CGME20260527092151epcas1p125118deafc1caad64c4c2c9620124969@epcas1p1.samsung.com> <20260527092134.275887-1-cw9316.lee@samsung.com>
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
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=870
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX2rv+4oIcfuVw
 SfydOp5/hmEY77NzzvBUhfYh3YAPuN/sVCc5QMYC3tKAinB0s4HCpiK2ecitwHxMu2ZPOXRwiCf
 dEBS8MHmC4a1hReBS5nuquZ+nWOZC47Lr9MRZRzQ639z5ITqcruuZ0DoIerVMh8uBGaKKQdJtXR
 +zCMxx6VTsSDoeGBUNnlYBB9BXj2Y8EDs35QoYENrv3kE64aO3gzXPg48PvSFw+VtK79BGafqiC
 IIAe3LAi/6uE50T5Db4RXVIlAoQligJGeBP/X7phwgqSy4PsPB6nqwaqsv7gBuJxzAtbxjXF4kV
 pVLBgjwDncAF7AspoHCTFeY3MvWFoxgsfFXtHGkIo9ndqnMT3rakFd8vlfYm66Nu0e3i5IwNDU8
 MCsL2FElP30I7FW9F6CAfMQpfmhnF81VBKgsFCtzw/CKjt+opH/IcQgDXR0sQSS4ftC0HANGVlb
 iRhLTzl25ieVtBAwrNXfIYp4szH1iAe2y8FFGTTM=
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a276ebc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=Ugpoo7-HI9-1WNIZmqIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: iBklBOgB_sfMI4UxGvuVmrvI201Q4UYf
X-Proofpoint-ORIG-GUID: iBklBOgB_sfMI4UxGvuVmrvI201Q4UYf

On Wed, 27 May 2026 18:21:34 +0900, Chanwoo Lee wrote:

> In ufshcd_transfer_rsp_status(), the default case of the inner switch
> statement prints the UPIU response code when an unexpected response is
> received. However, the code was printing 'result' variable which is
> always 0 at that point, making the error message useless for debugging.
> 
> Fix this by printing the actual UPIU response code returned by
> ufshcd_get_req_rsp().
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: Fix wrong value printed in unexpected UPIU response case
      https://git.kernel.org/mkp/scsi/c/2483ae0a5623

-- 
Martin K. Petersen
