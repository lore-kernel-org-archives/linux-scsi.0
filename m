Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9367433A0;
	Tue, 23 Jul 2024 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721697862; cv=none; b=JEzj0OVaF7Uqhy0iD9rbxPAc9o7rg0ZaF1vKb2sYMf1yQrcPMIwxbdAE0h47LqThcCJ0ePQGcYA5HI5cWS/g6Bwtjn1sO+zP5rpdyZkpUGZdEbExFg9kXACtQcd6WPRLQ7bjB1jpOxyIN/KDnD5U2AkIjRj0XXAXSJTiexwN+6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721697862; c=relaxed/simple;
	bh=SFW+0OXE9t3+5aLgsQ5MJaDTqKs+8l5jK8dGDsbeEKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BH1XMcd917TfVIh3G4bnDiQyn5/5C51ULKV3LYhbKDiNta/LsARZ4h93HeG/mAKJxGorBf1VinJPassGI8HTKLs0JKEmmclPTqPSXPsGePsHAZ4KY6e00vswp3TqBDfiarbCMLIWSeJ/mb/exP2DmtSeuSGk4upzdYyncgjvvPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fV/J4p9b; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fV/J4p9b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtVic023808;
	Tue, 23 Jul 2024 01:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=KNAjVtIqDfrC56Q8qhfNYmn0NMygk+muEkuMqdsJ15w=; b=
	fV/J4p9bzSozIafa9O9NcfhWAxAdUDqiXwNd2WYX1/E1NSEZ54CjAl7asGR7eKQg
	ERHUIBptpLkuNZMCUNld525YzFeo54N1fYHHIOhLaWZ/XbRN24iNoN5N6D/kigBe
	zWASGoj6dVdni+eudb65IW9rsz4fbKmElc8/hWAQzh5IXRyP/Y5c3wYqx+vt3JaY
	77wPvu4WjFKG1OofeJ8VUz9/qHHIjllsfdnASqINDTsRV+wDnBVA99pzMIL+DyuB
	IA7c4OL6godPX3fClnC74vPGvyDRoFl4WraDVPIsI0jo/kRjTS+sT5DO4vhYtSeq
	tyZIB8U24j057kMNPgWdNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfxpcg2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46N0nRcP018975;
	Tue, 23 Jul 2024 01:24:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h27xysrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 01:24:11 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46N1O685005270;
	Tue, 23 Jul 2024 01:24:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40h27xysph-3;
	Tue, 23 Jul 2024 01:24:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        chu.stanley@gmail.com, huobean@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
Date: Mon, 22 Jul 2024 21:23:22 -0400
Message-ID: <172168235254.1161648.725788349992465796.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
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
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407230008
X-Proofpoint-GUID: kglc_b6RXsbeUm-z8cUI3UkV97Fpgso1
X-Proofpoint-ORIG-GUID: kglc_b6RXsbeUm-z8cUI3UkV97Fpgso1

On Mon, 15 Jul 2024 14:38:31 +0800, peter.wang@mediatek.com wrote:

> There is a deadlock when runtime suspend waits for the flush of RTC work,
> and the RTC work calls ufshcd_rpm_get_sync to wait for runtime resume.
> 
> Here is deadlock backtrace
> kworker/0:1     D 4892.876354 10 10971 4859 0x4208060 0x8 10 0 120 670730152367
> ptr            f0ffff80c2e40000 0 1 0x00000001 0x000000ff 0x000000ff 0x000000ff
> <ffffffee5e71ddb0> __switch_to+0x1a8/0x2d4
> <ffffffee5e71e604> __schedule+0x684/0xa98
> <ffffffee5e71ea60> schedule+0x48/0xc8
> <ffffffee5e725f78> schedule_timeout+0x48/0x170
> <ffffffee5e71fb74> do_wait_for_common+0x108/0x1b0
> <ffffffee5e71efe0> wait_for_completion+0x44/0x60
> <ffffffee5d6de968> __flush_work+0x39c/0x424
> <ffffffee5d6decc0> __cancel_work_sync+0xd8/0x208
> <ffffffee5d6dee2c> cancel_delayed_work_sync+0x14/0x28
> <ffffffee5e2551b8> __ufshcd_wl_suspend+0x19c/0x480
> <ffffffee5e255fb8> ufshcd_wl_runtime_suspend+0x3c/0x1d4
> <ffffffee5dffd80c> scsi_runtime_suspend+0x78/0xc8
> <ffffffee5df93580> __rpm_callback+0x94/0x3e0
> <ffffffee5df90b0c> rpm_suspend+0x2d4/0x65c
> <ffffffee5df91448> __pm_runtime_suspend+0x80/0x114
> <ffffffee5dffd95c> scsi_runtime_idle+0x38/0x6c
> <ffffffee5df912f4> rpm_idle+0x264/0x338
> <ffffffee5df90f14> __pm_runtime_idle+0x80/0x110
> <ffffffee5e24ce44> ufshcd_rtc_work+0x128/0x1e4
> <ffffffee5d6e3a40> process_one_work+0x26c/0x650
> <ffffffee5d6e65c8> worker_thread+0x260/0x3d8
> <ffffffee5d6edec8> kthread+0x110/0x134
> <ffffffee5d616b18> ret_from_fork+0x10/0x20
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/1] ufs: core: fix deadlock when rtc update
      https://git.kernel.org/mkp/scsi/c/3911af778f20

-- 
Martin K. Petersen	Oracle Linux Engineering
