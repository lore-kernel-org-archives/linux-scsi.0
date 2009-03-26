From: Ahmed A <ahmedcali@yahoo.com>
Subject: Stale devices in sysfs
Date: Thu, 26 Mar 2009 10:16:36 -0700 (PDT)
Message-ID: <566532.22288.qm@web32501.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32501.mail.mud.yahoo.com ([68.142.207.211]:23152 "HELO
	web32501.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583AbZCZRXU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 13:23:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I have a two port FC hba in my system.  The hba is properly connecting to a Target, and I can tell it seems all the LUNs exported to it.  However, when I browse through the /sys/class/scsi_host/... directory , and output of "lsscsi", I can see "sd" mappings that are old and invalid (cannot write to them).  In my ouput below, sd[e/f/g/h] and sd[c/d] are invalid.

1. Is there an command I an issue to flush out the older mappings?

2. Is this a bug in the FC driver?

[root@pe850 ~]# lsscsi
[2:0:0:10]   disk    3PARdata VV               0000  /dev/sde
[2:0:0:11]   disk    3PARdata VV               0000  /dev/sdf
[2:0:0:254]  enclosu 3PARdata SES              0000  -       
[2:0:1:10]   disk    3PARdata VV               0000  /dev/sdg
[2:0:1:11]   disk    3PARdata VV               0000  /dev/sdh
[2:0:1:254]  enclosu 3PARdata SES              0000  -       
[2:0:2:10]   disk    3PARdata VV               0000  /dev/sdi
[2:0:2:11]   disk    3PARdata VV               0000  /dev/sdj
[2:0:2:254]  enclosu 3PARdata SES              0000  -       
[3:0:0:10]   disk    3PARdata VV               0000  /dev/sdc
[3:0:0:11]   disk    3PARdata VV               0000  /dev/sdd
[3:0:0:254]  enclosu 3PARdata SES              0000  -       
[3:0:1:10]   disk    3PARdata VV               0000  /dev/sdk
[3:0:1:11]   disk    3PARdata VV               0000  /dev/sdl
[3:0:1:254]  enclosu 3PARdata SES              0000  -       
[root@pe850 ~]# 

Thank you,
Ahmed.



      
