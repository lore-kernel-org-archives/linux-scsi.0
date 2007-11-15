From: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 15:59:36 -0600
Message-ID: <473CC148.9050106@nortel.com>
References: <664A4EBB07F29743873A87CF62C26D70B345BD@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zrtps0kn.nortel.com ([47.140.192.55]:35885 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbXKOV7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 16:59:51 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70B345BD@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Moore, Eric wrote:
> On Thursday, November 15, 2007 12:10 PM, Chris Friesen wrote:

>>Does this status mean that the command needs to be retried by the 
>>userspace app, that it has already been retried by the lower 
>>levels and 
>>is now completed, or something else entirely?

> The midlayer is retrying the command.  I pointed you to the code in the
> previous email.

James Smart just indicated that the midlayer was not retrying the 
command because it's sgio.  Is he mistaken?

If the midlayer is retrying the command, then what should the 
application do when it receives that status?


Chris


