From: Christoph Hellwig <hch@lst.de>
Subject: Re: qla1280 compile problems
Date: Tue, 5 Aug 2003 18:31:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805163103.GA28693@lst.de>
References: <20030805121813.GA24647@lst.de> <1060100259.2044.3.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:13233 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272527AbTHEQbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 12:31:07 -0400
Content-Disposition: inline
In-Reply-To: <1060100259.2044.3.camel@fuzzy>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, Jes Sorensen <jes@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Aug 05, 2003 at 09:17:38AM -0700, James Bottomley wrote:
> On Tue, 2003-08-05 at 05:18, Christoph Hellwig wrote:
> > The qla1280 update still has some issues, mostly because it backs
> > out all the 2.5 changes applied to the driver in the last months,
> > also it doesn't work on ia64 because the IA64 generic build references
> > sn2-specific symbols that don't exist in that build.
> 
> Could you be more explicit on this?  I thought I'd re-added all of the
> backed out patches (although I might have missed some).


These seem to be missing at least

 - remove all #include <linux/blk.h>'s (Adrian Bunk)
 - give ->proc_info a struct Scsi_Host * paramter (me)
 - move all host templates into .c files (me)
 - Spellig fixes for consistent, dependent and persistent
 - Spellig fixes
 - [patch, 2.5] scsi_qla1280.c free on error path
 

> For what it's worth, this compiled for me without warnings on parisc64
> (although I haven't got around to actually testing it).

strange, I can's see how it could compile at least with the superflous
initializer for sht.command.
