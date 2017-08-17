From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: cxgb4i: call neigh_event_send() to update MAC address
Date: Wed, 16 Aug 2017 20:12:57 -0400
Message-ID: <yq1bmnfqcfq.fsf@oracle.com>
References: <1502892632-6563-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41701 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdHQANC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:13:02 -0400
In-Reply-To: <1502892632-6563-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 16 Aug 2017 19:40:32 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com


Varun,

> If nud_state is not valid then call neigh_event_send() to update MAC
> address.

Applied to 4.13/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
