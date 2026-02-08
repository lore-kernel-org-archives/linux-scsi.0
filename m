Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D7C2EE611;
	Sun,  8 Feb 2026 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516198; cv=none; b=l7ko75GF5jQ5+s2YH5W5cp5Y9tP2EBFS+5xS4hJiX4UW8VJ0QaLcOmZ9hMouxI4Cj8E1rPhUl82zq0hA/nMLgtzNSJD7FEbYreX6nIJteDiSKpMmgoODMylJ7oAd/LCL2Mudmj7vAxUNnF5q7dwZ5h0d/jSiMXRh3KkD9JnMfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516198; c=relaxed/simple;
	bh=3UQLfpu2oeslOEr+1oQYBjpvmLlhHTjumOiiEsqjwx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=otqAWaMP7GhRhdRN0ykvisf9SYJ/9k6PxURmjci5xs0kmRNbf2mEuKvKAmonuRc/2goGP/G0XgMPK2As37dkdB0BEKNdQFO9Q1IHH/DjnUTPI2HrmCNuW9WNYn8G9PaPholUKQhns35vz6hFoFRkthpmNHod57w90qet3v8zMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IcSC0Ldd; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcSC0Ldd"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6181ri622265329;
	Sun, 8 Feb 2026 02:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GY9VcPnx9F8dhRXeZ6IF84NwU/hTOG/xJKtD6XGZ+0w=; b=
	IcSC0Lddx/Q8zbB0mUNRAvTGXrTdq0mzSxBVR8YW2utPdppYGPCNsvIZoBfXy0Uo
	snoCgt5jAOHF8hAuBqiukv4CheSKkxELYR64cbJQRkDpynY5JtDF8HaxFN4jc7AS
	slf3d5imw6Rnk+MRj7fQZsfwQIVbBI0gDBYLc8rPcXXdFVXW+23o8g10EcX3dnYX
	cmnuOmgADOPDZHIlwrcCR4zk/DTTQRuwvfeGzRGn3Pdz6LG+W+GbnRjycEydy1XD
	362Vuv9WDajc5ASdCLb0crpDM6q3wwMird7WE6j7W/E/WvDyqjEZljvaXrq0CYpb
	Id62/7xf7SHb1k4SS8WMCA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhu8hus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:02:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6180NDNl006487;
	Sun, 8 Feb 2026 02:01:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxZ016745;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-8;
	Sun, 08 Feb 2026 02:01:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Thomas Yen <thomasyen@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Stable Tree <stable@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Flush exception handling work when RPM level is zero
Date: Sat,  7 Feb 2026 21:01:49 -0500
Message-ID: <177051564483.3805738.2015850071936649322.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260129165156.956601-1-thomasyen@google.com>
References: <20260129165156.956601-1-thomasyen@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Proofpoint-GUID: 3vv4Y2-uaE0UaywTp3QgNL-jzsZeRLgj
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=6987ee98 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=HY6Y_zffv6qRMAXnt8oA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfX2fS0jj5ubVZY
 bUqWqolqVhWqt03luNgZhZLkiW7AriSlqEqLApbJaksCETbMJ3Gwm7Ya1EDvRygg12+ahHOvJf/
 5KN28Jt71dLtUFtOK6nv3MI7qzegZK2RBj+CkYSQQrX+drkv6LtU5ckgmUwy+wrctdUVCdqwo1Z
 v68NNfJ7khKgmdjpqris2LzNxyTJy+gNCvaM6dWJ829H08LSy/N+ePFoRu6FEvCZnI5/xCvjowX
 KvmKXslsINm3cvj2CN7bHgBWAaYr8ZIioAh30hVL5NqDM00DhU4uI28r2Z8CDSohrP02K7JzBUd
 gM+/vkTijcK8V30LRwJYZN12HcK09itYJj1iJhC2PECnKsvo3xHuE9ClvyclSXvqvK2ZqjAY0E8
 fY1c98WxwQPXM9S0/CngqQH9XNvI0tW4JLOjwsMDJ5JtXi/5zTT4We7im9hV3ZbtLoRSr7k11GC
 7uWc11YB5skJbGZNF353wyuR5c0gJ9Ux66k9KuTw=
X-Proofpoint-ORIG-GUID: 3vv4Y2-uaE0UaywTp3QgNL-jzsZeRLgj

On Fri, 30 Jan 2026 00:51:51 +0800, Thomas Yen wrote:

> Ensure that the exception event handling work is explicitly flushed
> during suspend when the runtime power management level is set to
> UFS_PM_LVL_0.
> 
> When the RPM level is zero, the device power mode and link state both
> remain active. Previously, the UFS core driver bypassed flushing
> exception event handling jobs in this configuration. This created a race
> condition where the driver could attempt to access the host controller
> to handle an exception after the system had already entered a deep
> power-down state, resulting in a system crash.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: ufs: core: Flush exception handling work when RPM level is zero
      https://git.kernel.org/mkp/scsi/c/f8ef441811ec

-- 
Martin K. Petersen
