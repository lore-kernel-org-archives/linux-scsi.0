From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: 19 Aug 2004 12:28:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092932940.2025.463.camel@mulgrave>
References: <1092932342.2378.430.camel@mulgrave>
	<20040819162357.GA26375@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4493 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266674AbUHSQ3E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:29:04 -0400
In-Reply-To: <20040819162357.GA26375@havoc.gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-08-19 at 12:23, Jeff Garzik wrote:
> On Thu, Aug 19, 2004 at 12:19:01PM -0400, James Bottomley wrote:
> > The non unique SCSI ioctls:
> > 
> > SCSI_IOCTL_SEND_COMMAND
> > SCSI_IOCTL_TEST_UNIT_READY
> > SCSI_IOCTL_BENCHMARK_COMMAND
> > SCSI_IOCTL_SYNC
> > SCSI_IOCTL_START_UNIT
> > SCSI_IOCTL_STOP_UNIT
> > 
> > Have been deprecated for a while now.  We should make the kernel
> > complain when a program actually uses one of them, so users have had
> > adequate warning before they are removed.
> 
> any chance of deprecating the doorlock ioctls too?

The doorlock ones are unique, and are used by some of the CD tools.

We really need to know when an app locks the door rather than having to
scan the commands in SG_IO.

James


