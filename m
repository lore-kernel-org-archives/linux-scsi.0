From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] correct module refcounting
Date: Fri, 31 Oct 2003 12:18:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031031121841.A16828@infradead.org>
References: <1067377564.1788.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:45321 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263556AbTJaMSp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 07:18:45 -0500
Content-Disposition: inline
In-Reply-To: <1067377564.1788.39.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Oct 28, 2003 at 03:46:02PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Tue, Oct 28, 2003 at 03:46:02PM -0600, James Bottomley wrote:
> There's a race window between doing the last scsi_device_put and having
> the devices actually released where the module may be unloaded.  The fix
> is to move the module accounting into the
> scsi_allocate_sdev/scsi_free_sdev pieces of the SCSI routines.

That would mean we can't rmmod a LLDD without first removing all device
through sysfs, or did I get it completely wrong?

--
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
