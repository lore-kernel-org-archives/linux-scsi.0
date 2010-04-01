From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 1 Apr 2010 15:32:12 +0200
Message-ID: <n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
References: <4BB37454.8070808@interlog.com> <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 31, 2010 at 6:36 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Wed, 31 Mar 2010, Douglas Gilbert wrote:
>
>> > Stock udev comes with ata_id which I think may be invoked for this
>> > device (but I'm not sure). Try moving it out of the way?
>
> Jonas, these sound like good things to try. =A0Find the ata_id and ud=
isks
> programs on your computer and rename them so they can't be run
> automatically. =A0Then see if the problem still occurs.

Renamed both /usr/bin/udisks and /lib/udev/ata_id but the problem still=
 occurs.

-Jnoas
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
