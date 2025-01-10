Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13778219EAB;
	Fri, 10 Jan 2025 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543868; cv=none; b=iQU5mp71V4foMlBbanXi0UXRbnskJuK5hEcMLvYX3QdbjAUu1gbUSCLXn/Qt+5MgCkPf58RuFsSQ3zztc+4TcOb2BPF87F0Vv9KXhOjY7/K7X9R7mAw8PWvUdwqkWHZuc1x2An9uI47eSKbk1Vn/qOsnOeL4NpgpiucCrw/N57A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543868; c=relaxed/simple;
	bh=ReCk9c5Ve7fsbPdnGgT5fi2F+TbgzCRTxgqMwVJnnlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yo/XXM0KGU+G0IfQ8x09uiE6WcC56QbdJ4KwB9q9Y4ODFZ1hJF09Sy4xSw52073vRTKWdUofcdeJmdMBufcJNVSTW6E4DN4pWJ7jT0SYRJeSGkfwL2w74q90gPwiNwOObo5mhA10PkfvkeodZsXKP/0RUpj5UFRn+paQlhnShEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XT9/mVwz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XT9/mVwz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBrGB029087;
	Fri, 10 Jan 2025 21:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=WsFnBhFA2QJZSh9K5JJG+dVqsasZhlEb9Yo3HZWZe+w=; b=
	XT9/mVwzV4YdXTU+F4RnJiXXowSJnMrwyTFnlT67F2M+Jq1OrKuG2t/mDIU7OcOa
	YGWy04cZopx6bmo6uUDm6zqn2y8MMoXYKLnqVchoIAFMGyoZQm62S12bQXByCnS1
	06zhHN6DTXlz9rAfmgbNFGSlM2XCoHk+afESkvF9eCG2/XwvJZ8mtnSVM+MzBG8N
	tAyuv78F1TMBr58kl/z+x67MQMClVa9v5Gr8pp9g1cJ7DenHkBCTYVpsPwVoeffL
	TKDc5hXvcMDfGTS4munJh+oDgc3lozoFHdcAvriw+CCHd5cTrxp4AMTUEJ5xKAFb
	cET8rMlTWUMnTFifhLnHRQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0c39g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKBmfC027491;
	Fri, 10 Jan 2025 21:17:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5ra4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ2E034137;
	Fri, 10 Jan 2025 21:17:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-13;
	Fri, 10 Jan 2025 21:17:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: documentation: scsi_eh: updates for EH changes
Date: Fri, 10 Jan 2025 16:16:55 -0500
Message-ID: <173654330163.638636.1674164624707315367.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241219214928.1170302-1-rdunlap@infradead.org>
References: <20241219214928.1170302-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=809 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: nXnhHXzkou3ime9K-7qRe8CoaqYO-kVH
X-Proofpoint-GUID: nXnhHXzkou3ime9K-7qRe8CoaqYO-kVH

On Thu, 19 Dec 2024 13:49:28 -0800, Randy Dunlap wrote:

> SCSI_SOFTIRQ and scsi_softirq() are no longer used. Change to block
> layer equivalents.
> 
> scsi_setup_cmd_retry() has been deleted. Remove references to it.
> 
> SCSI_EH_CANCEL_CMD has been deleted. Remove references to it.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: documentation: scsi_eh: updates for EH changes
      https://git.kernel.org/mkp/scsi/c/a9dcee18a220

-- 
Martin K. Petersen	Oracle Linux Engineering
