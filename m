From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Date: Sat, 23 Feb 2008 18:53:14 -0500
Message-ID: <47C0B1EA.4010400@garzik.org>
References: <1203779614.3139.4.camel@localhost.localdomain>	<47C08134.2030205@garzik.org>	<alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org> <20080223124445.db779e3c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44115 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYBWXxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 18:53:18 -0500
In-Reply-To: <20080223124445.db779e3c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andrew Morton wrote:
> On Sat, 23 Feb 2008 12:31:02 -0800 (PST) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Sat, 23 Feb 2008, Jeff Garzik wrote:
>>> I know I am probably shooting myself in the foot here, since I am the original
>>> author of mvsas, but...
>>>
>>> Should we be adding new drivers during -rc?
>> I'm personally of the opinion that a new driver that doesn't add anything 
>> but itself (ie no infrastructure changes etc) is fine. I'd rather have a 
>> new, rough driver that might work, than no driver at all, and it's not 
>> like it can cause a regression if you don't enable it.
>>
> 
> Yes, I too think that adding new standalone code in late -rc is OK.

ACK, thanks!

	Jeff



