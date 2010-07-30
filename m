From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 20:19:56 -0400
Message-ID: <20100730001956.GJ4506@thunk.org>
References: <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <4C51DA1F.2040701@redhat.com>
 <20100729194904.GA17098@lst.de>
 <4C51DCF1.3010507@redhat.com>
 <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
 <20100729230406.GI4506@thunk.org>
 <1280446105.4441.837.camel@mulgrave.site>
 <1280446655.4441.863.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0G3AUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 20:20:04 -0400
Content-Disposition: inline
In-Reply-To: <1280446655.4441.863.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Jul 29, 2010 at 06:37:35PM -0500, James Bottomley wrote:
> Actually, just an update on this now that I've taken my SCSI glasses
> off.  Anything that does tagging properly ... like SCSI or SATA NCQ
> shouldn't have this problem because the multiple outstanding tags hide
> the media access latency.  For untagged devices, yes, it will be
> painful.
> 

Maybe I'm just being too paranoid and not trusting enough about the
competence of firmware authors, but let's do a lot of testing on this
first.  Or let's have some options so we can turn off FUA if it turns
out to be a disaster on a particular device.  I'll have to do some
searching, but I distinctly remember reading an article in Ars
Technical or Anandtech about how FUA wasn't all that useful because
what the writer had seen in terms of testing some specific devices.
Maybe that was a while ago and devices have gotten better, and maybe
that writer was on crack, but given that FUA doesn't get used a lot,
I'm nervous....

						- Ted
