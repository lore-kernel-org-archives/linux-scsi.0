From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Thu, 13 Mar 2008 11:11:35 -0600
Message-ID: <20080313171135.GL613@parisc-linux.org>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <200803122125.50161.us-@gmx.de> <1205357733.2941.160.camel@localhost.localdomain> <200803130709.44066.us-@gmx.de> <20080313125508.GF613@parisc-linux.org> <20080313164537.GA21995@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48068 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYCMRLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 13:11:37 -0400
Content-Disposition: inline
In-Reply-To: <20080313164537.GA21995@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Schweitzer <us-@gmx.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Thu, Mar 13, 2008 at 12:45:37PM -0400, Christoph Hellwig wrote:
> On Thu, Mar 13, 2008 at 06:55:08AM -0600, Matthew Wilcox wrote:
> > How does this look?  I've inverted the sense of the flashpoint config
> > option and neatened up the PCI-less support while I was there.
> 
> I think it's a good start.  Long-term flashpoint should either die or
> become a driver of it's own - these cards have very little in common
> with the regular intelligent buslogic cards and if you look at the
> driver it's full of if (flashpoint) in every major function.

Completely agreed about the long term direction.

I'm not volunteering to work on this particular obsolescent driver
though.  Advansys is quite enough trouble for me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
