From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.19 available
Date: Fri, 03 Feb 2006 19:52:05 +1000
Message-ID: <43E327C5.503@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [203.16.233.9] ([203.16.233.9]:60115 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932197AbWBCJxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 04:53:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI (and some ATA) commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl.

This version mainly updates various utilities to the
latest t10.org drafts and corrects some errors.
The interface to the linux SCSI pass through interface
has been made more generic. This has permitted ports of
most of the utilities to FreeBSD and Tru64.
See the CHANGELOG for more information.

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
