Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4051E884;
	Tue, 11 Mar 2025 01:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655988; cv=none; b=AwAdqpo9abu0RJrpFbhGpVp9820cAWxu9DuiCsggbcDcE27rJ+Dnq8GFaEyxTMxUye4NEEwoS/GSaSzHLV0FTBjkSRjYMGACN/u4DChwN5RFof01Gr49JKQ/Qfbe6kocbOMEjmNi3zoiifux4OZs3DKairNpUGC6G/FhVv4n0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655988; c=relaxed/simple;
	bh=rTqHHYLQ+sLMJPphzfRmxf9QvVpR3MH91nI7WYKTYww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXX6XExAekIWO2cBOsiO3mslgKbXVGjPqEmR07LvQK00p8HIBNdRXeFPOm4lpSh7iy+O3cQJVwBGBp322dBr2Q+gvGBoCsr8NAIyLFHMPkW59fSM7FtNO4/248BOKrgzAYh9vlJC2eeqRjDH758iTJzTOdbovviypQQwycrmOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eilK/cS9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eilK/cS9"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALg378017132;
	Tue, 11 Mar 2025 01:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=G7383/S4kPf8w4D/I7+seLsXapoaCtol+ueVbvvihLw=; b=
	eilK/cS9nPRoCySQ3eS6NkMDzUtWg2ZzDmuuS1VkAiUJc5iXJ5dCLl5o2W9KYvf5
	2APYMYRFvZQuluHb9KoYp7RwBfrVtZWMnvQ02Zw0r/l+lSvED71b6P1ONG+il3vE
	+aLqs0jlkfVOLpM+ouJdEJy0tVH2US7JeClsE6Da3KPCDdz/1ZHUchHu90CUjRGg
	v8KyU/GdCE2Ho+l7LeGRuk3AxdPZ28Hz4iQxorfiIEJezAIWbTvkaAADeJ7LdcmQ
	XFrHL0+1ylncLC3fwY2Uz/zIuIZf5tRoEafAF5wJCvDhXjFR8S98UjDs6X7nA1Fc
	mPU+T19L3NVdtuEuWoCD5A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cp33vvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0J0Fl015052;
	Tue, 11 Mar 2025 01:19:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:43 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrA014960;
	Tue, 11 Mar 2025 01:19:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-3;
	Tue, 11 Mar 2025 01:19:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] scsi: mpt3sas: Fix buffer overflow in mpt3sas_send_mctp_passthru_req()
Date: Mon, 10 Mar 2025 21:19:02 -0400
Message-ID: <174165505009.528513.9443974041520237075.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <02b0d4ff-961c-49ae-921a-5cc469edf93c@stanley.mountain>
References: <02b0d4ff-961c-49ae-921a-5cc469edf93c@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=884 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: H_wJcusWPBbd6UpruPxP6lDjzaIuBxXP
X-Proofpoint-ORIG-GUID: H_wJcusWPBbd6UpruPxP6lDjzaIuBxXP

On Fri, 28 Feb 2025 12:37:28 +0300, Dan Carpenter wrote:

> The "sz" argument in mpt3sas_check_cmd_timeout() is the number of u32,
> not the number of bytes.  We dump that many u32 values to dmesg.  Passing
> the number of bytes will lead to a read overflow.  Divide by 4 to get the
> correct value.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix buffer overflow in mpt3sas_send_mctp_passthru_req()
      https://git.kernel.org/mkp/scsi/c/0711f1966a52

-- 
Martin K. Petersen	Oracle Linux Engineering
