From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.14 available
Date: Fri, 06 May 2005 23:25:30 +1000
Message-ID: <427B704A.10202@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:49816 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261208AbVEFN2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2005 09:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI commands to devices. This package targets the lk 2.6 and
lk 2.4 series. In the lk 2.6 series these utilities (except
sgp_dd) can be used with any devices that support the SG_IO
ioctl.

This version adds sg_rmsn to read media serial number(s).
The tarball contains a spec file for building rpms. That
spec file builds two binary rpms: sg3_utils and libsgutils.
In the future my plan is to make other utilities such as
sdparm depend on libsgutils. See CHANGELOG for other changes.

A tarball, rpm and deb can be found on (see table 2):
http://www.torque.net/sg
For an overview of sg3_utils see this page:
http://www.torque.net/sg/u_index.html
The sg_dd utility has its own page at:
http://www.torque.net/sg/sg_dd.html
A changelog can be found at:
http://www.torque.net/sg/p/sg3_utils.CHANGELOG

A release announcement has been sent to freshmeat.net .

Doug Gilbert
