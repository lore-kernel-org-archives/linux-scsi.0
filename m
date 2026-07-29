Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2143914F0;
	Wed, 29 Jul 2026 02:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293727; cv=none; b=SYIpGhvewXM6kA1arE7JhqqpJtXW9aiqlF9lP1TtDqAq6duqWWJ3BktgjxLwKF3WLtuE0jfgdkHEQ3t5MM7wvlScvhmVIzb/HsNjD/vcY3MQScOSRX1ntfwhCReX3wY+AuVvuD816+WEBN7gIbEoLZ8ig/BzDoy2Ikvu6p1h3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293727; c=relaxed/simple;
	bh=xWdSUwlNR59sFUn/dn/5/RNaM+JYaINLUXud6khvcXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZ/eGTJ+dFVy57/Foc9gjmRHrZbhXXXVF1kzY7G+7ESui8NHAmTd4P/HsZWV1JenAyaE7Pf2z3Srs5BzO/a5lp9aV3qmEZ0KHJyqZuW0Wt7k4Qyj6Ko1TPJTp8QPMwph3AJWrYlgM6DN7vYIZX6t0AGjiO8rYxrBJJKw5MRL9js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b7aq1n53; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b7aq1n53"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T0J6mP1640995;
	Wed, 29 Jul 2026 02:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z2rP5vuaNr+vaebwrqW3yeBsgBmiYG43KUu82d9GsSM=; b=
	b7aq1n53Fd/ovOK0Cx+YKH9foGB5RbRgcfufbu5IaD5U/IzgKX9qGEbPZPR75K7l
	S73Fo/jZ2sZAoosB2xaAgpDUngNsIESLZ8RtKkSvdxgNVZC5gAXMGKTmaHo7LFqR
	YgnSpAkafRXtregKSli4BOGUVywd6PLUhxrSCocRYCXkeaM+4Ea250QP3zHXJsfb
	rpLOVyhNpHJv2dT/yS2QGtVso5AnLdknYwK34vu5cYjaVxQmJmdBF/uIGHK4Ap/G
	PHRQP7Z1OSFFRqensuUIuCCAYOTgXnOukm0/dBfPjQjiu16lXiWlK/AypMO18tiv
	67Bc+WUXGPomPaO8gKJ1DQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1dd63y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o6el001464;
	Wed, 29 Jul 2026 02:55:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:18 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jZ012133;
	Wed, 29 Jul 2026 02:55:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-8;
	Wed, 29 Jul 2026 02:55:17 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: switch WriteBooster missing free space message as warn_once
Date: Tue, 28 Jul 2026 22:55:02 -0400
Message-ID: <178508193508.4027291.17292493573659492465.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
References: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=848
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-GUID: H9yvVrHGecmu-oWEyRkMTrFoKqGMzUf8
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a696b96 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yMa8Z6lOFZ5tYPuSUosA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX2/0btqxVLSou
 BOWolY8PI/DfA6zxEjzR+KsBn2YPZ7vwpfrdvSK16mVmvBu5zBstjfYHUzyXZN1rW4M/hNohpZc
 qfOyLGKtR6l/G6vdOW+nxAR62gjnC6LV2szU3cKm9qkQojgiBoRe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX64f8n6sMvk8T
 1WrKsxf5UJgYMPstA5P8QjC9N5PexJvzMqc7yjY0Ev+7jkAW72YCu8P7bPXvOL/xYS7qNcs1o+Z
 xcNKmOWx73mdnFW1zHIokCkZWJsnTKqz1b/Wrr0Tkblt5k2HcDQFz2cMZplzP1+rIS90IxuB2+T
 AK49iOPQC+yqE5l1ZUaYJfw6mY2UU/eRagxjfSQ4vYabe1dNgsHDfKrsSlrSFDd1lB2L2QtCdQB
 cyU92ekVvMVgyGhwHFgryy1mEiG/GFaBwm2SjBF6V2DEpY57GOTQyUrHHSjHcFlu0v1AvXjhENw
 iM0wyqaCbnLWbQwHF3nsLYzc1q50WxrZJ22FlNanm7VCIIILqhwfm9Ex6JATcODuKxqLi0HO6Tx
 SrmfA3eYbfyTOgtrwhM9F0S18nSDaduEha+/A20okAJkN5p5NfYu1PvzD+OucRVhEUMJIQztw0Z
 8D41m8et3eozVof+QbQ==
X-Proofpoint-ORIG-GUID: H9yvVrHGecmu-oWEyRkMTrFoKqGMzUf8

On Thu, 18 Jun 2026 09:52:09 +0200, Neil Armstrong wrote:

> Once the UFS WriteBooster fails to allocate memory, the situation
> will stay until fstrim or equivalent is ran.
> 
> Mark is as a warning since it impacts the performance but only
> print it once for the lifetime of the kernel since it's not fatal.
> 
> Otherwise it will be printed each time the device is resumed:
> [   31.666880] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
> [   52.655594] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
> [   62.890469] ufshcd-qcom 1d84000.ufshc: dCurWBBuf: 0 WB disabled until free-space is available
> ...
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] ufs: switch WriteBooster missing free space message as warn_once
      https://git.kernel.org/mkp/scsi/c/c6cee609f614

-- 
Martin K. Petersen
