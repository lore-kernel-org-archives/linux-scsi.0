From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs: introduce setup_xfer_req callback
Date: Sat, 12 Nov 2016 10:38:59 -0500
Message-ID: <yq1eg2gk8rw.fsf@sermon.lab.mkp.net>
References: <002201d23b4c$012486d0$036d9470$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23503 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbcKLPjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 10:39:09 -0500
In-Reply-To: <002201d23b4c$012486d0$036d9470$@samsung.com> (Kiwoong Kim's
        message of "Thu, 10 Nov 2016 21:14:36 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Kiwoong> Some UFS host controller may need to configure some things
Kiwoong> before any transfer request is issued.

Applied your 3 v2 patches to 4.10/scsi-queue.

Kiwoong> V2: change data type of 2nd argument

Please make sure to put change entries like this below a --- separator
so they don't become part of the git commit description.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
