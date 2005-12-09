From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version
 of iscsi target?
Date: Fri, 09 Dec 2005 18:29:45 +0300
Message-ID: <4399A2E9.6000908@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>	 <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net>	 <4398850D.8070102@cs.wisc.edu> <1134071290.3259.31.camel@mulgrave> <439892FC.8040900@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:15553 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S964787AbVLIP3l
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 10:29:41 -0500
In-Reply-To: <439892FC.8040900@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Mike Christie wrote:
> James Bottomley wrote:
> 
>> On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
>>
>>> cleanup. In the end some of the scsi people liked the idea of 
>>> throwing the non-read/write command to userspace and to do this we 
>>> just decided to start over but I have been cutting and pasting your 
>>> code and cleaning it up as I add more stuff.
>>
>>
>>
>> To be honest, I'd like to see all command processing at user level
>> (including read/write ... for block devices, it shouldn't be that
>> inefficient, since you're merely going to say remap an area from one
>> device to another; as long as no data transformation ever occurs, the
>> user never touches the data and it all remains in the kernel page
>> cache).
> 
> 
> Ok, Tomo and I briefly talked about this when we saw Jeff's post about 
> doing block layer drivers in userspace on lkml. I think we were somewhat 
> prepared for this given some of your other replies.

Could you give me a reference on this message, please?

> So Vlad and other target guys what do you think? Vlad are you going to 
> continue to maintain scst as kernel only, or is there some place we can 
> work together on this on - if your feelings are not hurt too much that 
> is :) ?

 From one side, I hate dropping anything in the point where it isn't 
somehow completed. From other side, I don't have much time to spend on 
this my hobby. Nobody pays me for that, it's just for fun.

Vlad


