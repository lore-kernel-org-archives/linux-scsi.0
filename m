Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6D32F83A2;
	Sat, 23 May 2026 03:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506128; cv=none; b=gGCUuTCx29WZXQiAM14qwCcoVOip2YHIUVqRaJIWagloCvNSfE+TYVlSjF13OajaIRtxJVmpZOAXod/mRVmCRcNtrf6MnuHk1T41/bljWlDf0eql0eAx00gYl+cByNSEe84TiU9aS8Fe026BlR5yOrO9uuR6cHJbwhRvm0di8Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506128; c=relaxed/simple;
	bh=cE0OeMahesAHNp7HYEXl6ZEA0IDJD+WyhAFV5Z57H28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kn1UKpLCxZVs0htgbOhvxa+QWK0MLUKPNmYNiSpmQmtirmOHVyiZylNdIpwHDStnbxEyocDOlBIvQdC0vV0TOz77lQtxg0yXvkUJpGWBZWTp3SfVaBOC8jQWH4V8T56/qFins8UO5QNgql2pJ13DlRiY5trLb6FDLbWVrPiVDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kM8+KTUu; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kM8+KTUu"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N1VwUE2119365;
	Sat, 23 May 2026 03:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LoL94/ZgEB7JbkBLLExzFUq+6cEWfAur38v5yiIei3Q=; b=
	kM8+KTUuZDqjAB7zb3MGB+cm/qKXnqJtr4dyT7swuXMbK5JYwL+cS5DG0PeG3Lba
	V/5KXTFv9qmHS1z68aPAByrMyzilIJJphvTpk6oUpFuZw6KAoh0v9S3q9/bPIUrf
	E6m633O4C6NFa1qAjDYC47PJDSVWMb9yTlXMa0HDBTYkSVUUE+6ulrpR/F69qfwt
	+G9BwLKkVDuA4Zmzq2bJe4UtKYB0c+xZw4RccCo8Y59wkTYcffz6ZDKbXzLvglhL
	9heNIGKzTRfPzE8lE/vK3QG3Mnz90V4ZliOkJqik/bfJ6i/bSASjE2dOiLvDXuDj
	2MYgYql1npu1aKxU0lyMnw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2nb88k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F698032365;
	Sat, 23 May 2026 03:15:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:14 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9e2032824;
	Sat, 23 May 2026 03:15:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-5;
	Sat, 23 May 2026 03:15:13 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kai.Makisara@kolumbus.fi, Wang Zihan <jiyu03@qq.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] scsi: st: fix typo in documentation
Date: Fri, 22 May 2026 23:14:19 -0400
Message-ID: <177913641778.1181900.3176272497636019002.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_818C822F215676B9B14011B88848609BD309@qq.com>
References: <tencent_818C822F215676B9B14011B88848609BD309@qq.com>
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
 mlxlogscore=989 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=bPcm5v+Z c=1 sm=1 tr=0 ts=6a111bc3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=azPL76DtyQRYvY0si6YA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EkWgFJvIErstOhmsmvjChAd-v_REdt-2
X-Proofpoint-ORIG-GUID: EkWgFJvIErstOhmsmvjChAd-v_REdt-2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX4M+RmxikmKPG
 kPmb6HK2ohlt+ZOP6KLSzT3ls5uO/zQiyh3sKqky3+oD6K0BVauPEamUktsaFHVTXGTVPYkC9/N
 XKbk9gEIE1sRUMShLlCz5HQJhefZBe49m6tB0kzzmPALBrx0rNV3QnryETlsbSTbJDHXhtZR9Tb
 l7evMGsgF/2AljXuExW7jbc70IZYuwFEQKShwBg/7awJoWCu2xpQi/58Z2fBZAl18k/s9qWm9Vn
 Pbv1fH0utn46me6Xe9ZcnKzQdRiLA/mfClJIBixjgEZT7mZIbfTuY5arEHRtw2j2C9ApWRVIAiY
 kWexSV1emgKA4irWODgZdQCphcnrNY20/GoGkvkPD48O1c2vroUJARj535z3HhS9GlW5Zh3BTAM
 ObNso6IJTNdR3QfVlvurWk5X25FnNEm8Kp+xcuA4ruXfe10JTHIUjmUaOiSDKqtYnUP/nxpQqH0
 vuBQWmvJjRFRNEtoQAg==

On Sat, 02 May 2026 14:07:03 +0800, Wang Zihan wrote:

> Correct "form" to "from" in drive buffers description.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: st: fix typo in documentation
      https://git.kernel.org/mkp/scsi/c/53f5cce2efc7

-- 
Martin K. Petersen
