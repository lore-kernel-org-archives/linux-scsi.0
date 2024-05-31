Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E6C4C7B;
	Fri, 31 May 2024 01:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717118196; cv=none; b=QyOlQA2B0tVhzEe6ivliY5f7NUleMhQmagVYs3CV5RsVXju7U8cbNhpVlbmEcOV5NA1j5BUQuQ3t/4FGiA2G1V2s717cZj53tMtZ3T8vPK6IgCbl96uCiCgoa657asi1X5Dbg1nTmTXjAtsE+jm+26YP8ALdOtrAjQRY7n8D5AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717118196; c=relaxed/simple;
	bh=ZXpDPuU8btt1ZFC3F39jk5VEbo6WXmRE18sLPg/xHSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ece60b0RGA6CblDNc+bLlUKVgL/mxDcN7N/2C9PsFr+VxQhxGcuNmck7BOifBXyPXu6QmbGRfi1RaNkuRIaqghaaUDmamz7SrBgzLCDTBc6r/TwOf3XcoXUELldPNf9uzBcvn56C9/YOCrg0omuqIz8RP+wiTrl93nAzxEyysJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44UFTfkq005999;
	Fri, 31 May 2024 01:16:27 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DgOqugPLXSKN/Hqjf5gEqkV//LtZrIZw7lNbXHa7PE5s=3D;_b?=
 =?UTF-8?Q?=3DQiOY8mgtdgIeMfw7K2xmMEuisY53s8uYXMK6QkOKUPtSuGZADDSQLvp2RFF/?=
 =?UTF-8?Q?EjJhTR9v_bnlZjXTS5BRIgfHxGqgYSlQM0x6bPQ7UfwmTjoy1YLWcRMnvoGhrwG?=
 =?UTF-8?Q?e5AC7oojQ/ljRF_N6Fkje5SV1jvHEz8SL/Qv/A3kmH4RjekQmstpeM7ztfogj48?=
 =?UTF-8?Q?dcD3OdueuRfD6twCt095_LahYHVHkRXbXiso1LeoAz8Pqw3XYR4kO3op6rL3Rmu?=
 =?UTF-8?Q?qTULIFe/2sQfGigMkk5eAcKYmN_nbJ7HvrSihGUphSu+HeCPfAqwO9mM0bVXn3r?=
 =?UTF-8?Q?s+CKC3MLpRVHwBba/1EKdY2Op9U7IIta_NQ=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hga6mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:16:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44UMdgOw010772;
	Fri, 31 May 2024 01:16:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc511ba2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:16:25 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44V1GO0b005442;
	Fri, 31 May 2024 01:16:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3yc511ba28-1;
	Fri, 31 May 2024 01:16:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, quic_nguyenb@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Lee <cw9316.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs:mcq:Fixing Error Output and cleanup for ufshcd_mcq_abort
Date: Thu, 30 May 2024 21:15:49 -0400
Message-ID: <171711788756.3706380.7009680386444419702.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240524015904.1116005-1-cw9316.lee@samsung.com>
References: <CGME20240524015907epcas1p2598a2ba8a81529b6639cff007fe9106b@epcas1p2.samsung.com> <20240524015904.1116005-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=631 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310008
X-Proofpoint-GUID: Om4A4TWW4AZZFO8QNYAd4Opo9oZeIwf7
X-Proofpoint-ORIG-GUID: Om4A4TWW4AZZFO8QNYAd4Opo9oZeIwf7

On Fri, 24 May 2024 10:59:04 +0900, Chanwoo Lee wrote:

> An error unrelated to ufshcd_try_to_abort_task is being output and
> can cause confusion. So, I modified it to output the result of abort
> fail.
>   * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
> 
> And for readability,I modified it to return immediately instead of 'goto'.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] ufs:mcq:Fixing Error Output and cleanup for ufshcd_mcq_abort
      https://git.kernel.org/mkp/scsi/c/d53b681ce9ca

-- 
Martin K. Petersen	Oracle Linux Engineering
