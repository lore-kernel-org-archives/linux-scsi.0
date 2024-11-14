Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DB81E9078;
	Thu, 14 Nov 2024 02:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552680; cv=none; b=VkPPb7cQ9xvEBTXB+LXu/EnUqBgjv9HNIlSyORJqiveiy5DrXOaIPQanpA/95A5wA41JPMerxPARxkwexmSAEu0rrQ/vUN9BCp7nKI0POWyeiQUXOieFOtBmdyQGsCCuHgPDYlT247Y1XtuzV5Khn0lh3OVg+GmiEDG6PLnlzPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552680; c=relaxed/simple;
	bh=ykOy0Gl0f2PCP9FnizdmSyx6sDfupSjE3/Rdd6hQJsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzBBJln+yLRFJ61p4V12GgI3Xs1FJHFmp36Ww/5W/YBp8rnT5htEnQbuhtQ6K3geK+qnXOZUMtdZ4ybw1KMWBjhR596bDS8NpOqxCQ4IEux+yaJWyQKXvjFq+1mEabh+c4Y4baEb+kCBvVVFHftvIErPtwNKuBbBBOGVhIjGLL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A48CLyrr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A48CLyrr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1glgc008722;
	Thu, 14 Nov 2024 02:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gYJVnBPMXhheHdB/DJlVC/G5ubvTltb2akrj529V2ak=; b=
	A48CLyrrRUW0wIw3MEOMVjBMF4fsBzeh8y3J/lnwbPeiycWBoj1jQngzXlnLaHU8
	0g9oI0RH030CgjfWg8rzw0garMOdU6MKgMPK21e+9ld4/03gtTKUXbje1oFjsZ/i
	aNlpk6W28X44vl3uJBRn+Z6mbE3EUlTeXj0VrthRbH95AdH1/yJLE6I4CIaeOeTr
	mNUgxj5Zd+e2wTQfF6C8UJOi+0VHmKoLWQXaCTQCaM7WP0lz3Ukb6TfJXcb9/bVG
	766KB+a9NTLSLVSwO3+BBNCXxpVLArOQCJPAIxLUuAqY13GnSPPSfMViqnqcfZgO
	YBTjvKLOFNf3w1+I0cWd6g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwr8gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1LVoc023918;
	Thu, 14 Nov 2024 02:50:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p1xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:49 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYm003527;
	Thu, 14 Nov 2024 02:50:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-3;
	Thu, 14 Nov 2024 02:50:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: peter.wang@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        ed.tsai@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, chun-hung.wu@mediatek.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue flags
Date: Wed, 13 Nov 2024 21:49:56 -0500
Message-ID: <173155154783.970810.4459751536411041309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008065950.23431-1-ed.tsai@mediatek.com>
References: <20241008065950.23431-1-ed.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=921 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: Zi8IdhYC6FopUOKlx7zd_MFUMADU3u7I
X-Proofpoint-ORIG-GUID: Zi8IdhYC6FopUOKlx7zd_MFUMADU3u7I

On Tue, 08 Oct 2024 14:59:42 +0800, ed.tsai@mediatek.com wrote:

> Previously, ufs vops config_scsi_dev was removed because there were no
> users. ufs-mediatek needs it to configure the queue flags for each LU
> individually. Therefore, bring it back and customize the queue flag as
> we required.
> 
> 

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-mediatek: configure individual LU queue flags
      https://git.kernel.org/mkp/scsi/c/7670e74ff319

-- 
Martin K. Petersen	Oracle Linux Engineering
