From: Mark Lord <kernel@teksavvy.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 07 Apr 2010 14:08:13 -0400
Message-ID: <4BBCCA0D.3000708@teksavvy.com>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org>	 <4BB61237.5030000@ru.mvista.com> <1270223970.2899.80.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1270223970.2899.80.camel@mulgrave.site>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Mark Lord <liml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On 02/04/10 11:59 AM, James Bottomley wrote:
> On Fri, 2010-04-02 at 19:50 +0400, Sergei Shtylyov wrote:
..
>>     IDENTIFY DEVICE command has *no* parameters.
>
> Alan was talking about ATA_16, which has to contain payload data in SCSI
> format for the encapsulation to work, so for a command that returns 512b
> the ATA_16 has to contain this as the data length.
>
> Sounds like a Mark Lord problem to me ... cc added.
..

Errr.. yes and no.

Yes, because nobody else is likely to do anything about it,
so I will work around the hardware bug by updating hdparm.

But no, there's no funky missing data length issue there.
Just a bridge chip that doesn't understand ATA_16 commands.

Apparently it *does* understand ATA_12 commands, though,
so perhaps hdparm will simply use ATA_12 for IDENTIFY from now on.

Cheers
