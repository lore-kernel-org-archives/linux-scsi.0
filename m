From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v3] scsi_debug: Convert to use root_device_register()
 and root_device_unregister()
Date: Mon, 06 Sep 2010 23:00:56 -0400
Message-ID: <1283828456.15944.1323.camel@mulgrave.site>
References: <1283819068-24587-1-git-send-email-nab@linux-iscsi.org>
	 <20100907003251.GA21430@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0IGDBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2010 23:01:11 -0400
In-Reply-To: <20100907003251.GA21430@core.coreip.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>

On Mon, 2010-09-06 at 17:32 -0700, Dmitry Torokhov wrote:
> On Mon, Sep 06, 2010 at 05:24:28PM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Doug and Co,
> > 
> > This patch updates the scsi_debug virtual LLD to use root_device_register()
> > and root_device_unregister() from include/linux/device.h instead of device_register()
> > and device_unregister() respectively within scsi_debug_init() and scsi_debug_exit()
> > This simply involved converting the static struct device pseudo_primary into a
> > pointer that is setup by the call to root_device_register().
> > 
> > This patch also contains the correct IS_ERR() conditional check of
> > root_device_register() from within scsi_debug_init().
> > 
> > Thanks to Richard Sharpe and Dmitry Torokhov for their help with this item.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> Thanks for making the changes.
> 
> Acked-by: Dmitry Torokhov <dtor@mail.ru>

Can I make that Reviewed-by:? Acked-by is really just for maintainer
patches which don't warrant a signoff.

James


