Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A77F2C11DF;
	Thu, 20 Nov 2025 04:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612204; cv=none; b=ajbOQkKgt4053cC1EJYnSCbP/iXO0C9DdMUvJRawqD+bBkj4FasrqFsVIz5/fDnPKGBgf/hSVStrXFVtabyVWgxKgUYhv4GoIKjamTcNuSnPT/FlDbx3GF24NWQ/BZXKxIxAtMz2FTFLsaKuf/x2D47vth4IvEaDaSHhChGGKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612204; c=relaxed/simple;
	bh=FrPVivPhCiOGMidyCkIKU3DiLOfLzCVZIvFKMFgaH14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8Demg++Lovm8iyCCZZUhb42iHWfqpcBbULMxGp1EcebgFeXqKtaPVMpuni4a/9FgQC+jUW7cPjHFNm8tZliGTK+vGU7CeK9CG0vgjTcM8r0/FufqiPLZBHjAdRxs2P989CKolM2V9TscBiaQJvRJ1g7J7G0qlRIXfrQQWoLP3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DOhzRx9z; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DOhzRx9z"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1O4M6030642;
	Thu, 20 Nov 2025 04:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ivfg1q+bSGCO2hOfBvaRvhuecABA9Bzal7owbTIPprI=; b=
	DOhzRx9zX7RP6/CUitbCZyIT8+iZ0+u1wIm7kxCJz55zO8QkXlUngkfAp1vNNgUq
	DRdJGDnLmZowqigiIQO02EmYkJ3zjC4X/gIK4ozrbUql3A+P+dMNYgKVYPNwkA2U
	Y5UCiw1S9osfPhG9C21VKNqRMTOZuNQxy0SE3pJ37ZjKvOtBfdVJgfQdolfqQZ59
	wPv1BsS1RbVhFiMSMezvkwt9hckTv2KIA3yV5EXmogxEwlQxBNDFeDob1xo09XZv
	mJCyfT5ygLR23NxVuo2gaoJVy9m9FuovaOyWoVLxaCD0BSTlNyqmsCMUsQzf3J+D
	124wkI0yiJ5DuuRt0l2I4g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK28lZn007971;
	Thu, 20 Nov 2025 04:16:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:38 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPx012546;
	Thu, 20 Nov 2025 04:16:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-17;
	Thu, 20 Nov 2025 04:16:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Haotian Zhang <vulab@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sim710: Fix resource leak by adding missing ioport_unmap calls
Date: Wed, 19 Nov 2025 23:16:06 -0500
Message-ID: <176357169023.3229299.17454485586955241395.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251029032555.1476-1-vulab@iscas.ac.cn>
References: <20251029032555.1476-1-vulab@iscas.ac.cn>
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
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=817 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e9627 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=cDEqfk7u0dXtlGyMBYgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: F2mkqbmfep3XR9MTkhc4hIg4bbP92VXu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX1QaHP+fAbus6
 IVCqN70/KCs9VE/w0eHYEOTt4ktwozF7TkaN5ZzbaNz6Pz5QrTrnQu85F548PTxuuEOtmeOeb2q
 2asrwLPOqDKypTb0l1ShgvC+NZZ3HKkt3eaHiGl0+NlSo8OO77LrOGtKl0ogy1vUCguynFRQPwn
 wswVa/Cr439+sBIPLgf0/2hUUDU8D9FQwxZ6y53gS6Szs5fP4Ce00a5inZu7Y5HKq5gPEmea3OX
 vU9kBwa3WGvE/PT0zAZhJ2s1KRK5EnNdCJ9J+ADpteLPECPqkLvZHuCBzDyeieR6W6Z5HbCmxKo
 VoMBpkdDBjU8jSELQiYC2YpV/N945XwQ+vcNGZyS/M5kxZe4L6rDKL9oDZFMpJUe2yHQpg8VtUi
 eT+0gbHGRJGvOQvirwLhVs00lc6FGg==
X-Proofpoint-ORIG-GUID: F2mkqbmfep3XR9MTkhc4hIg4bbP92VXu

On Wed, 29 Oct 2025 11:25:55 +0800, Haotian Zhang wrote:

> The driver calls ioport_map() to map I/O ports in sim710_probe_common()
> but never calls ioport_unmap() to release the mapping. This causes
> resource leaks in both the error path when request_irq() fails and in
> the normal device removal path via sim710_device_remove().
> 
> Add ioport_unmap() calls in the out_release error path and in
> sim710_device_remove().
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] sim710: Fix resource leak by adding missing ioport_unmap calls
      https://git.kernel.org/mkp/scsi/c/acd194d9b5ba

-- 
Martin K. Petersen
