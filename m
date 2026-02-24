Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D73A9623;
	Tue, 24 Feb 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951685; cv=none; b=dvtUCJApjDIv8kzf2BmXn9lqXjnOe77ktlQ7ba8AosjfB4ll3kVEkO/tu+zI56f7IweI9uOShvCMUAEVE5O5WdI2xF0BH1OpjgW/LL7/2F8AK54Re+jvlWk+uVeCdw+TEHcUN81Yz1RdTVsjcBmMRuJmmpDO8icqNFJMvV3vrUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951685; c=relaxed/simple;
	bh=Gmj+8vhbTRo5bC2EMpeqMRw7Hl+GuMaTvO1pjCzsSro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuEx2i09DJ/BcTzyl3r/Q3aVSD2i7bFjNCw6pdy8byCp/AvFfTKaO1Pqyt4UN4DdmILgO+KNQ+dha+D3d/JHdKBeIWo+DDQGOgMq36h1UbO3UdovoNGA6BSgS+pTa/SV+vC5xX8tCkHY4RCvqJyQd+yP70yoE6qpODCsIMv0rMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L4+9KBcP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L4+9KBcP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMoh14088652;
	Tue, 24 Feb 2026 16:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RFRPzN9oaaJNdb8xdhByXtWztYb3m6pt3nVWKDBEi68=; b=
	L4+9KBcPnApVgX6ycz5iNcPG3m8LX952ctYTcVpDm9HvnXPRI1+0OsJlJ6jN//g5
	yd7+vlGpJ6eCaHZQOnbx1YDapx95KXMVs+T1U9hYsOlduTHU5hpz8rATosArE0TQ
	Z7m+dno70rPaSH5ZbimvH8eJCiOYTulqWWrrrnrF6ihH2wSQuH4kCTb3IQ0H7V+/
	CixKJy2kpjbOwOxa5WZRrQdtaLE6a2A+9jr00DOJDUobflcsSw6XlcX8EKMUGz/N
	1A6LEhRq4hN/sjYkb0Jpt9cypsvV+Lj/uBNyGhoZJAXtoOAR0pksZj1+HeposJ+Q
	IT3OztfgkvhOVn/iE0fatA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7vkuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OFl1rI015682;
	Tue, 24 Feb 2026 16:48:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6knv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:00 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4l012936;
	Tue, 24 Feb 2026 16:48:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-5;
	Tue, 24 Feb 2026 16:48:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nmusini@cisco.com, fourier.thomas@gmail.com,
        Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] snic: MAINTAINERS: Update snic maintainers
Date: Tue, 24 Feb 2026 11:47:44 -0500
Message-ID: <177195161260.1154639.1398015068407266135.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217204658.5465-1-kartilak@cisco.com>
References: <20260217204658.5465-1-kartilak@cisco.com>
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
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=582 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240139
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699dd641 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=EsecnnlcGdy9LKmwybcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: WI_MyvFcX6RBE364lUgGXs8V5FMDg766
X-Proofpoint-ORIG-GUID: WI_MyvFcX6RBE364lUgGXs8V5FMDg766
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfX9gzHTcEkJVrY
 RpJyQpHEXQOiS/iS1vbExbDS6DUxWVNJu0vkRY4v4ZiAjobkj6qDRQwXMXz1isC7PxkjOzo71wV
 dGcWLRWYldcAOmg9KaTa3gB1RPRCxI2ydivzQl31rvu2C1CYHjf5I7/Ara3UiA/ikKvf2QC2jBX
 s1pIYCJ6Uj9NA0uLhxgQJUfm3gunhQ7Mw7hK1jiNRx43p4clxhzxKy55x7YP2n4IgAS7fPViYF1
 EUfQ3P80q2V/9vYenLiESIeYoer5HWmYJKyfARIQHfd+ghQ1agfEAiH7UP3GwYRLoBsBWGX0Xdf
 L9TbOsXugIA/ZNqCUaY0E9dUXQhnNyoxkzp8+KEEGo7oRI4/W1M9FECePyDWsd1hYALffQo4XSA
 aSGYEXdGmnpFeELQ0lZ/mvnFotqXRYWE+FhhkUjwnbCMiJWPyGPbLyH9Gg7rlPNfOt582yPQi25
 T6xQbKDzMtn34X/AtqA==

On Tue, 17 Feb 2026 12:46:58 -0800, Karan Tilak Kumar wrote:

> Update snic maintainers.
> 
> 

Applied to 7.0/scsi-fixes, thanks!

[1/1] snic: MAINTAINERS: Update snic maintainers
      https://git.kernel.org/mkp/scsi/c/97af85787c19

-- 
Martin K. Petersen
