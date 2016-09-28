From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cxgb4i: set completion bit in work request
Date: Wed, 28 Sep 2016 01:25:53 -0400
Message-ID: <yq1bmz8y4ri.fsf@sermon.lab.mkp.net>
References: <1474641460-23106-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22495 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbcI1F0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2016 01:26:00 -0400
In-Reply-To: <1474641460-23106-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Fri, 23 Sep 2016 20:07:40 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, indranil@chelsio.com

>>>>> "Varun" == Varun Prakash <varun@chelsio.com> writes:

Varun> If SKCBF_TX_FLAG_COMPL flag is set and unacknowledged credits are
Varun> >= max credits / 2, set completion bit in work request to reclaim
Varun> credits.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
