From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi version 0.27 released
Date: Thu, 09 May 2013 00:08:00 -0400
Message-ID: <518B2120.9040607@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, =?ISO-8859-1?Q?Dan_Hor?= =?ISO-8859-1?Q?=E1k?= <dhorak@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux
2.6 and 3 series kernels in order to list information about
SCSI devices and SCSI hosts. Both a compact format which is
one line per device and a "classic" format (like the output
of 'cat /proc/scsi/scsi') are supported.

Version 0.27 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section containing
tarballs, rpm and deb packages.


ChangeLog:
Version 0.27 2013/05/08 [svn: r111]
   - rework buffer handling for systems with many disks
   - add --lunhex option for displaying LUNs in hex
   - accept LUNs from sysfs as large as a 64 bit unsigned
     decimal number (largest was signed 32 bit decimal)
   - accept LSSCSI_LUNHEX_OPT environment variable
   - add --scsi_id option for /dev/disk/by-id/scsi*

Version 0.26 2012/01/31 [svn: r97]
....

Doug Gilbert
