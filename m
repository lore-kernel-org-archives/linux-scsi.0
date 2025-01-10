Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E65120A5CF;
	Fri, 10 Jan 2025 21:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543869; cv=none; b=HhEH3D1TqKMt1kwkERpvxj1ioKXnnf9Wx8WE21pjOuabGvL49rStWs5QvxDYZBy49qIFsB9L2gtF4qHelfM1jjvJ8BEVO9g43Jcrj/0czmq9EV81TrjVY7+pPRY6+57yz4oj7o8YCpSjj0LMX83JWl8Eyld6oZbTiESNX+FmG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543869; c=relaxed/simple;
	bh=kFfydlbjoBZ5EzDIg0ussqbMhKRvT6fmuuVrbZH2904=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALSz/BSEfDEixc3ghLuNyK+Gl/v4W95ngC3kDk0gcsO/ksh6jjP6t7MgSbUBAKQ1Q61S1BVIHfxt1HnsXp6nDM77v583KELcLc2wYXL7nQk0FVi2+mZwAguWdx7aKCstkGhhofJL8tZAmZ/nsnEyYkk3nDdoFTmeuM4wo7d91MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RQhaZ71L; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RQhaZ71L"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBmLJ013589;
	Fri, 10 Jan 2025 21:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GQ0hIDBS+Zk6iuJoWjgwpykkuLMmbMlYyto1bhzu50k=; b=
	RQhaZ71LzKjwMEmx62mIu6IvKbKsvFRhVZEl0xi3c1Drr2bAeLppb/E9dnysK5Um
	OcqzTIfMZArSkK1WziPa6TXxO3wRH+nGNmWg2gbfUYPlC23Pfv+5GiCnb2Fy0Y72
	HLztwzbSeEy+cFNW4ncFlKd5ZEqLNu+A6kPWMZwV9P4tneg/gL2rmISNFrTbZplb
	c+i1i03C5F1rK2TZa+BFRw9DKhU6Z1e52g+ZUxWiwNqSa2lz6A5hNQN5jQlhF0Ff
	iDlbNTLGz1m+awGtlesyxFuCer4sVDrtk500AP2cm0QnjNq7XA5g2yNTqwDs0VhN
	CNJ3WEGoYHw5kJ/brdUuIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1c3qme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJM2CG027219;
	Fri, 10 Jan 2025 21:17:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:41 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ2C034137;
	Fri, 10 Jan 2025 21:17:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-12;
	Fri, 10 Jan 2025 21:17:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: Documentation: corrections for struct updates
Date: Fri, 10 Jan 2025 16:16:54 -0500
Message-ID: <173654330201.638636.6845934119604687394.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241221212539.1314560-1-rdunlap@infradead.org>
References: <20241221212539.1314560-1-rdunlap@infradead.org>
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
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=887 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: wU6vs1VQtEQhAanADRad1Tv-3W69B4Ta
X-Proofpoint-GUID: wU6vs1VQtEQhAanADRad1Tv-3W69B4Ta

On Sat, 21 Dec 2024 13:25:39 -0800, Randy Dunlap wrote:

> Update scsi_mid_low_api.rst for changes to struct scsi_host and
> struct scsi_cmnd.
> 
> struct scsi_host:
> . no_async_abort is gone
> . drop sh_list w/ no replacement
> . change my_devices to __devices
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: Documentation: corrections for struct updates
      https://git.kernel.org/mkp/scsi/c/d102c6d589c2

-- 
Martin K. Petersen	Oracle Linux Engineering
