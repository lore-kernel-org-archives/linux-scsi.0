From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date: Mon, 21 Nov 2016 22:37:15 -0500
Message-ID: <yq1y40cyyl0.fsf@sermon.lab.mkp.net>
References: <000401d24236$cb8fc5b0$62af5110$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50081 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbcKVDhX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 22:37:23 -0500
In-Reply-To: <000401d24236$cb8fc5b0$62af5110$@samsung.com> (Kiwoong Kim's
        message of "Sat, 19 Nov 2016 16:30:25 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Hi Kiwoong,

Kiwoong> Some UFS host controllers may think granularities of PRDT
Kiwoong> length and offset as bytes, not double words.

This patch does not apply to 4.10/scsi-queue. Please rebase and
resubmit.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
