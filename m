From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: 19 Aug 2004 18:27:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092954443.2025.1564.camel@mulgrave>
References: <1092932342.2378.430.camel@mulgrave>
	<41252740.50401@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26250 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267474AbUHSW1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 18:27:35 -0400
In-Reply-To: <41252740.50401@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-08-19 at 18:18, Douglas Gilbert wrote:
> [Wearing my smartmontools maintainer hat] such a change is going
> to cause a lot of noise in the log from the smartd daemon.
> The code to use SG_IO ioctl in smartmontools is in CVS but
> won't be released for a month or so.
> 
> If they are not going to be dropped in the lk 2.6 series
> why not wait until the lk 2.7 development starts (or late
> lk 2.6 series)?

The current issue is that some of them have no compat code, so they
don't actually work 32 on 64.

If the noise becomes unbearable, we can rate limit it, but I'd like to
get the message out.

James


