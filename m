Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88C51C694;
	Tue, 16 Jul 2024 02:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721097030; cv=none; b=LMgZTMDOEN0A2WFkyv8a/ztBKtGl/SmGtxDMtPsCh0tNOfpiL5K4kWhlb2ecSDV0miMrljaxnpXoB91zjTpuMhgBNJfneWDuPwkJMqb03hE0BhbYq0dQeNXJCH16u+w7Eq49piZNlsROoPx2XIhilfSAZp/d50/bbJlMaJNJjQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721097030; c=relaxed/simple;
	bh=8Cpsm0ZhBHuf444Yk8e+Az5VO1dkZdncwNCBhXbtbUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phO8mXPorVz9nVyYP5ipLeu6WHCMjZIiuSj5lyWvmKU9lm1pZXN5MYuVIjaL7Kou7Hrm1RqNXkJ/IQs5DP/tPqUojoMpszu8FyUtWXD87kS8Xd9tD4S2Iwu5Y/LV+W3L7MXB7aJYVzFyZpbQsJInVqkYevA66OWUxRToyH22mRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hou1IwWb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hou1IwWb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FL90HB002980;
	Tue, 16 Jul 2024 02:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=ohhSNM0LsvUICVcsJwpHtQH6rwZE/78TtulzmT1jz+0=; b=
	Hou1IwWbGsd36whFPWUwyQDU4xZZbF/jrqT6M4JOqGpJVK/Sl8/WhjMKwdWFwOAk
	9nY/S8dRuOSTeM/VS3AGcp+9PVBwOV/6pnLYgDQAyaOG6+TRI0iAj+RYNKpHoGy9
	tNLlcLhfTMLruXNB/apzuPTy1e7+8MaKuF2YFac0qO068wHfWCAW36oY5pG6Q+Oq
	oiL1/9r4j4AQDW6tC0Eun4UernYJzLGp3WRNdBAA18Cwn+tDgOrxaHN9ZaZPVanN
	ywnWqjFinluIcqY+0OpK+DAvtmD85CtV53MNVahJKykqO92ABWPtnpUQisRsvenZ
	pd4Y77F5DR2WL9KZOK2sPg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bh6svnf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G23phI002651;
	Tue, 16 Jul 2024 02:30:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg1exxds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46G2U3AD027682;
	Tue, 16 Jul 2024 02:30:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40bg1exxah-5;
	Tue, 16 Jul 2024 02:30:05 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: fischer@norbit.de, James.Bottomley@HansenPartnership.com,
        Zhongqiu Han <quic_zhonhan@quicinc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Mon, 15 Jul 2024 22:29:24 -0400
Message-ID: <172109323565.941202.9875743621405105678.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240705103614.3650637-1-quic_zhonhan@quicinc.com>
References: <20240705103614.3650637-1-quic_zhonhan@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=904 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160018
X-Proofpoint-GUID: RgNm-uhvztY9jBc9zAirnPGsF4qEI9M-
X-Proofpoint-ORIG-GUID: RgNm-uhvztY9jBc9zAirnPGsF4qEI9M-

On Fri, 05 Jul 2024 18:36:14 +0800, Zhongqiu Han wrote:

> The _ONSTACK variant should be used for on-stack completion, otherwise it
> will break lockdep. See also commit 6e9a4738c9fa ("[PATCH] completions:
> lockdep annotate on stack completions").
> 
> 

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
      https://git.kernel.org/mkp/scsi/c/23cef42d1741

-- 
Martin K. Petersen	Oracle Linux Engineering
