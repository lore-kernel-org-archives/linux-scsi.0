From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.18 available
Date: Sun, 20 Nov 2005 16:26:07 +1000
Message-ID: <438016FF.2070202@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750746AbVKTGY6@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI (and some ATA) commands to devices. This package targets
the lk 2.6 and lk 2.4 series. In the lk 2.6 series these
utilities (except sgp_dd) can be used with any devices that
support the SG_IO ioctl.

This version adds the sg_map26 utility which maps between
a primary scsi device node (e.g. /dev/hdc) and the
corresponding scsi generic node (e.g. /dev/sg5) or vice
versa. Uses major/minor numbers and sysfs (thus only works
for the lk 2.6 series).
sg_dd now takes iflag and oflag options similar to those
found in recent GNU dd versions.
"sg_inq -rr" outputs an ATA IDENTIFY response in a form
suitable to be piped to "hdparm --Istdin" for decoding.
See CHANGELOG for more information.

A tarball, rpm and deb can be found at (see table 2):
http://www.torque.net/sg
For an overview of sg3_utils see this page:
http://www.torque.net/sg/u_index.html
The sg_dd utility has its own page at:
http://www.torque.net/sg/sg_dd.html
The SG_IO ioctl is discussed at:
http://www.torque.net/sg/sg_io.html
A changelog can be found at:
http://www.torque.net/sg/p/sg3_utils.CHANGELOG

A release announcement has been sent to freshmeat.net .

Doug Gilbert
