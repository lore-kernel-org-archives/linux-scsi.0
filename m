From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Mon, 8 Nov 2010 07:55:36 -0800
Message-ID: <20101108155536.GD10092@kroah.com>
References: <106187.30360.qm@web31802.mail.mud.yahoo.com>
 <20101108112456.GI4173@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0KHQAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 11:00:06 -0500
Content-Disposition: inline
In-Reply-To: <20101108112456.GI4173@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 06:24:56AM -0500, Matthew Wilcox wrote:
> On Fri, Oct 29, 2010 at 05:33:19PM -0700, Luben Tuikov wrote:
> > Eliminate an infinite loop whereby the SCSI layer
> > would reissue a command (which would be failed by
> > the driver) ad infinitum. (Invariably due to the
> > driver's profuse use of the
> > SCSI_MLQUEUE_DEVICE_BUSY returned result in its
> > queuecommand() method.)
> > 
> > Also add a debug option and a few debug prints.
> 
> Why have you added your own debug scheme instead of using dev_dbg?

I agree, don't ever do that.

thanks,

greg k-h
