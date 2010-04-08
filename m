From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 08 Apr 2010 07:06:45 +0200
Message-ID: <4BBD6465.2070006@gmail.com>
References: <Pine.LNX.4.44L0.1004071516260.5760-100000@iolanthe.rowland.org> <4BBD0C0D.5060606@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BBD0C0D.5060606@teksavvy.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@suse.de>, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Mark Lord <liml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On 04/08/2010 12:49 AM, Mark Lord wrote:
> I do have a pre-release HDPARM that uses ATA_12 for IDENTIFY,
> as this is reported to work on this hardware, even though it is
> otherwise _identical_ to the command issue via ATA_16.
> That's another indication of a buggy/inconsistent bridge chip.
>
> And I've also added a sector count of "1" to hdparm's IDENTIFY
> commands. Properly implemented hardware/software will just ignore it
> as usual, but this bridge might benefit from it.
>
> Anyone want to give this second update a try?

Sure.

-Jonas
