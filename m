From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [announce] scsi_id 0.1 - generate unique scsi id
Date: 23 Oct 2003 03:33:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq04qy0be7n.fsf@wildopensource.com>
References: <20031021165857.A8240@beaverton.ibm.com>
	<20031022153140.A22298@infradead.org>
	<1066808536.27285.19.camel@w-stekloff.beaverton.ibm.com>
	<20031022154638.A22952@infradead.org>
	<1066809889.27285.36.camel@w-stekloff.beaverton.ibm.com>
	<20031022155231.GQ18370@parcelfarce.linux.theplanet.co.uk>
	<20031022091519.A11995@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:6604 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S261305AbTJWHiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 03:38:12 -0400
In-Reply-To: <20031022091519.A11995@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>, Daniel Stekloff <dsteklof@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

>>>>> "Patrick" == Patrick Mansfield <patmans@us.ibm.com> writes:

Patrick> On Wed, Oct 22, 2003 at 04:52:31PM +0100, Matthew Wilcox
Patrick> wrote:
>> You shouldn't be installing them into the <sys/> namespace, that's
>> basically owned by POSIX.  How about <sysfs/> instead?

Patrick> I incorrectly suggested we should use <sys/>.

Patrick> Should we use <linux/>, rather than another new directory?

Rule of thumb: any existing hierachy is reserved, either you want to
drop it in header root, ie. /usr/include or /usr/loca/include or you
want to create your own hierachy, <sysfs/> as Matthew suggested looks
like a good candidate to me.

Cheers,
Jes
