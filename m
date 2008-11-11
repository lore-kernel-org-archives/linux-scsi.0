From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Question about spun-down USB disk
Date: Tue, 11 Nov 2008 19:27:43 +0100
Message-ID: <4919CE9F.80304@s5r6.in-berlin.de>
References: <4918cdb1.2208420a.0cdf.5972@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41009 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYKKS1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 13:27:51 -0500
In-Reply-To: <4918cdb1.2208420a.0cdf.5972@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kitgerrits@gmail.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

Kit Gerrits wrote:
...
> If, for some reason, a program wants to write to a file on there without
> spinning the drive up in advance, the error pops up.
> Mind you, I haven't had the error in days now.
> 
> All I'm looking for is a way to increase the time the O/S waits for the disk
> to spin up.

Try the /sys/bus/scsi/devices/*:*:*:*/timeout attribute.

Of course increasing the timeout isn't a particularly sophisticated
method to solve the issue, but simple enough to try.  The default
timeout is 30 seconds: linux/drivers/scsi/sd.h::SD_TIMEOUT.  Can an HDD
really take longer than that to receive a request when spun down, spin
up, execute the request, and return status?
-- 
Stefan Richter
-=====-==--- =-== -=-==
http://arcgraph.de/sr/
