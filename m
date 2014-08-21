From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Thu, 21 Aug 2014 07:42:52 -0700
Message-ID: <20140821144252.GA16226@infradead.org>
References: <Pine.LNX.4.44L0.1408201507280.1959-100000@iolanthe.rowland.org>
 <53F604FE.8040301@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHUOnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 10:43:04 -0400
Content-Disposition: inline
In-Reply-To: <53F604FE.8040301@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, Aug 21, 2014 at 10:41:02AM -0400, Douglas Gilbert wrote:
> Perhaps we could add another bit flag in struct
> scsi_host_template such as:
>     unsigned int transport_says_dont_scsi2_lun_cmd:1;
> 
> then drivers/usb/storage/scsiglue.c could set that
> bit in its usb_stor_host_template and
> drivers/scsi/scsi.c could take heed (and not mask
> cmd->cmnd[1] with the LUN).

Fully agreed.

(except that I'd shorten the flag name to .no_scsi2lun :))

