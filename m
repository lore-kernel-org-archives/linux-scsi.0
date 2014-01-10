From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Fri, 10 Jan 2014 06:40:27 -0800
Message-ID: <52D0065B.4060905@gmail.com>
References: <20140109235045.GA17660@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140109235045.GA17660@xanatos>
Sender: linux-kernel-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/09/2014 03:50 PM, Sarah Sharp wrote:

>>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
>>
>> The aftermarket usb3 adapter card and the usb3 outboard hard-drive docking
>> station are the only two usb3 devices I have.
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

Thanks :)  Just to clarify, when you say 'your device' do you mean the
outboard disk docking station?  So I need to buy other host controllers,
not new docking stations?

> 
> In the meantime, try this patch, which is something of a long shot.

No difference.  But I notice the code enables the TRB quirk only if the
xhci_version is specifically 0x95.  My debug messages claim that "xHCI
doesn't need link TRB QUIRK" so I'm wondering if adding my asmedia device
to the quirks list really doesn't change anything unless it's xhci 0.95.

Does lspci provide that information?  I'm not seeing anything obvious.
