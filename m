From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Wed, 22 Oct 2003 15:46:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022154638.A22952@infradead.org>
References: <20031021165857.A8240@beaverton.ibm.com> <20031022153140.A22298@infradead.org> <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:28177 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263693AbTJVOqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 10:46:39 -0400
Content-Disposition: inline
In-Reply-To: <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com>; from dsteklof@us.ibm.com on Wed, Oct 22, 2003 at 12:42:16AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

On Wed, Oct 22, 2003 at 12:42:16AM -0700, Daniel Stekloff wrote:
> > Umm, libsysfs isn't installing headers into /usr/include/sys, is it?
> > Especially with something like dlist.h that sounds like yet another
> > linked list implementation..
> 
> 
> 
> Patrick told me about this, we will change libsysfs to install headers
> there.

??

s/there/not there/

> Is there another linked list implementation that you'd recommend?

I'd recommend not to expose your linked list implementation to
libsysfs users.  If you really need it might be best to use <sys/queue.h>
although it's quite ugly.  But if dlist.h is the one from evms is certainly
much much better than that one 8)

