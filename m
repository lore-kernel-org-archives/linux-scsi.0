From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.19 released
Date: Thu, 25 Jan 2007 17:43:45 -0500
Message-ID: <45B932A1.90003@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35146 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030630AbXAYWn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 17:43:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, taggart@debian.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format (default) which is one line per device and a
"classic" format (like the output of 'cat /proc/scsi/scsi') are
supported.

Version 0.19 is available at
http://www.torque.net/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.
This version adds transport specific information.

ChangeLog:
Version 0.19 2007/1/25
  - add transport information (target + initiator)
    - start with FC, SAS, SPI, iSCSI and SBP
    - alter ISCSI for 2.6.20 changes
  - SAS fix for lk 2.6.20 (SYSFS_DEPRECATED=n)
  - enhance host name search when proc_name is "<NULL>"
  - implement filter option for '--hosts'
    - accept 'host<n>' as first item in filter to mean host <n>
  - output more host attributes when '-Hll' given
  - add '--list' (or '-L') option output attribute=value
    entries, one per line


Doug Gilbert
