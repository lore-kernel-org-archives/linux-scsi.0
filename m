From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Tue, 30 Nov 2010 18:44:51 +0200
Message-ID: <4CF52A03.2000704@panasas.com>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local> <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de> <4CF521DE.7020800@panasas.com> <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:18481 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0K3Qox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 11:44:53 -0500
In-Reply-To: <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, linux-scsi@vger.kernel.org

On 11/30/2010 06:23 PM, Kai Makisara wrote:
> On Tue, 30 Nov 2010, Boaz Harrosh wrote:
> 
>> On 11/30/2010 03:31 PM, Lukas Kolbe wrote:
>>> On Mon, 2010-11-29 at 19:09 +0200, Kai Makisara wrote:
>>>
> ....
>> It looks like something is broken/old-code in sr. Most important LLDs
>> and block-layer scsi-ml fully support sg-chaining that effectively are
>> able to deliver limitless (Only limited by HW) sg sizes. It looks like
>> sr has some code that tries to allocate contiguous buffers larger than
>> PAGE_SIZE. Why does it do that? It should not be necessary any more.
>>
> The relevant driver is st 

Sorry I meant st, yes.

> and it use sg chaining when necessary. I tried 
> to explain that the effective limit in this case comes from mptsas. I 
> don't know if it is HW limit or driver limit.
> 

Than I don't understand where is the failing allocation. Where in the
code path anyone is trying to allocate something bigger then a page?
Please explain?

> Kai
> 

Thanks
Boaz
