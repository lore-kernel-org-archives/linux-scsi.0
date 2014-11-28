From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi version 0.28 released
Date: Thu, 27 Nov 2014 20:27:54 -0500
Message-ID: <5477CF9A.5060003@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux
2.6 and 3 series kernels in order to list information about
SCSI devices and SCSI hosts. The default format is one device
(e.g. disk) per line. Other storage devices that use the SCSI
subsystem such as SATA and USB keys are also listed.

Version 0.28 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section containing
tarballs, rpm and deb packages.

ChangeLog:
Version 0.28 2014/09/30 [svn: r120]
   - fix handling of scsi_level 0 (no compliance)
   - add SRP transport identifier
   - add --unit option for LU identifier (>= lk 3.15)
   - add (S)ATA transport identifier (>= lk 3.15)
   - make USB transport ids more consistent
   - fix FC transport id missing comma
   - add pdt strings for security manager and zbc
   - upgrade automake to version 1.14.1

Version 0.27 2013/05/08 [svn: r111]
...


Doug Gilbert
