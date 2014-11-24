From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: AW: ARCMSR - Notify sense data report - Lost patch?
Date: Mon, 24 Nov 2014 15:47:56 +0100
Message-ID: <5473451C.1040400@redhat.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C1FC8@EXCHANGE.collogia.de>,<20141124132331.GA4179@infradead.org> <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C20B0@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaKXOs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 09:48:26 -0500
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F8C20B0@EXCHANGE.collogia.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>, Christoph Hellwig <hch@infradead.org>
Cc: "ching2048@areca.com.tw" <ching2048@areca.com.tw>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/24/2014 02:45 PM, Markus Stockhausen wrote:
>> Von: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org]&quot; im Auftrag von &quot;Christoph Hellwig [hch@infradead.org]
>> Gesendet: Montag, 24. November 2014 14:23
>> An: Markus Stockhausen
>> Cc: ching2048@areca.com.tw; thenzl@redhat.com; linux-scsi@vger.kernel.org
>> Betreff: Re: ARCMSR - Notify sense data report - Lost patch?
>>
>> On Mon, Nov 24, 2014 at 11:47:02AM +0000, Markus Stockhausen wrote:
>>> Hi,
>>>
>>> sorting out some diffs between the official Arcea driver and
>>> the newest 3.18 patches I found a patch that might got lost:
>>>
>>> https://lkml.org/lkml/2014/2/20/956
>>>
>>> Could you check if that is desired?
>> Looks sensible to me.  Did you test it?
> No not really, as I don't know how. We had a controller crash the last
> week and I was wondering about the differences between vendor and
> upstream version. So I basically did some code comparison between 
> the two source. Besides a lot of layout differences and other hacks 
> this was one of the first things I noticed and wondered what difference 
> those flags could make. Especially regarding stability.
>
> Hopefully Ching and/or Tomas know better as they seem repsonsible 
> for the rest of the 3.18 arcmsr patches.

I don't know why Ching hasn't re-posted this in later series.
The Areca in-house driver works stable?

>
> Markus

