From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Updated linux uas driver, please test
Date: Wed, 10 Sep 2014 16:54:32 -0400
Message-ID: <5410BA88.9090508@interlog.com>
References: <54104070.20606@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:45541 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaIJUyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 16:54:44 -0400
In-Reply-To: <54104070.20606@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, daveiro@hotmail.com, tuxoko@gmail.com, sumit.tiwari1943@gmail.com, wolput@on.nl, claudio.bizzarri@gmail.com
Cc: linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On 14-09-10 08:13 AM, Hans de Goede wrote:
> Hi All,
>
> I'm mailing all of you because you've reported various problems
> with the new uas support in kernel 3.16 and later.
>
> I've been working on making the uas driver more resilient to
> errors, as well as improved logging so we can easier figure
> out the cause of errors.
>
> I would like to ask you all to test a standalone version of
> the new uas driver with the devices you've been having
> trouble with before, and report the results to me.
>
> Testing instructions:
>
> 1) Remove any usb-storage.quirks= setting from the kernel commandline,
> and remove any /etc/modprobe.conf* files doing the same, boot your
> machine without the uas device attached.
>
> 2) Make sure your machine is set up for building kernel modules,
> usually this means installing kernel-devel and gcc packages, see
> your distributions documentation for more info
>
> 3) Download all files from here:
> https://fedorapeople.org/~jwrdegoede/uas/
> And put them all in a single directory, named e.g. uas
>
> 4) Start a terminal, cd into the uas directory
>
> 5) Run the following commands:
> make
> sudo rmmod uas
> sudo insmod ./uas.ko
>
> 6) Connect your uas device
>
> 7) Wait for the disk to show up (wait circa 1 minute max), then do:
>
> dmesg > dmesg.log
> lsusb -v > lsusb.log
>
> 8) Test the uas disk
>
> Once done please send me a mail, in this mail please
>
> 1) Describe how the disk worked, did it show up in a reasonable time,
> and did it work?
>
> 2) Attach dmesg.log and lsusb.log

Could you give some sort of indication of the dd throughput
time (on READs) with UAS given a recent SATA SSD that can
source data faster than 300 MB/sec (say)?


My ASM1051 based dock under W7 got an underwhelming maximum
of 42 MB/sec with such a SATA SSD. And I saw enough stupid
meta-data from SCSI commands to suggest that product should
be binned.

Doug Gilbert


