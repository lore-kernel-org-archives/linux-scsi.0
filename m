Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E2D38F626;
	Wed, 29 Jul 2026 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293735; cv=none; b=fBvxA/8nyK2IpGjvYKYdfN9PkkYCEbCTft51+AmvEnN+UZZh42gn+skrLVRWEopPuXlxGCS35/Y52xFQmVQITV0rPTLIXFtxY+0nwBJjdRPWvtS/bPxJ2qYBe0rvllE/f8/c3gHwTtuAJXUNOWBgAcPk7lXXiWWpYOTyHN+bJt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293735; c=relaxed/simple;
	bh=ce3A56o/dyr3pPiXWThlpy84i0MUX/GluyinmrnKWkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9SlSjR7EucyFbS0QaKyJ/w86fJgTz50scmZthBqQ4ZJ0Ae9ZROqLvo1rkz1BT5yKZl1PE7TWaXNbFEDHqU9PaXCEaiTt0BcEaZLh1QarW3/ZHuNgtQ3g0EGV6lJ3KHENXUnT2NG0uUOfq4Ho/CV947woqkI63WxtTKGj5umiaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lf7kTEK0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lf7kTEK0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItqfk2091613;
	Wed, 29 Jul 2026 02:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z0l4Bp+5+Y4yFZ5XasMMueRCytlXMKNfVRo7vlTlFys=; b=
	Lf7kTEK0akjzIKseRwobzotSPLwF38iG8WLyF5wkg4H8qdbrBBSZUaFbVEbZrqO6
	fk6tHcggIOyKHSu+fl9wMpoTdzwDDGD3FIc915P8GTLyJaV4PttBjBwurG74ogvE
	Gi/tD6mER42AW5Q86RwWo1SoNkRzuceoIivnPE7Kl10/UagX4yJWXBX50LwKiE9q
	MW1Q7P3uilD5/aGLeVkoXH3dHn0iOxq8umd1KOezupUQGdB6xlqRG+LQKp96rewt
	OVxzPOeGlQQRFOGB7CNJNiOnNs/IiXKCSgsxK+Tldxp+XOBAqT020B2HoPRtSXWb
	aTtNrH04sFjA80aCwybwUQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyd83q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o5NO001420;
	Wed, 29 Jul 2026 02:55:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:14 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jT012133;
	Wed, 29 Jul 2026 02:55:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-5;
	Wed, 29 Jul 2026 02:55:13 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Avri Altman <avri.altman@sandisk.com>, ed.tsai@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        peter.wang@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, chun-hung.wu@mediatek.com
Subject: Re: [PATCH v3 0/3] ufs: Add callback for vendor-specific RTT capability
Date: Tue, 28 Jul 2026 22:54:59 -0400
Message-ID: <178508193507.4027291.7150424989200322423.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260615055802.105479-1-ed.tsai@mediatek.com>
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
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
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=952
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX8CIH5Lx9gjXp
 AjTPolwFrdrU2iIJa22IXKEzYmF+Vidr8tapzLtEcEGEzPfSNwFLHSckgs4WJkX6Kcn2u4dXMtX
 u+2GCnu1eCl1Rr8hn+MT1rO8VA1uDten1y6/VMFTxJQ/GyAHS20r
X-Proofpoint-GUID: lrzFVhjw-w_ldy1upAbIsbKIMs9ldxqp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXzd7THBL1SPuC
 xqgzgPB4q3znGF9RhyprQbaujWRZGlL4Jg9rvcaLcYTwKLLFZYz1mttQcLOeKljB+ejMbCndSJC
 Pzt4x4yY/B67WP0xwMC6cZFrhyJlOtxpvCRWtO2eMjCE0lypycFEUc/qjxfjj2enrqUAPd35pvU
 fY5ZzTo8ROH3ooVXTrPht65ZGWO3ntCZlOFOTUO5A8hM1KPEwLfOcFwDduCB5LLHe3UgdxYrXJi
 EPRy8CMm1RlNpGSbfLCHgFYcOVKboaYANT8qWNAVHOPl1DEWIk+cVIuqABbleNv2XD2J6nNCEpS
 Npui57bA2EaOg9GsJXar2Of8NRLrRIvVkBtvfpM0Y19ocja5bk/WJESbpKbahYIepJq1HSFsGlV
 6WjefCyf4mHlRHD/zLIYBEiOWVNgPJ0Lvg6UORcXZFHAfTotaG3etE4D2R1sH1PudckOeIQfZyk
 D5W/qNQF+y5g93poGsA==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a696b93 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=mpaa-ttXAAAA:8 a=AHtIWjdTHCXrM6kK-bEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: lrzFVhjw-w_ldy1upAbIsbKIMs9ldxqp

On Mon, 15 Jun 2026 13:57:14 +0800, ed.tsai@mediatek.com wrote:

> The first patch adds the get_hba_nortt() callback to the UFS core layer,
> allowing vendor drivers to provide dynamic, platform-specific RTT
> capability handling.
> 
> The second patch implements this callback in the MediaTek UFS driver,
> distinguishing between legacy platforms (which require the RTT to be
> limited to 2) and newer MT6995 B0+ platforms (which can use the value
> from the capability register directly).
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/3] ufs: core: Add get_hba_nortt callback for vendor-specific RTT capability
      https://git.kernel.org/mkp/scsi/c/e7896d02cb4d
[2/3] ufs: mediatek: Implement get_hba_nortt callback for RTT capability
      https://git.kernel.org/mkp/scsi/c/75f529a7bcd4
[3/3] ufs: core: Remove max_num_rtt field from ufs_hba_variant_ops
      https://git.kernel.org/mkp/scsi/c/7ebadbae3dd7

-- 
Martin K. Petersen
