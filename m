From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 21:52:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECD7EE0.1000507@pobox.com>
References: <3ECD346D.2070302@pobox.com> <20030522214555.A13150@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:59797 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263580AbTEWBjl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 21:39:41 -0400
In-Reply-To: <20030522214555.A13150@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Thu, May 22, 2003 at 04:34:53PM -0400, Jeff Garzik wrote:
> 
>>I request permission to do the following:
>>
>>1) bk mv drivers/scsi/scsi.h include/linux
>>2) bk mv drivers/scsi/hosts.h include/linux/scsi_hosts.h
>>3) bk mv drivers/scsi/scsi_obsolete.h include/linux
>>4) create shell drivers/scsi/{...}.h that includes just-moved files, so 
>>to preserve full driver source compatibility.
>>5) edit include/linux/scsi.h to include <linux/scsi_obsolete.h> not 
>>"scsi_obsolete.h"
>>
>>Objections/comments?
> 
> 
> It's not that easy.  The current host.h/scsi.h split is silly we either want
> to merge them or better split them saner (and into more pieces).  The current
> scsi_obsolete.h should go away completly, it may make a driver compile but
> not work (missing EH).  OTOH all those ugly typedefs should move into a 'new'
> onbsolete.h.  Also all this should go into include/scsi/


This is a whole list of steps to perform after I submit the above changes :)

Sure there are many other improvements to be made.  What I suggest is 
one small step in that direction.  It's an important step because it's 
the minimum necessary to get a sane include structure, with minimum 
controversy.  It's also backport-able to 2.4.

Since files are now just a "bk mv" away from a new pathname, a new file 
location may easily be debated and then implemented, at a later date.

	Jeff


