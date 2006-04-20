From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.20 available
Date: Thu, 20 Apr 2006 15:30:30 -0400
Message-ID: <4447E156.60809@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21435 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751004AbWDTTae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 15:30:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, emschwar@debian.org, robbat2@gentoo.org

sg3_utils is a package of command line utilities for sending
SCSI (and some ATA) commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl.
A subset of the utilities in this package will build on FreeBSD
and Tru64.

In this version the sg_dd, sgp_dd, sgm_dd, and sg_read
utilities have been cleaned up and expanded. sg_scan
and sg_map are now more robust when used with 2.6 kernels.
SAS (SSP) support has been improved. Various bugs have been
fixed. See the CHANGELOG for more information.

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
