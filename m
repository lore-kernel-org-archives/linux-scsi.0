From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 30/33] USB storage: sg chaining support
Date: Mon, 16 Jul 2007 23:12:18 -0700
Message-ID: <20070717061218.GA16976@kroah.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792692184-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:56365 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXGQGlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 02:41:50 -0400
Content-Disposition: inline
In-Reply-To: <11845792692184-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jul 16, 2007 at 11:47:44AM +0200, Jens Axboe wrote:
> [PATCH] USB storage: sg chaining support
> 
> Modify usb_stor_access_xfer_buf() to take a pointer to an sg
> entry pointer, so we can keep track of that instead of passing
> around an integer index (which we can't use when dealing with
> multiple scatterlist arrays).
> 
> Cc: greg@kroah.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

No objection from me, I'm guessing this needs to go through the scsi
tree?

thanks,

greg k-h
