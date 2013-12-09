From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: CONFIG_SCSI_MULTI_LUN default
Date: Mon, 09 Dec 2013 19:43:55 +0100
Message-ID: <52A60F6B.6040700@interlog.com>
References: <Pine.LNX.4.44L0.1312091322070.1439-100000@iolanthe.rowland.org> <1386614243.2028.101.camel@dabdike.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53775 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab3LISoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Dec 2013 13:44:01 -0500
In-Reply-To: <1386614243.2028.101.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 13-12-09 07:37 PM, James Bottomley wrote:
> On Mon, 2013-12-09 at 13:24 -0500, Alan Stern wrote:
>> James:
>>
>> Is there any good reason why CONFIG_SCSI_MULTI_LUN still doesn't
>> default to Y?
>
> Assuming we've got all the screw ups (mostly CD ROMS) blacklisted, I
> think the only real reason is that some SCSI-2 devices don't respond to
> stuff not on LUN 0, so it keeps the boot process quick.
>
> There isn't really any reason to change it, though, is there?  The
> option only applies to SCSI-2 and below devices which should be a self
> obsoleting class as their motors start to burn out.

and a couple of billion USB keys.

