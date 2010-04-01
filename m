From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 1 Apr 2010 15:42:11 +0200
Message-ID: <s2zac3eb2511004010642ic2e8f973h2e038d3c90c6ca75@mail.gmail.com>
References: <4BB37454.8070808@interlog.com> <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
	<n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 1, 2010 at 15:32, Jonas Schwertfeger
<jschwertfeger@gmail.com> wrote:
> On Wed, Mar 31, 2010 at 6:36 PM, Alan Stern <stern@rowland.harvard.ed=
u> wrote:
>> On Wed, 31 Mar 2010, Douglas Gilbert wrote:
>>
>>> > Stock udev comes with ata_id which I think may be invoked for thi=
s
>>> > device (but I'm not sure). Try moving it out of the way?
>>
>> Jonas, these sound like good things to try. =C2=A0Find the ata_id an=
d udisks
>> programs on your computer and rename them so they can't be run
>> automatically. =C2=A0Then see if the problem still occurs.
>
> Renamed both /usr/bin/udisks

That's the commandline tool, you need to check for something like:
  /usr/lib/udisks/udisks-daemon

Can you run as root:
  udevadm test /sys/class/block/sd...
and post the output here. So we see what udev would run on bootup.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
