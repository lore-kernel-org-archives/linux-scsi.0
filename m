From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Thu, 08 Sep 2016 12:43:48 +0200
Message-ID: <1473331428.32073.0.camel@suse.com>
References: <1471349112-13876-1-git-send-email-oneukum@suse.com>
         <yq1bn0pijqh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42753 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758995AbcIHKtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 06:49:13 -0400
In-Reply-To: <yq1bn0pijqh.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, usb-storage@lists.one-eyed-alien.net, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, Johannes Thumshirn <JThumshirn@suse.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Thu, 2016-08-18 at 22:19 -0400, Martin K. Petersen wrote:
> >>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:
> 
> Oliver> Some SATA to USB bridges fail to cooperate with some drives
> Oliver> resulting in no cache being present being reported to the
> Oliver> host. That causes the host to skip sending a command to
> Oliver> synchronize caches. That causes data loss when the drive is
> Oliver> powered down.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Hi,

may I ask about the fate of this patch? Has it been lost?
Should I resubmit? Are any further changes necessary?

	Regards
		Oliver


