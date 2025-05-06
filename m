Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDB42D4B4B;
	Tue,  6 May 2025 04:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505589; cv=none; b=GgmRF+NzoWHknrRYlAfuzykmWWnSoeFyLKssRCIGIsDcp32mKQZ5xZ40WJgOXhQXs4WjepX/x8Rddz7GFdMv+h+C63eek5xT0mgqW+R6EzaTmCGBE7DV+pwqKUajnaB4B1rgcIwJvUZqJAjb8PQE+HE22bJaHhfQQ/MnXiwegj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505589; c=relaxed/simple;
	bh=HNDYxx6P6wwl5aKjocJibMY/OlhkGWjSlZ2BBiRn6wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKRSlVNnxjLH6zi7/YnmuyJZuXhMxmMU2C0Rmf57HZqerNmHBfJ7OdE+g/k7VvQXPySV82xB+aJhGf6p9g2/M5ul7B+tAEE3rHkvAyjGtHvV+RGhIKnPBI0bTfwviMe9pS3f1Ujyg6G6cNrWJQvddX8LIJzakNP42eATSPYO6k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cyF0SES3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cyF0SES3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5464FUBP024266;
	Tue, 6 May 2025 04:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=npmnctiMC9I3wzlrU/UooY6pvVe/mtSmv/LlwfOAMC4=; b=
	cyF0SES3x1+ARFlrJ0NaTO9DdIFIh1QX6+FY1R5bUlphVFN/XeGJpSCb+Qyh/zHx
	0ibEec/X27rsdsWYXXctqzywrgaGHvtOmqSccxyc2l7H40y/dUtw5BkPgV0ngFlQ
	CFzST7Ogut52djXs3U6VTec70uyjneAVQgZXMA1g02WjNb5Y/1exyJnZcPfjltqw
	hejDTFtVwdfs9xnCZSh2rcUrpjXXeBhhf6yyz6q/IpdJUFSUGEGnPG/hicQL0z46
	/eRoypOJq1Br+dskOigdvrn/iZ82JQqc4dvt/RzNG+tMpuheC5kKo6GwaD101D0t
	nO7Qk09NesKX19zfY1z+5A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fb7h00be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:26:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5462wYJO035335;
	Tue, 6 May 2025 04:26:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gprh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:26:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4M012838;
	Tue, 6 May 2025 04:26:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-9;
	Tue, 06 May 2025 04:26:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Tue,  6 May 2025 00:25:27 -0400
Message-ID: <174649624837.3806817.17844248608124491552.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250428171625.2499-2-thorsten.blum@linux.dev>
References: <20250428171625.2499-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=767 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-GUID: IpkI4UnbpTFVuURZim2Wf20oB_MofDcc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX4LfR+H35z/s8 72WWRTtK+QZQPltUnp2qU4AvYOVNnI/G7nFGAEoH4dSsT4N2xMADqlO0x3+lVTxjCbNjmSIxpLR ncI1rwkX9DnQVjmfRhh8JrS4bMeLYzN21P0yeUWb4vHXQop0bWUP0TidihWRRotn4UdMhQ+KvLO
 dpjfEOi+vxuitBkmpWgstBVjQ48eb4LNtnDhX7eGOP29iTAvvE48SzHoCw18egGuyphjYIFvThf xFQUaBI/Agm6QgfagpbLT4MLVUswkxc/xC2W1xxOiuZOCkXVPT0n/XYA/Deqo5cbLtxaRlePl2k ask+Hz0YYR0duRrY9RTQOCNRjNdtOLuUfZCXLTHm5cJp+2Ip1e0oYMbwJUG+t2gK+F8N3uIuh/q
 862AIP9xmDB3Ouong+Ds8zHsghDFVstDNabNmaQrKdO5jXnOnie6sxKrJ4ihg5eLbkE6X6gs
X-Authority-Analysis: v=2.4 cv=e6AGSbp/ c=1 sm=1 tr=0 ts=68198f5c b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=ZRFplKR--klOF1cwjjcA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: IpkI4UnbpTFVuURZim2Wf20oB_MofDcc

On Mon, 28 Apr 2025 19:16:26 +0200, Thorsten Blum wrote:

> Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
> the timeouts to milliseconds.
> 
> No functional changes intended.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: lpfc: Use secs_to_jiffies() instead of msecs_to_jiffies()
      https://git.kernel.org/mkp/scsi/c/edf147e215c6

-- 
Martin K. Petersen	Oracle Linux Engineering
