From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCSI] scsi: ufs: get a TM service response from the correct offset
Date: Wed, 21 Sep 2016 16:34:17 -0400
Message-ID: <yq137kt6lh2.fsf@sermon.lab.mkp.net>
References: <000401d20a27$da459040$8ed0b0c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29843 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753311AbcIUUej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2016 16:34:39 -0400
In-Reply-To: <000401d20a27$da459040$8ed0b0c0$@samsung.com> (Kiwoong Kim's
        message of "Fri, 09 Sep 2016 08:22:22 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, =?utf-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

>>>>> "Kiwoong" == Kiwoong Kim <kwmad.kim@samsung.com> writes:

Kiwoong,

Kiwoong> When any UFS host controller receives a TM(Task Management)
Kiwoong> response from a UFS device, UFS driver has been recognize like
Kiwoong> receiving a message of "Task Management Function Complete"(00h)
Kiwoong> in all cases, so far.  That means there is no pending task for
Kiwoong> a tag of the TM request sent before in the UFS device.  That's
Kiwoong> because the byte offset 6 in TM response which has been used to
Kiwoong> get a TM service response so far represents just whether or not
Kiwoong> a TM transmission passes.

Kiwoong> Regarding UFS spec, the correct byte offset to get TM service
Kiwoong> response is 15, not 6.

Kiwoong> I tested that UFS driver responds properly for the TM response
Kiwoong> From a UFS device with an reference board with exynos8890, as
Kiwoong> follow: No pending task -> Task Management Function Complete
Kiwoong> (00h) Pending task -> Task Management Function Succeeded (08h)

Went through the hoops to verify this in the spec since nobody stepped
up to review. In the future please make sure to submit patches against
my scsi for-next git repo. I had to apply the patch by hand.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
