From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC PATCH 0/19] A kernel-level configfs enabled generic
 target engine for Linux v2.6.32
Date: Fri, 11 Sep 2009 19:37:40 -0700
Message-ID: <1252723060.28368.48.camel@desktop>
References: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:43759 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbZILChF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 22:37:05 -0400
In-Reply-To: <1252720508.2067.196.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

On Fri, 2009-09-11 at 18:55 -0700, Nicholas A. Bellinger wrote:
> There is cleanup work continuing to make the TCM code to use
> dprintk(),
> and some include cleanups, and other minor fixes.  The code has also
> been run through checkpatch again since the posting in April, and all
> errors have been removed, with the exception of one ConfigFS macro
> define triggering a checkpatch false positive.


One show stopping issue is that your adding new semaphore usage in patch
5 and 16 (and in 16 it's a LOCKED one wtf!!). Which you should not be
doing .. You need to really evaluate the warnings from checkpatch, cause
those still have meaning.. 

It's basically telling you what you should be doing in the warnings..
For instance, don't add new semaphore usage, and it tells you what you
need to be using in place of them.. Also typedefs are frowned upon, so
you could remove those..

Daniel

