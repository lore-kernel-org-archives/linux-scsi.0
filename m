Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31972836A;
	Fri, 14 Jun 2024 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718331831; cv=none; b=NoYOs+027Djh63aFOjkjuKEBwckNYb3l3naXyHkvYTu8Qh/lKevKTh4cCe6cDJy0IOiyaSIhF/vT469M+W/4gXAfLqoqUw4PPu1bxio7uQZe9z3F6Y7WKJ4ZWYDKeOkVWqn9hgoqf8e7uo6UyfM+AW1mUmXihAyQ5bdsfoJiYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718331831; c=relaxed/simple;
	bh=T7ZI30pdt8cKouu+B6Wek7jgn7JCy3A/eGiNzOKgFco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7ZGst+v2MNGWQ13z4d2WCF6YDr82vkWqd8XfOvBsI/1DjDuqN97gOlTcFtxAYRNaHgBqKh+aUQLS1JADdcGvMnj/zIbQpVxyyBP7nw28JWp4AYAhEMNAa0eYJfF986GwaBGc1Zjf85PqiZDPqq8rwNsMyjI43S/AIFaAfWsy1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SlyWzDRP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SlyWzDRP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1gA3o023011;
	Fri, 14 Jun 2024 02:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=9Z41dJob1FL54RNTLvwuxNa32aW8KmiumqItdNjxDWE=; b=
	SlyWzDRP89S/UmdhaNXSbB8M1eXehWdoJkBFE0ItT2bYk1t1Igddk7qL+aKun+OE
	TZn7UnQp83jPHSQKHg94CC85zXWlkkpafwG2oNaeFA62tkzQAl04GqjLQNvM9/rw
	DKy500ikOnw1h7HwIxw0tSUbYCDH6l4deNsjB4rHy1LQS5n5CFOwV24JJiNGOP6I
	4ITUxjI2cRZ/mi9kWpemyL75fAy4IAsUKU54GTfTknGLs8khDewRzUmas5UyWtXp
	YTxVkCU/FSxBX9KlhgptfKaFffkm4T1uKR9irWtNC/EtpRfYKmSVJUfgzYg5wpnD
	SD0q5RIddWeuwhixnjGguA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1mjt5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:23:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E0Uq2M012527;
	Fri, 14 Jun 2024 02:23:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1vrj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Jun 2024 02:23:44 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45E2NhG1009531;
	Fri, 14 Jun 2024 02:23:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynca1vrfh-1;
	Fri, 14 Jun 2024 02:23:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Do not read the IO hints VPD page from USB storage devices
Date: Thu, 13 Jun 2024 22:23:00 -0400
Message-ID: <171833164848.271429.11609704907810406023.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240613211828.2077477-1-bvanassche@acm.org>
References: <20240613211828.2077477-1-bvanassche@acm.org>
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
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=519 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140014
X-Proofpoint-ORIG-GUID: KBoZJP_SYEyMBxyv70ULe3jKD7eRXUqz
X-Proofpoint-GUID: KBoZJP_SYEyMBxyv70ULe3jKD7eRXUqz

On Thu, 13 Jun 2024 14:18:25 -0700, Bart Van Assche wrote:

> Recently it was reported that reading the IO hints VPD page makes at least two
> USB storage devices crash. Hence this patch series that disables reading the IO
> hints VPD page from USB storage devices. Please consider this patch series for
> your scsi-fixes branch.
> 
> Thanks,
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/2] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
      https://git.kernel.org/mkp/scsi/c/633aeefafc9c
[2/2] usb: Do not query the IO advice hints grouping mode page for USB devices
      https://git.kernel.org/mkp/scsi/c/57619f3cdeb5

-- 
Martin K. Petersen	Oracle Linux Engineering
