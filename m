From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC] MAINTAINERS: Update SCSI git trees
Date: Thu, 16 Aug 2012 14:46:26 +0200
Message-ID: <502CEBA2.5080205@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:57896 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2HPMrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2012 08:47:41 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 16 Aug 2012 13:47:39 +0100
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7GClT6t20840618
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:47:29 GMT
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7GClZkJ029526
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 06:47:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

In http://marc.info/?l=linux-scsi&m=133517794218707&w=2
James wrote on 2012-04-23:
> Just to let you know that SCSI is moving on to a single tree model
> from now on. The new tree is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>
> And the branch for next is for-next.
>
> Could you drop both the scsi-misc-2.6 and scsi-rc-fixes-2.6 tree, please
> because I'll send everything through this for-next branch.
>
> For the time being, could you keep the scsi-post-merge-2.6 tree?  It's
> easier when resolving conflicts amongst other trees to use a separate
> git tree (although we haven't actually had to use this one for a while).

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org> #3.4+
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5947,9 +5947,9 @@ F:	include/scsi/sg.h
 SCSI SUBSYSTEM
 M:	"James E.J. Bottomley" <JBottomley@parallels.com>
 L:	linux-scsi@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git fixes
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/

