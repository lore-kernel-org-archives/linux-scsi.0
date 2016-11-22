From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4] ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date: Tue, 22 Nov 2016 16:45:06 -0500
Message-ID: <yq1zikrw5nh.fsf@sermon.lab.mkp.net>
References: <01b501d24497$66a81e50$33f85af0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:19029 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932559AbcKVWmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 17:42:06 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uAMLkF5p025812
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 21:46:15 GMT
In-Reply-To: <01b501d24497$66a81e50$33f85af0$@samsung.com> (Kiwoong Kim's
        message of "Tue, 22 Nov 2016 17:06:59 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Hi Kiwoong,

Kiwoong> Some UFS host controllers may think granularities of PRDT
Kiwoong> length and offset as bytes, not double words.

Your patch still didn't apply cleanly to 4.10/scsi-queue. I did it by
hand. Please verify.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
