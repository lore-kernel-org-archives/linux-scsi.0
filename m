Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A37145FE0;
	Tue, 30 Sep 2025 02:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759199831; cv=none; b=DnWdsvSd/ynwHavwFAjsJgn2YtQkorjVx2GrrdT2CPD+zCzV7bJjzvne/ScP0699iMWJdfI//uVvKXrwo8fQACodGYzVtkPgX2/QMgbuRHIoXXuABE+g9Sy/6IXM/HxDBdrfLSRJRZxnyYE9FaCKEcd9LXsOnaLrqwwebMp0hSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759199831; c=relaxed/simple;
	bh=yfqmHavS1eLCbqTqlljLMNoP7ABYdFR1R3XHPcVQ9+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0oF2xOctqxHlM3xJmhaSslkrVfmvl+cDVRT5YOVnN2zgdNbK853K4oL2+0XgMuas6rw767UPrV/6T6X2g/KbdvjfyWL1elbaW71/0vgd16XxWtTbQhrnDzSW5hgFuobL3CIxyPuHoeiituipN0kLXDqYvLhqMZV4UNyPjrVljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T/wFzg6q; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T/wFzg6q"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U1idgB029962;
	Tue, 30 Sep 2025 02:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kxHvQ/+e/qbZTLv0lrpXPdrZ6rhVeIeDOzjuYR/n+ws=; b=
	T/wFzg6qKpoO1dnwo+HeTT5xEDPRPRGG5bXx0+N58I9OQYBWYxPv44BC8HBgursd
	aRNmdg6HDyXlGPRB1MLhDFe1fMt7rWZvjFnAe2iHKdHFKo7D9Hl0BNg63DqwabvA
	k7B6dNUYzj14C5026fcHFu6lBXmMHt+l3+3VUW9iHyIDOJTBYeWxLwSJ0fezmvcT
	Q/Z/Y654JSXM02Tj3inYsGNmGDUV4t/YETZAiqy3kUV1g1k+bHLfgdye7IemXXQC
	wQZkZuTBTCAfo4IL1R0GdDqcHTXO2YLXKn3pW/gseeIX19zeW0NDT8W8+Foicl6a
	eUdSNwURHth1aK9PP9eBog==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g5ta82vm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:36:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TNKJle008194;
	Tue, 30 Sep 2025 02:36:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c86ev0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:36:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58U2awV9004400;
	Tue, 30 Sep 2025 02:36:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49e6c86eur-1;
	Tue, 30 Sep 2025 02:36:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: hare@suse.de, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()
Date: Mon, 29 Sep 2025 22:36:47 -0400
Message-ID: <175917739970.3755404.1234135227705143771.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250915183759.768036-1-alok.a.tiwari@oracle.com>
References: <20250915183759.768036-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=777 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300021
X-Proofpoint-GUID: vR4siH2rv4BJBh8L7sIhDG07xb3zWT34
X-Authority-Analysis: v=2.4 cv=HZ0ZjyE8 c=1 sm=1 tr=0 ts=68db424b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=thc0kbuJZ-nfdIKY84gA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDAxMyBTYWx0ZWRfXw6+kXG6RsDjr
 C3yHrBQL0Yd3WQYH/9IpNhdrnjr4FIAGOHMZ8oJnj/BK4o+x6oOJAVS6oqITyM80HhldcRr5OOF
 nkEsGUXqnNFpG5SVoINWypN3VHWWKcGfPyhTeqtQQ045UoTBUwcZpvuNKK/PUVdoVwZwTDzelKA
 XsEtLeqLft86ZCyl2rrq3qVDWIKn+Jw0MW2Uf6FX24j0LO78Mb0Z5LICN2DGb8FlM2LL6SeCGMg
 pijPSTwTM+ojaFvuEgVtYycG5Ugq2A/7Pydq+zoqQ3YNVEZ3g/+iMT0QYJkUkIsHtqfCu2L/Pwl
 6SWVw3k9bm19g/HB76g3gKJlyznGsX00iUAGhbFegANgsZ1CNyW4rRS0it1mSFwcsDoXyDL4x1x
 CZ3AABEdoIrE0ccI8HeJdCPVz2gXJg==
X-Proofpoint-ORIG-GUID: vR4siH2rv4BJBh8L7sIhDG07xb3zWT34

On Mon, 15 Sep 2025 11:37:57 -0700, Alok Tiwari wrote:

> The fc_ct_ms_fill() helper currently formats the OS name and version
> into entry->value using "%s v%s". Since init_utsname()->sysname and
> ->release are unbounded strings, snprintf() may attempt to write more
> than FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN bytes, triggering a
> -Wformat-truncation warning with W=1.
> 
> In file included from drivers/scsi/libfc/fc_elsct.c:18:
> drivers/scsi/libfc/fc_encode.h: In function ‘fc_ct_ms_fill.constprop’:
> drivers/scsi/libfc/fc_encode.h:359:30: error: ‘%s’ directive output may
> be truncated writing up to 64 bytes into a region of size between 62
> and 126 [-Werror=format-truncation=]
>   359 |                         "%s v%s",
>       |                              ^~
>   360 |                         init_utsname()->sysname,
>   361 |                         init_utsname()->release);
>       |                         ~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/libfc/fc_encode.h:357:17: note: ‘snprintf’ output between
> 3 and 131 bytes into a destination of size 128
>   357 |                 snprintf((char *)&entry->value,
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   358 |                         FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
>       |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   359 |                         "%s v%s",
>       |                         ~~~~~~~~~
>   360 |                         init_utsname()->sysname,
>       |                         ~~~~~~~~~~~~~~~~~~~~~~~~
>   361 |                         init_utsname()->release);
>       |                         ~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()
      https://git.kernel.org/mkp/scsi/c/072fdd4b0be9

-- 
Martin K. Petersen
