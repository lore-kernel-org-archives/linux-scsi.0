From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Sat, 2 Feb 2008 13:08:23 -0800
Message-ID: <20080202210823.GA31525@kroah.com>
References: <47A350DF.5020404@cybernetics.com> <532ABFBDAAC3A34EB12EBA6CEC2838F43976569D@ADPE2K703.adaptec.com> <170fa0d20802011643u600c4386wb801c0490800ea5f@mail.gmail.com> <20080202202438.GB2367@kroah.com> <170fa0d20802021256i224ad638ma96bdb4cbbcbac37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbYBBVRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Feb 2008 16:17:36 -0500
Content-Disposition: inline
In-Reply-To: <170fa0d20802021256i224ad638ma96bdb4cbbcbac37@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: stable@kernel.org, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>, Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Luben Tuikov <ltuikov@yahoo.com>

On Sat, Feb 02, 2008 at 03:56:30PM -0500, Mike Snitzer wrote:
> On Feb 2, 2008 3:24 PM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Feb 01, 2008 at 07:43:54PM -0500, Mike Snitzer wrote:
> > > Hi Greg,
> > >
> > > Given your recent call for review of the next 2.6.22-stable I'd
> > > appreciate it if you and the rest of the stable team would strongly
> > > consider this SCSI IO error propagation fix for inclusion in 2.6.22.17
> > > (as well as the other stable trees).
> >
> > Is the patch in Linus's tree already?
> >
> > If so, what git commit id?  That's a requirement to go into the stable
> > tree...
> >
> > If not, we need to wait until it is.
> 
> Fair enough.  Thanks for the clarification.
> 
> That likely leaves us with having James add it to his git tree for
> Linus (provided he agrees with the change).  Which he and Luben seemed
> to agree was the reasonable thin layer of protection that would be
> allowed for such out of spec SCSI devices.
> 
> James, how would you like to proceed?  The patch fixes the good_bytes
> != 0 on HARDWARE_ERROR issue I have been chasing with Mark Salyzyn.

After it goes in, can someone notify stable@kernel.org that it went in,
the git id, and that it should be applied to all older kernel trees?

thanks,

greg "drowning in -stable patches" k-h
