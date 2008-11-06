From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 17:26:31 -0600
Message-ID: <1226013991.4703.127.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com> <20081106223605.GC2373@disturbed>
	 <491375E9.7020707@redhat.com>
	 <1226012815.4703.122.camel@localhost.localdomain>
	 <49137981.7050308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44025 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYKFX0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 18:26:36 -0500
In-Reply-To: <49137981.7050308@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 2008-11-06 at 18:10 -0500, Ric Wheeler wrote:
> James Bottomley wrote:
> > On Thu, 2008-11-06 at 17:55 -0500, Ric Wheeler wrote:
> >> I have no idea how we can pass the aggregation size up from the block 
> >> layer since it is not currently exported in a uniform way from SCSI. 
> >> Even if it is, we have struggled to get RAID stripe alignment handled so 
> >> far.
> >>     
> >
> > Well, this is identical to the erase block size (and array stripe size)
> > problems we've been discussing.  I thought we'd more or less agreed on
> > the generic attributes model.
> >   
> 
> We could do it, but need them to put it in a standard place first. 
> Today, it is exposed only in device specific ways.

Actually, I think it is standard.  I think it's exposed in READ CAPACITY
(16) logical per physical blocks exponent.  This also has an analogue in
SATA since word 106 of the IDENTIFY DEVICE also contains this.  What I'm
not clear on is whether SSDs actually implement this for the erase block
size (I'm reasonably sure 4k sector devices do).

James


