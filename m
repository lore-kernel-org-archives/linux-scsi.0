From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi-0.23 released
Date: Thu, 03 Dec 2009 02:55:31 +0100
Message-ID: <4B171A93.2040202@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38906 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbZLCBza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 20:55:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Matt Taggart <taggart@debian.org>

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.23 is available at
http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm** and deb packages.

ChangeLog:
Version 0.23 2009/12/01 [svn: r76]
   - remove /proc/mounts scan for sysfs mount point, assume
     /sys unless overridden by re-instated '--sysfsroot' option
Version 0.22 2008/12/26 [svn: r71]
...


** The rpm and srpm packages are not currently there but will
    appear in the next day or so. They can be built from the
    lsscsi.spec file in the appropriate environment.

Doug Gilbert
