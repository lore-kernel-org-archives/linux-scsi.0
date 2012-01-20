From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.97 available
Date: Fri, 20 Jan 2012 18:20:16 -0500
Message-ID: <4F19F6B0.2000608@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40177 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab2ATXUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2012 18:20:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: David Zeuthen <david@fubar.dk>, Kay Sievers <kay.sievers@vrfy.org>

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Serial Management Protocol. A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with SSP and
STP initiators). A SAS expander contains a SMP target. Many
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package is
designed to work with the linux kernel (lk) 2.6 series,
FreeBSD 9.0 and recent Solaris versions.

Two interfaces are available for Linux: "sgv4" and "mptctl".
The "sgv4" interface uses the bsg driver.

This version adds the smp_conf_phy_event utility. Now all
SMP functions defined in SPL and SPL-2 (up to revision 3)
are supported. The build is now autotools-based (i.e.
'./configure ; make ; make install') and ports to FreeBSD and
Solaris have been added. There is now a 'smputils' library
which may be of interest to Linux udev maintainers since
udisks-probe-sas-expander is "a bit cheesy" to quote its C
source.

For an overview, examples and downloads of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html

Changelog for smp_utils-0.97 [20120120] [svn:r116]
   - smp_conf_phy_event: new utility
   - change to ./configure style build and use smputils
     runtime and development libraries
   - change binary install from /usr/bin to /usr/sbin
     in debian and rpm (.spec) scripts
   - sync to SPL-2 (spl2r03)
   - take resid into account when calculating the actual
     response length
   - smp_rep_phy_event, smp_rep_phy_event_list: add --enumerate
     option to list Phy Event Source names
   - smp_read_gpio, smp_write_gpio: move register type,
     index and count fields in enhanced variants
   - add solaris and freebsd ports

Changelog for smp_utils-0.96 [20110620] [svn:r96]
   ...

SAS-2 expanders often include a SCSI Enclosure Services (SES)
device. To support this there has been a major rework of the
sg_ses utility (again) in the sg3_utils version 1.33 package.
See http://sg.danny.cz/sg/sg3_utils.html and
http://sg.danny.cz/sg/sg_ses.html

Doug Gilbert
