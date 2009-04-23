From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices and  partitions
Date: Thu, 23 Apr 2009 07:30:29 -0600
Message-ID: <20090423133029.GN1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk> <20090423114959.GL1926@parisc-linux.org> <20090423115508.GE4593@kernel.dk> <20090423132237.GM1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33280 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZDWNaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 09:30:30 -0400
Content-Disposition: inline
In-Reply-To: <20090423132237.GM1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 07:22:37AM -0600, Matthew Wilcox wrote:
> On Thu, Apr 23, 2009 at 01:55:09PM +0200, Jens Axboe wrote:
> > On Thu, Apr 23 2009, Matthew Wilcox wrote:
> > > ATA reports this in the INQUIRY data.  SCSI reports it in READ CAPACITY 16.
> > 
> > OK, I wasn't aware of that. That's a relief!
> 
> Here's a patch to translate ATA to SCSI (extracted from the 4k work I
> did last year).  Jeff, could you apply this?

hahaha.  i should have read down as far as 8/8 ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
