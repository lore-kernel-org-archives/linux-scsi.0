From: michaelc@cs.wisc.edu
Subject: iscsi bugfixes for scsi-misc/2.6.27
Date: Mon, 16 Jun 2008 10:11:31 -0500
Message-ID: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYFPPL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:11:58 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m5GFBa2W015749
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 11:11:57 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GFBaDC007250
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 11:11:36 -0400
Received: from localhost.localdomain (vpn-15-112.rdu.redhat.com [10.11.15.112])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GFBZSC013530
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 11:11:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made over scsi-misc for 2.6.27. They are
bugfixes but fixes for the new code in there so they should not
go into scsi-rc-fixes.


