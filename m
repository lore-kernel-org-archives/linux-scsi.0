From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Mon, 28 Jul 2003 11:08:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030728150823.GC1399@gtf.org>
References: <20030724153505.GC1063@suse.de> <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:42635
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S270332AbTG1OxI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 10:53:08 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jul 28, 2003 at 10:10:33AM -0400, Alan Stern wrote:
> Jens:
> 
> This patch changes the scsi_mode_sense() routine to retry up to a total of 
> 3 times if a command fails with a UNIT ATTENTION sense key value.
> 
> Without this change, sr.c does not properly read the capabilities mode 
> page for a just-powered-up cdrom drive -- it gives up upon receiving a 
> Device Reset Occurred code.

I'm curious, are you testing against a real SCSI device, or a faked one
as via ide-scsi.c?

	Jeff



