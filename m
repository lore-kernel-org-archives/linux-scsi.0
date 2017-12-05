From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_devinfo: handle non-terminated strings
Date: Mon, 04 Dec 2017 22:08:50 -0500
Message-ID: <yq1bmjd6fct.fsf@oracle.com>
References: <20171127224735.32139-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30840 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdLEDJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 22:09:15 -0500
In-Reply-To: <20171127224735.32139-1-mwilck@suse.com> (Martin Wilck's message
        of "Mon, 27 Nov 2017 23:47:34 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Alan Stern <stern@rowland.harvard.edu>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>


Martin,

> devinfo->vendor and devinfo->model aren't necessarily
> zero-terminated.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
