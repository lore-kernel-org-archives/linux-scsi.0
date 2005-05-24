From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Mon, 23 May 2005 22:30:21 -0500
Message-ID: <20050524033020.GA23998@lists.us.dell.com>
References: <1116362098.5838.2.camel@markh1.pdx.osdl.net> <20050522165443.GA31638@infradead.org> <1116873408.22284.26.camel@markh1.pdx.osdl.net> <20050523184610.GA19285@infradead.org> <1116881371.22284.29.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:35936 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S261349AbVEXDaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 23:30:24 -0400
Content-Disposition: inline
In-Reply-To: <1116881371.22284.29.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, May 23, 2005 at 01:49:30PM -0700, Mark Haverkamp wrote:
> On Mon, 2005-05-23 at 19:46 +0100, Christoph Hellwig wrote:
> > On Mon, May 23, 2005 at 11:36:48AM -0700, Mark Haverkamp wrote:
> > > > the "Adaptec Raid Controller:" doesn't belong in here.  The driver build
> > > > data and version neither, use MODULE_VERSION instead.
> > > 
> > > Using MODULE_VERSION in the snprinf doesn't seem to work:
> > > 
> > > drivers/scsi/aacraid/linit.c: In function `aac_show_host_version':
> > > drivers/scsi/aacraid/linit.c:541: error: `MODULE_VERSION' undeclared (first use in this function)
> > 
> > sorry, MODULE_VERSION is a macro similar to MODULE_LICENSE or MODULE_AUTHOR.
> > You say MODULE_VERSION("something"); outside any function and you can find
> > the version out using modinfo and sysfs (not sure the latter is implemented
> > yet, but there were patches floating around)
> 
> I haven't seen anything to display MODULE_VERSION in sysfs.

http://marc.theaimsgroup.com/?l=linux-kernel&m=110671970405497&w=2
was posted, not included yet, and I haven't pushed it again lately
waiting for 2.6.12 to settle.

> How about If I just print out AAC_DRIVER_VERSION which is what is
> passed into the MODULE_VERSION macro.

That's what others do (ethtool -i), so seems sane if you really need
it exported in sysfs before the above is merged.  What's the rush
though?  If it can wait a release, I'll push on the above then it'll
be there for all modules.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
