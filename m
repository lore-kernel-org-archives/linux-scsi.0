From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Thu, 2 Sep 2010 10:29:31 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1009021025190.16817@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
 <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan> <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan> <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan> <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan> <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
 <alpine.DEB.2.00.1009020540500.22317@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009020540500.22317@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Thu, 2 Sep 2010, Justin Piszcz wrote:

>
>
> On Wed, 1 Sep 2010, adam radford wrote:
>
>> On Wed, Sep 1, 2010 at 2:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> 
>> wrote:
>> 
>>> Could the lock/unlock be causing the issue?
>>> Again, in 2.6.34, there are no latency problems or controller resets.
>> 
>> Justin,
>> 
>> We are looking into this issue and should get back to you soon.
>> 
>> The lock/unlock() kernel calls were not added by me but were part of a
>> series of 'BKL pushdown' patches added by someone to all drivers with
>> an ioctl interface.  If you think those might be related to your
>> issue, you could try
>> removing those 2 lines of code and recompiling.
>> 
>> If you haven't already, please email you kernel .config files for both
>> the working kernel and non working kernel to the 3ware/LSI support
>> people you are in contact with.
>> 
>> Thanks.
>> 
>> -Adam
>> 
>

I spoke too fast, it also happens with the 2.6.34 driver under 2.6.35.
I will have to research this more, until then I'll stick with 2.6.34.

Justin.
