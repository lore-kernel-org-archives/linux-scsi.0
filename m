From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: mac scsi, ncr5380
Date: Thu, 02 Oct 2008 11:33:42 +0300
Message-ID: <48E48766.4010903@panasas.com>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au> <48DF8398.30000@panasas.com> <Pine.LNX.4.64.0810011703120.13318@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:5999 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669AbYJBIdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 04:33:47 -0400
In-Reply-To: <Pine.LNX.4.64.0810011703120.13318@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, Christoph Hellwig <hch@infradead.org>

Finn Thain wrote:
> 
> On Sun, 28 Sep 2008, Boaz Harrosh wrote:
> 
>> From what I understand, (And again I do not), the ESP sounds a lot like 
>> the NCR5380. I would craft a very similar copy of the new ESP stack, 
>> with it's central library and function-vector registration, The 
>> scsi-generic part is all there, in full glory. Then one concentrated 
>> effort should go into the basic/general chip programing, which lots of 
>> it could be ripped from current code, and the different platform 
>> implementation becomes one liners, if the new ESP stack is any 
>> indication.
> 
> I still do not understand the whole ESP driver but when I wrote mac_esp.c 
> I learned the value of the layered structure it provided.
> 
> I still have a lot to learn about the SCSI layers and the APIs too. I'm 
> reading Documentation/scsi at the moment. If you know of any other 
> introductory reading material, that would be a help.
> 

I don't know anything about the ESP driver, You should contact
David S. Miller, Perhaps he will have some time to help you.

The SCSI-API I know more about. Please don't hesitate to ask 
any question, I will be glad to answer.

>> From my passed experience, there becomes a source code state when a 
>> rewrite is less effort then any cleanup or enhancements. From the small 
>> changes I had to do to the xxx_NCR5380 family of drivers, my guts 
>> feeling scream "rewrite", so here I voice them. In the mid/long-term you 
>> will work much less. And be much more satisfied from the results.
> 
> This makes sense. Thanks for your feedback.
> 
> Finn
> 
>> Good lock
>> Boaz
>> --

Thanks for looking into this. We are here for any assistance
Boaz
