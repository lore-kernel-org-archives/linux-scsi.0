Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9D825A354;
	Wed, 10 Sep 2025 03:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473493; cv=none; b=lGe7cgdvvKkqc1n4D1sy2VXefsPzYu65DC8bB27M4gTDgVj7gxw6GoxnXh9wuk6ovqg0VryBvbrfdNriDVjDPulbH9eBOVNuP7V+pTaBH8aN5SksIWINsRi0Jw2SJykrtcv4oGpcfDKlft778NRHMMtyMBLNq48FSxLHrp+DeKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473493; c=relaxed/simple;
	bh=SN6lu+QQoMR2HSSp5igufLsHIjOogZ02uaamWb9RXzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Af8eyFpWeoZWdJJV7lpQqduDvxGr3QyyANw1qVfFaQzWurqDL72zvYbEoSCsIoR8EwM43uFhz2eNm0xtoBWmiS0QiHTR+a3IGk6wPldAqlcn9uRtL6+D4XgLjB4YGMwlNpNLzbmxFhodzV7FBwgXJeYb75HCw1pMtGAHqxxJNH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R5uxLghE; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R5uxLghE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0i0T004368;
	Wed, 10 Sep 2025 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gg4nXW/AqeZ5jJ53Eq+tqL6yrUzwn+INxO3MDUY1okM=; b=
	R5uxLghEfDyEviIE8JLTP1nu/JI86MlN2Bn7gadHduM8k0IMq2wxBV85A38XOZBC
	shK7ExE8K2zx6kF2Dj8qwaCraqr1mb+zGWO52BCW+aR8xPGeuOFAvVDD9b8acQFZ
	j8BD7cHnboRjkklgUzbZRMXK2caCm2H49C30GwXpn7RrTBlgXwZIHKQTcPB17fWw
	ATwC8QzebSmcFaZz7VkrytdyoKxmpOGZWABMIb5ugcYkWHabUrxqUFGr/nv6uici
	l5X6tiKOCb4Nkejzl2w2sHll0xjO4mW6jnfVY1orfagM7qj0yRJ8nhdVB751z8Tx
	49CdazXZluQcbOrHqA/O2w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 492296383n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A2rJ4c030745;
	Wed, 10 Sep 2025 03:04:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:44 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5Y011326;
	Wed, 10 Sep 2025 03:04:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-3;
	Wed, 10 Sep 2025 03:04:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Justin Tee <justin.tee@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Hannes Reinecke <hare@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
Date: Tue,  9 Sep 2025 23:04:35 -0400
Message-ID: <175746865975.2804493.17612301701065981287.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aK6hbQLyQlvlySf8@kspp>
References: <aK6hbQLyQlvlySf8@kspp>
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
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=753 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Proofpoint-GUID: Pu92ur4qLVyW7NUCcaOzcx7aaWCaKNaS
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c0eacd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=4643i3Vx3Gws2U8W7BQA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX9tYHdDeR3PCe
 YVdZ4EcLR3vpJKP89eRdELBZkYA4xbRQSrqE1LPGDQTsTtlgQdu9rfozJnltLp8s3tPpY1e+GV7
 +BOzmKdNZc0QeUyJoApYjoStoFwv8fcL4NeMzzyAdOh4yRZqrrQLmmYIsT/+agAe/RmnTf2YEv1
 dgsiisvolcGx07fs4AJY/EFZ3cPM4960NQ3gE9cJm4l/iDNlGIj3dQI3m3iEqn3R3R5JW4fwvy1
 6x/p1Mtp68bpnLZenKBhRP8VsEFN7Tu0mytg0dIlV0APkacoJ7tpBrHNSupWE6AyxV+ALTvCW8v
 Hzo+B1kMHVVt+vOnW+ZFkbntM7MfzlHU4CIdspBpZI7Y2VAgY+0Eydlnaj3MREbqKT28XpfoldL
 AxUKvf1b
X-Proofpoint-ORIG-GUID: Pu92ur4qLVyW7NUCcaOzcx7aaWCaKNaS

On Wed, 27 Aug 2025 08:10:53 +0200, Gustavo A. R. Silva wrote:

> -Wflex-array-member-not-at-end has been introduced in GCC-14, and we
> are getting ready to enable it, globally.
> 
> So, in order to avoid ending up with a flexible-array member in the
> middle of multiple other structs, we use the `__struct_group()`
> helper to create a new tagged `struct fc_df_desc_fpin_reg_hdr`.
> This structure groups together all the members of the flexible
> `struct fc_df_desc_fpin_reg` except the flexible array.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
      https://git.kernel.org/mkp/scsi/c/44b6169ada7f

-- 
Martin K. Petersen
