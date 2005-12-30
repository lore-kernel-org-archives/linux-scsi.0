From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.16 released
Date: Fri, 30 Dec 2005 23:54:41 +1000
Message-ID: <43B53C21.7050108@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:10188 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751263AbVL3NxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 08:53:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, taggart@debian.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about all SCSI devices and SCSI hosts. Both a
compact format (default) which is one line
per device and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported. Some examples:

$ lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
[1:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

$ lsscsi --classic
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: Linux    Model: scsi_debug       Rev: 0004
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: SONY     Model: SDT-7000         Rev: 0192
  Type:   Sequential-Access                ANSI SCSI revision: 02

Version 0.16 is available at
http://www.torque.net/scsi/lsscsi.html
[See Download section for tarball and rpm]

No major changes. ChangeLog:

Version 0.16 2005/12/30
  - clean up peripheral device type naming
  - properly identify osst and (tape) changer devices
  - add debian build directory

Doug Gilbert
