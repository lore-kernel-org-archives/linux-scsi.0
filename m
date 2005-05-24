From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter
	information (re-diff)
Date: Tue, 24 May 2005 07:18:28 -0700
Message-ID: <1116944309.13106.2.camel@markh1.pdx.osdl.net>
References: <1116362098.5838.2.camel@markh1.pdx.osdl.net>
	 <20050522165443.GA31638@infradead.org>
	 <1116873408.22284.26.camel@markh1.pdx.osdl.net>
	 <20050523184610.GA19285@infradead.org>
	 <1116881371.22284.29.camel@markh1.pdx.osdl.net>
	 <20050524033020.GA23998@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:43221 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261259AbVEXOSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 10:18:39 -0400
In-Reply-To: <20050524033020.GA23998@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-05-23 at 22:30 -0500, Matt Domsch wrote:
> On Mon, May 23, 2005 at 01:49:30PM -0700, Mark Haverkamp wrote:
> > On Mon, 2005-05-23 at 19:46 +0100, Christoph Hellwig wrote:
> > > On Mon, May 23, 2005 at 11:36:48AM -0700, Mark Haverkamp wrote:
> > > > > the "Adaptec Raid Controller:" doesn't belong in here.  The driver build
> > > > > data and version neither, use MODULE_VERSION instead.
> > > > 
> > > > Using MODULE_VERSION in the snprinf doesn't seem to work:
> > > > 
> > > > drivers/scsi/aacraid/linit.c: In function `aac_show_host_version':
> > > > drivers/scsi/aacraid/linit.c:541: error: `MODULE_VERSION' undeclared (first use in this function)
> > > 
> > > sorry, MODULE_VERSION is a macro similar to MODULE_LICENSE or MODULE_AUTHOR.
> > > You say MODULE_VERSION("something"); outside any function and you can find
> > > the version out using modinfo and sysfs (not sure the latter is implemented
> > > yet, but there were patches floating around)
> > 
> > I haven't seen anything to display MODULE_VERSION in sysfs.
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=110671970405497&w=2
> was posted, not included yet, and I haven't pushed it again lately
> waiting for 2.6.12 to settle.
> 
> > How about If I just print out AAC_DRIVER_VERSION which is what is
> > passed into the MODULE_VERSION macro.
> 
> That's what others do (ethtool -i), so seems sane if you really need
> it exported in sysfs before the above is merged.  What's the rush
> though?  If it can wait a release, I'll push on the above then it'll
> be there for all modules.

I just hadn't seen that patch before.  If it is going to be merged in,
then it seems like we should use that method instead of adding another.

Mark.

> 
> Thanks,
> Matt
> 
-- 
Mark Haverkamp <markh@osdl.org>

