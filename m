Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23AD801;
	Fri, 20 Jun 2025 03:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389576; cv=none; b=kikiCkf4hrCk+LrnFDiiCWVDtzO+wbxhy0CKgTrESo1EZQD/hg7/sToyNn8ATevbc7/af0hZ5v3FbtX61RheIxe7OlUS5YfRLoS343ENFsItbeVEhhP4vkmMqVcIRnDSKQAVuBVJd2Dio5DP61pC/4rWxMkmYyhwPW53pmdI2OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389576; c=relaxed/simple;
	bh=1NNit1AAqTSwc1aYmKzBPX7EGlwXXbw90pM+2SVrN8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKTmrudWcQ4CfXQ0FJgkrexgqRA6q9OwwyiV1VMhsYern9t923HU0cJ4KWz5FGV2HNyb4byzgS2gUBqH6DH+D8XsdQE7zkhTafTgR3CWwY8hz6ccdSLDGqaE4532HF+AJXjvGD9n2GI8hPaB1udFgyt+U60vHFjicELy+E4l8JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tqqgwn5R; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tqqgwn5R"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2tcWD012108;
	Fri, 20 Jun 2025 03:19:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7719dfXto/ii3PpM9n0DTlAlhm8zMReQumuZGrz+3Hc=; b=
	Tqqgwn5R/V76ZY5Tm8HkcTbfhUcgop++0InMy3wy9TlINj3KxAC4JpZlAopBrCYL
	bJYGx0lx9ob0R69RiPbKX3U2s6oe3SsKkQ8ehjCUGaOyAHBX0ULCzq+xL294/Y1/
	tEE4JUEJCt3nwOb6EWT/9Csqxo5yIxrOyE34ORsFfYXkuhYVc99SNxz1RT8oQMb8
	HrTfO3fmZcx8u0x455T065//SJtz0fan/GQzBfMCXmJ4Id5Ha/2W9mtx7EjCerrH
	kUWS814dU+uVU1UNYtGZY43NaeF1HY8jwC1eQKJh8r+14egFZ7R/DzwK+sJrKbo7
	yZcQXyLSnI4jncdzTB8yqA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914etvkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1F26a037473;
	Fri, 20 Jun 2025 03:19:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhc7d5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55K3JU2C013310;
	Fri, 20 Jun 2025 03:19:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 478yhc7d52-1;
	Fri, 20 Jun 2025 03:19:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arulprabhu Ponnusamy <arulponn@cisco.com>, Arun Easi <aeasi@cisco.com>,
        Gian Carlo Boffa <gcboffa@cisco.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: fix missing dma mapping error in `fnic_send_frame()`
Date: Thu, 19 Jun 2025 23:19:09 -0400
Message-ID: <175038952907.1692313.15200129425689911215.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250618065715.14740-2-fourier.thomas@gmail.com>
References: <20250618065715.14740-2-fourier.thomas@gmail.com>
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
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=953 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506200024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyNCBTYWx0ZWRfX/EuOp1/dCCPi r6ePe7hcNRZ2YaWuZHrE5f1pj4jnlS6mb3a7KXxCY5o+CEfJKibclB6y/mFiWd3COD/8NquaGs7 qKwpDxv3WnyG0Gb1CR4SW/rFgIO0LIH2kOtvXA8SQjaPWUrImhHeLTkPGEU5vur6KNmPbbwzxC7
 ex/56aFv/qtCJ50evEZRX2Bw695HJVwvpMQBm3b9iUl3lNB5HkIRcPuVRwVup0/ygXDkKJXVMEX aQp/c4C6UwNZokIhQJWM72VW/cToKWAel+w6QkBaytra/nJolY4s8kUTQH6oeotBal9ASmZlrsq apr4Yy36WiEds3Xfai+TpTt4kspOPeoVyh6/O1R2cwBlVO2nXGJzpH9BZfNsvuWsEDKyBylKIO7
 /NXg+4daYoVW17tprblFD7e8xt3Pu1qAJN6ACRbfVQFPAuFDXil3G6iITsAl45F6wrDFYiKI
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=6854d344 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=vwQfSl2PeIesOJjDinMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: H_3a7CoY6wd9U79UqdzPtv7D8LGCrYU2
X-Proofpoint-ORIG-GUID: H_3a7CoY6wd9U79UqdzPtv7D8LGCrYU2

On Wed, 18 Jun 2025 08:57:04 +0200, Thomas Fourier wrote:

> `dma_map_XXX()` can fail and should be tested for errors with
> `dma_mapping_error().`
> 
> 

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: fnic: fix missing dma mapping error in `fnic_send_frame()`
      https://git.kernel.org/mkp/scsi/c/85d6fbc47c30

-- 
Martin K. Petersen	Oracle Linux Engineering
