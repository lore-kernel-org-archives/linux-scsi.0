From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Patch] sg: fix device number in blktrace data
Date: Fri, 30 Jan 2009 11:24:32 -0500
Message-ID: <498329C0.5010704@interlog.com>
References: <1233326783.929.6.camel@kitka.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45877 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZA3QYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2009 11:24:40 -0500
In-Reply-To: <1233326783.929.6.camel@kitka.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

Martin Peschke wrote:
> Hi,
> 
> we have run into an issue with blktrace being started for sg devices.
> Please apply.
> 
> Thanks,
> Martin
> 
> 
> 
> From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> 
> The device number denoting a generic SCSI devices (sg) in a blktrace
> trace is broken; major and minor are always 0. It looks like
> sdp->device->sdev_gendev.devt is not initialized properly.
> The fix below uses other data to make up a valid device number,
> similar to the way an sg device number is generated for sysfs output.
> 
> Reported-by: Stefan Raspl <raspl@linux.vnet.ibm.com>
> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
