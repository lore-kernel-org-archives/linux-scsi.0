From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 12:57:37 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B345BD@NAMAIL4.ad.lsil.com>
References: <473C997A.90404@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64520 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXKOT5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 14:57:55 -0500
Content-class: urn:content-classes:message
In-Reply-To: <473C997A.90404@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Thursday, November 15, 2007 12:10 PM, Chris Friesen wrote:
> 
> My impression is that the per-device queue is supposed to be 
> decreased 
> at runtime to match the actual size that the hardware can handle.  In 
> the earlier version we're seeing the queue set to 7 at runtime, while 
> the more recent version is showing a queue depth of 32 or 64 and is 
> giving QUEUE_FULL errors to the userspace apps.
> 

The per-device queue is a hard coded value.   We don't know what the
queue depth of each device attached to the controller.   


> 
> I don't know the scsi code very well, so maybe I'm missing something 
> obvious here.  If so, I apologize.
> 
> Our userspace apps are getting a status of TASK_SET_FULL on 
> completion 
> of an ioctl() call.
> 
> Does this status mean that the command needs to be retried by the 
> userspace app, that it has already been retried by the lower 
> levels and 
> is now completed, or something else entirely?
> 

The midlayer is retrying the command.  I pointed you to the code in the
previous email.

Eric
