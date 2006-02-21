From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.17 released
Date: Tue, 21 Feb 2006 18:39:57 -0500
Message-ID: <43FBA4CD.6000505@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts36.bellnexxia.net ([209.226.175.93]:17897 "EHLO
	tomts36-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S932175AbWBUXlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 18:41:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, taggart@debian.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format (default) which is one line per device and a
"classic" format (like the output of 'cat /proc/scsi/scsi') are
supported.

Version 0.17 is available at
http://www.torque.net/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs and rpms.
This version will be required for lsscsi to work properly
when lk 2.6.16 is released.

ChangeLog:
Version 0.17 2006/2/6
  - fix disappearance of block device names in lk 2.6.16-rc1

Doug Gilbert
