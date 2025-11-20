Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49E372AA0;
	Thu, 20 Nov 2025 04:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612185; cv=none; b=VSh7f0dJa2upu46fHTge3GQLcKdrGfcopXOvMcDF5D6vCed8HUFb0a7i8WFH/KLQeH7ZlbGlteM6SYLllkg0orrZPGuGhY+60FJkYVJ2Ln2b2wE/ORmoTB9T/pnBs+j/3NsjpYh5OX6CK/AFQbusIUD3wag7KyN8hYAumK05xco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612185; c=relaxed/simple;
	bh=y+QWWOPJ06NzVwxfJHRH8qRVcOeEO8w4P/LYYsEjx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nMqG2ZJtZtM49ThHdhzHOEjTvCgFU3GTED3mEnYpPngdPo2h6t5pPt7U1xAf2A1uPgFf85VvVXFDAWP/ynEJ+VglAgPGkppiJz3rzp0tPeIQyyzFKS6YwhjzDwvmh19uEv5Lk0ZNcmxFnNBauHhZEhIw8VEvMYCSrYwIzwXhq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FIYAkDs/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FIYAkDs/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NwDr013793;
	Thu, 20 Nov 2025 04:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cBCNPIQD/lJdQu3pLyhj5aqNAsPB6cRX723edKLaBJo=; b=
	FIYAkDs/rE31ffu8H/ygjsInYe+oeQAyqC5uWDp/UlJThdBnDyrDcb1GS9rt1jsi
	v9Wi4faJCdbiNUnMRJOavuSOWGKmuapK2kpwgFDBC65dP0rt8ebqwmk0VaMOTW0X
	bdjZxchYOvjU8jgVy95JgSbmHGF35OqvhZcD3ol6rHptPIB9CiI+w27236+C7qiH
	wJxhcBqOa5z0gsjbb1BgW9vvnn2egPyq1eUdwR8xfgNPgwPgBhvK48Jjdsjk+f0l
	Cpc98WphOXBrbTgXUZ5+mhwelzDGnyVeimwNazMpXsgDJkM4BdsnUd8XsVrXiwWj
	PC+nMnA2ctDhzj9On7mllQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbur8wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1Aqsg007164;
	Thu, 20 Nov 2025 04:16:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh493-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPR012546;
	Thu, 20 Nov 2025 04:16:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-1;
	Thu, 20 Nov 2025 04:16:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ally Heev <allyheev@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Date: Wed, 19 Nov 2025 23:15:50 -0500
Message-ID: <176357169033.3229299.10737876668875559171.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=669 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX97uvmH/33M3U
 Y2DMj5kj48LdTDoATtR7unxfjB/NBnlUUVilej2DaBHw0ZieqV6n1RXVTpN5fBCGdmTpCvs6uWV
 fVXwA0o+cmFJXIx70V2z+RzG5nfqaYrENWk2UhiPPjNyjJjqiFn8copDORrXeSvWQq2SaiQe+/l
 XxS4koSYmvWPS23+z3e1CcBC+2b0IAyd/4qgdVnNJRjVJuiJrPxzTour/6FLoDlycxvoF7gRDDJ
 td/MDymXZQGTp7lWsPVHMz/0gqoBVSmpS0i5LM46BRD4aE3MCI0W0AQtwGvJPIy8X9fA1SwTzLX
 0wHCkuO+bdetJP5Y10N545FTekiVr4kGqEmQykIZWGFPnFOsSkCvqzZ0cqQ0GIS2bPg683ptIpH
 e0Wo2VsSTYpd+ueIcDw8bTt/Apbrbg==
X-Proofpoint-GUID: XCFei7skvgWRB3paOheQWEUQhl_NF_Jx
X-Proofpoint-ORIG-GUID: XCFei7skvgWRB3paOheQWEUQhl_NF_Jx
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691e9615 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=ydH4HZNqwj7iu1hnzfQA:9 a=QEXdDO2ut3YA:10

On Wed, 05 Nov 2025 19:44:43 +0530, Ally Heev wrote:

> Uninitialized pointers with `__free` attribute can cause undefined
> behaviour as the memory assigned(randomly) to the pointer is freed
> automatically when the pointer goes out of scope
> 
> scsi doesn't have any bugs related to this as of now, but
> it is better to initialize and assign pointers with `__free` attr
> in one statement to ensure proper scope-based cleanup
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: fix uninitialized pointers with free attr
      https://git.kernel.org/mkp/scsi/c/3813d28b2b12

-- 
Martin K. Petersen
