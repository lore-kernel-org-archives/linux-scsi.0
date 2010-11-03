From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Wed, 3 Nov 2010 09:24:09 -0700
Message-ID: <20101103162409.GA5460@kroah.com>
References: <106187.30360.qm@web31802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:40405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0KCQXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Nov 2010 12:23:23 -0400
Content-Disposition: inline
In-Reply-To: <106187.30360.qm@web31802.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Oct 29, 2010 at 05:33:19PM -0700, Luben Tuikov wrote:
> Eliminate an infinite loop whereby the SCSI layer
> would reissue a command (which would be failed by
> the driver) ad infinitum. (Invariably due to the
> driver's profuse use of the
> SCSI_MLQUEUE_DEVICE_BUSY returned result in its
> queuecommand() method.)
> 
> Also add a debug option and a few debug prints.

Matthew, any thoughts about this, and the other ones by Luben?  I need
your ack before I can take them.

thanks,

greg k-h
