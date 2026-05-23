Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7552733F59A;
	Sat, 23 May 2026 03:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506144; cv=none; b=U7FiNANSc4I9yf4h/PrbwG3fu49zHGEN9S6zuAirw8Z7Dw6YZF+yawP8LIH+JMeZcIJI+oQDgV3iS/P8Dv2dpdXzrsnqpbWiR+YSEDv2sn5MtSl5oM6KKbxrPxoL+ggZXvj/ozgB/5SerWEvnDRpALs6YG+XZGcf4iGXZgl/Q9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506144; c=relaxed/simple;
	bh=hcMekVsbbxeaI6ObNsh6fCRAZdO4xlRE+ljg0sGvlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICBln++4wa6UpGHAqQYJSCbQ7EfumwIpRccwhMQ7CYorNZdt2xA/88KtrOtPGHZsdPxCGqRKB/XbxaGBc+FWSffiDJkXhADeujswFB7UaG5l2kEvk0QRsRPPTQSBfrQK4o2SMBt4UQGsLv4HfJ5Oe+erm64yIAolDoNk88CwmBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q3Obp6Qp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3Obp6Qp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N2tTpT2818812;
	Sat, 23 May 2026 03:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IEFOvVQwdsvl0imTynvgbWRsOENvjqJW1Bt9iWH5qLg=; b=
	Q3Obp6QpUK2YFvbqZm76Nl8Nz9yuRQBc+RXJKCYv6ciN6nwlxMBQ0uWO78bTAv7C
	gOLfNYZ8MxDeF7BueP1JAgFU3EZ6qA57sCEiirX4AH6pGpYlRi1LYcPmAANRB8Fe
	j9bKp4/ybqxKY0QZSqpwDXAXq8rKLHXTiyUqtMd7VJAXILHYkWcOVPaVb4SrDOee
	I9ZRQ8tf9zY+nn9F33G/EhDAkyENa7+SkQhzZ2IglaGzwy0VQik8l92FH4oDK0lI
	vxo98T1iaFWZnjXcQkG+vwhKa6HaBaY73ciQK5i1mybeBmEtbGcz2YqlWGHF2t1J
	or5uDZ8hyulgwcemZhie8g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb3us80d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F61A032364;
	Sat, 23 May 2026 03:15:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:28 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eQ032824;
	Sat, 23 May 2026 03:15:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-17;
	Sat, 23 May 2026 03:15:27 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        Archana Patni <archana.patni@intel.com>,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ufs: Rework pci_device_id initialization
Date: Fri, 22 May 2026 23:14:31 -0400
Message-ID: <177913641765.1181900.11554423938330676893.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=948 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Zewt8MVA c=1 sm=1 tr=0 ts=6a111bd1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=IpJZQVW2AAAA:8 a=-5ljeZG2g70C0efMZmwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IawgGOuG5U0WyFbmm1f5:22
X-Proofpoint-GUID: qPv4FPZKfs3U2KBO2-O4dGPJrHtz18gi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfXy5FAL3vKXdoZ
 l5wTXUmZXJg6u1oNE5HB7tCqLoKsWLanRo+PZSaolmnCJvmWo3YLJ3jchoeE0b3l3qGChf7e+0r
 yQszUAN6ZP0Lt71PGaPUvJv7K7B0zRs4Dw8KzO+QK2jW/Ayd5AnInnt9uW8fpfZoDfJoRjGqDJK
 YzrH2GnHiPc8IApc0wRUjVo1wX8bJV47T4Njc4txs2UhNUoZkxoufZIj7MeNK8PcGx/MpYutuHk
 IdXT4zpRuwf4v1OfL9QLj5iOEPPNNT7l+TzWGsllT7bmWtnkU08+bB54h3bTRlf27RLDxj7nkIP
 cV6//A+t194AS7EFucLTxOZ4SyE1R/KWZIc4AHK08OqAQZPwIYRtN7NVxN7gR+PLG+36PhRL8qz
 +RcinvcSddQvEOtjwKsyK8CfKk9Li+GPxwD3ltFjUWf+VykmfJeMIc1y9OPRTr8Aw7qnFpTX2Sp
 wJ1dh6KC5ncT1lVnihQ==
X-Proofpoint-ORIG-GUID: qPv4FPZKfs3U2KBO2-O4dGPJrHtz18gi

On Tue, 05 May 2026 10:25:43 +0200, Uwe Kleine-König (The Capable Hub) wrote:

> the patches in this series adapt the pci_device_id arrays of two ufs
> drivers. These are preparing a change for making struct
> pci_device_id::driver_data an anonymous union (similar to
> https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/).
> This requires named initializers for .driver_data. But even without that
> this is a nice cleanup making the array better readable and consistent.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/2] ufs: tc-dwc-g210-pci: Simplify initialization of pci_device_id array
      https://git.kernel.org/mkp/scsi/c/2a18c57560f4
[2/2] ufs: ufshcd-pci: Use PCI_VDEVICE and named initializers for pci array
      https://git.kernel.org/mkp/scsi/c/8ef4c72dbbfd

-- 
Martin K. Petersen
