Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582C34A3A5;
	Fri,  3 Apr 2026 02:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181951; cv=none; b=dPr7fjCALjP+0OHNO9tRt5VtujUUxVPB5TJPM5sHp79nsNoIRDne05YMBZ6nUS5LxgfWbC/uN5lNsTqqLpAIpd1x17jXUhrwyyfqLI+Y+cDxdMvCFmncu2tTDZY0ZYt2Vp4wMUdHAMQa87j3l7y8lMYa+ORUa20xpFSrgGaJ+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181951; c=relaxed/simple;
	bh=nqwkAcOnzHmrD/ajw3/lsejsASmiSiOVHUoKji0CiUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVStefixgl5bgzusZ4wvVjTEI/d/ZXZq8QOIkRbI8e/qAWKNLYYYEGJBzAlUHxPTpArkSh2GKvghcJqbCM9ard2PJFbS9nm3YtRwgoaY5tKHoEK87Z7BacU2ZFVVw+662rFdpEF5TLAgS8TOu47228sK1ORKPWNvlZm9VS+cfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cG44+wdK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cG44+wdK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6330P58C3150600;
	Fri, 3 Apr 2026 02:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=va8tZAzcik9ibYN5dhcgHo1/7Og0KTYznIgjG96zuQE=; b=
	cG44+wdKf6Tsvz0CAm7MuabTvueoPrpy1HHvc/ZKaE8kiPo23/Adrj05ikf7xlvO
	BWgibIrWmphiREqrrWVL7zNnweIFafwIsLdqQzsq/DcQ6/4d6IZYVI3+a0h79Ejm
	vbJtOOS0Gm76gQDYw+eKCapRF+amu60ueEp66+ZiIN3g48+fNqqx31Rq9Ruk/rPm
	sPtgVUk3bpqj/RDEMB7s4m7Q1Z9JtNt5uJRNnkDbRdotbBySjwlnNJ2gxEAvLSpo
	iUPZ+4Lu7O0FDRV1PfFtTYHkpl3cYRpsllpwYl1TCwif6O7JPSnzzqBwLclIL1KD
	Ty4zObYB9q1v5UpD6yz2iw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5se65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6331A5Lk028960;
	Fri, 3 Apr 2026 02:05:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:39 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqX017364;
	Fri, 3 Apr 2026 02:05:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-1;
	Fri, 03 Apr 2026 02:05:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Shawn Lin <shawn.lin@rock-chips.com>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v1 1/1] scsi: ufs: rockchip: Drop unused include
Date: Thu,  2 Apr 2026 22:05:24 -0400
Message-ID: <177517593422.3522679.1544975066978972395.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
References: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=624 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-GUID: jMrp97DojdWvgtypZ3hTaCcxL8mvjgnP
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cf2074 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=kJSQstGPYqi19cbqO5EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: jMrp97DojdWvgtypZ3hTaCcxL8mvjgnP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfXz6/IPjs5Ksft
 sSMZS7rSwfShxry1hbwSuS85VcpGz4EIl5J86V0o5m6H4LIFZPl9CmPNlFpz8W/VSIvFlazZOLR
 +V7bmKsBhgEAccXO/n61oIvZJ1Ktvrv/kQonJhbQaE7nni/5ZGpWpu3aUW7hnRO12QTiCEcUBoz
 mr0ikJethsbC3wPqrx+LV6e+RMbrl1Yp0ny2W597zfZnRzAWsaXW+RIj+H1ELsbeRf2oxoXXGK9
 OFij43Xc0i7JUNsbhU5wzAZUBchXzJIPr1dzbtffK6jnIwDE3TGZu/mrKgcIqk8h1jEZzHsT4qz
 i/vn/sdvMEd94CByE59icH9rApmIIYA/aBY+4AUWNZCSRTVqS2dnVr3ZTVPg35SUU5p+fnH3Df0
 146YNgToR9XRIAcVx8Vu0GiCpTYViqLWpQHjYchK0Qsom4F7Ujckq8kItgbl6nxfUbXEh6xbbx9
 5SIuXISiMP9YV4UcEEA==

On Fri, 20 Mar 2026 22:56:06 +0100, Andy Shevchenko wrote:

> This driver includes the legacy header <linux/gpio.h> but does
> not use any symbols from it. Drop the inclusion.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip: Drop unused include
      https://git.kernel.org/mkp/scsi/c/8ad1ddc50d15

-- 
Martin K. Petersen
