From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: linux-scsi-owner@vger.kernel.org is a pain
Date: Mon, 8 Jan 2007 22:28:32 +0200
Message-ID: <20070108202832.GE11825@mea-ext.zmailer.org>
References: <45A16FED.7000005@torque.net> <1168272975.2824.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from z2.cat.iki.fi ([212.16.98.133]:55387 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbXAHUgU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jan 2007 15:36:20 -0500
Received: (mea@mea-ext) by mail.zmailer.org id S1620543AbXAHU2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 22:28:32 +0200
Content-Disposition: inline
In-Reply-To: <1168272975.2824.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Mon, Jan 08, 2007 at 10:16:15AM -0600, James Bottomley wrote:
> On Sun, 2007-01-07 at 17:10 -0500, Douglas Gilbert wrote:
> > Seems I'm not the only one sending posts to the
> > linux-scsi-owner@vger.kernel.org bit bucket.
> > 
> > Could the maintainer of lsml either:
> >   - get rid of linux-scsi-owner@vger.kernel.org
> >   - or forward posts in there to lsml
> > 
> > That bright idea might save the maintainer time but
> > it wastes ours.
> 
> I think it's a majordomo feature ... you need misdelivered or
> undelivered emails not to come back to the list, so the return-path: is
> set to the owner list (so they can be removed from the email list).
> 
> In theory, a mailer should never reply to the return path, so how are
> you getting this in your reply path?
> 
> James

No,  linux-scsi -list does not set that as "Reply-To:"

That behaviour is seen commonly in LAN "email" systems, which
are unable to differentiate information carried in SMTP level
transport vs. what is in the visible headers.

I let you figure out yourself whose email server "product" should
not be connected into the Internet because it is unable to handle
these fundamental differentiations in the internet email..

  /Matti Aarnio
