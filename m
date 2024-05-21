Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B8E12E71;
	Tue, 21 May 2024 02:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716259267; cv=none; b=P5hXFyts6VFTgWbjZPgChl6/eY/9y9f7rkc3gcSL+bD6jN2UNLgTuibQHRFqHrr+54oreAxuKaRHml3+nlaWT+NztffLTIH+6ZHOnpOzE0sQaQop6D9fulmsguO9qEclpJo5NoWMzhPT8Qg+VrBpHjMiLSt8+GhXhU0p+N1eutU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716259267; c=relaxed/simple;
	bh=IOasFjIiDzWB1gXgz0Z5A2JuGeYdYgB6kaV7r4ZKVfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBL9fQ8qZI9+LZ+9spBYbbSAEqMJEAYh8fbPgZJmzhPrwZJQID3RHE0Azk2HR+UaYHbG7Ed2YiiJgXhYwchBbZ3cvcXISXSNgw0QOe1vzQCNc84yIBixUtsUYzsGlmn37aG2DkxqPrOvZNnW62ox4JDt/ECDjnsiAcFHAPnRV5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DCeeH3lQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCeeH3lQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KMxVOK001853;
	Tue, 21 May 2024 02:41:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=Q1ANszq/KhRVZ0uqtnDVZiqdhsEBMdrbt1oqDmfmMKE=;
 b=DCeeH3lQDgN4QkAoVA7aQquo+Ke/pXvxkJJLaCFk1kfqkQkrTpeeAvtPRtAri3rmLhQx
 0TlvVWLHACdmJuzpakpWFlE52yoYyYJW3OoC3UpEP3q1BsHgBua1a+HW1m4qxY1cUEK8
 csF6U8XcY20UXFI+q+tMjwB5BlFQqwqn36Ng1p++ijLMK+yiJ0LYCz6taCnNSSwBtao6
 OOLPAFQYPEJr8iJ5AP+xBmRruVn4T5+eR8tH2Tg7k83KzT5az2HpU6xFSDWbl8qVp9wz
 IhqucqzqKD/AVtoX8D+Ybkavrhyo7/SWumhhjez19fVYxUC+iheR/hxalAwHch6AnJQb Ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv40yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44L1TVC6002776;
	Tue, 21 May 2024 02:40:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js72bg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:40:59 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44L2exck013516;
	Tue, 21 May 2024 02:40:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6js72bfn-1;
	Tue, 21 May 2024 02:40:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sr: fix unintentional arithmetic wraparound
Date: Mon, 20 May 2024 22:40:14 -0400
Message-ID: <171625915912.2717551.9281506639932713567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com>
References: <20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com>
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
 definitions=2024-05-21_01,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210020
X-Proofpoint-ORIG-GUID: mM9dtlgOZ54M8MsG3vFYc6BkwmSNCfdS
X-Proofpoint-GUID: mM9dtlgOZ54M8MsG3vFYc6BkwmSNCfdS

On Wed, 08 May 2024 17:22:51 +0000, Justin Stitt wrote:

> Running syzkaller with the newly reintroduced signed integer overflow
> sanitizer produces this report:
> 
> [   65.194362] ------------[ cut here ]------------
> [   65.197752] UBSAN: signed-integer-overflow in ../drivers/scsi/sr_ioctl.c:436:9
> [   65.203607] -2147483648 * 177 cannot be represented in type 'int'
> [   65.207911] CPU: 2 PID: 10416 Comm: syz-executor.1 Not tainted 6.8.0-rc2-00035-gb3ef86b5a957 #1
> [   65.213585] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   65.219923] Call Trace:
> [   65.221556]  <TASK>
> [   65.223029]  dump_stack_lvl+0x93/0xd0
> [   65.225573]  handle_overflow+0x171/0x1b0
> [   65.228219]  sr_select_speed+0xeb/0xf0
> [   65.230786]  ? __pm_runtime_resume+0xe6/0x130
> [   65.233606]  sr_block_ioctl+0x15d/0x1d0
> ...
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: sr: fix unintentional arithmetic wraparound
      https://git.kernel.org/mkp/scsi/c/9fad9d560af5

-- 
Martin K. Petersen	Oracle Linux Engineering
