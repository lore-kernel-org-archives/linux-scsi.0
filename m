Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5332860B;
	Tue,  2 Jun 2026 02:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366265; cv=none; b=d4VNIVUsTcn/I1LzuNuapa153euwhlss1jn/KLecLRfMiyVAHZ/PWbeefy64fhY4303VMZlgxiGRcys1EeklQhkipk1Hua63csAe/c6mIIa3GVPpT034hZzVb10UqTDJmXFQP9xhyVtESAWiQ/9W7RejtYehvUeXt5QpBaliU0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366265; c=relaxed/simple;
	bh=OP/inSMX7QAW1vN+mvfYNnJsEbeE1YVPbB2N+ZC8+vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyN8il5q2jGvugTtWe8WUwx9RPgSZCBYiZlWP+3l5DuBMXx1qPUdtNv39b7ptOMyLJzN+3quD1n47o0uDE1jU/+d7p7av7irIr+oTZY5v7GWv+CDz0SR3uBLCGUCwFiRsba8lviUHzSHf0utgDEGLbBZmnsV10Zb542B9bfR2Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ev7yVSz+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ev7yVSz+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GtoH13108079;
	Tue, 2 Jun 2026 02:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pfBoKeU0NjSDSShkXdKMYbr9iILagvIoOzU8h21OUEg=; b=
	ev7yVSz+S7CQb2HvNvqDW5jWq4dcH8sLYfPsHO3Chuet2rVUcURekoujxSIYOPbn
	TUmoNR/gJ+nZ21ZVmMLO/pZ0c//HFiMH0VFsanku/EqijDX/pTUriNcLlf1cFerS
	FMvbYohvht1cJI+UV8OxUpMgfObPBKVLeQ03rgPEREZoiqEP4rNMFuBi27rW2jaP
	WlYBzDH0EK/TqtaqMSomgFtBbDyZXc0RfC9vnCnh6MMdahVeP9iRLDDQPdXylipA
	iRIpSc9+l3TgZU2bJgJNkTFa038SCJG9BGDIrHYGShwWbo3LR+kmNlhj4CNU4YVW
	dHPHWvwxzVwZUWEqZ4kcrA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpfxu9fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A4fi020139;
	Tue, 2 Jun 2026 02:10:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2wx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:54 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArC4023303;
	Tue, 2 Jun 2026 02:10:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-1;
	Tue, 02 Jun 2026 02:10:53 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
        Kees Cook <kees@kernel.org>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid: reduce stack usage in megaraid_cmm_register()
Date: Mon,  1 Jun 2026 22:10:42 -0400
Message-ID: <178036282202.1628204.14731403880451053161.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519202143.1305850-1-arnd@kernel.org>
References: <20260519202143.1305850-1-arnd@kernel.org>
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
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Authority-Analysis: v=2.4 cv=FOMrAeos c=1 sm=1 tr=0 ts=6a1e3baf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=uw2dwx6-vXxH-_8Kw_EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4eDfLvssI6QAPhUOrvNiMb0ERgtXCwmS
X-Proofpoint-ORIG-GUID: 4eDfLvssI6QAPhUOrvNiMb0ERgtXCwmS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxNyBTYWx0ZWRfXwMKJg+GTdKtX
 enWyMt784n4XLiWGntvJHHonvi1ev3w6bPm0TXE1sajTHDHAk42YVs4tCctHVpVXY1mmi1IJ3UW
 DuCElYV1LcMDJ0LhocbXWlYsJ6T2GGn3VodYI7Inp6IMyaQfAEMFtzhxMrhonHq+oue5Kt9SpVt
 Gt1+49irRm6/EdjPSg+ylzVDXiakoJIPAQJ0o4fyx1Gadv+KUj4+QGKIJcBm5YiXaNUPiM4oNfz
 4EKwg2OUCdbopD3HTzwMd1uwJGUJTK8SBsa6nq5VoHVgNRmfDHtQBx8rmSb4w7GdFOiGujehbfH
 Zq87zXSoMo70z1bbAwWZmqdHF31Ha0rebDr633OR6JGuV4G95ZrCuHAwlaWppQTPlmMXE3uHucM
 Du4GKeP76XePdPMR7aE3JCumaoKW3aJPIzSVbWh3JwiFZ50duSgKRBVF3DZyENTlWY/t7lwuIJk
 ia7JIgncQXCBR3XwnKw==

On Tue, 19 May 2026 22:21:24 +0200, Arnd Bergmann wrote:

> The megaraid_cmm_register() function has a local copy of mraid_mmadp_t on
> the stack that gets copied into the actual structure used at runtime. When
> -fsanitize=thread is enabled, this causes the per-function stack frame
> to grow beyond the warning limit:
> 
> megaraid_mbox.c: In function 'megaraid_cmm_register':
> megaraid_mbox.c:3472:1: error: the frame size of 1312 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: megaraid: reduce stack usage in megaraid_cmm_register()
      https://git.kernel.org/mkp/scsi/c/c1f7275b613b

-- 
Martin K. Petersen
