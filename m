From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: 22 Oct 2003 00:42:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com>
	 <20031022153140.A22298@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:33949 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263685AbTJVOn0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 10:43:26 -0400
In-Reply-To: <20031022153140.A22298@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

On Wed, 2003-10-22 at 07:31, Christoph Hellwig wrote:
> On Tue, Oct 21, 2003 at 04:58:57PM -0700, Patrick Mansfield wrote:
> > libsysfs 0_2_0 was not installing libsysfs.h or dlist.h, manually copy
> > those files to /usr/include/sys before compiling.
> 
> Umm, libsysfs isn't installing headers into /usr/include/sys, is it?
> Especially with something like dlist.h that sounds like yet another
> linked list implementation..



Patrick told me about this, we will change libsysfs to install headers
there. Is there another linked list implementation that you'd recommend?
We couldn't include list.h like Greg did in udev because we are keeping
libsysfs LGPL and we didn't want the overhead of glibc.

Thanks,

Dan


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Daniel Stekloff <dsteklof@us.ibm.com>

