From: jshankar <jshankar@CS.ColoState.EDU>
Subject: queue depth help!!
Date: Sat, 27 Dec 2003 14:38:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF514CE@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chico.cs.colostate.edu ([129.82.45.30]:35509 "EHLO
	chico.cs.colostate.edu") by vger.kernel.org with ESMTP
	id S264600AbTL0ViD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 16:38:03 -0500
Received: from webmail.colostate.edu (csunts4.acns.colostate.edu [129.82.100.135])
	by chico.cs.colostate.edu (8.12.10/8.12.9) with ESMTP id hBRLc2Ox016411
	for <linux-scsi@vger.kernel.org>; Sat, 27 Dec 2003 14:38:02 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

if the scsi target queue depth is 1, does it mean that i can handle only one
outstanding command  at a time.

Does it mean if another command is issued( queue depth=1), it has to wait till
the previous command is done.


Thanks
Jay

