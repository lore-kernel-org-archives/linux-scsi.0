From: michaelc@cs.wisc.edu
Subject: iscsi update for 2.6.30
Date: Thu,  5 Mar 2009 14:45:54 -0600
Message-ID: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZCEUqM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:12 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n25KkAvT023094
	for <linux-scsi@vger.kernel.org>; Thu, 5 Mar 2009 15:46:10 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n25KkAtq021074
	for <linux-scsi@vger.kernel.org>; Thu, 5 Mar 2009 15:46:10 -0500
Received: from localhost.localdomain (vpn-12-183.rdu.redhat.com [10.11.12.183])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n25KkABt014775
	for <linux-scsi@vger.kernel.org>; Thu, 5 Mar 2009 15:46:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a mix of fixes, cleanups and features for 2.6.30 feature
window.

The patchset was made over scsi-rc-fixes instead of scsi-misc, because
scsi-rc-fixes has patches that are not in scsi-misc, and the patches
in this patchset are built over them.



