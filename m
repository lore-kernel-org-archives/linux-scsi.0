From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.04 available
Date: Sat, 03 Oct 2009 00:07:32 -0400
Message-ID: <4AC6CE04.20901@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751514AbZJCEHg@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>, kumba@gentoo.org
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
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since June 2008.


ChangeLog for sdparm-1.04 [20090920] [svn: r129]
   - add SAT ATA Power condition mode page (sat2r06)
   - add SBC Thin provisioning mode page (sbc3r20)
   - add SBC Thin provisioning VPD page (sbc3r20)
   - sync with spc4r21
   - add Power condition, update extended inquiry VPD pages
   - smc3: add Device capabilities + Extended device
     capabilities + Transport geometry parameters mode pages
   - prepare for Thin provisioning VPD and mode pages
   - expand block limits VPD page
   - update Power condition mode page
   - rename SAS-2 phy mode page to Enhanced phy control (SAS)
   - add ADC mode (sub)page place holders
   - print mode page descriptors in full in more contexts
   - add linux bsg support
   - scripts/sas_disk_blink: moved here from sg3_utils package
   - rework the '-w' option (win32) per sg_scan in sg3_utils
   - change SDPARM_* constants to SG_LIB_*
   - remove sdparm.html, refer to its url in sdparm.8
   - sdparm.spec: correction to configure call

ChangeLog for sdparm-1.03 [20080623] [svn: r96]
....


For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html
Note that the web site has changed since the previous release.

A release announcement will be sent to freshmeat.net .

Doug Gilbert
