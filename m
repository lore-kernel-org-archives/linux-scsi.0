From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 1/4] convert block layer drivers to blkerr error values
Date: Wed, 24 Aug 2005 14:42:25 -0500
Message-ID: <430CCDA1.2050403@cs.wisc.edu>
References: <1124874238.10888.18.camel@max> <20050824192132.GA20663@us.ibm.com> <430CCB5E.3090808@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:11734 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751491AbVHXTmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 15:42:37 -0400
In-Reply-To: <430CCB5E.3090808@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: axboe@suse.de, Patrick Mansfield <patmans@us.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> In general, I'm a bit worried about these changes, for two overall reasons:
> 
> 1) I didn't see any analysis of the ultimate end users of block layer 
> error values:  the filesystems.

The filesystems or helpers they use normally did not even check the 
-Exyz error they were getting except for -EOPNOTSUPPORTED. They 
typically use the uptodate bits on the bio or buffer head.

A greater discussion on what the FS's needed and what actions they 
should take would be good though, I agree. They never responded in the 
past so I thought the MD and DM were the only interested users for now. 
I will post to lkml or fs-devel next time. Sorry about that.
