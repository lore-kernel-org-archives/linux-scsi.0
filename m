From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: Fri, 20 Aug 2004 08:18:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41252740.50401@torque.net>
References: <1092932342.2378.430.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:51213 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S267465AbUHSWTb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 18:19:31 -0400
In-Reply-To: <1092932342.2378.430.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
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

James,
[Wearing my smartmontools maintainer hat] such a change is going
to cause a lot of noise in the log from the smartd daemon.
The code to use SG_IO ioctl in smartmontools is in CVS but
won't be released for a month or so.

If they are not going to be dropped in the lk 2.6 series
why not wait until the lk 2.7 development starts (or late
lk 2.6 series)?

Doug Gilbert
