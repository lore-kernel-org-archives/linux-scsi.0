From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3] scsi_debug: Convert to use root_device_register() and
 root_device_unregister()
Date: Mon, 6 Sep 2010 20:58:03 -0700
Message-ID: <20100907035803.GA1562@core.coreip.homeip.net>
References: <1283819068-24587-1-git-send-email-nab@linux-iscsi.org>
 <20100907003251.GA21430@core.coreip.homeip.net>
 <1283828456.15944.1323.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61725 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0IGD6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 23:58:09 -0400
Content-Disposition: inline
In-Reply-To: <1283828456.15944.1323.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>

On Mon, Sep 06, 2010 at 11:00:56PM -0400, James Bottomley wrote:
> On Mon, 2010-09-06 at 17:32 -0700, Dmitry Torokhov wrote:
> > On Mon, Sep 06, 2010 at 05:24:28PM -0700, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Hi Doug and Co,
> > > 
> > > This patch updates the scsi_debug virtual LLD to use root_device_register()
> > > and root_device_unregister() from include/linux/device.h instead of device_register()
> > > and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> > > This simply involved converting the static struct device pseudo_primary into a
> > > pointer that is setup by the call to root_device_register().
> > > 
> > > This patch also contains the correct IS_ERR() conditional check of
> > > root_device_register() from within scsi_debug_init().
> > > 
> > > Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> > > 
> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > 
> > Thanks for making the changes.
> > 
> > Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Can I make that Reviewed-by:? Acked-by is really just for maintainer
> patches which don't warrant a signoff.
> 

Sure, whatever suits better.

-- 
Dmitry
