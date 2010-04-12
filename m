From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Mon, 12 Apr 2010 09:48:25 +0200
Message-ID: <4BC2D049.1090606@gmail.com>
References: <4BBF6B2F.9060902@gmail.com> <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org> <20100409215439.GA4779@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20100409215439.GA4779@xanatos>
Sender: linux-hotplug-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 04/09/2010 11:54 PM, Sarah Sharp wrote:
>> Now that you mention it, we don't know what sort of chip you have.
>> Only that the vendor ID is 0x0411 (MelCo., Inc.) and the product ID is
>> 0x0184.

Buffalo is part of the MelCo Inc. holding.

> I've just opened the case on my Buffalo hard drive, and the circuit just
> says Buffalo.  There's an ARM chip and a winbond chip, but not much else
> to identify it.  I'll ask around the USB-IF PIL lab to try and get a
> company contact.

The ARM chip in the Buffalo USB3 drive is the USB3-SATA bridge MB86C30A 
by Fujitsu: 
http://www.fujitsu.com/downloads/EDG/binary/pdf/catalogs/a04000431e.pdf

My guess would be that any drive using this chip will choke on the 
identify command. Sarah, any chance you could get a contact at Fujitsu?

-Jonas
