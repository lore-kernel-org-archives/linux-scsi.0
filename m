From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: 22 Oct 2003 01:05:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066809889.27285.36.camel@w-stekloff.beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com>
	 <20031022153140.A22298@infradead.org>
	 <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com>
	 <20031022154638.A22952@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:49044 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263466AbTJVPGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 11:06:24 -0400
In-Reply-To: <20031022154638.A22952@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

On Wed, 2003-10-22 at 07:46, Christoph Hellwig wrote:
> On Wed, Oct 22, 2003 at 12:42:16AM -0700, Daniel Stekloff wrote:
> > > Umm, libsysfs isn't installing headers into /usr/include/sys, is it?
> > > Especially with something like dlist.h that sounds like yet another
> > > linked list implementation..
> > 
> > 
> > 
> > Patrick told me about this, we will change libsysfs to install headers
> > there.
> 
> ??
> 
> s/there/not there/


The headers are being installed into /usr/local/include, I believe this
can be configured differently using autoconf tools. If they should be
installed elsewhere by default, please let us know.

Patrick told us that we weren't even installing headers. Don't mind me,
need more tea. 


> > Is there another linked list implementation that you'd recommend?
> 
> I'd recommend not to expose your linked list implementation to
> libsysfs users.  If you really need it might be best to use <sys/queue.h>
> although it's quite ugly.  But if dlist.h is the one from evms is certainly
> much much better than that one 8)

Dlist was written and submitted to us by Eric Bohm. I looked at a couple
implementations, including some from IBM, but liked Eric's more. I will
take a look at queue.h, I didn't even know it was there.


Thanks,

Dan


-- 
Daniel Stekloff <dsteklof@us.ibm.com>

