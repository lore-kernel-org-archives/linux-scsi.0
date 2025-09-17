Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F272F49E9;
	Wed, 17 Sep 2025 02:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758076042; cv=none; b=b1U0UuBYZW4fqjok55ex+bA6LUjCKd5rAu7DneLPeSbrD+OanPp/eDW1XQmxi3G7EQIzcj5EmqpNlXzctxkoOlOYFI8guj1nhmjdiWhR0C+pIM5FtNo+IBrx0D7ibPBB/2ZBUUwGZEgPD+b9mugdb9Tj9EkHzJtk7hZ41luvOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758076042; c=relaxed/simple;
	bh=0W5cJSxFiyMMIfdxqx/RpU55sjKEaIg0wx2Lmmn5ebk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OC3P+JPAxrtrAU7oyEHnfTAEunprwQctmv90rY1T1cBF6qlyUIGoCrG0OIH5w1BYOSJmjB/sbn+Ac0omjl0V2b+4HLQHgUCF1r0MWpivUJoHCCHhB6tOoXwGkLualbibqo+c9BlTMf4APK4nTzGYI5XxmH8Zz1gKR872HGJYdFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ngpW6i1M; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngpW6i1M"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLZ202020627;
	Wed, 17 Sep 2025 02:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9uZ+Lh6WqA7JOQU69c1j04bTjdvpdyj+hjesn+/VZao=; b=
	ngpW6i1MsOagusTMpitpozJX7B+rhyeFgMLOsvDbSNWn6O9RfAJeJsX3rSEORmAC
	ykTEkBaCs5Z+fb5AxJbD3m3uGGwok/9zW7+PWIbXCjou9OhpXiNmnlUef2BS1TKF
	DCP50/2pzxlw06wHZjWsHxW8fM+cTJpTASgSGFP4KzCBLluON5vHcdldITpZyNNX
	xJQ3rEkjvdkgjnY73bMM3BqGTAi3uDoMKyRF2OkV821raie2usgM+EK1GMFaSUzw
	ketroCRTMBTXcpBbQSNpuMmCwJod+p0hl0ugYlvMNuZfChy6//8pkQmA+blYdU1v
	kSw37tHWynwdTg7ulIQECg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbr9ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0bvHH028898;
	Wed, 17 Sep 2025 02:27:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2d52g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58H2RHY7037520;
	Wed, 17 Sep 2025 02:27:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 494y2d52f0-3;
	Wed, 17 Sep 2025 02:27:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use int type to store negative value
Date: Tue, 16 Sep 2025 22:27:11 -0400
Message-ID: <175798566830.3116853.5922880559006107436.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250902125017.41371-1-rongqianfeng@vivo.com>
References: <20250902125017.41371-1-rongqianfeng@vivo.com>
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
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=890 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX45A+DfAiSjxz
 Bk8yz3lkHwYFZ74suRpRwnknGaP8N91qJCmwHwvwU6kH0c0Vgs4p2THjGS6qxndhzTjuFYeVFtW
 xUFT7yBb102XgNezfgjG8oY1wFYcIreusp0bBSLhUoyTVUTzSo+XDVgKxSjzI64+mik0Do5+LLf
 xqBfJucdFVh+3rO3m2bzqtTVNFZxFSLN3nGs7nfbKBX0e2yU7dBwjjXa46y/HfJFKKWoxyr6tAR
 LjgamISGmRPAPX4968JqPLnsWt4BjNckdZm4e4gQ6XGirwmfMtggRQ+xN79z/wik1BHuv/e18Fa
 K1BCfR3DdsXs/uuM1ve7IFDrMv12mLvDnXWTAy3O045e0PJhovDGec+5hdN8EGQX9BGVQz10bCs
 NdOjvLGU
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68ca1c88 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=BUmgLafrPBtdokYnvPQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wY5Jkv0ybKQNZE9GxAGFBNgmT_QO9mSN
X-Proofpoint-ORIG-GUID: wY5Jkv0ybKQNZE9GxAGFBNgmT_QO9mSN

On Tue, 02 Sep 2025 20:50:14 +0800, Qianfeng Rong wrote:

> Change the 'ret' variable in iscsit_tmr_task_reassign() from u64 to int,
> as it needs to store either negative value or zero returned by
> iscsit_find_cmd_for_recovery().
> 
> Storing the negative error codes in unsigned type, or performing equality
> comparisons (e.g., ret == -2), doesn't cause an issue at runtime [1] but
> can be confusing.  Additionally, assigning negative error codes to unsigned
> type may trigger a GCC warning when the -Wsign-conversion flag is enabled.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: target: iscsi: Use int type to store negative value
      https://git.kernel.org/mkp/scsi/c/b0aca7ae8285

-- 
Martin K. Petersen
