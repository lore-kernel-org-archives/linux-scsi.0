From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 10:29:30 -0600
Message-ID: <20100601162929.GC32708__18227.9269015$1275409792$gmane$org@parisc-linux.org>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <yq1iq64kv9f.fsf@sermon.lab.mkp.net> <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com> <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com> <1275398876.21962.6.camel@mulgrave.site> <20100601133341.GK8980@think> <1275399637.21962.11.camel@mulgrave.site> <20100601134951.GM8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55510 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0FAQ3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 12:29:31 -0400
Content-Disposition: inline
In-Reply-To: <20100601134951.GM8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, Martin K. Peter

On Tue, Jun 01, 2010 at 09:49:51AM -0400, Chris Mason wrote:
> > I agree that a block based retry would close all the holes ... it just
> > doesn't look elegant to me that the fs will already be repeating the I/O
> > if it changed the page and so will block.
> 
> We might not ever repeat the IO.  We might change the page, write it,
> change it again, truncate the file and toss the page completely.

Why does it matter that it was never written in that case?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
