From: Chris Mason <mason@suse.com>
Subject: Re: reiserfs and SCSI oops seen in 2.6.9-rc2 with local SCSI disk
	IO
Date: Mon, 27 Sep 2004 16:44:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096317899.19249.40.camel@watt.suse.com>
References: <4154372C.7070506@netapp.com>
	 <20040924151828.GC16153@parcelfarce.linux.theplanet.co.uk>
	 <4154404B.3070705@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:65189 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267368AbUI0Usm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 16:48:42 -0400
In-Reply-To: <4154404B.3070705@netapp.com>
List-Id: linux-scsi@vger.kernel.org
To: David Wysochanski <davidw@netapp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2004-09-24 at 11:42 -0400, David Wysochanski wrote:
> Matthew Wilcox wrote:
> > On Fri, Sep 24, 2004 at 11:03:08AM -0400, David Wysochanski wrote:
> >  > I can reproduce this pretty easily with local disk.
> >  >
> >  > Here's some details about my setup (attached is the
> >  > full kernel config):
> >  > - dell 2650 (dual xeon, hyperthreading disabled)
> >  > - 1 local SCSI disk (root volume)
> >  > - 2 local SCSI disks (data), each with 10 partitions
> >  > of 100MB each, 6 of them reiserfs filesystems, 3 of them
> >  > ext3, and 3 of them ext2 (total of 20 unique filesystems)
> >  > - one instance of test program running on each of the
> >  > 20 filesystems
> > 

Can you reproduce with a smaller test setup?  Say just the 6 reiserfs
partitions of 100MB each?  Is a mix of filesytems required to trigger
the bug or can you trigger with reiser alone?

I'm having a hard time triggering here, but since your oopsen so
consistently include roughly the same paths in reiserfs, I'd expect this
isn't a scsi problem.  I've got an aic7892 card, so our test setups are
at least similar.

-chris


