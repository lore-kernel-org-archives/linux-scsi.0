Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5440DFBA;
	Wed, 11 Mar 2026 02:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194982; cv=none; b=jjErMlLmNJsIDFnITx/KiPgTzuwFCWI+ZfwHVr/FnpKwVIRv672OS6OhNP1zh8yRY3FP8jjkAYR3yI6esTV0RbIZE88jqzlSI6SOoF94i/uZ7RmizEjkbJj/YGR94eLHfX9FxwuwJOslZVvrEqO9T8OI0x7UfmvLnLXnYMtY81Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194982; c=relaxed/simple;
	bh=M+rzvdYAth+rzfIzj3py096KzLV+9KlVXaau/rP3Qy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enZbhFNziQO/DAYSNe+QP4l6ITjcrqEW0MnEIWF7Ls+0fGEGMOiCbjOcTP+HnmlyFs1Dnoz4csXfvRaRk5KxFqIm9OByWKU7cdZyv4+3KY536J2Cba/RANPklIjtWrRYhBjtnyDGj/Ah7jT8yUGepYOWnExBOQr9G9tENggIJOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q/9oUWHR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q/9oUWHR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AInhUs094181;
	Wed, 11 Mar 2026 02:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tEGa6fJogAtQPh1AtvT3Glz64lf+F9JBvoaOV78JwxQ=; b=
	q/9oUWHRIjaAiJmrw8cbyETgD3FLBzNE8nZIWeLBHFiXNEjrdrSgDfry5J5hEw9+
	0+QSaprupUVoSvyjXQAaRo5OitRJEY13bmc2vhrR4VLfcNX9R446THFo7nZVuufZ
	g659zEuanC7dROnIS3IR9LQkNd3i3ks0lIDxqpHv/7Me0lwRKvQFdZyIqYi7F3HR
	5GKfAOE3AScpSHIjEyOhxIbC6YF0O5O4fwAIYFJLlBIf9DGg1GwB+PTKRpjof0l8
	tffZLhgksC2qe/+8Be8hfaZT3nwNN44rULYiKD9Rp8xuvi+z+W4K3Lwvw9RLCG3F
	NOE5sf44C9G9Kw8t9dIYHw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkm4cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B1o3IK012855;
	Wed, 11 Mar 2026 02:09:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffewtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B29c9e018454;
	Wed, 11 Mar 2026 02:09:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4craffewtr-1;
	Wed, 11 Mar 2026 02:09:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, Vladimir Riabchun <ferr.lambarginio@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@hansenpartnership.com, skashyap@marvell.com,
        qutran@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Completely fix fcport double free
Date: Tue, 10 Mar 2026 22:09:32 -0400
Message-ID: <177319446957.2524613.7736751001661301891.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aYsDln9NFQQsPDgg@vova-pc>
References: <aYsDln9NFQQsPDgg@vova-pc>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=491 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b0cee3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=QFY6jo-fL-RZk2Mo2p0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13819
X-Proofpoint-ORIG-GUID: ePJ123Y--KZVu2fRxUAhryij_T50T4j5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfXxA7eMRUSefkw
 K3i6yRUSPTdCFTOozUzCij7ILd1P2ATHR9Fo56+9MQ+su/a/f0weURaDQy/HxSPRcBqp4u3xmil
 buSjranh8fjY+SkJJyCU8AFWSqWxgJIpmNVbCUL/ANKm5Z/0djNYtQQpru3AKH2dF7rLeCBT3+M
 FQ9z0kg65XeM/Ks6suZ56UZKpuehmN3xShiIDYC9uDF/4v5L6NXMkFzuW7omAlmszKVDKx7OqU+
 2o8skJKu6zXhPC0Sj9eAa4whpwpTJ4RSl7j81xBKQFH0Cs1Mhg952wbmRenzOtUbs4sM6WIomnl
 T9buqnlmz9KPZPUGB3cs2q9h89v+x8PdP+leniLkkocBjC2+0DO6THyxViNbyLMy2RYQ/OKoffE
 cW14uF3R7X7bNqafPUjW9x7zoQsucpZ3919UXhgdZ/OvcN//1ZOvW6RK5b/ZOYVHs1krx6qJ6IY
 YGhMvVsKwWkO+/P4Cm3nEnRvQmbvm4F2KIPmj34I=
X-Proofpoint-GUID: ePJ123Y--KZVu2fRxUAhryij_T50T4j5

On Tue, 10 Feb 2026 11:08:22 +0100, Vladimir Riabchun wrote:

> In qla24xx_els_dcmd_iocb sp->free is set to qla2x00_els_dcmd_sp_free.
> When an error happens, this function is called by qla2x00_sp_release,
> when kref_put releases the first and the last reference.
> 
> qla2x00_els_dcmd_sp_free frees fcport by calling qla2x00_free_fcport.
> Doing it one more time after kref_put is a bad idea.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Completely fix fcport double free
      https://git.kernel.org/mkp/scsi/c/c0b7da13a04b

-- 
Martin K. Petersen
