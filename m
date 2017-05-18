From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: fix error message in ses_intf_add()
Date: Wed, 17 May 2017 20:18:21 -0400
Message-ID: <yq137c381bm.fsf@oracle.com>
References: <1495026008-25704-1-git-send-email-mlombard@redhat.com>
        <1495028486.3629.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33325 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdERAS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 20:18:29 -0400
In-Reply-To: <1495028486.3629.10.camel@localhost.localdomain> (Ewan D. Milne's
        message of "Wed, 17 May 2017 09:41:26 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com


Ewan,

> This looks OK but I think we should consider suppressing these
> messages.  There are a lot of devices that return page 0 instead of
> the correct page, we should either say something like "enclosure
> services not supported", or else work with what we get instead of
> logging a message on every device probe that make it sound like
> the device is failing.

I agree.

> I've received several complaints about this.

Me too. There appears to be a ton of bad devices out there.

-- 
Martin K. Petersen	Oracle Linux Engineering
