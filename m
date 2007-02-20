From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] SG: cap reserved_size values at max_sectors
Date: Tue, 20 Feb 2007 13:43:18 -0600
Message-ID: <45DB4F56.2070006@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0702201310340.8957-100000@iolanthe.rowland.org> <45DB4CA7.5090007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55109 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001AbXBTTnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Feb 2007 14:43:35 -0500
In-Reply-To: <45DB4CA7.5090007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Yeah you are right getting memory is not a problem I replied about that
> in the other mail. You do not have to use it, but the min of the
> reserved buffer and max_sectors or max_hw_sectors could still be off for
> drivers that do not support clustering or if there is a weird arch
> segment boundary or limit (maybe the arch segment limits and boundary is
> not used much though).
> 
Oh yeah, to handle the clustering I think you could just stick a check
in the sg reserved buffer allocation code to handle that. You could also
stick the max sectors check in there too if you wanted the reserved
buffer to then reflect what was reserved and what a device could handle
at the same time. I am not sure about those other arch segment limits
though. I though I saw something from parsic or something before, but I
am still working on the reserved buffer fixes and just stared digging
into that.
