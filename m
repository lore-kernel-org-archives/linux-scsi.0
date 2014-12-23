From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Date: Tue, 23 Dec 2014 10:58:25 +0800
Message-ID: <5498DA51.7030207@gmail.com>
References: <548FCD81.7030106@gmail.com> <20141217093027.GA13198@infradead.org> <54924CEA.3060808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47920 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaLWC6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2014 21:58:30 -0500
In-Reply-To: <54924CEA.3060808@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On 12/18/2014 11:41 AM, Charles Chiou wrote:
>
>
> On 12/17/2014 05:30 PM, Christoph Hellwig wrote:
>> I'm not going to add a new reboot notifier for a driver.  If you can
>> convince the driver model / PM people to pass this information to
>> ->shutdown we can add support for this difference, but not in this way.
>>
>> Can you send me a series that just adds the hardware support for now, so
>> we can dash this PM issue out separately?
>>
>
> Hi, we need to provide this information to our device.
> We face the HW signal issue on various motherboards.
> We experiment on many motherboards, and we observe that the restart
> signal is different on different motherboard. If device misses the
> signal, PCI loss or volume disappearance might happen.
>
>
> To make power management easier, driver provide the shutdown or reboot
> information to the device.
>
> Sorry, I'm not understand what is meaning of "series".
> Could you specify what you what me to send you?
> Thank you
>
> BRS
> Charles
>


Hi, after our internal discussion, we can use shutdown flow for reboot 
temporarily. Some signal issue will happen (depend on MB), and it can be 
fixed by plug in and plug out manually. We will add reboot feature after 
PM can pass reboot information to ->shutdown.

BRS
Charles
