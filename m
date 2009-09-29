From: Greg KH <greg@kroah.com>
Subject: Re: Question about invoking of "Task management" functions in USB
	driver  (from newbie)
Date: Tue, 29 Sep 2009 12:49:48 -0700
Message-ID: <20090929194948.GA12232@kroah.com>
References: <ac9fc6790909290721y6b046793rd28357595be2f3a9@mail.gmail.com> <4AC25F81.3070105@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZI2Ttv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 15:49:51 -0400
Content-Disposition: inline
In-Reply-To: <4AC25F81.3070105@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: yukta eswar <yukta.eswar@gmail.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, Sep 29, 2009 at 03:26:57PM -0400, Douglas Gilbert wrote:
> Greg KH wrote:
> > On Tue, Sep 29, 2009 at 07:51:47PM +0530, yukta eswar wrote:
> >> Dear Experts,
> >>
> >> I am developing a new USB attached SCSI (UAS) driver for Linux.
> >
> > Why?
> >
> > Do you have a pointer to your source code for your driver?
>
> Greg,
> It would seem that several groups might be working on UAS ***
> drivers for Linux. They may even be in commercial competition.
> Why ask them to show all their cards on the table at this
> stage?
> When they ask informed questions like this one, why not try
> to answer them or find someone (else) who can?

Because there have been at least 5 different people asking questions
like this on the linux-usb list for the past 6 months, with no code
forthcoming.

You don't get a "competitive advantage" with a Linux driver for a USB
class specification.  What you do is duplicate effort and make it harder
for everyone involved to help out with the development process by
keeping it private.  They are hurting themselves by doing this.

thanks,

greg k-h
