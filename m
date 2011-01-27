From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/3] scsi: Detailed I/O errors
Date: Thu, 27 Jan 2011 17:54:31 -0500
Message-ID: <20110127225431.GI14951@redhat.com>
References: <cover.1295340405.git.hare@suse.de>
 <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
 <4D357AA3.5070509@interlog.com>
 <4D358130.6040508@suse.de>
 <20110127223525.GH14951@redhat.com>
 <1296168102.3050.83.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab1A0Wyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2011 17:54:44 -0500
Content-Disposition: inline
In-Reply-To: <1296168102.3050.83.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, dgilbert@interlog.com, James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com

On Thu, Jan 27 2011 at  5:41pm -0500,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2011-01-27 at 17:35 -0500, Mike Snitzer wrote:
> > On Tue, Jan 18 2011 at  7:01am -0500,
> > Hannes Reinecke <hare@suse.de> wrote:
> > 
> > > On 01/18/2011 12:33 PM, Douglas Gilbert wrote:
> > > 
> > > This patchset is primarily for fixing up multipathing,
> > > which has the habit of retrying failed I/Os on the
> > > next path. For some errors this is just pointless
> > > (eg MEDIUM ERROR), for some errors this is the desired
> > > behaviour (namely transport errors), and for others
> > > this is positively damaging (persistent reservation
> > > failures).
> > > Just plain EIO simply don't cover the whole range :-)
> > > 
> > > > 
> > > > BTW might "vulgo" be "ergo" [Latin: therefore]?
> > > > 
> > > Nope. Correct etymology is from 'sermo vulgaris',
> > > ie the language of the common people.
> > > But maybe I should remove it for the next
> > > round to avoid confusion.
> > 
> > Is a new round even needed given there haven't been any code issues
> > raised against v4?
> > 
> > James, what are your thoughts on this patchset?  Would be great to get
> > this in scsi-misc for 2.6.39
> > 
> > Please advise,
> 
> Well, it covers three subsystems ... I was waiting for Alasdair and Jens
> to ack ... but I bet they each were waiting for the other two to ack ...
> 
> So, I'll take it if no objections.

OK, I just sent a mail to jens and alasdair asking the same ;)

Thanks,
Mike
