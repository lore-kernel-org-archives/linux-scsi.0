From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH] scsi: ufs: fix race between clock gating and devfreq scaling work
Date: Fri, 14 Oct 2016 16:47:39 -0400
Message-ID: <yq137jyk68k.fsf@sermon.lab.mkp.net>
References: <1476227759-22389-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17650 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbcJNUrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:47:48 -0400
In-Reply-To: <1476227759-22389-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Tue, 11 Oct 2016 16:15:59 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash> UFS devfreq clock scaling work may require clocks to be ON if
Subhash> it need to execute some UFS commands hence it may request for
Subhash> clock hold before issuing the command. But if UFS clock gating
Subhash> work is already running in parallel, ungate work would end up
Subhash> waiting for the clock gating work to finish and as clock gating
Subhash> work would also wait for the clock scaling work to finish, we
Subhash> would enter in deadlock state. Here is the call trace during
Subhash> this deadlock state:

Somebody from the UFS camp, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
