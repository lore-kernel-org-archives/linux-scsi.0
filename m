Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8995305050;
	Thu, 20 Nov 2025 04:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612213; cv=none; b=UxhsKC4+3NN7Ep/fGGg1qfH/CdjagnPUfLAtSKVqSFembTVJOsvv9Df7VYivTAQ7gW41maJb/PyLXzZ8hByCszskpZqItQ0MArL92O2ZXmwZD3uqUDCKp/6rHblTHhHa7mnseiiBN/LvGL+H7iFntEtOxyoaipgChyIqirsKDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612213; c=relaxed/simple;
	bh=j3tgSX+G6DZkTZZwcxMG0rANI1Gmk8pM3I1/yu77QMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nlpYjntryv86N1/Cuje3H/br7KQv+M5wJnCDNvXor0ludzTTLe3278tTV8at2a5ayJm/I3ZK3GnNzUstyfHA2ljdZU0lXQbm1vsTXJ54m+KOSGLIbulaKfRvz0e2SVCdfeHYqJIbYPzOPzSL/16oMqOwQn48WtIssjjDP0SDfhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sToyDQh+; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sToyDQh+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1ORMI014130;
	Thu, 20 Nov 2025 04:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Qq7Wv2OZL0sLr0yg531xwJ6K3aGn2fld7xWprIuzkwc=; b=
	sToyDQh+ZG5Lq3nfBJydhLLYu83eFioq2eM18a96Kik/GCllOzgxP0wwe1i2ot55
	+J7akxVd0gUWn6Wn2UDh3Q4F/iMnYzoLaeA7cMWaHJA0tkBAENNH7rn6oqPrwVLE
	b81aa3V3s0n6QFnWP8z+gA8Qx83sDWhWViuptI/fYB2dovfqykQbmrp2SV6+EVQ5
	KGtdZivTfyPXvnXrhYFg2MxiHbDDDvRJSbFeJes7/JLlOGOPvp81a5kVG/uFzxbP
	WFW/UM3pHFd/6a2PwIOdWoglyZH/J/xYj8BmIbOX1Yww6WNu0Jesc9j5J+tMtb/Y
	VqzYnFavrIQ4E6cmg3h5LQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbq0c7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK3XcJc007832;
	Thu, 20 Nov 2025 04:16:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:38 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPv012546;
	Thu, 20 Nov 2025 04:16:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-16;
	Thu, 20 Nov 2025 04:16:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Tony Battersby <tonyb@cybernetics.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
        scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v3 00/16] qla2xxx target mode improvements
Date: Wed, 19 Nov 2025 23:16:05 -0500
Message-ID: <176357169017.3229299.5659513054334326173.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
References: <aaea0ab0-da8b-4153-9369-60db7507ff7a@cybernetics.com>
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
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=788 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX+L0RIsWcoMD4
 ePQBFXDV9l77p4UU+XOY77eHN8xBB6wXaNcitfCGXS6LGFxP3pvDQW0/UwanCjMHA0rrjfdAU0U
 4LzUx3H5BgvSLCuKDtKkHocMnkZqO2f5PBjWLsC4PXoCELPVrcS6+ytNqxW+v1JHJ6I9c8EqkME
 1fWieZnh8pnNENgtg/I1DXPdBVvEk5JlOelw/CbaZ/gQkM88GDS/9buoPFz/u/kJsjKjENGXjkQ
 w4FBNOfHUfiBkdTvEkRd5LPpo+xil0veG4NVdAT1UJiPkqxk9xXuHk2npnBjXnmxO2uXiPtIDF+
 gsInI5hQ0Pn/EgAyQjR1Y1ySf4RMZkmGjPfVZbMibqhRv7LgZp04wpYBTpwaBzKlcG8BAIkoTND
 FXiws8WUtcnh3zD0xh0U8nX8nCZBuQ==
X-Proofpoint-ORIG-GUID: SzpoOWxEQhSARBUuo_JqndWhpYZvuER1
X-Proofpoint-GUID: SzpoOWxEQhSARBUuo_JqndWhpYZvuER1
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691e9627 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=svO6gwnVAAAA:8 a=z38bvKbKXSZPXFN0TnIA:9 a=QEXdDO2ut3YA:10
 a=5awQwY9Y38-QVGG67zo_:22

On Mon, 10 Nov 2025 10:46:45 -0500, Tony Battersby wrote:

> v2 -> v3
> - Omit SCST patches as requested to work better with b4 and patchwork.
> They can still be found at the v2 link below.
> - Fix "scsi: qla2xxx: fix TMR failure handling" to check for mcmd == NULL.
> 
> v2:
> https://lore.kernel.org/linux-scsi/e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com/
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[01/16] Revert "scsi: qla2xxx: Perform lockless command completion in abort path"
        https://git.kernel.org/mkp/scsi/c/b57fbc88715b
[02/16] scsi: qla2xxx: fix initiator mode with qlini_mode=exclusive
        https://git.kernel.org/mkp/scsi/c/8f58fc64d559
[03/16] scsi: qla2xxx: fix lost interrupts with qlini_mode=disabled
        https://git.kernel.org/mkp/scsi/c/4f6aaade2a22
[04/16] scsi: qla2xxx: use reinit_completion on mbx_intr_comp
        https://git.kernel.org/mkp/scsi/c/957aa5974989
[05/16] scsi: qla2xxx: remove code for unsupported hardware
        https://git.kernel.org/mkp/scsi/c/9da4e1dcea46
[06/16] scsi: qla2xxx: improve debug output for term exchange
        https://git.kernel.org/mkp/scsi/c/c34e373f535e
[07/16] scsi: qla2xxx: fix term exchange when cmd_sent_to_fw == 1
        https://git.kernel.org/mkp/scsi/c/ed382b95f5de
[08/16] scsi: qla2xxx: clear cmds after chip reset
        https://git.kernel.org/mkp/scsi/c/d46c69a087aa
[09/16] scsi: qla2xxx: fix races with aborting commands
        https://git.kernel.org/mkp/scsi/c/17488f139074
[10/16] scsi: qla2xxx: improve checks in qlt_xmit_response / qlt_rdy_to_xfer
        https://git.kernel.org/mkp/scsi/c/5c50d84798eb
[11/16] scsi: qla2xxx: fix TMR failure handling
        https://git.kernel.org/mkp/scsi/c/3d56983cc6f0
[12/16] scsi: qla2xxx: fix invalid memory access with big CDBs
        https://git.kernel.org/mkp/scsi/c/091719c21d5a
[13/16] scsi: qla2xxx: add cmd->rsp_sent
        https://git.kernel.org/mkp/scsi/c/f4199d581256
[14/16] scsi: qla2xxx: improve cmd logging
        https://git.kernel.org/mkp/scsi/c/04957d8c9852
[15/16] scsi: qla2xxx: add back SRR support
        https://git.kernel.org/mkp/scsi/c/c7bd85a7b9c5
[16/16] scsi: qla2xxx: improve safety of cmd lookup by handle
        https://git.kernel.org/mkp/scsi/c/4f5eb50f7c82

-- 
Martin K. Petersen
