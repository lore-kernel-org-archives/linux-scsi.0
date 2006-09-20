From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH] qla4xxx driver resubmission
Date: Tue, 19 Sep 2006 17:08:07 -0700
Message-ID: <1158710887.4358.17.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8803 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750710AbWITAII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 20:08:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Duane Grigsby <duane.grigsby@qlogic.com>

This is another resubmission of qla4xxx driver for QLogic Corporation's iSCSI HBAs.

The main changes from the previous submission are 
- use block layer tagging
- clean up code and remove unused function for firmware pass thru

Please not that this patch is dependant on the previously posted patch titled
[RFC] [PATCH] helper function for retrieving scsi_cmd given host based block layer tag 
( http://marc.theaimsgroup.com/?l=linux-scsi&m=115871027627964&w=2 )


The complete mega patch for the driver is at
ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/0000-Initial-Commit-qla4xxx.txt


For ease of comprehension the above patch has been broken down into 
the following smaller patches: 
(located at ftp://ftp.qlogic.com/outgoing/linux/iSCSI/upstream/5.00.05b10-k/ )

0001-qla4xxx-driver-defs.diff
0002-qla4xxx-driver-init.diff
0003-qla4xxx-driver-os.diff
0004-qla4xxx-driver-isr.diff
0005-qla4xxx-driver-mbx.diff
0006-qla4xxx-driver-support.diff
0007-qla4xxx-driver-version.diff

All patches are against scsi-misc-2.6.git

Other items which needs to be done are 
 - Add support for sysfs attributes. 
 - Userspace support for session creation/deletion for iscsi HBAs. 
 - Add support for other discovery modes ie iSNS/SLP. 

Here are the links to the previous two submissions
http://marc.theaimsgroup.com/?l=linux-scsi&m=115532714515853&w=2

http://groups.google.com/group/open-iscsi/browse_frm/thread/536ce2edf9a60c48?hl=en

I believe block layer tagging was the gating item in the last submission. 
I would really appreciate if it can be merged upstream.

Regards, 
David Somayajulu 
Qlogic Corporation. 



