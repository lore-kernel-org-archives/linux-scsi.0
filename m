From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID v.96 for 2.6.9-rc2
Date: Tue, 21 Sep 2004 15:26:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41508055.6000401@pobox.com>
References: <4150666A.90807@rtr.ca> <41506BBE.2050507@rtr.ca> <4150712F.3080504@pobox.com> <41507F21.8010800@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3538 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268004AbUIUT02
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 15:26:28 -0400
In-Reply-To: <41507F21.8010800@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
> 
>>
>> Where is this seperate RAID management module?  :)
>>
>> Typically we do not add kernel hooks to non-public stuff...
> 
> 
> It is still under development.  The vendor will likely
> distribute it in source code form with the product installation disk,
> since it is likely to undergo far more frequent updates that the
> base kernel driver.
> 
> This allows them to decouple the portion not needed at boot-time,
> from the more difficult to change kernel code that has to be
> there to boot the system on RAID.


Regardless, if the RAID code isn't in the kernel or otherwise posted 
somewhere publicly and GPL'd, the hooks are unlikely to be accepted.

	Jeff


