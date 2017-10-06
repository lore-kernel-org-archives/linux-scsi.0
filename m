From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi/libfc: fix a deadlock in fc_rport_work
Date: Fri, 06 Oct 2017 14:58:57 -0400
Message-ID: <yq1h8vcnlvy.fsf@oracle.com>
References: <1507246881-20508-1-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32239 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdJFS7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2017 14:59:05 -0400
In-Reply-To: <1507246881-20508-1-git-send-email-satishkh@cisco.com>
        (satishkh@cisco.com's message of "Thu, 5 Oct 2017 16:41:21 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com
Cc: linux-scsi@vger.kernel.org


Satish,

> In places like fc_rport_recv_plogi_req and fcoe_ctlr_vn_add we
> always take the lport disc_mutex lock before the rports mutex
> (rp_mutex) lock. Gaurding list_del_rcu(&rdata->peers) with
> disc.disc_mutex in fc_rport_work is correct but the rp_mutex lock
> can and should to be dropped before taking that lock else results
> in a deadlock.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
