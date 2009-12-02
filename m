From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 0/3] qla2xxx: fixes for 2.6.32-rc8
Date: Wed, 2 Dec 2009 12:25:39 -0800
Message-ID: <7A072011-F24C-4044-98B3-BC650079EC85@qlogic.com>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com> <1259784260.5430.136.camel@mulgrave.site>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16715 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbZLBUZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 15:25:33 -0500
In-Reply-To: <1259784260.5430.136.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Dec 2, 2009, at 12:04 PM, James Bottomley wrote:

> On Wed, 2009-12-02 at 10:36 -0800, giridhar.malavali@qlogic.com wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>>
>> Please apply...
>>
>> Anirban Chakraborty (1):
>>  Fix to accommodate a hardware bug in multiqueue mode that does not
>>    work properly when acknowledgement of MSIX Interrupts is disabled.
>
> OK, so this looks like a bug fix
>
>> Giridhar Malavali (2):
>>  qla2xxx: Queue depth ramp up/down modification changes.
>
> But this looks like an enhancement
>
> Which tree did you want these in?  scsi-misc is fine ... if you want
> them in rc-fixes, I need the enhancement removed.
>

scsi-misc is fine

> Thanks,
>
> James
>
>

