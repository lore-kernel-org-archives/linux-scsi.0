From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [stable] [PATCH 04/06] mptfusion: mptctl_release is required
 in mptctl.c
Date: Fri, 04 Feb 2011 08:53:59 -0600
Message-ID: <1296831239.3025.0.camel@mulgrave.site>
References: <20110203100250.GE23502@lsi.com>
	 <20110203171930.GA11533@kroah.com>
	 <B2FD678A64EAAD45B089B123FDFC3ED71121F381@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60796 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab1BDOyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2011 09:54:04 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED71121F381@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Greg KH <greg@kroah.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "stable@kernel.org" <stable@kernel.org>

On Fri, 2011-02-04 at 12:20 +0530, Desai, Kashyap wrote:
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, February 03, 2011 10:50 PM
> > To: Desai, Kashyap
> > Cc: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com;
> > Prakash, Sathya; Moore, Eric; stable@kernel.org
> > Subject: Re: [stable] [PATCH 04/06] mptfusion: mptctl_release is
> > required in mptctl.c
> > 
> > On Thu, Feb 03, 2011 at 03:33:00PM +0530, Kashyap, Desai wrote:
> > >
> > > Added missing release callback for file_operations mptctl_fops.
> > > Without release callback there will be never freed. It remains on
> > > mptctl's eent list even after the file is closed and released.
> > >
> > > Relavent RHEL bugzilla is 660871
> > >
> > > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > > ---
> > 
> > <snip>
> > 
> > This is NOT the way to get patches into a stable kernel release.
> > Please
> > read the file, Documentation/stable_kernel_rules.txt for how to do it
> > properly.
> 
> 
> Greg, Thanks for the redirecting to correct process. I understood that I have to add "CC: stable@kernel.org " in header of the patch itself instead of 
> CCing stable@kernel.org from email client.
> Do I need to resend those patches?

Well, as I said, I need the series split into enhancements and bug
fixes ... so why not do that with a resend and add it?

James


