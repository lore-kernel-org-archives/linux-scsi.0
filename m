From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Fri, 17 Oct 2003 13:31:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031017133129.A27349@infradead.org>
References: <1066265974.16761.426.camel@fuzzy> <3F8E8786.2020502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:44807 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263430AbTJQMbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:31:35 -0400
Content-Disposition: inline
In-Reply-To: <3F8E8786.2020502@torque.net>; from dougg@torque.net on Thu, Oct 16, 2003 at 09:56:54PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 16, 2003 at 09:56:54PM +1000, Douglas Gilbert wrote:
> What was the point of putting 32 dev_t's into the
> kernel? Many people who were advocating it used
> the increased number of scsi disks (> 256) and
> partitions (from 15 to 63 [to match the ide subsystem])
> as a major reason.
> 
> The sd driver is still littered with hacks to distribute
> its 256 (max) disks over 8 majors. Shouldn't this be
> fixed?
> 
> Comments?

I agree with you that there's some late features that need
to be addresses, and the larger dev_t probably is number
one on that list.  But with Linus' policy having two trees
is the best thing James can do.
