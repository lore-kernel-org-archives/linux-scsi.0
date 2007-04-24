From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Question regarding firmware
Date: Tue, 24 Apr 2007 07:45:23 -0700
Message-ID: <20070424144523.GD26148@andrew-vasquezs-computer.local>
References: <432090.15694.qm@web7905.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:41582 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbXDXOpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2007 10:45:31 -0400
Content-Disposition: inline
In-Reply-To: <432090.15694.qm@web7905.mail.in.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: renuka apte <renuka_apte@yahoo.co.in>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Tue, 24 Apr 2007, renuka apte wrote:

> I am using a QLA2460 card. I was experiencing a problem with port
> entries not appearing under /sys/class/fc_hosts/. Through the dmesgs
> I realised it was happening as the firmware image could not be
> found, and I could get around the problem by disabling the
> ql2xfwloadbin module parameter. I would like to know whether having
> the firmware image is mandatory, or whether I should continue using
> this workaround.

Take a look at the driver's Kconfig file:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/scsi/qla2xxx/Kconfig;h=8c865b9e02b579f2d5bfc64a706fec3ea4063433;hb=HEAD

for details on where to retrieve and place the firmware images on your
local systems.

Regards,
Andrew Vasquez
