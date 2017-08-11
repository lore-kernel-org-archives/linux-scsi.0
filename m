From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 2/4] scsi: Export blacklist flags to sysfs
Date: Thu, 10 Aug 2017 20:43:33 -0400
Message-ID: <yq1valv0w96.fsf@oracle.com>
References: <1502275444-27676-1-git-send-email-hare@suse.de>
        <1502275444-27676-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31737 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752092AbdHKApM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 20:45:12 -0400
In-Reply-To: <1502275444-27676-3-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 9 Aug 2017 12:44:02 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>


Hannes,

> Each scsi device is scanned according to the found blacklist flags,
> but this information is never presented to sysfs.  This makes it quite
> hard to figure out if blacklisting worked as expected.  With this
> patch we're exporting an additional attribute 'blacklist' containing
> the blacklist flags for this device.

There have been changes to the blacklist values over the years so I'm
not so keen on exporting them as a numbers.

-- 
Martin K. Petersen	Oracle Linux Engineering
