From: Shobhit Mathur <shobhitmmathur@yahoo.com>
Subject: SCSI Query - cmd_per_lun & can_queue ...
Date: Tue, 13 Jul 2004 03:40:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040713104002.10597.qmail@web52510.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web52510.mail.yahoo.com ([206.190.39.135]:36768 "HELO
	web52510.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264819AbUGMKkF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 06:40:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

I have a basic query related to the Scsi_Host_Template
fields namely : cmd_per_lun and can_queue. I would
like
to know what is the relation between the per-lun queue
and the per-HBA queue ?

To elaborate my query, I would like to know how are
the
I/Os from the upper-layers managed between per-lun and
the host-queue depth. In most cases the host-queue
depth
is very large [128 or more], while the per-lun queue
is
a fraction [5 or 2]. I would like to know how is the
relation between the two queues and how does this
impact
io-rate ?

- Kindly let me know as I have a blurred picture of
the
role of the 2 queues.

- Thank you very much

- Shobhit Mathur


		
__________________________________
Do you Yahoo!?
Yahoo! Mail - 50x more storage than other providers!
http://promotions.yahoo.com/new_mail
