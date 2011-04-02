From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sat, 2 Apr 2011 15:02:40 -0600
Message-ID: <20110402210240.GD7286@parisc-linux.org>
References: <20110401202051.GL4183@linux.intel.com> <20110402133643.GB18990@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58735 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1DBVCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 17:02:42 -0400
Content-Disposition: inline
In-Reply-To: <20110402133643.GB18990@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Sat, Apr 02, 2011 at 09:36:43AM -0400, Christoph Hellwig wrote:
> On Fri, Apr 01, 2011 at 04:20:51PM -0400, Matthew Wilcox wrote:
> > 
> > In preparation for moving some drivers out from under the host_lock,
> > make cmd_serial_number an atomic.
> 
> The right fix is to stop abusing cmd_serial_nubmer in those few
> drivers, and use a driver-private and more scalable lookup data
> structure than a linear list search.
> 
> And yes, I promised to at least move cmd_serial_number into these
> drivers long time ago - time to get back to that.

Fair enough, but you're making the perfect the enemy of the good.
How about putting this patch in for now (since it harms nothing), and
then it'll all go away when you delete cmd_serial_number?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
