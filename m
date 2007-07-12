From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 11:05:53 -0700
Message-ID: <20070712180553.GA21716@suse.de>
References: <468BE4CE.80402@panasas.com> <4696287C.8060501@panasas.com> <46962B74.9040909@panasas.com> <20070712165805.GB19998@suse.de> <1184259955.3402.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:44584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbXGLSGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 14:06:25 -0400
Content-Disposition: inline
In-Reply-To: <1184259955.3402.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Oliver Neukum <oliver@neukum.name>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jul 12, 2007 at 01:05:55PM -0400, James Bottomley wrote:
> On Thu, 2007-07-12 at 09:58 -0700, Greg KH wrote:
> > No objetion from me.  Care to resend it to me, and CC: the
> > linux-usb-devel list also so that it is in a format that I can apply to
> > the tree?
> 
> This will give you a cross tree dependency on scsi-misc-2.6 because of
> the new data accessors ... if that's what you want to do?

Oops, sorry, I wasn't aware of that.

No, I don't want that at all, feel free to push this through your tree,
I have no objection to it at all:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


thanks,

greg k-h
