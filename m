From: michaelc@cs.wisc.edu
Subject: iscsi new bug fix and regression fix
Date: Wed, 15 Aug 2007 01:38:28 -0500
Message-ID: <11871599101926-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXHOGid (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 02:38:33 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7F6cVxj020424
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2007 02:38:32 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7F6cV7e031142
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2007 02:38:31 -0400
Received: from localhost.localdomain (vpn-14-21.rdu.redhat.com [10.11.14.21])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7F6cVfI006467
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2007 02:38:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following two patches fix two bugs found while testing linus's
tree and scsi-rc-fixes. The patches were made against scsi-rc-fixes
and contain only critical bug fixes, so if there is time for patches
to go into 2.6.23 then these might be able to go in.


