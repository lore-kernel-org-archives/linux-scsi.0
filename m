From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 06 Apr 2010 16:56:48 +0200
Message-ID: <4BBB4BB0.9040203@gmail.com>
References: <Pine.LNX.4.44L0.1004061048590.1722-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1004061048590.1722-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Lord <mlord@pobox.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

Argh, I'll send you the correct trace in a bit.

On 04/06/2010 04:49 PM, Alan Stern wrote:
> On Tue, 6 Apr 2010, Jonas Schwertfeger wrote:
>
>> Here is the trace after limiting memory to 900M:
>>
>> ffff88001fc82780 3529669229 S Bo:10:002:2 -115 31 = 55534243 ca000000
>> 00020000 80001085 082e0000 00000000 00000000 40ec00
>
> This trace was made using the original version of hdparm, not the
> updated version.
>
> Alan Stern
>
