From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.10 released
Date: Mon, 01 Nov 2004 10:36:23 +1000
Message-ID: <41858507.7050300@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:6852 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261708AbUKAAgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2004 19:36:50 -0500
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 6949739403A
	for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2004 10:36:49 +1000 (EST)
Received: from [192.168.48.80] (dsl-102.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.102])
	by borg.st.net.au (Postfix) with ESMTP id 8EBF73944F9
	for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2004 10:36:47 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball, rpm and deb can be found on http://www.torque.net/sg .
Overview of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement has been sent to freshmeat.net .

This minor release adds one new utility (sg_luns) and fixes a
problem with the implementation of the read capacity command in
the previous version.

Changelog for sg3_utils-1.10 [20041030]
   - sg_readcap, sg_dd, sgm_dd, sgp_dd: fix sg_ll_readcap_10+16
     (sg_cmds.c)
   - sg_luns: new utility to report luns
   - sg_logs: with '-t' (show temperature) ignore extra parameters in
         temperature log page (still show them with '-p=d')
   - sg_ses: clean argument sanity checks
   - sg_cmds: add more common command wrappers

Doug Gilbert
