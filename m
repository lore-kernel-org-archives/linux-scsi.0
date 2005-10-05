From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 5 Oct 2005 17:28:50 +0100
Message-ID: <20051005162850.GA17710@infradead.org>
References: <4341D38A.40509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31705 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030218AbVJEQ2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 12:28:52 -0400
Content-Disposition: inline
In-Reply-To: <4341D38A.40509@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On Mon, Oct 03, 2005 at 08:57:46PM -0400, Jeff Garzik wrote:
> This change updates the 3ware raid drivers to use scsi_scan_target(), 
> rather than scsi_scan_host().  This is especially nice for 3w-xxxx, 
> which does not support LUNs.  The device scan is a bit quicker and more 
> direct, even if it is a tiny bit more code in the driver.

if it doesn't support luns scsi_add_device sounds like the better
interface to use.  How does 3x-9xxx support luns?  From reading the
code it doesn't seem to support passthru and faking up LUNs for logical
volumes sounds odd.

