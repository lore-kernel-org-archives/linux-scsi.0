From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCSI] ufs: fix a wrong string in power mode change
Date: Fri, 09 Sep 2016 07:22:59 -0400
Message-ID: <yq14m5pgvvw.fsf@sermon.lab.mkp.net>
References: <003001d209a5$9afb9b00$d0f2d100$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39739 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754074AbcIILXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 07:23:08 -0400
In-Reply-To: <003001d209a5$9afb9b00$d0f2d100$@samsung.com> (Kiwoong Kim's
        message of "Thu, 08 Sep 2016 16:50:02 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, =?utf-8?B?7LaU?= =?utf-8?B?7ZeM6rSR?= <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Kiwoong> From: Kiwoong Kim <kwmad.kim@samsung.com> I modified a string
Kiwoong> as described in UFS spec as follow: umpcrs -> upmcrs

Applied to 4.9/scsi-queue by hand. Please make sure patches are against
the current scsi-queue tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
