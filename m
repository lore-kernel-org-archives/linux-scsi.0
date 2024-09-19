Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA451A42AB;
	Thu, 19 Sep 2024 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761247; cv=none; b=l/nNwyuyhZUZmALORGHLMJ/u7WuZ4kFtVJeM15sa+OlPrpVgjoJDXmYNg8rVVvljJjEoY/Uno1HflDIYwKWFdsbKnyCWMXIcVG1FqE7LzIV1ixxZLD2dxA8NocBYukK25/wXevtG7yylB826LBVmBNTcU9BukFbsBd+R1XtN7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761247; c=relaxed/simple;
	bh=DZvwPbTggBtKpyxUgRtKXqPd1PhO3s7FolBUOHBITYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YiQ3BlhYfRrORbQDhNfuqrCn4Ffcnb+DbbZO1ED6ePcUoIIyw46MperiYtYKb/X8awlcQwA2DCLYGDHRpVs/Y0UcFguUQoPPcHDuU7y09iyHXSV9jdoBp9WnK78deYdsHUyfVAdyO4phO3Xopmv/jmb8zrT5hqhp9AnVEZET3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fZijRnG5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fZijRnG5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEanQw008078;
	Thu, 19 Sep 2024 15:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=0AWhqveqZMqok6AvB3kwuxeSUeljEdBbjo9Ka/XQGEE=; b=
	fZijRnG5EgHmeb3vCqMNnRX2sSda2SqJynn0zkQJ4IIQhVLa7OlwcN2q45tIp2vh
	ttV0/K6tqXuI6nGfijtpPmeYqk/Ggr/zbdCr2A9AxooZMoNiB8ryBNftQ4j7eR+a
	zzvQkmqgWCgYGxB2FeUWnlGJt9ppjRdsFHYhgro2s0asb/+RhpE7WbH/V/r3mlex
	Fpcukka5ngzMvK3+CBJVNBjmI7ngjsHfmaSk/vcAqOUfmLrl96vzG7dKG+51rvdF
	iurrx+zKNAGZUmovkLuK9HAr+dNYqp7G5yO/I4B8b+OlEvIdyFuZ40w6+tVv+gim
	mWP3lOkTVkyRtHoDkLHe4g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd4mh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:54:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFmkhJ010269;
	Thu, 19 Sep 2024 15:54:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:54:01 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri99031813;
	Thu, 19 Sep 2024 15:54:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-16;
	Thu, 19 Sep 2024 15:54:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, Yan Zhen <yanzhen@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v2] fusion: mptctl: Use min macro
Date: Thu, 19 Sep 2024 11:53:02 -0400
Message-ID: <172676112039.1503679.11983044667100994404.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902013303.909316-1-yanzhen@vivo.com>
References: <20240902013303.909316-1-yanzhen@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=892 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-ORIG-GUID: 6zHs4hrBbTsLn2gnUcG8Lvi8WYvXNGpJ
X-Proofpoint-GUID: 6zHs4hrBbTsLn2gnUcG8Lvi8WYvXNGpJ

On Mon, 02 Sep 2024 09:33:03 +0800, Yan Zhen wrote:

> Using the real macro is usually more intuitive and readable,
> When the original file is guaranteed to contain the minmax.h header file
> and compile correctly.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] fusion: mptctl: Use min macro
      https://git.kernel.org/mkp/scsi/c/e88ed5943289

-- 
Martin K. Petersen	Oracle Linux Engineering
