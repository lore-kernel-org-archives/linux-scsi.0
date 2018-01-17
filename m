From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Tue, 16 Jan 2018 23:39:52 -0500
Message-ID: <yq1h8rlumhz.fsf@oracle.com>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
        <yq1k1xjjsly.fsf@oracle.com> <1516119082.2844.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbeAQEkI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2018 23:40:08 -0500
In-Reply-To: <1516119082.2844.5.camel@wdc.com> (Bart Van Assche's message of
        "Tue, 16 Jan 2018 16:11:23 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>


Bart,

>> Applied to 4.15/scsi-fixes. Thanks!
>
> Since that patch fixes an issue that was introduced in kernel v4.14
> but did not have a "Cc: stable" tag, should this patch be sent to Greg
> for inclusion in the kernel v4.14.x series?

Yes. Hannes?

-- 
Martin K. Petersen	Oracle Linux Engineering
