From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.13 available
Date: Tue, 15 Mar 2005 16:27:17 +1000
Message-ID: <42368045.8020605@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:64736 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262279AbVCOG0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 01:26:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI commands to devices. This package targets the lk 2.6 and
lk 2.4 series. In the lk 2.6 series these utilities (except
sgp_dd) can be used with any devices that support the SG_IO
ioctl.

This version adds sg_format which can format SCSI disks,
potentially with a different number of bytes in each block.
It can also resize (sometimes called "short stroke") a
disk. There are also extensions to the sg_dd utility to
use the READ LONG SCSI command on damaged blocks (for a "last
resort" media copy).

A tarball, rpm and deb can be found on:
http://www.torque.net/sg .
For an overview of sg3_utils see this page:
http://www.torque.net/sg/u_index.html
The sg_dd utility has its own page at:
http://www.torque.net/sg/sg_dd.html
A changelog can be found at:
http://www.torque.net/sg/p/sg3_utils.CHANGELOG

A release announcement has been sent to freshmeat.net .

Doug Gilbert
