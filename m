From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: Thu, 19 Aug 2004 17:21:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040819172109.A10853@infradead.org>
References: <1092932342.2378.430.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:27143 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266626AbUHSQVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:21:10 -0400
Content-Disposition: inline
In-Reply-To: <1092932342.2378.430.camel@mulgrave>; from James.Bottomley@SteelEye.com on Thu, Aug 19, 2004 at 12:19:01PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 19, 2004 at 12:19:01PM -0400, James Bottomley wrote:
> The non unique SCSI ioctls:
> 
> SCSI_IOCTL_SEND_COMMAND
> SCSI_IOCTL_TEST_UNIT_READY
> SCSI_IOCTL_BENCHMARK_COMMAND
> SCSI_IOCTL_SYNC
> SCSI_IOCTL_START_UNIT
> SCSI_IOCTL_STOP_UNIT
> 
> Have been deprecated for a while now.  We should make the kernel
> complain when a program actually uses one of them, so users have had
> adequate warning before they are removed.

drivers/block/scsi_ioctl.c also implements SCSI_IOCTL_SEND_COMMAND, so
you'll have to warn there aswell.

