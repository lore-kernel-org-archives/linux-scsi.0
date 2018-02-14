From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi_debug: reset injection flags for every_nth > 0
Date: Tue, 13 Feb 2018 21:49:59 -0500
Message-ID: <yq1r2ponv3c.fsf@oracle.com>
References: <20180129233552.26702-1-mwilck@suse.com>
        <20180129233552.26702-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33002 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966497AbeBNCuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:50:10 -0500
In-Reply-To: <20180129233552.26702-2-mwilck@suse.com> (Martin Wilck's message
        of "Tue, 30 Jan 2018 00:35:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Martin,

> If every_nth > 0, the injection flags must be reset for commands
> that aren't supposed to fail (i.e. that aren't "nth"). Otherwise,
> commands will continue to fail, like in the every_nth < 0 case.

Applied to 4.17/scsi-queue.

Please rebase patch 1/2. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
