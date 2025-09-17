Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0873222575;
	Wed, 17 Sep 2025 02:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758076049; cv=none; b=TnmzS5Pjms2It3iOJhXQ9hcGSM6CSWeJY7ANeWOCh65fEhQuXkCilIVZnlR5BGV1rtMVyMMIMlb88wxuvPekR3Np+r1KkHzDuK8QMqiA1CxvQdHIMxM2tc5c/fLa8PO3uBA/MRtbBf/B2syW2zaISGVYM1ccXoZbrHsWWigNvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758076049; c=relaxed/simple;
	bh=V3OIPbMvwHEgKJdrQds31lN7E7XLXRIKIY/Y+p6dKF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mclYhmic13H4y9sasjGoKqodil+tit9UU+0JkrsGpOahqUSwGnFa9ftXru/6Wwf0e6OetxcY6ISzDtEw7kVlpfb5IXuGPUSogel4Xgd0XHV2dYem4cnU4uyui+WPU27kiD23L2Al3WJGZX7cmSLZKjmGMOWfvImTw/H/8o878ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bx4fmVI8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bx4fmVI8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLZ93M032174;
	Wed, 17 Sep 2025 02:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rsk0geJ2RaM2trAUsQqwIYhPanp68wyRGAfVutmZZ8s=; b=
	bx4fmVI8KHnnpsmTRl17HK1R/uVpv1B5g3WN0lcPPSf96eb05J3cy6NEe9x5k00g
	y3qg2UOlTQ/o12zUsxBDd8FR6RVeV2TtWZKR3neeWLY+jOiRinu9G033Iorff43p
	o8gOvRp2Lt1AHxksTwSlmt5zSSQ/YoSukwIDwzIWw/3rZrXzfoqWtorRoCn66hXb
	rt8JvhGw4UStKYDnHVRzriCpJuRVVCVORSFC4kTjiidKNoqVuGhVxcWQzcxDnhpa
	6w7Yai0aRDMXFrYRSMEOICuHV/2INJdrZnvNHBdBxBXqKJKKyvXRUdMdkTco3BbO
	jgHAtuCvJP6ej9kE4beYfw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb09ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0bUVU028863;
	Wed, 17 Sep 2025 02:27:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2d52fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58H2RHY3037520;
	Wed, 17 Sep 2025 02:27:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 494y2d52f0-1;
	Wed, 17 Sep 2025 02:27:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end warnings
Date: Tue, 16 Sep 2025 22:27:09 -0400
Message-ID: <175798566836.3116853.1907076670217510948.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aL8jeSJ8uKih9DNJ@kspp>
References: <aL8jeSJ8uKih9DNJ@kspp>
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
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=447 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1vqCgUf3XLQp
 Q0pnusuywIXVEs2uwKshImI/akwynmS4aAe2VVNp882d+LDUlbo2XsZ21EEFOAOjvVGpLcsBQ+0
 uguTkCxdGuP2JTQlSDmsroKBoN/hM9UF8u4LL52AblAJl42d0d9jQ1qvzcB99TMtzdZ4iqOddbS
 uhBb7krVihqTVkeN5usuGbJLkAVbs5I1dz3AV/bOZtw6uTrFAEAcNiX9XMX9QW7wKwPUaPGxtGL
 kqa097O+OK8DHTbWepWKHMuZpCYAJKyYhMs42xseYBTTP0CEj6BI/t9n6IyvrrEmD4m5/r4/xhY
 0PmqV65N8MXDTxJwq7TBVdP9ivXsrMHI6jFS26c/cknTmxKMrUpQ0Nyp3t7GSnyObTuAwt9iO9O
 /2yV0u+s
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68ca1c86 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EscN_06PMkp4Idz6WpUA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: SXrM2rDnZuu6dKj-MlZJcRvIagyUefg8
X-Proofpoint-ORIG-GUID: SXrM2rDnZuu6dKj-MlZJcRvIagyUefg8

On Mon, 08 Sep 2025 20:42:01 +0200, Gustavo A. R. Silva wrote:

> Comment out unused field `residual_count` in a couple of structures,
> and with this, fix the following -Wflex-array-member-not-at-end
> warnings:
> 
> drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end warnings
      https://git.kernel.org/mkp/scsi/c/508e754c6931

-- 
Martin K. Petersen
