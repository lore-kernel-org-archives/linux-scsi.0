From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: RE: Disk Exerciser
Date: Mon, 8 Apr 2002 14:02:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0204081359260.18626-100000@dragon.pdx.osdl.net>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F12C539@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F12C539@nonamea.ptu.promise.com>
List-Id: linux-scsi@vger.kernel.org
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: Aron Zeh <ARZEH@de.ibm.com>, linux-scsi@vger.kernel.org

Hi-

You should make sure that the iozone data file is significantly
larger than your system memory, by either making the file
larger or reducing system memory (for example, use "mem=NNN"
on the kernel command line).

Otherwise the I/O can just be done in page cache, not to the
physical device.

This is documented in the run rules for iozone.

...or are you having a different kind of problem?
Maybe I didn't understand the problem.

~Randy

On Mon, 8 Apr 2002, Haofeng Kou wrote:

| The iozone doesn't access the SCSI drive's IO, but it keep display the
| data without error report.
|
| Anyone has meet this before?
|
| -----Original Message-----
| From: Aron Zeh [mailto:ARZEH@de.ibm.com]
| Sent: Tuesday, April 02, 2002 3:25 PM
| To: Haofeng Kou
| Cc: linux-scsi@vger.kernel.org
| Subject: Re: Disk Exerciser
|
| Hello Haofeng,
|
| I think Iozone (www.iozone.org) or
| bonnie++(http://www.coker.com.au/bonnie++/) might just do the trick.
|
| Aron
|
| "Haofeng Kou" <haofengk@ptu.promise.com>@vger.kernel.org on 04/03/2002
| 12:41:06 AM
|
| Please respond to "Haofeng Kou" <haofengk@ptu.promise.com>
|
| Sent by:    linux-scsi-owner@vger.kernel.org
|
| To:    <linux-scsi@vger.kernel.org>
| cc:
| Subject:    Disk Exerciser
|
| Dear         friends,
|
| Any one know certain Disk Exerciser tools, which can be used to test the
| performance of the SCSI RAID Controller for the HardDisk? The tools need
| to be running on the Linux for the Xscale(IQ80310) board, also the
| source code is necessary for me because I plan to modify it suitable for
| my project.
|
| Thanks!
| haofeng
| -

