Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7A2F1FCF;
	Tue,  9 Dec 2025 03:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250501; cv=none; b=OqOKSk9aCcMn8mpKWte0vi03WgTSdCNNfWtJIbrlzF3+nSz1M3AbtlD7uCnAJD7IAKth2RTi7fvNZmFiA3Kk3Hbew5ZuslkvhNmd9xMf0NQ7eEnYy8l9ovERt0+xMbmu6+fVxgKOcCLcJApibmlilKaWNhy9mgPGQ1zYAzQPdk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250501; c=relaxed/simple;
	bh=eKFhJiqZFxo8PTR6+JuK53u7kbiTh2gp2gD9aHPN8rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vpm1Fs3vrFvn1wTKoV0LQXwL99YhElMv3ZL8IYNTOb/gbGxTb11v/mujudrPvNwtVR3jy3cJomyPtTPnRnXPg9qgVjWcWjc3anf65EINQT+7UJet9Ni+w65ayarCnOUf8/XKyex0fpWOe4OGhvY5xY1BeAA6Uoa3T7XLD4+C+Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P6VEsJ/n; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P6VEsJ/n"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91gBAF3845410;
	Tue, 9 Dec 2025 03:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+a7Vr7dwegJAu+1nCYofM+Nha4IOoeAG6WJHVb+01G0=; b=
	P6VEsJ/njyRaug1cOvgnc/+24Ul59AvA9esPkhGDwMAa265g/2AnrTedTfxFAowR
	27ERD9C4TGHi1ZOe4uXUaoLDxR8o9PCskIdAyffLMy2F25IT/84dQFvpc6Meab8E
	XQhhkgxJ1iKtlBFRnHDMEDRrhqVfZit5rYIPnRqQA3z2upXs2c3w4ldUyBDtnItO
	ngVlaOKok6Bb6TGMyEOGyJC+uejpCrR/+XGveopeqH9bZy9pssHHQL5hcls/k4qN
	KN47CIM/t3ikogpnQpo499hFppRVE6xfwsidRDIWvv+/CvLmxDz8JClVILA9e55r
	lM01G0O5SZwqgJfXgX1XMw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ax9c684n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B92AthO038112;
	Tue, 9 Dec 2025 03:21:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j024-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:21 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4Fa022652;
	Tue, 9 Dec 2025 03:21:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-7;
	Tue, 09 Dec 2025 03:21:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Po-Wen Kao <powenkao@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume error
Date: Mon,  8 Dec 2025 22:21:06 -0500
Message-ID: <176524933116.418581.12440014725918073406.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251112063214.1195761-1-powenkao@google.com>
References: <20251112063214.1195761-1-powenkao@google.com>
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
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=916 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Authority-Analysis: v=2.4 cv=aKD9aL9m c=1 sm=1 tr=0 ts=693795b2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=ZX29RaMUgQc0Or7nvOEA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: gfFULa4lMWKyKtVtXc1_r-RHWiBXdCce
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX6hE2uoaresPw
 IIRS18gf33ydrIeJ1YhO2B/9+LgLeFdiNySzN0wnj5kHvUgFcbNOOrhP3DBxamzN0LRPqsNM0MC
 HCZ+WMqmd/zxpkwbbmHJfxQVBySUMHrxKfp8a+HtLUWqll9psRR5Wuc/vHKxCJASsEjI+qWu3fq
 xZl9ccyTiNAd9sVTYKC0b11H3irK+lSre7C7eA3LbRM5XK4bqu3X18/qkBXAZk0KQSuhzut5vSh
 lF+MgOIq78OcsLnSwylKqIdCxUWMhK0c0GxsUKR3qYFdMMROM64RDyE5H77MBQWYyh0bX5pe09I
 FVmAWO17KE3ulmqZMUMWo+XuYpvAvVPaltf70CavngCGWE27iis8tMtWsgFXvdI+nectbpJNYc6
 2a7/GG9u1QldgMC+f9IaEWlmodv8EQ==
X-Proofpoint-GUID: gfFULa4lMWKyKtVtXc1_r-RHWiBXdCce

On Wed, 12 Nov 2025 06:32:02 +0000, Po-Wen Kao wrote:

> When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
> including the scsi_target, may be runtime suspended. Subsequently, the
> error handler in ufshcd_recover_pm_error() fails to set the W-LUN
> device back to active because the parent target is not active.
> This results in the following errors:
> 
>   google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; ...
>   ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1, result 40000
>   ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
>   ...
>   ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child device 0:0:0:49488 but parent (target0:0:0) is not active
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix EH failure after wlun resume error
      https://git.kernel.org/mkp/scsi/c/b4bb6daf4ac4

-- 
Martin K. Petersen
