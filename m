From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: directly call ELS request handlers
Date: Tue, 11 Apr 2017 20:59:03 -0400
Message-ID: <yq1o9w2v3u0.fsf@oracle.com>
References: <20170407134224.14804-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30409 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdDLA7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 20:59:10 -0400
In-Reply-To: <20170407134224.14804-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Fri, 7 Apr 2017 15:42:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

Johannes Thumshirn <jthumshirn@suse.de> writes:

> Directly call ELS request handler functions in fc_lport_recv_els_req
> instead of saving the pointer to the handler's receive function and then
> later dereferencing this pointer.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
