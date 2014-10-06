From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/2] uas: Make uas work with blk-mq
Date: Sun, 5 Oct 2014 17:10:20 -0700
Message-ID: <20141006001020.GA32273@kroah.com>
References: <1412330937-22630-1-git-send-email-hdegoede@redhat.com>
 <1412330937-22630-2-git-send-email-hdegoede@redhat.com>
 <20141003214712.GA3579@kroah.com>
 <542FB590.4030902@redhat.com>
 <1412433981.21548.6.camel@jarvis.lan>
 <543109F8.3030303@redhat.com>
 <20141005091015.GA29855@infradead.org>
 <54310CF9.8040503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaJFAKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Oct 2014 20:10:21 -0400
Content-Disposition: inline
In-Reply-To: <54310CF9.8040503@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Oct 05, 2014 at 11:18:49AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 10/05/2014 11:10 AM, Christoph Hellwig wrote:
> > On Sun, Oct 05, 2014 at 11:06:00AM +0200, Hans de Goede wrote:
> >> This patch sits on top of a lot of other uas fixes which are already
> >> in usb-next, so this needs to go in through usb-next.
> > 
> > What is the actual conflict? If it's just your revert of the
> > disable_blk_mq flag
> 
> Yes, the conclict is just my revert of the disable_blk_mq flag
> 
> > you might want to skip that for this pull request
> > and send it on after both scsi and usb trees make it to Linus.
> 
> Since the patch with the conclict actually makes the flag unnecessary,
> to me this belongs in the same patch.
> 
> > If there's more conflict around the host template you could cherry pick
> > my patch for your tree.
> 
> Yes, Greg cherry picking the patch in question into his tree to resolv
> the conflict would be my preferred solution to this, but ultimately
> that is Greg's call.

I'm not going to do that, just resend it to me after 3.18-rc1 is out, my
tree is closed for the -rc1 merge window now anyway.

thanks,

greg k-h
