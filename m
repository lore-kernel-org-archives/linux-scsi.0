From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: MAINTAINERS: use new email address for James Bottomley
Date: Mon, 14 Mar 2016 12:42:27 -0700
Message-ID: <1457984547.2374.50.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34062 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcCNTmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 15:42:36 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Mon, 14 Mar 2016 13:42:34 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CA93B19D8058
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 13:30:25 -0600 (MDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2EJgUcO13500552
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 19:42:30 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2EJgT9i020176
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 15:42:29 -0400
Received: from localhost (sig-9-76-2-30.ibm.com [9.76.2.30])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u2EJgSJ2019959
	for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2016 15:42:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The @odin.com one has been bouncing for a while now, so replace with
new Employer email.

Signed-off-by: James Bottomley <jejb@linux.vnet.ibm.com>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index a7c4466..59f12c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9644,7 +9644,7 @@ F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
-M:	"James E.J. Bottomley" <JBottomley@odin.com>
+M:	"James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
 M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git

