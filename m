From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.14 released
Date: Mon, 20 Sep 2004 16:09:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <414E741F.3000009@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:38850 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S266073AbUITGKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 02:10:22 -0400
Received: from [192.168.48.80] (dsl-16.131.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.131.16])
	by borg.st.net.au (Postfix) with ESMTP id 94A1C3944A9
	for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2004 16:10:20 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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

Version 0.14 is available at
http://www.torque.net/scsi/lsscsi.html
It depends on the recently released libsysfs v1.2.0 see:
http://linux-diag.sourceforge.net

lsscsi v0.14 has been tested with lk 2.6.9-rc2 .

Version 0.14 2004/9/20
   - port to depend on sysfutils-1.2.0 or later. Needs
     dlist_sort_custom().
   - remove 'sysfsroot' command line option


Doug Gilbert
