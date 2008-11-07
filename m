From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 15:48:49 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0811071540530.8115@Nokia-N800-26>
References: <4913028B.6010405@redhat.com>  <1225984628.4703.80.camel@localhost.localdomain>
  <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>  <20081107120534.GO21867@kernel.dk>
 <49143142.4010809@redhat.com>  <20081107121934.GP21867@kernel.dk>
 <49145029.4040900@redhat.com>  <20081107144311.GE9543@mit.edu>
 <4914568A.7090307@redhat.com>  <49145E0C.4030705@hp.com>
 <Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26> <1226072195.8030.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYKGPss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:48:48 -0500
In-Reply-To: <1226072195.8030.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Woodhouse <dwmw2@infradead.org>, jim owens <jowens@hp.com>, Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Fri, 7 Nov 2008, James Bottomley wrote:


> If we're being shown native flash with no intervening disk interface
> then, yes, we need to do wear levelling (although I suspect this will
> really only occur in the embedded space).

Native flash will need special handling anyway. In practice I expect that 
when we make btrfs do native flash, it'll use UBI which will handle a lot 
of that for us. Including wear levelling.

-- 
dwmw2
