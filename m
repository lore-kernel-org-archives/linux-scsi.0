From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.09 released
Date: Fri, 22 Oct 2004 13:51:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417883D7.3090709@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:43244 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S270812AbUJVDwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 23:52:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 8E2B1394643
	for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2004 13:52:31 +1000 (EST)
Received: from [192.168.48.80] (dsl-25.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.25])
	by borg.st.net.au (Postfix) with ESMTP id 56FF33944E9
	for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2004 13:52:29 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Tarball, rpm and deb can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement has been sent to freshmeat.net .

There are 4 new utilities and a major refactoring of code to use
a new library called libsgutils. If serious glitches are found
sg3_utils-1.10 will soon follow.


Changelog for sg3_utils-1.09 [20041022]
   - sg_ses: new utility to get status and set control on SES devices
   - sg_verify: new utility to verify block devices
   - sg_emc_trespass: new utility for EMC specific trespass mode page
   - sg_request: new utility that sends a REQUEST SENSE command
   - sg_logs: '-r' to reset to manufacturer's defaults
       - decode last n error events and last n deferred errors pages
       - add names of ADC log pages
   - sg_inq: update to SPC-3 rev 21
       - decode Extended INQUIRY VPD page [0x86]
       - decode Unit Path Report VPD page [0xc0] (EMC)
   - sginfo: decode SAS protocol specific lu mode page
   - sg_err: convert to sg_lib + update to SPC-3 rev 21
       - change GPL to FreeBSD license
       - flag vendor specific asc/ascq ranges
   - libsgutils: library made from sg_lib.c and sg_cmds.c
     - rpm "spec" file additionally builds a "-devel" rpm with
       static libsgutils.a and sg_lib.h and sg_cmds.h
   - utils/hxascdmp.c: add FreeBSD license
   - sg_persist: additions to man page
       - add sg_persist_tst.sh example script to examples directory
   - sg_turs: add '-v' and '-V' options
   - sg_senddiag: add '-v' option

Doug Gilbert


