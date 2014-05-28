From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.98 available
Date: Wed, 28 May 2014 00:07:05 -0400
Message-ID: <538560E9.1030907@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36005 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaE1EHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 00:07:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 9F5042041BD
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 06:07:09 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7RfmIkXgUh7e for <linux-scsi@vger.kernel.org>;
	Wed, 28 May 2014 06:07:07 +0200 (CEST)
Received: from [192.168.48.86] (host-23-251-189-16.dyn.295.ca [23.251.189.16])
	by smtp.infotech.no (Postfix) with ESMTPA id EAB1C20415B
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 06:07:06 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Serial Management Protocol. A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with SSP and
STP initiators). A SAS expander contains a SMP target. Several
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package is
designed to work with the Linux kernel (lk) 2.6 and 3 series,
FreeBSD 9.0 (and later) and recent Solaris versions.

Three interfaces are available for Linux: "sgv4", "mptctl" and
"aac". The "sgv4" interface uses the bsg driver. The "aac"
interface is new in this version and requires a recent aacraid
driver and firmware in the controller.

For an overview, examples and downloads of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html

Changelog for smp_utils-0.98 [20140526] [svn:r138]
   - add Linux aacraid support, interface name : aac
     - device name has form /dev/aac[N[,E_ID]]
   - smp_discover, smp_discover_list: in 1 line summary use
     routing attribute "U" instead of "T" if "table to
     table supported" set in report general response
     - output device slot (group) number if len > 109
     - add 'attached persistent capable' bit (spl3r2)
     - add pwr_dis_* fields (spl3r3)
     - add '--cap' option to decode phy capabilities
     - change 'end device' to 'SAS or SATA device'
   - smp_discover: '-mm' produces full output for each phy
   - smp_rep_broadcast: add broadcast type names
   - smp_general: add 'initiates ssp close' and 'ssp
     maximum connect time limit' fields (spl3r04)
   - add support for mpt3ctl (Linux LSI 12 Gbps HBAs)
   - change binary install from /usr/sbin to /usr/bin since
     sbin caused problems
   - examples folder scripts cleanup
   - make code more C11/C++ friendly

Changelog for smp_utils-0.97 [20120120] [svn:r116]
...

SAS expanders often include a SCSI Enclosure Services (SES)
device. SES devices can be accessed with the sg_ses utility
in the sg3_utils version 1.38 package.
See http://sg.danny.cz/sg/sg3_utils.html and
http://sg.danny.cz/sg/sg_ses.html

Doug Gilbert
