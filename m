From: Mike Anderson <andmike@us.ibm.com>
Subject: Question on kernel.org scsi git trees.
Date: Wed, 21 Sep 2005 13:42:17 -0700
Message-ID: <20050921204217.GA28313@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:929 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964810AbVIUUmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 16:42:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8LKgodR011598
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 16:42:50 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8LKgd8D078272
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 16:42:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j8LKgd4T025226
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 16:42:39 -0400
Received: from hmsbounty.us.ibm.com (dyn9047022139.beaverton.ibm.com [9.47.22.139])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j8LKgciG025176
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 16:42:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am getting an odd error (or message) on these two scsi git trees:
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-for-linus-2.6.git

I received an merge error last night when I did an cg-update on
scsi-misc-2.6 so I decided to remove the view and clone.

The messages I am receiving are:

scsi-misc-2.6.git:
Missing object of tag v2.6.13... unable to retrieve

scsi-for-linus-2.6.git:
Missing object of tag v2.6.14-rc1... unable to retrieve

Just to verify I can clone a clean tree, I did a cg-clone of linux-2.6.git
and it worked fine.

Anybody else seeing this?

I have ran the cg-clone on two different systems with different versions of
cogito and git. The above errors where produced with:

git-core-0.99.6-1.fc4
cogito-0.14.1-2.fc4

and

git-core-0.99.7
cogito-0.15


-andmike
--
Michael Anderson
andmike@us.ibm.com
