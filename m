From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Mon, 04 Feb 2008 10:30:12 -0500
Message-ID: <47A72F84.8000203@garzik.org>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org> <20080202175738.GA26560@elte.hu> <47A4BB3C.6050709@garzik.org> <20080202193524.GC27927@elte.hu> <47A4D71F.3060009@garzik.org> <20080204125736.GA32056@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46355 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbYBDPa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 10:30:56 -0500
In-Reply-To: <20080204125736.GA32056@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Ingo Molnar wrote:
>>> so please tell me Jeff. If Greg, who is the super-maintainer of your 
>>> code area, and who deals with your code every day and changes it 
>>> every minute and hour, simply did not Cc: the SCSI list - how am i, a 
>>> largely outside party in this matter, supposed to notice that 3 
>>> maintainers and 3 mailing lists in the Cc: were somehow not enough 
>>> and that i was supposed to grow the already sizable Cc: list even 
>>> more?
>> Because, regardless of the situation, it's both common courtesy and 
>> wise practice to CC relevant driver maintainers, when you touch a 
>> driver.
>>
>> And it's just common sense: Greg simply does not know the intimate 
>> details of every PCI driver.  Nor do I.  Nor you.
>>
>> In the case of lpfc here, we have an active driver maintainer, and an 
>> up-to-date MAINTAINERS entry.  Even if you are too slack to read 
>> MAINTAINERS, 'git log' would have given you the same info.
>>
>> Don't pretend there is some benefit here to ignoring the people that 
>> best know the driver.  I don't buy that; it simply makes no 
>> engineering sense whatsoever.
> 
> what you _STILL_ do not realize is the following: you still attribute 
> the lack of Cc:s to some intention of mine. No, it was not my intention. 

I was never speaking to intent.

I was noting that, having been in the kernel community for years, both 
of you guys should know that you should always CC a driver author, when 
touching their driver.

Even after this thread, I have not even heard a "yes, I agree, I should 
have CC'd the driver author since they know the most about the driver" 
from either of you, which is quite disappointing.

Instead, I get this long thread in response...


>   is just super fragile and does not serve users at all. Even Greg and i 
>   got it wrong accidentally. If _we_ get it wrong, who will get it 

Sure.  But... do you agree the CC list should have included the driver 
author?  Do you agree that a mistake was made in this case?

	Jeff


