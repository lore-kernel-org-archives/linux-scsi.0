From: Andrew Buehler <abuehler.kernel@gmail.com>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sun, 17 Feb 2008 11:21:43 -0500
Message-ID: <47B85F17.5020407@gmail.com>
References: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:29498 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbYBQQVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 11:21:46 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1059340wxd.4
        for <linux-scsi@vger.kernel.org>; Sun, 17 Feb 2008 08:21:45 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, Kernel development list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 2/16/2008 10:35 PM, Alan Stern wrote:

> On Sat, 16 Feb 2008, Andrew Buehler wrote:
> 
>> Messages sent to my address directly are explicitly not filtered
>> into the folders I have set up for various mailing lists, so that
>> if someone does send me a "heads up" reply for a specific topic on
>> a list to which I am subscribed it does not get caught by the list
>> filter and fail to come to my attention. If a message fails to be
>> filtered into any mailing-list folder, then I should be able to
>> conclude that it is specifically intended for me, and not part of
>> normal mailing-list traffic. The practice of sending replies to
>> both addresses renders this an invalid conclusion. I do not think
>> that it is unreasonable to expect that conclusion to be valid.
> 
> It's not unreasonable.  Neither is Aristotelian physics.
> Nevertheless, neither one is a good match to reality.
> 
> Why not arrange instead that messages sent from a mailing list server
> _do_ get filtered into the corresponding folder, even if they were
> also sent to your address?  This certainly should make your
> assumption (that messages not filtered into any mailing-list folder
> are specifically intended for you) much more valid than it is now.

Two reasons that I can think of off the top of my head.

One of them I mentioned above: because that precludes the possibility of
someone sending me a direct copy to draw my attention to something which
they think needs it, unless they send it separately from the list copy.
(This does not especially apply on the kernel-related mailing lists,
since no one is likely to think I am particularly worth drawing in to
any discussion there anytime soon, but it has come up elsewhere and the
basic principle is the same.)

The other is that this would lead to duplicate copies of the same reply
in the mailing list folder, which is ugly at best, especially with
respect to proper threading.

>> Until this thread, I was not even aware that ACPI was related to
>> USB; I had largely conflated it with a similar acronym which I
>> think is related to power management and which I can suddenly not
>> even find in my kernel config. I will, however, look into
>> linux-acpi.
> 
> ACPI isn't directly related to USB; rather it has to do with
> transferring information between the OS and the 
> BIOS/vendor-specific-hardware.  Power management is example where
> such a transfer is needed.  In your case, the relevant information is
> which IRQ is connected to which motherboard device.  If you don't
> have ACPI enabled in your configuration, then perhaps that's the
> problem -- try enabling it.

It is indeed not enabled, and when I check the config for the 2.6.23.1
kernel where USB works, I find that it is enabled there. I will test the
result of enabling it in the current kernel. If I don't have an answer
by the end of the day, I probably won't be able to get one until at
least Tuesday.

>> That will not be helpful for the other two problems, however, since
>> neither of them was ever working as far as I am aware. That also
>> leaves me hesitant to conclude that they are rooted in the same IRQ
>> issue as the USB problem appears to be.
> 
> Maybe they aren't.  But when you have multiple bugs, you have to fix
> them one at a time.

Oh, I agree - that is a large part of why I posted a "full" description
of only one problem initially, rather than all three in a single mail.

-- 
    Andrew Buehler
