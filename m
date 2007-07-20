From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ESP SCSI and QLGC,ISP SCSI drivers not finding attached devices
Date: Fri, 20 Jul 2007 11:57:26 -0500
Message-ID: <1184950646.3455.45.camel@localhost.localdomain>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
	 <1184941136.3455.8.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33786 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935974AbXGTQ52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 12:57:28 -0400
In-Reply-To: <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2007-07-20 at 16:22 +0100, Mark Fortescue wrote:
> Thansk for the info. I will try some experiments and see if I can work 
> out where the scsi commands/responses are getting lost.

Actually, for ESP it looks like you can alter the timeout ... it's the
parameter ESP_BUS_TIMEOUT in drivers/scsi/esp_scsi.h

It could be that the register calculation is off here ... but someone
who knows the device would have to look at it (or you could time it, I
suppose).

> I do not beleave the issue with the ESP is a hardware problem. The PROM 
> and SunOS-4.1.1 have no problem finding/accessing the disk on the ESP and 
> I did not observe any issues prior to testing Linux v2.6.22. The V1 ESP 
> SCSI driver never failed to find the ESP disk (on kernels that got that 
> far) but I have not done as much testing with the V2 ESP driver as memory 
> problems post v2.6.21 needed to be fixed to get things up and running.

James


