From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Fri, 9 Sep 2016 13:46:09 +0200
Message-ID: <20160909114609.GA23702@kroah.com>
References: <1471349112-13876-1-git-send-email-oneukum@suse.com>
 <yq1bn0pijqh.fsf@sermon.lab.mkp.net>
 <1473331428.32073.0.camel@suse.com>
 <yq1zinhfh5y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45368 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753715AbcIILqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 07:46:04 -0400
Content-Disposition: inline
In-Reply-To: <yq1zinhfh5y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Oliver Neukum <oneukum@suse.com>, jejb@linux.vnet.ibm.com, usb-storage@lists.one-eyed-alien.net, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, Johannes Thumshirn <JThumshirn@suse.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Fri, Sep 09, 2016 at 07:26:17AM -0400, Martin K. Petersen wrote:
> >>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:
> 
> Oliver> On Thu, 2016-08-18 at 22:19 -0400, Martin K. Petersen wrote:
> >> >>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:
> >> 
> Oliver> Some SATA to USB bridges fail to cooperate with some drives
> Oliver> resulting in no cache being present being reported to the
> Oliver> host. That causes the host to skip sending a command to
> Oliver> synchronize caches. That causes data loss when the drive is
> Oliver> powered down.
> >> 
> >> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> >> 
> 
> Oliver> may I ask about the fate of this patch? Has it been lost?
> Oliver> Should I resubmit? Are any further changes necessary?
> 
> I'm OK with the change but it needs to go through the USB tree.

Ugh, ok, this is gone from my queue, Oliver, can you resend it and I'll
queue it up?

thanks,

greg k-h
