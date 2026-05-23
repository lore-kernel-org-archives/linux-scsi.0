Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAF344023;
	Sat, 23 May 2026 03:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506170; cv=none; b=VMo87Dts379Gq6BVXzlvR4e4nd6eeE2kM6LznnqM2EXy4QQwBojWbksxR5wAKrB0fa+n1asuVqrm0Q9K7hzZMn+OKLUFxdidz64rZh/bRZmeaEY/iU3hbvOz09jWIqai3NFZZOEni3avyiomSXHoEmPP5RFaS82Tgo8yg2PGNrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506170; c=relaxed/simple;
	bh=OPAz2Y0BF2mtliKYBhVjFTFdRd/hRrHEsoY8IjmWbCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYFrTD9LTj1QU3fXLSKsbtgyxnNVE95+l7vUzuXctz6RGqgGRQ2eWRYYUq7vrT/uYb1HhDj77vexXGEZwDEsZl/byPAWp6dcWBT/epVs2bMoOw3/pVHGLF8dRAFpTIOiDJABmSfgT1NqRzaBt5XslqJ5JokslaMpXrCpwDae8m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jKpe+0b8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKpe+0b8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3ChTx1944381;
	Sat, 23 May 2026 03:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ogFu9mwGGgFKS9MjuLerYjJWZD9UcsKhg/TOlhzpNf0=; b=
	jKpe+0b8vBUdAo3IdVzKZmC+x6Oz7yMitXSLs6ZvMLqb0d8zTQ4XkJ5Cqc1lfIN/
	T7ZDFPWou8q7e6p2X+Ra5R6hpsZejmqUos60eLNPNJJu5z5iCIQRxNWrP5JJkK0U
	bVgoet8Gnb61gXN69adWSong3NV0ghpCJZdPE5XcqBSAIGRneHGqE7Cmj6cH1r3C
	QIcpkNPDQWUTY9mKoSrQeBsZR1Lb5Mzq0tv0pDBTQXnz6EeUqf+zpKLCGPUxJymi
	/yp4GhZeLvms0Iz/hOI8HHnoR1kgF3DJxpFxYkc4TjSMYl2aTwL7BGTPlLJGqMO6
	e+48cqI9GvphpqbrPtrEBQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb447g05n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F69K032365;
	Sat, 23 May 2026 03:16:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:00 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRM035132;
	Sat, 23 May 2026 03:15:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-4;
	Sat, 23 May 2026 03:15:59 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        mlombard@arkamax.eu, ddiss@suse.de, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Fri, 22 May 2026 23:15:50 -0400
Message-ID: <177950426869.1557613.4511172889873596665.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260521151121.808477-1-hossu.alexandru@gmail.com>
References: <20260521151121.808477-1-hossu.alexandru@gmail.com>
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
 mlxlogscore=865 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Ecn4hvmC c=1 sm=1 tr=0 ts=6a111bf0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=Tq2vKD9PR_ByvZOGbd8A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: 4T_DwIaPuLkbciG5tYsTKdnx2d0cdaus
X-Proofpoint-GUID: 4T_DwIaPuLkbciG5tYsTKdnx2d0cdaus
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOCBTYWx0ZWRfX6L+TkKafcm9a
 l4G7xwJQz4OdCqiMEO78IdVTeBhCDCgCzAAJjj6zixAyMNFMYh688I2IT4DOVBRvWfE4o6lCGX9
 F1d+dP/tHC3oXB1IPWKKs9snHLyPrn2VMVNJg7ZG3Qs7VMbbmLxvxOZTWE4l5eP7CWiOhzZJJJy
 lZIoOopPWUb0GMGDes8qsKP25OAtCSUzDgvqAAKK4Xnsuc0cmBttvq8R7OzBREZU4P9fMVDVktH
 y/uuMkA2njaTIDSGe9/AlQouidd4ppUOcYuH94YNBgJuEgRSTSMr2fQr7pJnG0+sLGOhTokRGJo
 SPD+DCJdgBKTJxVZt2WhII5kIYEHWB2SRWarI7BdvaeR1up4ZwZtTbZhNVX8GreH0BQM9Se6b1g
 0JOufwMP53+gFEl/71YznWKaF+fw0Fk4Tq6Et9hvO/rJ79AIxEqpL0DNwTFKagOiKhJwG1GDZ7x
 tMHKQ6SqDIduxOnLLpQ==

On Thu, 21 May 2026 17:11:21 +0200, Alexandru Hossu wrote:

> chap_server_compute_hash() allocates client_digest as
> kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
> passes chap_r directly to chap_base64_decode() without checking whether
> the input length could produce more than digest_size bytes of output.
> 
> chap_base64_decode() writes to the destination unconditionally as long
> as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
> the "0b" prefix stripped by extract_param(), up to 127 base64 characters
> can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
> (digest_size=32) this overflows client_digest by 63 bytes; for MD5
> (digest_size=16) the overflow is 79 bytes.
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: validate CHAP_R length before base64 decode
      https://git.kernel.org/mkp/scsi/c/85db7391310b

-- 
Martin K. Petersen
