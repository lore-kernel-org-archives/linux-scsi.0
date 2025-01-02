Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AB31B4F3E;
	Thu,  2 Jan 2025 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858083; cv=none; b=GP2fj96fbK8IvmC2H8VBjWe0IwXg8Y/QEmtrrWE/FkTbnd3M9jBm0rf3+J48IZD7NsFFjbVUfCN2YZ6K4ZPZwzmwvFaa/byFdXPn5YrldA5GUZ+RlZ70CsFVUOb8K5+5e24qYy+NYwfwDfA7Yx//ZVNQmx7MXRfdw3JHlF8Uvb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858083; c=relaxed/simple;
	bh=2kzmRvD5qw3jmfwvLZ4YVkOdWdS0aP1sZxrxIPjJ+dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU8yyIxdbCnLiSxonFcq0XsAm6KeCctbboVDOmcwU3Ev55PKRwQN+nYx3xL65YixE3x/Fx5LHVdk/nyfQLG/5vhigkqWEjrEXIIvH30hxeoUrUZ8Mtv+njFEycLPrkcbbJ7KmXGfW5ard3FexTiCf/tmWHp+ZuOT1uignyozaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4nAUbIR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4nAUbIR"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502Kfs4d016471;
	Thu, 2 Jan 2025 22:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZaHX6TR0TlpZqGO8pyVAtKGFFYO4dO1eC2fFm+tWQ68=; b=
	c4nAUbIRvHl/ewdy82GMawolkRdZzPrXyo/6mwBFPzgzmZgGhKu+xF6KBpLQgn8I
	I0D6T5df9TgJvtEP4JXDSxh7d1tDQnF7HVTkaYKv/yb8iVVN3ewtF/B31C51KjJ8
	FcwDccPPzbRMciL7ztsUEeZh9C0xAg2o2OTEKWgx1JypW7hHtQrPBxd2Rz1J9kiu
	1hyvLnAmehhThU6pvj545dZkEZ8iN3TnV209Tkxni1qshnL4pdJn7bnZ/L72JSId
	NJA5dRJmVBAchNT2RpVI92UfuCxGvLeqUgFpg/M7qFiXosDJWeWigiiXTZL56jdu
	Gax2CvgEuHtHbGHpAAg3FA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t7rbybp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502KF3Ke009525;
	Thu, 2 Jan 2025 22:47:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s93nvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:11 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 502MlAtd004461;
	Thu, 2 Jan 2025 22:47:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43t7s93nuq-1;
	Thu, 02 Jan 2025 22:47:10 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, Michael Reed <mdr@sgi.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: Constify struct pci_device_id
Date: Thu,  2 Jan 2025 17:46:37 -0500
Message-ID: <173583977810.171606.912728304121517929.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <fc61b1946488c1ea8f7a17a06cf40fbd05dcc6de.1733590049.git.christophe.jaillet@wanadoo.fr>
References: <fc61b1946488c1ea8f7a17a06cf40fbd05dcc6de.1733590049.git.christophe.jaillet@wanadoo.fr>
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
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020199
X-Proofpoint-ORIG-GUID: uybmMUaempwqyv9zyA6h-YkFUKUm0TNh
X-Proofpoint-GUID: uybmMUaempwqyv9zyA6h-YkFUKUm0TNh

On Sat, 07 Dec 2024 17:48:28 +0100, Christophe JAILLET wrote:

> 'struct pci_device_id' is not modified in these drivers.
> 
> Constifying this structure moves some data to a read-only section, so
> increase overall security.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>   70237	   9137	    320	  79694	  1374e	drivers/scsi/3w-9xxx.o
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: Constify struct pci_device_id
      https://git.kernel.org/mkp/scsi/c/c9a71ca13f71

-- 
Martin K. Petersen	Oracle Linux Engineering
