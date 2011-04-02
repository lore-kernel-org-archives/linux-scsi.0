From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sat, 02 Apr 2011 08:51:07 -0500
Message-ID: <1301752267.4092.3.camel@mulgrave.site>
References: <20110401202051.GL4183@linux.intel.com>
	 <20110402133643.GB18990@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1DBNvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2011 09:51:13 -0400
In-Reply-To: <20110402133643.GB18990@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Sat, 2011-04-02 at 09:36 -0400, Christoph Hellwig wrote:
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

Gosh, I'm glad you said that ... I was afraid it would sound like I was
a Nag.

James


