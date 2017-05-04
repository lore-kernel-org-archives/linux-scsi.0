From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v2] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Thu, 4 May 2017 09:23:43 -0600
Message-ID: <20170504152342.GB16489@sbauer-Z170X-UD5>
References: <20170503180911.24326-1-bart.vanassche@sandisk.com>
 <20170504073013.GA3684@lst.de>
 <1493911596.2692.2.camel@sandisk.com>
 <20170504151525.GA16489@sbauer-Z170X-UD5>
 <1493911964.2692.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:64088 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752221AbdEDPgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 11:36:31 -0400
Content-Disposition: inline
In-Reply-To: <1493911964.2692.4.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "jack@suse.cz" <jack@suse.cz>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Thu, May 04, 2017 at 03:32:44PM +0000, Bart Van Assche wrote:
> On Thu, 2017-05-04 at 09:15 -0600, Scott Bauer wrote:
> > On Thu, May 04, 2017 at 03:26:37PM +0000, Bart Van Assche wrote:
> > > On Thu, 2017-05-04 at 09:30 +0200, Christoph Hellwig wrote:
> > > > Please just add a flag to ->flags instead of adding a whole new field.
> > > > 
> > > > Otherwise this looks good to me.
> > > 
> > > Hello Christoph,
> > > 
> > > Thanks for the feedback. I will make the proposed change and post a second
> > > version.
> > 
> > BTW, what branch was your last patch based off? I had some hunk errors while
> > applying it.
> 
> Hello Scott,
> 
> That patch was based off kernel v4.11. Did you perhaps use a different kernel
> version for your tests?
> 
> Bart.

I've been working on top of Jens' for-linus
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=for-linus
