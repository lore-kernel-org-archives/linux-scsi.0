From: Matthew Wilcox <willy@debian.org>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: Wed, 22 Oct 2003 16:52:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022155231.GQ18370@parcelfarce.linux.theplanet.co.uk>
References: <20031021165857.A8240@beaverton.ibm.com> <20031022153140.A22298@infradead.org> <1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com> <20031022154638.A22952@infradead.org> <1066809889.27285.36.camel@w-stekloff.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51418 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263480AbTJVPwc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 11:52:32 -0400
Content-Disposition: inline
In-Reply-To: <1066809889.27285.36.camel@w-stekloff.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Mansfield <patmans@us.ibm.com>, linux-hotplug-devel@lists.sourceforge, linux-scsi@vger.kernel.org

On Wed, Oct 22, 2003 at 01:05:21AM -0700, Daniel Stekloff wrote:
> The headers are being installed into /usr/local/include, I believe this
> can be configured differently using autoconf tools. If they should be
> installed elsewhere by default, please let us know.
> 
> Patrick told us that we weren't even installing headers. Don't mind me,
> need more tea. 

You shouldn't be installing them into the <sys/> namespace, that's
basically owned by POSIX.  How about <sysfs/> instead?

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
