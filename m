From: Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 15:24:12 -0400
Message-ID: <4BCF50DC.20205@pobox.com>
References: <Pine.LNX.4.44L0.1004211506040.1422-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1004211506040.1422-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 21/04/10 03:07 PM, Alan Stern wrote:
> On Wed, 21 Apr 2010, Jonas Schwertfeger wrote:
>
>> On 04/21/2010 08:17 PM, Mark Lord wrote:
>>
>>   >  Let's try again. Does the attached copy of hdparm work for everybody
>>   >  now? It uses ATA_16 by default, for everything.
>>
>> No, it doesn't:
>>
>> /dev/sdb:
>> outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
>> data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> That line is supposed to be the data returned by the drive?  It sure
> doesn't look right.
>
> Jonas, can you run the same test, but this time with the drive attached
> to your EHCI controller, and get a usbmon log?
..

Yeah, I am also curious about that,
how it works (or not) when connected via a USB2 cable
instead of USB3.

Thanks
-- 
Mark Lord
Real-Time Remedies Inc.
mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
