Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6976168DA;
	Thu, 29 Aug 2024 02:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899851; cv=none; b=YDXf2SUdHCzGqVESGdIcuhpI26BTW92QWCeFPcRVY3gLalY7zBYYX1J/VdBF7a7MFTIc8XoXtvUOxuMIwoQBq90W6CcQEGtRMisarGMT0d/t3PYTKALC//q3aAFr0AXJLMkU/C2wtWhZU7Kivg3xu7Iyk6JirNCeHwQTTJzXNwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899851; c=relaxed/simple;
	bh=EhCrej9yBEUhGiy4ZXaUNuffjAqkh2ormAoe+rDPad0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dup7zMSB2DW628FGuCU5EuAyEtpOILT5ld3O4mQ0EovlqnIDow0D6oqzGTwnyhzuupAR3lmNDZMAYJDuL4gSeYCNKYyN7Dk+p55hU2VqKTfehD+o8XPuwUHFU6i7Ux4e0bUEc3vFaPVCrMXa6/rMT1Pobf07Mu7Lw0KSVThoV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L9Ld2kld; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9Ld2kld"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fvna013964;
	Thu, 29 Aug 2024 02:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=V3JykrdNnfk3XwAtz5yXC063Y8se7LxHu3xyfkQjEHw=; b=
	L9Ld2kld6Mna1+XLxRpWHE214SlZl8SJczPHxFzB+CXG9+L+cOke9MWfPRAFBp7x
	DhFczzOftp4YYHIPhN2OkbRtq8/66Mh5nN83fQ+POylpxDB2iKcvnDLFhntCV9vp
	aTZvvgeL5BY2OYzqRlWRLTV6yGJyU2jw3SLgW/U2dCfRjx7/yUC3iTuIXQ5Ro07N
	n1Rh7TH2/GUaUB5D6D+dwY3r+2/HMyavD6xXDwUZRpMy9WcxoDzDmYVw29h8TQ5n
	vjCNNx3unq/QrVeM5WjwoMuwlmN7M/cD5Td/CxKOxHW16Sa3nkYiL2Vo3VfjosKQ
	pJ4Xq5ZfqWVA3qaperTaXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pus34xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:50:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNQ24n036511;
	Thu, 29 Aug 2024 02:50:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jmmsna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:50:41 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47T2oeKv021990;
	Thu, 29 Aug 2024 02:50:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4189jmmsn1-1;
	Thu, 29 Aug 2024 02:50:40 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, Mary Guillemard <mary@mary.zone>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Date: Wed, 28 Aug 2024 22:50:01 -0400
Message-ID: <172489967600.759144.12839891235692358362.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240818222442.44990-3-mary@mary.zone>
References: <20240818222442.44990-2-mary@mary.zone> <20240818222442.44990-3-mary@mary.zone>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=981 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290020
X-Proofpoint-GUID: ts2JZZLcmkPMpe87WoMNb4bSqXuP_BTN
X-Proofpoint-ORIG-GUID: ts2JZZLcmkPMpe87WoMNb4bSqXuP_BTN

On Mon, 19 Aug 2024 00:24:42 +0200, Mary Guillemard wrote:

> MT8183 supports UFSHCI 2.1 spec, but report a bogus value of 1 in the
> reserved part for the Legacy Single Doorbell Support (LSDBS) capability.
> 
> This set UFSHCD_QUIRK_BROKEN_LSDBS_CAP when MCQ support is explicitly
> disabled, allowing the device to be properly registered.
> 
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
      https://git.kernel.org/mkp/scsi/c/0f9592ae26ff

-- 
Martin K. Petersen	Oracle Linux Engineering
