Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D86C23AB88;
	Tue, 15 Jul 2025 01:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752544488; cv=none; b=BKjaNXKPJ4ZQ6FQD8bO5QEk3fPT0BdxcLvSXSBfdh2LRC76KuTVaoiWHr84KXB6rlkWjcRZhfJsa47RYLhdBtiBrJNzdX/okESWxJGPAp5wjAmq9ZXsks0thxQDFtM3+e6COOGMddXnKCrj3K6+qC2/DMJRJITKgn45sI7r5nRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752544488; c=relaxed/simple;
	bh=vRWwFAZduI2Zb0KxizMkBN7naKqbLm3HaT5m6epHxec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/plVC6djFGfv/jCDjgpN3inYdVAzXXkILHUI44J5bZRlF3KskQLvndeVtammaiABeQB9MAWs0+Gx2Ujc19wfKG1myfbntXk+XfdIV4ar0O5skGuNcdmMN9UzYpiaD2r+xNqtD5iUNmC7yL3v2Y5qDBzn1VhTJS18dK4+mr2vBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kr1dOWEZ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kr1dOWEZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56F1YsFk019669;
	Tue, 15 Jul 2025 01:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MhYbLGhqFabUGzLDsIMJ/6Lq5QQcImUyQEHrkRkgqoo=; b=
	Kr1dOWEZzSIxy6UlKpCPfmeEgVm8DlQEfpI7L5OEdwthfQjtB7cDxiGlCIzO/A4+
	pUY2NyS7pIFw/vC4WGJcQfThYHisB+1zsHEwPF0WA2OfsRA12W3ZJa2QYQ2OvQyE
	7bB4Pf8OgtYsCHhZr06Qde06BLot6siTH8bcn8p43diNFHR1D/A2O06TXbCCZA9/
	1m5VaGHTiSQCX2hjrSsd9UdHzIzhQAxLo7KfwaPxC6DNhVPzshp1zqxXxpxzqb+A
	mIZolH9BFx5sDv3YSZiiGOmupnTyhkHckkZrlRoCFH1sTMbcSTC4ZyDVKq7TaNmE
	TajaTDXdCuOAx+Fj6C9Wpw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujy4nhws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56F0Xasa029002;
	Tue, 15 Jul 2025 01:54:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue592dxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56F1sM6W002175;
	Tue, 15 Jul 2025 01:54:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ue592dxd-1;
	Tue, 15 Jul 2025 01:54:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
Date: Mon, 14 Jul 2025 21:53:48 -0400
Message-ID: <175193808975.2586181.3549891126119956725.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250620173232.864179-1-arnd@kernel.org>
References: <20250620173232.864179-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_03,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507150016
X-Proofpoint-ORIG-GUID: PCgrTv53Z-8gKqnbbK8oPryu-2bQw-nA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDAxNiBTYWx0ZWRfX4MYBKjdsWoP/ ITyPjBRhrsQp5ia3DLDLL7yvgnPxTNJay8cGjFYWGLzFrDGShOL6zZyztkp1ycu2uwuuXQczwe1 f7J9PdNl4KET4/zkI7QFFeHM1NWXRilolfLMSBdoBqyps3Vxva/6NrmpFCR07AUIcTEbkD0ogFN
 I6o24aVGMeKYRPhizZgvOnSMQZN4ze3u8WPOxgokyVFlXi95AydC0oVGsTViqFIOpuU+KkzttmP ZZRIxNNpZzBa3tfe4eGhrclr+AVl+FT3fXaG6AnFrzm2h2Todc8jM49DFokI1fDLK3ZPsxuIH6f H6eVWDzH84pBmNVF2CBj5n9BLZagvrsTRN43dRhFKpzloByBn2ZF1OACEP4Zjgxv3Hvqv5wC6Fd
 9bXkzT5JGb9qZ1fzZfP38BB4ioH4WCeBuEsrvuIYAkzhTarbC6gG+O9K7a4n6lTXr1MHp0xI
X-Authority-Analysis: v=2.4 cv=Xtr6OUF9 c=1 sm=1 tr=0 ts=6875b4cf cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=OcqzRV0sGrcaDEt1q9IA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: PCgrTv53Z-8gKqnbbK8oPryu-2bQw-nA

On Fri, 20 Jun 2025 19:32:22 +0200, Arnd Bergmann wrote:

> The qla2x00_dfs_tgt_port_database_show() function constructs a fake
> fc_port_t object on the stack, which depending on the configuration
> is large enough to exceed the stack size warning limit:
> 
> drivers/scsi/qla2xxx/qla_dfs.c:176:1: error: stack frame size (1392) exceeds limit (1280) in 'qla2x00_dfs_tgt_port_database_show' [-Werror,-Wframe-larger-than]
> 
> Rework this function to no longer need the structure but instead
> call a custom helper function that just prints the data directly
> from the port_database_24xx structure.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
      https://git.kernel.org/mkp/scsi/c/6243146bb019

-- 
Martin K. Petersen	Oracle Linux Engineering
