From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Wed, 22 Oct 2003 09:15:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022091519.A11995@beaverton.ibm.com>
References: <20031021165857.A8240@beaverton.ibm.com> <20031022153140.A22298@infradead.org> <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com> <20031022154638.A22952@infradead.org> <1066809889.27285.36.camel@w-stekloff.beaverton.ibm.com> <20031022155231.GQ18370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:40852 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263692AbTJVQQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 12:16:39 -0400
Content-Disposition: inline
In-Reply-To: <20031022155231.GQ18370@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Wed, Oct 22, 2003 at 04:52:31PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Daniel Stekloff <dsteklof@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Wed, Oct 22, 2003 at 04:52:31PM +0100, Matthew Wilcox wrote:
> On Wed, Oct 22, 2003 at 01:05:21AM -0700, Daniel Stekloff wrote:
> > The headers are being installed into /usr/local/include, I believe this
> > can be configured differently using autoconf tools. If they should be
> > installed elsewhere by default, please let us know.
> > 
> > Patrick told us that we weren't even installing headers. Don't mind me,
> > need more tea. 
> 
> You shouldn't be installing them into the <sys/> namespace, that's
> basically owned by POSIX.  How about <sysfs/> instead?

I incorrectly suggested we should use <sys/>. 

Should we use <linux/>, rather than another new directory?

And sorry for getting the hogplug list address wrong.

-- Patrick Mansfield
wrong.
