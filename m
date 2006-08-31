From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes
Date: Thu, 31 Aug 2006 18:09:23 -0400
Message-ID: <11570621752047-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:16262 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932227AbWHaXJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:14 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k7VN9DdZ018331
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 19:09:13 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k7VN9Dxc001713
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 19:09:13 -0400
Received: from localhost.localdomain (vpn50-101.rdu.redhat.com [172.16.50.101])
	by pobox.corp.redhat.com (8.13.1/8.12.8) with ESMTP id k7VN9Cht014934
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 19:09:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


These patches fix several bugs in iscsi_tcp and libiscsi including:
- support for targets that do not obey max burst length for
r2ts
- Lots of data and head digests fixes.
- Lots of fixes for partial IO handling.
- Fix for when IO needs padding.
- Fix for when the recv soft irq completes a command but
the xmit thread has not yet filly cleaned itself up.

The patches were made over scsi-rc-fixes, but patch against
scsi-rc-fixes or scsi-misc. These are all bug fixes so if
we send patches upstream again these would qualify. Since
I am sending them so late in the 2.6.18 cylce, I know there
is a slim chance so if they are merged into scsi-misc it is
fine.
