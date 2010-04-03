From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Sat, 03 Apr 2010 17:40:40 +0200
Message-ID: <4BB76178.70008@gmail.com>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org> <4BB61237.5030000@ru.mvista.com> <4BB61975.1070406@interlog.com> <4BB61DAF.7090709@interlog.com> <4BB66077.3060202@pobox.com> <4BB6DE77.4070409@gmail.com> <4BB73EB3.3040308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:50532 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0DCPkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2010 11:40:45 -0400
In-Reply-To: <4BB73EB3.3040308@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>

On 04/03/2010 03:12 PM, Mark Lord wrote:
 > Here's the pre-release, attached to this email.
 > Please do give it a try and report back.

Doesn't seem to fix it. Here's the output:

sudo ./hdparm --verbose /dev/sdb

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 ec 00
data:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: ATA_16 status=0x0, host_status=0x0, driver_status=0x0
SG_IO: bad response (not CHECK_CONDITION)
Trying legacy HDIO_DRIVE_CMD
outgoing cdb:  85 08 2e 00 00 00 01 00 00 00 00 00 00 40 a1 00
data:  40 00 ff 3f 37 c8 10 00 00 00 00 00 3f 00 00 00
SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[]:  72 0b 00 00 00 00 00 0e 09 0c 00 04 00 01 00 00 00 00 00 
00 40 51 00 00 00 00 00 00 00 00 00 00
SG_IO: desc[]:  09 0c 00 04 00 01 00 00 00 00 00 00
       ATA_16 stat=51 err=04 nsect=01 lbal=00 lbam=00 lbah=00 dev=40
I/O error, ata_op=0xa1 ata_status=0x51 ata_error=0x04
  HDIO_DRIVE_CMD(identify) failed: Input/output error
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 121601/255/63, sectors = 1953525168, start = 0

-Jonas
