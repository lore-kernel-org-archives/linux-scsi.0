Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572B3315D45;
	Sun,  4 Jan 2026 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563017; cv=none; b=sDB1pdae9T0KHpLXpBTp1n6OAaen2SKSf8p+YrY6tddl9yUXgjseIQ+fjdKG8AKlJGw83rM6BwfqpevfE4Cd+ilHTLguyVklU7bJ4pnpfPqOBkeA7w+fEIUzypeoG3H2MTTEEWc58lINHCTXDFuPZE+kjHUrKMORPa+2xd4K7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563017; c=relaxed/simple;
	bh=E5m/dS80gkrtlsUlBf6AtIKAZpQHyoFEJBomfgjTfp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9BxBtjS5KlGPfGhFSulBwaTRGZIHsp8kycVgdpeJgSbViZ2QDDsVvI0YNUb79H9vn2ZhP/7LpB2UPLGeRcadHc3dJC1m65TqfHjjGbj1opXJxCucjIOoagbpFtXHmBFMQuL53WxYylomyKhrW5aUNhzltH5C3uJSK7GxymLxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yw7fdpDK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yw7fdpDK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604L3ttI4144679;
	Sun, 4 Jan 2026 21:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CFQG70oAkE9PpQogym4UjYltySX3Bhs4b9h6xRp2mrE=; b=
	Yw7fdpDKGytShHyt17uZr1ckA1ia0jAxMRkOJMX2wAO1He/CZKQpx7r+RSh3Q+uF
	eSZMEgUgJJ1Pf16s9JiNnYflmXy1QoGIWZPFMg7EByYJCJ1/qsbAh7ylcXUuLWIP
	tIos/RGQBYQhm4Zrr3N339lq5n8PGpZT3ZYgHdNX8cvHYmbT2haFAAROG93bTTeY
	wV/rk4QPRiCD2l18e3oGat238f0mhEMf7XrCEOgoxDELUQLgPJb1TNMKnI9ppFKG
	na0ORyXUrQlUxdd3xTMuT2CUZAObdv+b1RTK8o4JKjpAfN+SSa47IBzKvmZuH2MX
	rtvoIki+ChDaSY+H9NyDlQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev6ngxwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604HIYdI026766;
	Sun, 4 Jan 2026 21:43:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPob007658;
	Sun, 4 Jan 2026 21:43:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-8;
	Sun, 04 Jan 2026 21:43:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
Date: Sun,  4 Jan 2026 16:43:14 -0500
Message-ID: <176755562240.1327406.13930479831805099008.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205235808.358258-1-yury.norov@gmail.com>
References: <20251205235808.358258-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=835 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-ORIG-GUID: nd_94l7zLskpJiDnAwcwxELmlC28VbvQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX+nZmQmnf55QR
 ba0CfUi2xTPFLvFIuoq1ObJ6Nbamjsx3zPWvN6xInyjXtOtwjlBVHDczBZuR6d1iN94EsSz5+IL
 N0EdMuBH2URSdXBl6SnMI0mFnf2UwmBfxq4IjaIh7/NkKHFxs0CgjN2emjQKhNaaGYz9f+QkX3N
 Xnql89OC3hehhqq18rmSW/p53/T5Uyd5pp39MXz/lnPeB2KexX5xvhNIfmrXh0E/xB3ebSRdha9
 Tbboehh/cnAJESXJ1MIh62JlT1TsSr7edcvckKA/HGUEJVsBH3adYWZNAzXoO+eqjNT/ljArQ/c
 8VTzEHjxijOffy/yi2nqNsnhjWTO1cX1aYwlNjpzC37g82hbxXH6lCPM4cxeWmAcJN835vlNqXY
 WtYHbZv8cL+XO7jKMZxt0FinV9xD75eiLUZ0C1nI3t+Mm9KGjs/H0FffcHmG4B8N73m9xkNWJn5
 zOuYd2X8FXQhqi40q2w==
X-Proofpoint-GUID: nd_94l7zLskpJiDnAwcwxELmlC28VbvQ
X-Authority-Analysis: v=2.4 cv=QtFTHFyd c=1 sm=1 tr=0 ts=695adf05 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=RNZEd_7TLfh3hsy2-ZcA:9 a=QEXdDO2ut3YA:10

On Fri, 05 Dec 2025 18:58:08 -0500, Yury Norov (NVIDIA) wrote:

> The function opencodes for_each_set_bit_wrap(). Use it, and while there
> switch from goto-driven codeflow to more high-level constructions.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
      https://git.kernel.org/mkp/scsi/c/1a56e63c8216

-- 
Martin K. Petersen
