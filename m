From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 20:27:32 +0200
Message-ID: <4BCF4394.3080701@gmail.com>
References: <Pine.LNX.4.44L0.1004201533220.1837-100000@iolanthe.rowland.org> <4BCF0605.7080508@pobox.com> <4BCF4120.4060806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BCF4120.4060806@pobox.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 04/21/2010 08:17 PM, Mark Lord wrote:

 > Let's try again. Does the attached copy of hdparm work for everybody
 > now? It uses ATA_16 by default, for everything.

No, it doesn't:

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
