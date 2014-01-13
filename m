From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Mon, 13 Jan 2014 15:39:07 -0800
Message-ID: <52D4791B.3030309@gmail.com>
References: <20140109235045.GA17660@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140109235045.GA17660@xanatos>
Sender: stable-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/09/2014 03:50 PM, Sarah Sharp wrote:

>>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
>>
>> I've wondered if my xhci problems might be caused by hardware quirks, and
>> wondering why I seem to be the only one who has this problem.
>>
>> Maybe I could "take one for the team" by buying new hardware toys that I
>> don't really need but I could use to test the xhci driver?  (I do enjoy
>> buying new toys, necessary, or, um, maybe not :)
> 
> It would be appreciated if you could see if your device causes other
> host controllers to fail.  Who am I to keep a geek from new toys? ;)

Sarah, I just fixed my xhci bug for US$19.99 :)

#lspci | tail -1
04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)

This new NEC usb3 controller does everything the ASMedia controller should have
done from the start.  I can even power-up the outboard usb3 disk docking station
after the computer is running and still everything Just Works :)

I appreciate all the debugging work you've done to fix the ASMedia problem but
I think it's time to quit now.  If hundreds of irate linux users complain about
the same bug then I'll be happy to test more patches.

Until then... :)
