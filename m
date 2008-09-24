From: michaelc@cs.wisc.edu
Subject: iscsi update for scsi-post
Date: Wed, 24 Sep 2008 11:46:08 -0500
Message-ID: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYIXQqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:20 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m8OGkH90018664
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2008 12:46:17 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8OGkH9Y019186
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2008 12:46:17 -0400
Received: from localhost.localdomain (vpn-12-126.rdu.redhat.com [10.11.12.126])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m8OGkGhF011901
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2008 12:46:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches are fixes and enhancements for 2.6.28 scsi-post,
becuase:

Subject: [PATCH 6/7] libiscsi: check reason why we are stopping iscsi session to determine error value

collides with other patches in that tree.


