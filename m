From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: 20 Sep 2004 09:49:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095688178.1762.4.camel@mulgrave>
References: <1095526671.2483.5.camel@mulgrave>
	<414E6F3E.4070502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62093 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266555AbUITNuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 09:50:10 -0400
In-Reply-To: <414E6F3E.4070502@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-09-20 at 01:48, Douglas Gilbert wrote:
> Perhaps there should be a new reset called:
>      ...RESET_LOGICAL_UNIT
> 
> as this is now defined as a task management function in SAM-3.
> If so ...RESET_DEVICE might get a synonym: ...RESET_TARGET.
> Most transports support a RESET_TARGET while RESET_BUS is
> SPI specific (is there an FCP equivalent?).

Well, perhaps ... also one that takes an actual value for the reset type
instead of a pointer to a value that requires compat processing. 
However, the goal of this exercise was simply to provide backwards
compatibility.

Probably, longer term, the reset ioctls should be provided by the
transport class, since they're pretty much transport specific.

James


