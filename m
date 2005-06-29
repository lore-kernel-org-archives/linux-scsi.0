From: Nick Orlov <bugfixer@list.ru>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 21:58:30 -0400
Message-ID: <20050629015830.GA4203@nikolas.hn.org>
References: <20050626153941.456543d6.akpm@osdl.org>
 <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org>
 <1119882142.5175.11.camel@mulgrave> <20050628020858.GA4111@nikolas.hn.org>
 <1119931541.5573.3.camel@mulgrave> <20050628110209.GA5392@nikolas.hn.org>
 <20050628120953.GJ4410@suse.de> <1119968301.4997.6.camel@mulgrave>
 <20050628142300.GX4410@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta8.srv.hcvlny.cv.net ([167.206.4.203]:24815 "EHLO
	mta8.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S262367AbVF2B6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 21:58:40 -0400
Received: from nikolas.hn.org (ool-45731e9d.dyn.optonline.net [69.115.30.157])
 by mta8.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-2.06 (built May 11 2005))
 with ESMTP id <0IIT00LU6PESDV00@mta8.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Tue, 28 Jun 2005 21:56:53 -0400 (EDT)
In-reply-to: <20050628142300.GX4410@suse.de>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>

On Tue, Jun 28, 2005 at 04:23:02PM +0200, Jens Axboe wrote:
> On Tue, Jun 28 2005, James Bottomley wrote:
> > On Tue, 2005-06-28 at 14:09 +0200, Jens Axboe wrote:
> > > > Hard to say. Kernel panics right after the small pause during detection.
> > > > And scroll back does not work. I don't really know what it prints before.
> > > 
> > > Try this variant, fixes the mapping type and kunmap_atomic().
> > 
> > Actually, I suspect the problem is the BUG_ON(len < 7).  The mode sense
> > routines have to be really careful for USB, so we request 4 bytes at
> > first to get the true mode length, hence I think this trips.
> 
> Sounds plausible, the other bugs wouldn't show up unless Nick is using
> highmem (or has it enabled, at least).
> 

I'd like to confirm that this patch solves the problem for me :)
And yes, I don't use highmem.

Thank you,
	Nick Orlov.

-- 
With best wishes,
	Nick Orlov.

