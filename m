Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768E33D6C7;
	Sat, 23 May 2026 03:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506162; cv=none; b=duvu8mT+a3r/5H5cm5bm6skBHo2SMZN1TXjktV7WCvkmp7FpepkH2DaTzkYxz2ZpvHwaE6y6htlgah+ZwsCX8mr88lGZLllIEAXVE5AQ2XBwSs/PirDIOQA1AEFKpbnR7HEC4y1BUwPUSoPJ7GCBMBzMbOjcU8NIKZ//59sIOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506162; c=relaxed/simple;
	bh=IFHtXUl/rmxrhXalXLLMn7jLuME+SNZdz9lMDAh1PKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVy85i1Ei8O9xj8QrySQ7c7eMTaFP8BwKtUhujFnYGQtLMbyJ84pgjGnj2ryrUHUvNb0inKW2l8zo6mgfLAjrCweMGGYkWDA4VNaDWduSC581jB2CGa6yj9S1YTCx0QCiynqie7MkGxN5LlNFGPXk+hOX8Fe1kb0ORmTA+QxuxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mSECbXsp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mSECbXsp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3BcnK1942559;
	Sat, 23 May 2026 03:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1R/hnSMK+XZZmwmXUFxaesfejobLvV38R9JlnXvRZfA=; b=
	mSECbXsp8f4sLKWaR2uSht/077PLLwG5AgV7pyClhrHF9iPe7T3GLV9GtozHjz4f
	JwOuX7z1be28RH17EikPfZSNH/s/xwn9VCqJD2uOGUn/roetLncg3NVJYfos36ft
	nFTfZlieMRA5wRK/HRvQsmhL+H9N1SMxeFNsASSLRozNhKKclZl5QgPx/NjnhlRH
	uoNVuT9Bu8r11/bUrAC63yYIWBU/SvAFrcJUJVvq1C6THM0evNHz1NuRdZZ+eMtt
	3a9fiR3XgwH0qhdJlK0tXtSMIdkT1kaqBIsBU1apwqINTbR3hxSj+evNo5XC8sUl
	zrEbTsdU76vvnqzmrflRaQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb447g05m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6a1032352;
	Sat, 23 May 2026 03:15:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hstm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:57 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRG035132;
	Sat, 23 May 2026 03:15:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-1;
	Sat, 23 May 2026 03:15:56 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Alexander Perlis <aperlis@math.lsu.edu>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikkos Svoboda <nsvoboda@math.lsu.edu>
Subject: Re: [PATCH] scsi: devinfo: Add BLIST_NO_RSOC for Promise VTrak E310f
Date: Fri, 22 May 2026 23:15:47 -0400
Message-ID: <177950426844.1557613.195450412255768361.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512231254.27530-1-aperlis@math.lsu.edu>
References: <20260512231254.27530-1-aperlis@math.lsu.edu>
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
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Ecn4hvmC c=1 sm=1 tr=0 ts=6a111bee cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=X2_Ych7kLY-UD9z66WAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3NrsfVwSm3APNJFgJqVlaImigc-5FVZe
X-Proofpoint-GUID: 3NrsfVwSm3APNJFgJqVlaImigc-5FVZe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOCBTYWx0ZWRfX3y4VBlBegUi+
 fEtf2/tFIFdDh0/thNlZ+1xSswx6CikgKLyZcpZKoONh6xfdRq0n2iNVvXyQXClpRDUJjZXNqBN
 IAT0BCAUUKPfY+WAYUnBKr8O/OftGnn+N5skcQTlxseICno7bHT9qQDATSDocs9pqiQ1btUf5mT
 scyaJZ+zs0/X3b/sPLYufAyZTCySU0Ii8NxUrH6fI/NKHhfJzqGEUtXe4Dq6Gl4gp3zDShCJWBJ
 ELcZUVWNaImXMHmHlmzTjNs87e0OjubIjXgPYEJQGefXNRjA2r3S3Im1I6oeTf2l3V8TJMwZicX
 ZbxcCj5IG2R5gdFVm+GvVU6mALw6/5rdq99rUIlJLnLfw401mfvRmhcFHQhfUwEJpVJEAUZdC7M
 3suzAqdKxgS6T9vHzSdo4mwKXZ6QydI+J+CrMdU3fUepB/r4KzZvsbruHdGgPqm54CgCB3ZAszi
 1jSIPQlL2sTQhi7j5SQ==

On Tue, 12 May 2026 18:12:54 -0500, Alexander Perlis wrote:

> The extremely slow boots reported July 2014 in
>   [Bug 79901](https://bugzilla.kernel.org/show_bug.cgi?id=79901)
> for Promise VTrak E610f 3U 16-bay FC RAID enclosure occur also with
> the Promise VTrak E310f 2U 12-bay FC RAID enclosure. The 2014
>   [patch](https://bugzilla.kernel.org/attachment.cgi?id=144101&action=diff)
> added support for the BLIST_NO_RSOC flag and specified that flag for the
> Promise VTrak E610f. This current patch simply adds the E310f to that same
> list. (My workaround has been to include
>   scsi_mod.dev_flags=Promise:\"VTrak E310f\":0x20000040
> among my kernel boot parameters.)
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: devinfo: Add BLIST_NO_RSOC for Promise VTrak E310f
      https://git.kernel.org/mkp/scsi/c/adda8a44e1e4

-- 
Martin K. Petersen
