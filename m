From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.07 available
Date: Sat, 21 Jan 2012 20:52:14 -0500
Message-ID: <4F1B6BCE.3070105@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>, kumba@gentoo.org, =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD/BD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the Linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since October 2010.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html


ChangeLog for sdparm-1.07 [20120121] [svn: r188]
   - LB provisioning + Block limits VPD pages to sbc3r27
   - Enhanced phy control page: optical mode enabled (spl-r07)
   - Phy control and discover page: sync to spl2r02
   - sync with spc4r31+32 (handle status good with sense)
   - extended inquiry VPD: add POA_SUP, HRA_SUP and VSA_SUP
   - application tag mode page subcode 0xf0->0x2 (sbc3r28)
   - add 'sinq' pseudo VPD page for standard inquiry response
   - add power consumption mode and VPD pages (spc4r33)
   - point out some mode page numbers are vendor specific

ChangeLog for sdparm-1.06 [20101031] [svn: r166]
   ...

Doug Gilbert
