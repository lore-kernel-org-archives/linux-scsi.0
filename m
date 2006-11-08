From: Mike Christie <michaelc@cs.wisc.edu>
Subject: iscsi bugfixes
Date: Wed, 08 Nov 2006 15:58:30 -0600
Message-ID: <11630231143038-git-send-email-michaelc@cs.wisc.edu>
Reply-To: Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:25498 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965668AbWKHV6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 16:58:36 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kA8LwZIC022640
	for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2006 16:58:35 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kA8LwZpi027892
	for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2006 16:58:35 -0500
Received: from localhost.localdomain (vpn-14-145.rdu.redhat.com [10.11.14.145])
	by pobox.corp.redhat.com (8.13.1/8.12.8) with ESMTP id kA8LwY17025732
	for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2006 16:58:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches fix a memory leak, a oops, and some printk messages.
The printk fixup is not critical but is small. The oops in the
main write path and memory leak could be so if there are more patches
going out for another rc kernel these could be ok.

The patchset was made against scsi-rc-fixes but applies to
scsi-misc incase it ends up there.



