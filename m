From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Tue, 14 Jan 2014 13:27:25 -0800
Message-ID: <52D5ABBD.7090202@gmail.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140114172056.GB12126@xanatos>
Sender: stable-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/14/2014 09:20 AM, Sarah Sharp wrote:
> On Mon, Jan 13, 2014 at 03:39:07PM -0800, walt wrote:

>> Sarah, I just fixed my xhci bug for US$19.99 :)
>>
>> #lspci | tail -1
>> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
>>
>> This new NEC usb3 controller does everything the ASMedia controller should have
>> done from the start.

 
> I just got a similar report from someone with a Fresco Logic host
> controller, so I may need you to test a work-around patch for the
> ASMedia host at some point.

Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
docking station, too.)

I can't believe the adapter works perfectly in a different computer.  Have you
seen this kind of thing before?

At the moment I have two machines using your xhci driver and both work perfectly,
so I thank you again :)

I'm not sure where to go with this next.  I could put the adapter back in the
other machine again if you have more patches to test.
