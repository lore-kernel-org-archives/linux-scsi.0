From: Shobhit Mathur <shobhitmmathur@yahoo.com>
Subject: SCSI /proc query ...
Date: Tue, 21 Sep 2004 23:23:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922062305.52594.qmail@web52507.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web52507.mail.yahoo.com ([206.190.39.132]:35741 "HELO
	web52507.mail.yahoo.com") by vger.kernel.org with SMTP
	id S266561AbUIVGXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 02:23:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

I intend to implement /proc interface for a SCSI HBA.
The proc_info() entry-point in Scsi_Host_Template 
structure automatically takes care of creating a 
proc-dir for each host [HBA] as in :
/proc/scsi/<mydriver>/<HBAnumber>.

I have been able to implement the above stage. Now, I 
am interested in having separate proc-folders for each

SCSI target detected as in :

/proc/scsi/<mydriver>/<HBAnumber1>/<target1>
/proc/scsi/<mydriver>/<HBAnumber1>/<target2>
/proc/scsi/<mydriver>/<HBAnumber1>/<target3> ....

Under each of the target-folders, I would like to
print
relevant information specific to each target.

How do I go about achieving the above objective ? Some
clarifications/insights would be gratifying.

- Thank you

- Shobhit

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
