From: Jeff Garzik <jgarzik@pobox.com>
Subject: 'aic' branch of misc-2.6 updated with aic79xx changes
Date: Tue, 31 May 2005 14:10:32 -0400
Message-ID: <429CA898.8050909@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:1922 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261157AbVEaSKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 14:10:38 -0400
Received: from cpe-065-184-065-144.nc.res.rr.com ([65.184.65.144] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.51 #1 (Red Hat Linux))
	id 1DdBCF-00057W-Jb
	for linux-scsi@vger.kernel.org; Tue, 31 May 2005 18:10:37 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


The 'aic' branch of
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

has been completely replaced with refreshed patches:

[SCSI] aic79xx: remove Linux 2.4 ifdefs
[SCSI] aic79xx: remove busyq
[SCSI] aic7xxx: minor cleanups made possible by busyq removal change

This addresses Christoph's objection to the scsi_set_device() changeset, 
and also collapses "[PATCH 5/4]" into the "remove busyq" patch.

Additionally, a user has verified that these changes do not break things.

If you need help figuring out how to obtain a patch from the above 
repository, read http://lkml.org/lkml/2005/5/26/11

	Jeff



