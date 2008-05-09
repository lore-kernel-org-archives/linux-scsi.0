From: michaelc@cs.wisc.edu
Subject: Another bugfix for 2.6.26
Date: Thu,  8 May 2008 20:15:33 -0500
Message-ID: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYEIBPg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2008 21:15:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m491FZ48012949
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 21:15:35 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m491FZMw031945
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 21:15:35 -0400
Received: from localhost.localdomain (vpn-14-237.rdu.redhat.com [10.11.14.237])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m491FYTr012554
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 21:15:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry about multiple days of patches James. I found another possible bug
in the iscsi code. The problem occurs when setting the iscsi recv timeout
and iscsi ping timeout to signifigantly different values.

The patch was made over scsi-rc-fixes.


