Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6363191A5;
	Sat, 23 May 2026 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506125; cv=none; b=ohGbHhcwi6ZYJk7dW3+l55G50O9F3fKzIfArEwoc83BqqV4DJh6l/P8vMLqKniTYAtXPwMx5DRFmOYoQuQv4dcQj14iC6+f9pVwiunjLZIAIaJtNOvQCGdwPqlHQ6FrDxWHr1sbzp3XUOeEc+Mszy9n9MpQTaXRIOAWE8OuIEZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506125; c=relaxed/simple;
	bh=S/TlpdcO4dm9i6ZHyYB3jJIBp4jOx+5nV3cdL/7tpdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFq92Wt9kmES0SCHwSsHi+u+GXKOgUgLTkb2fLfYGqVU/3+XHnXuP8NZwLsAK774L2v8q/65XQQQmNKF5Z5wfXebRXRyymk4MXhn71pOohB8uF4RqdsgTqbD4ayt6YTUUs3NsphUaRHRtxgsjtpON3SK+45zsl9ZggzgoBJfDc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZmkgL1ed; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZmkgL1ed"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N25wHK2307414;
	Sat, 23 May 2026 03:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/kmfK07dEaX16jBYxOGM/pypYtKDJKrUFWIOib2LsCE=; b=
	ZmkgL1edjmKYkm9BJT9Rh1Axb4TGbikwkik08gDcaS7KXw0QvMNJBBM5/ab31leQ
	f6EdU16AU3/xv2YrCXfDfd7wK/FiraT8zzhAPyDpKlSjGQJ7/yLsMG0K3UoM+P/T
	RgdDYPp3WmCHzWFS8rjOu9kvIIzBxx6bezzedNrAVt4gbBmSQqhEzp8y64fHyN5F
	LEK93Du3vpx92hEGN4w78mOxFIJu3oauIrqi1c/SKA3KVkRLPQRuOSWPChTabSVs
	HGd5esyhNCSmQhuyQ6z6sCY7YS7Up5o0duEh/5KHfRuZI7TvwK93/wNdOtgTwhst
	IQC4FECdWtOII3e/zFFKwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb35904mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F7LG032528;
	Sat, 23 May 2026 03:15:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:20 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eC032824;
	Sat, 23 May 2026 03:15:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-10;
	Sat, 23 May 2026 03:15:19 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Piotr Zarycki <piotr.zarycki@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: remove unused macro scu_get_command_request_logical_port
Date: Fri, 22 May 2026 23:14:24 -0400
Message-ID: <177913641796.1181900.3303891384134216946.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423081343.1813002-1-piotr.zarycki@gmail.com>
References: <20260423081343.1813002-1-piotr.zarycki@gmail.com>
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
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX7Mp0I9W0ahl9
 qKkkk7J4YHOLr0lRQ02jWE8IDcQmdTUq0hnPPSUNvbHlSZu38gAHccxKiE7KeUyfJ2BCPG1vjol
 YaAh4ugV9KogJG1RbwJS1819A46RFaNhOxEpVAe97pFUrmlOHdBuV7RsQGxZnxlsqkzyGfxKoGV
 yb5zx/pt90xof+sniBierEs8ivvFNtFpgn1OQfe5+Xb5ow8TXiEORNNWGMWmlgexGXBoToyDO/I
 PdiFbcheUpqsCeMeo9mS2ILt5SqSjK5+TifefyvaAX5HJ/34rnOvymwmj8Adlrj0Cb3L6lOo7h2
 eDO3L999iX/2UF1B8osIUrOvltup2HP4cf4RIIxwZEPOMuNy76cVFml2iTh2hKc87cZsCyBxPSI
 tTyUUHggcIsA1JPX85jkwNhdvrOo1GQT/QXzYbzQQP1ermlfA2cdlMVkAtIOYJrFlN4Bu81EV/P
 SJpNkT6MYQjKO52xT+A==
X-Proofpoint-GUID: coBz0OTjky3rbcfn4pD-bKhRb0LXPBCE
X-Proofpoint-ORIG-GUID: coBz0OTjky3rbcfn4pD-bKhRb0LXPBCE
X-Authority-Analysis: v=2.4 cv=TJJ1jVla c=1 sm=1 tr=0 ts=6a111bc8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=RMJTmugo21fl1VEQpQsA:9 a=QEXdDO2ut3YA:10

On Thu, 23 Apr 2026 10:13:43 +0200, Piotr Zarycki wrote:

> The macro scu_get_command_request_logical_port() has never been used
> since it was introduced.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: isci: remove unused macro scu_get_command_request_logical_port
      https://git.kernel.org/mkp/scsi/c/016d484531e3

-- 
Martin K. Petersen
